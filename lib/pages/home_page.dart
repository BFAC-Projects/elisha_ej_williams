import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'about.dart';
import 'social.dart';
import 'messages.dart';
import 'videos.dart';
import '../services/remote_config_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final int _buttonCount = 5;
  final List<AnimationController> _controllers = [];
  final List<Animation<Offset>> _animations = [];
  bool _animationStarted = false;
  bool _backgroundImageLoaded = false;
  bool _splashAnimationCompleted = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _buttonCount; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      );
      final animation =
          Tween<Offset>(begin: const Offset(-1.5, 0), end: Offset.zero).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
          );
      _controllers.add(controller);
      _animations.add(animation);
    }

    // Fallback timer to ensure animation starts even if image loading detection fails
    Future.delayed(const Duration(seconds: 3), () {
      if (!_animationStarted) {
        _splashAnimationCompleted = true;
        _backgroundImageLoaded = true;
        _checkAndStartAnimation();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_animationStarted) {
      final route = ModalRoute.of(context);
      if (route != null && route.animation != null) {
        route.animation!.addStatusListener((status) {
          if (status == AnimationStatus.completed &&
              !_splashAnimationCompleted) {
            _splashAnimationCompleted = true;
            _checkAndStartAnimation();
          }
        });
      } else {
        // Fallback: if no route animation, mark splash as completed
        _splashAnimationCompleted = true;
        _checkAndStartAnimation();
      }
    }
  }

  void _checkAndStartAnimation() {
    if (_splashAnimationCompleted &&
        _backgroundImageLoaded &&
        !_animationStarted) {
      _animationStarted = true;
      _runStaggeredAnimation();
    }
  }

  Future<void> _runStaggeredAnimation() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 120));
      _controllers[i].forward();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _navigate(BuildContext context, Widget page) {
    // Haptic feedback
    HapticFeedback.mediumImpact();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  void _shareApp() async {
    // Haptic feedback
    HapticFeedback.mediumImpact();
    
    try {
      final configService = RemoteConfigService();

      // Pure cached access - no network calls!
      print('Sharing app with cached Remote Config values...');
      print('Share message: "${configService.shareMessage}"');
      print('Share URL: ${configService.shareUrlWithFallback}');

      // Share immediately using cached values only
      await Share.share(configService.fullShareMessage);
    } catch (e) {
      print('Error sharing app: $e');
      // Ultimate fallback
      const fallbackMessage =
          'Follow Elisha EJ Williams and stay updated with stats, highlights, and news. Download the app now:\nhttps://apps.apple.com/app/elisha-ej-williams/id123456789';
      await Share.share(fallbackMessage);
    }
  }

  void _onBannerTap() async {
    // Haptic feedback
    HapticFeedback.mediumImpact();
    
    try {
      final configService = RemoteConfigService();
      final url = configService.bannerLinkUrl;

      print('Banner tapped, opening URL: $url');

      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error opening banner URL: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    final configService = RemoteConfigService();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/home_background.jpg',
            fit: BoxFit.cover,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded || frame != null) {
                if (!_backgroundImageLoaded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _backgroundImageLoaded = true;
                    });
                    _checkAndStartAnimation();
                  });
                }
                return child;
              }
              return Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            },
          ),

          // Signature in the center (adjusted for banner)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: configService.showBanner
                ? 80
                : 0, // Move up when banner is shown
            child: Center(
              child: Image.asset(
                'assets/signature_text.png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Button column absolutely positioned at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: configService.showBanner
                ? 80
                : 0, // Adjust for banner height
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SlideTransition(
                    position: _animations[0],
                    child: _HomeIconButton(
                      asset: 'assets/about.png',
                      onTap: () => _navigate(context, const AboutPage()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SlideTransition(
                    position: _animations[1],
                    child: _HomeIconButton(
                      asset: 'assets/social.png',
                      onTap: () => _navigate(context, const SocialPage()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SlideTransition(
                    position: _animations[2],
                    child: _HomeIconButton(
                      asset: 'assets/videos.png',
                      onTap: () => _navigate(context, const VideosPage()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SlideTransition(
                    position: _animations[3],
                    child: _HomeIconButton(
                      asset: 'assets/messages.png',
                      onTap: () => _navigate(context, const MessagesPage()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SlideTransition(
                    position: _animations[4],
                    child: _HomeIconButton(
                      asset: 'assets/share.png',
                      onTap: _shareApp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Banner at bottom (conditionally shown)
          if (configService.showBanner)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: _onBannerTap,
                child: Container(
                  width: double.infinity,
                  height: 80, // Fixed height for banner
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Image.network(
                    configService.bannerImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Banner image loading error: $error');
                      return Container(
                        color: const Color(0xFF618DAC),
                        child: const Center(
                          child: Text(
                            'Banner',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HomeIconButton extends StatelessWidget {
  final String asset;
  final VoidCallback onTap;
  const _HomeIconButton({required this.asset, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Haptic feedback
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: SizedBox(
        width: double.infinity,
        height: 48, // Reduced height
        child: Image.asset(asset, fit: BoxFit.fitWidth),
      ),
    );
  }
}
