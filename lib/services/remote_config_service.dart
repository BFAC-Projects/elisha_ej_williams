import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:io';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  // Cached values for instant access
  String _shareMessage = '';
  String _androidShareUrl = '';
  String _iosShareUrl = '';
  
  // Banner parameters
  bool _showBanner = false;
  String _bannerImageUrl = '';
  String _bannerLinkUrl = '';
  
  bool _isInitialized = false;

  // Getters for instant access
  String get shareMessage => _shareMessage.isNotEmpty 
      ? _shareMessage 
      : 'Follow Elisha EJ Williams and stay updated with stats, highlights, and news. Download the app now:';
      
  String get shareUrl => Platform.isAndroid ? _androidShareUrl : _iosShareUrl;
  
  String get shareUrlWithFallback => shareUrl.isNotEmpty 
      ? shareUrl 
      : Platform.isAndroid 
          ? 'https://play.google.com/store/apps/details?id=app.android.elisha_ej_williams'
          : 'https://apps.apple.com/app/elisha-ej-williams/id123456789';

  String get fullShareMessage => '$shareMessage\n$shareUrlWithFallback';

  // Banner getters
  bool get showBanner => _showBanner; // Set to true for testing: true;
  String get bannerImageUrl => _bannerImageUrl.isNotEmpty 
      ? _bannerImageUrl 
      : 'https://apps.bfacmobile.com/images/application/183/features/image_gallery/6339/686d59621ade7.jpg';
  String get bannerLinkUrl => _bannerLinkUrl.isNotEmpty 
      ? _bannerLinkUrl 
      : 'https://athleteapps.com/';

  bool get isInitialized => _isInitialized;

  /// Initialize and fetch Remote Config values at app startup
  Future<void> initialize() async {
    try {
      print('RemoteConfigService: Initializing...');
      final remoteConfig = FirebaseRemoteConfig.instance;
      
      // Fetch and activate
      await remoteConfig.fetch();
      await remoteConfig.activate();
      
      // Cache the values
      _shareMessage = remoteConfig.getString('share_message');
      _androidShareUrl = remoteConfig.getString('android_share_url');
      _iosShareUrl = remoteConfig.getString('ios_share_url');
      
      // Cache banner values
      _showBanner = remoteConfig.getBool('show_banner');
      _bannerImageUrl = remoteConfig.getString('banner_image_url');
      _bannerLinkUrl = remoteConfig.getString('banner_link_url');
      
      _isInitialized = true;
      
      print('RemoteConfigService: Initialized successfully');
      print('- Share message: "$_shareMessage"');
      print('- Android URL: $_androidShareUrl');
      print('- iOS URL: $_iosShareUrl');
      print('- Show banner: $_showBanner');
      print('- Banner image URL: $_bannerImageUrl');
      print('- Banner link URL: $_bannerLinkUrl');
      
    } catch (e) {
      print('RemoteConfigService: Error during initialization: $e');
      // Set fallback values
      _shareMessage = 'Follow Elisha EJ Williams and stay updated with stats, highlights, and news. Download the app now:';
      _androidShareUrl = 'https://play.google.com/store/apps/details?id=app.android.elisha_ej_williams';
      _iosShareUrl = 'https://apps.apple.com/app/elisha-ej-williams/id123456789';
      
      // Set banner fallback values (disabled by default)
      _showBanner = false;
      _bannerImageUrl = 'https://apps.bfacmobile.com/images/application/183/features/image_gallery/6339/686d59621ade7.jpg';
      _bannerLinkUrl = 'https://athleteapps.com/';
      
      _isInitialized = true;
    }
  }

  /// Refresh values in background (optional, for periodic updates)
  Future<void> refreshInBackground() async {
    try {
      print('RemoteConfigService: Refreshing in background...');
      final remoteConfig = FirebaseRemoteConfig.instance;
      
      await remoteConfig.fetch();
      await remoteConfig.activate();
      
      // Update cached values
      _shareMessage = remoteConfig.getString('share_message');
      _androidShareUrl = remoteConfig.getString('android_share_url');
      _iosShareUrl = remoteConfig.getString('ios_share_url');
      
      // Update banner values
      _showBanner = remoteConfig.getBool('show_banner');
      _bannerImageUrl = remoteConfig.getString('banner_image_url');
      _bannerLinkUrl = remoteConfig.getString('banner_link_url');
      
      print('RemoteConfigService: Background refresh completed');
      print('- Updated share message: "$_shareMessage"');
      
    } catch (e) {
      print('RemoteConfigService: Background refresh failed: $e');
    }
  }
}
