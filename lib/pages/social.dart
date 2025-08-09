import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize fade animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Initialize slide animation controller
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Create fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Create slide animation
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );

    // Start animations with a slight delay
    Future.delayed(const Duration(milliseconds: 100), () {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(
    BuildContext context,
    String url,
    String platform,
  ) async {
    final Uri uri = Uri.parse(url);
    print('Attempting to launch: $url');

    // Try multiple approaches to handle platform channel errors

    // Method 1: Try with platformDefault mode
    try {
      bool launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
      if (launched) {
        print('Successfully launched with platformDefault: $url');
        return;
      }
    } catch (e) {
      print('platformDefault failed: $e');
    }

    // Method 2: Try with externalApplication mode
    try {
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) {
        print('Successfully launched with externalApplication: $url');
        return;
      }
    } catch (e) {
      print('externalApplication failed: $e');
    }

    // Method 3: Try basic launchUrl without mode specification
    try {
      bool launched = await launchUrl(uri);
      if (launched) {
        print('Successfully launched with basic launchUrl: $url');
        return;
      }
    } catch (e) {
      print('Basic launchUrl failed: $e');
    }

    // Method 4: Show dialog with URL for manual copying
    _showUrlDialog(context, url, platform);
  }

  Future<void> _launchUrlWithContext(
    BuildContext context,
    String url,
    String platform,
  ) async {
    final Uri uri = Uri.parse(url);
    print('Attempting to launch: $url');

    // Try multiple approaches to handle platform channel errors

    // Method 1: Try with platformDefault mode
    try {
      bool launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
      if (launched) {
        print('Successfully launched with platformDefault: $url');
        return;
      }
    } catch (e) {
      print('platformDefault failed: $e');
    }

    // Method 2: Try with externalApplication mode
    try {
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) {
        print('Successfully launched with externalApplication: $url');
        return;
      }
    } catch (e) {
      print('externalApplication failed: $e');
    }

    // Method 3: Try basic launchUrl without mode specification
    try {
      bool launched = await launchUrl(uri);
      if (launched) {
        print('Successfully launched with basic launchUrl: $url');
        return;
      }
    } catch (e) {
      print('Basic launchUrl failed: $e');
    }

    // Method 4: Show dialog with URL for manual copying
    _showUrlDialog(context, url, platform);
  }

  void _showUrlDialog(BuildContext context, String url, String platform) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Open $platform'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Unable to open $platform automatically.'),
              const SizedBox(height: 10),
              const Text('You can copy this link and open it in your browser:'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: SelectableText(
                  url,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Try once more with a different approach
                _launchUrl(context, url, platform);
              },
              child: const Text('Try Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Social',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF618DAC),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([_fadeAnimation, _slideAnimation]),
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 1200),
                    tween: Tween(begin: 0.8, end: 1.0),
                    curve: Curves.easeOutBack,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Image.asset(
                          'assets/feature_header.png',
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/feature_background.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildAnimatedSection(
                            delay: 200,
                            child: const Text(
                              'Follow Elisha EJ Williams',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Instagram Link
                          _buildAnimatedSection(
                            delay: 400,
                            child: SocialButton(
                              label: 'Instagram',
                              accountId: '@EJWilliams_42',
                              icon: FontAwesomeIcons.instagram,
                              onPressed: () => _launchUrlWithContext(
                                context,
                                'https://www.instagram.com/ejwilliams_42/?hl=en',
                                'Instagram',
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Twitter/X Link
                          _buildAnimatedSection(
                            delay: 600,
                            child: SocialButton(
                              label: 'Twitter/X',
                              accountId: '@EJWilliams_42',
                              icon: FontAwesomeIcons.xTwitter,
                              onPressed: () => _launchUrlWithContext(
                                context,
                                'https://x.com/ejwilliams_42?lang=en',
                                'Twitter/X',
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Facebook Link
                          _buildAnimatedSection(
                            delay: 800,
                            child: SocialButton(
                              label: 'Facebook',
                              accountId: 'EJWilliams42',
                              icon: FontAwesomeIcons.facebook,
                              onPressed: () => _launchUrlWithContext(
                                context,
                                'https://www.facebook.com/EJWilliams42/',
                                'Facebook',
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // IMDb Link
                          _buildAnimatedSection(
                            delay: 1000,
                            child: SocialButton(
                              label: 'IMDb',
                              accountId: 'Elisha Williams',
                              icon: FontAwesomeIcons.film,
                              onPressed: () => _launchUrlWithContext(
                                context,
                                'https://www.imdb.com/name/nm9712591/?ref_=nmbio_ov_bk',
                                'IMDb',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedSection({required int delay, required Widget child}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, opacity, _) {
        return TweenAnimationBuilder<Offset>(
          duration: Duration(milliseconds: 800 + delay),
          tween: Tween(begin: const Offset(0, 30), end: Offset.zero),
          curve: Curves.easeOutBack,
          builder: (context, offset, _) {
            return Transform.translate(
              offset: offset,
              child: Opacity(opacity: opacity, child: child),
            );
          },
        );
      },
    );
  }
}

class SocialButton extends StatelessWidget {
  final String label;
  final String accountId;
  final IconData icon;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.label,
    required this.accountId,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.9),
          side: const BorderSide(color: Color(0xFF424242)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF618DAC).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: FaIcon(icon, color: const Color(0xFF618DAC), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    accountId,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
