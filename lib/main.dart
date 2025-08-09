import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'firebase_options.dart';
import 'pages/splash_screen.dart';
import 'services/remote_config_service.dart';

// Initialize the local notifications plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();



@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("=== BACKGROUND MESSAGE HANDLER STARTED ===");
  print("Message ID: ${message.messageId}");
  print("Message data: ${message.data}");
  print("Message notification: ${message.notification}");
  
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    print("Firebase initialized in background handler");
    
    // Save message to storage
    await _saveMessageToStorage(message);
    
    // For background messages, Firebase will automatically show the notification
    // if the message contains a notification payload
    print("Background message processed - Firebase will show notification automatically");
  } catch (e) {
    print("Error in background handler: $e");
  }
  print("=== BACKGROUND MESSAGE HANDLER COMPLETED ===");
}

Future<void> _saveMessageToStorage(RemoteMessage message) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('push_messages') ?? [];
    
    final messageData = {
      'title': message.notification?.title ?? 'New Message',
      'body': message.notification?.body ?? 'You have a new message',
      'timestamp': DateTime.now().toIso8601String(),
      'data': message.data,
      'imageUrl': message.notification?.android?.imageUrl ?? 
                  message.notification?.apple?.imageUrl ?? 
                  message.data['imageUrl'],
    };
    
    stored.add(jsonEncode(messageData));
    
    // Keep only the last 50 messages to prevent storage bloat
    if (stored.length > 50) {
      stored.removeRange(0, stored.length - 50);
    }
    
    await prefs.setStringList('push_messages', stored);
    print('Message saved to storage: ${messageData['title']}');
  } catch (e) {
    print('Error saving message to storage: $e');
  }
}

Future<void> _showForegroundNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'elisha_channel_id',
    'Elisha Notifications',
    channelDescription: 'Notifications for Elisha EJ Williams app',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );
  
  const DarwinNotificationDetails iOSPlatformChannelSpecifics =
      DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );
  
  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title ?? 'New Message',
    message.notification?.body ?? 'You have a new message',
    platformChannelSpecifics,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  const InitializationSettings initializationSettings =
      InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  
  // Create notification channel for Android
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'elisha_channel_id',
    'Elisha Notifications',
    description: 'Notifications for Elisha EJ Williams app',
    importance: Importance.max,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');

    // Initialize Firebase Remote Config
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10), // Reduced from 1 minute to 10 seconds
      minimumFetchInterval: const Duration(seconds: 0), // Allow immediate fetches for development
    ));
    
    // Set default values
    await remoteConfig.setDefaults({
      'android_share_url': 'https://play.google.com/store/apps/details?id=app.android.elisha_ej_williams',
      'ios_share_url': 'https://apps.apple.com/app/elisha-ej-williams/id123456789',
      'share_message': 'Follow Elisha EJ Williams and stay updated with stats, highlights, and news. Download the app now:',
      'show_banner': false,
      'banner_image_url': 'https://apps.bfacmobile.com/images/application/183/features/image_gallery/6339/686d59621ade7.jpg',
      'banner_link_url': 'https://athleteapps.com/',
    });
    
    // Initialize our Remote Config Service (this will fetch and cache values)
    await RemoteConfigService().initialize();

    // Set up Firebase Messaging
    final messaging = FirebaseMessaging.instance;
    
    try {
      // Request permission for iOS
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      print('User granted permission: ${settings.authorizationStatus}');
      
      // Try to get the token (iOS specific handling)
      try {
        print('Attempting to get FCM token...');
        
        // For iOS, we need to get APNS token first
        try {
          print('Getting APNS token first...');
          final apnsToken = await messaging.getAPNSToken();
          if (apnsToken != null) {
            print('APNS Token retrieved: ${apnsToken.substring(0, 20)}...');
          } else {
            print('APNS Token is null, waiting...');
            // Wait a bit and try again
            await Future.delayed(const Duration(seconds: 2));
            final apnsTokenRetry = await messaging.getAPNSToken();
            if (apnsTokenRetry != null) {
              print('APNS Token retrieved on retry: ${apnsTokenRetry.substring(0, 20)}...');
            } else {
              print('APNS Token still null after retry');
            }
          }
        } catch (apnsError) {
          print('Error getting APNS token: $apnsError');
        }
        
        // Now try to get FCM token
        final token = await messaging.getToken();
        if (token != null) {
          print('FCM Token retrieved successfully: $token');
        } else {
          print('FCM Token is null');
        }
        
        // Listen to token changes (this will help catch the token when APNS is ready)
        messaging.onTokenRefresh.listen((String token) {
          print('FCM Token refreshed: $token');
        });
        
        // Also listen to APNS token changes on iOS
        messaging.onTokenRefresh.listen((String token) async {
          print('Token refresh detected, checking APNS...');
          try {
            final apnsToken = await messaging.getAPNSToken();
            if (apnsToken != null) {
              print('APNS Token is now available: ${apnsToken.substring(0, 20)}...');
            }
          } catch (e) {
            print('Error checking APNS token on refresh: $e');
          }
        });
        
      } catch (e) {
        print('Error getting FCM token: $e');
        print('Error details: ${e.toString()}');
        // Continue without the token
      }
      
      // Set up background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      
      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) {
          print('Got a message whilst in the foreground!');
          print('Message data: ${message.data}');

          if (message.notification != null) {
            print('Message also contained a notification: ${message.notification}');
            print('Title: ${message.notification!.title}');
            print('Body: ${message.notification!.body}');
            
            // Save message to storage
            _saveMessageToStorage(message);
            
            // Show local notification for foreground messages
            _showForegroundNotification(message);
          }
        },
        onError: (error) {
          print('Error listening to foreground messages: $error');
        },
      );
      
      // Handle when app is opened from notification
      FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) {
          print('App opened from notification!');
          print('Message data: ${message.data}');
          print('Message notification: ${message.notification}');
          // You can navigate to specific screens here based on the notification
        },
        onError: (error) {
          print('Error handling notification open: $error');
        },
      );
    } catch (e) {
      print('Error setting up Firebase Messaging: $e');
      // Continue without messaging functionality
    }
  } catch (e) {
    print('Error initializing Firebase: $e');
    // Continue without Firebase
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
    );
  }
}