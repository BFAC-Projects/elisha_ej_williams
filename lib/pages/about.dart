import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with TickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About',
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAnimatedSection(
                            delay: 200,
                            child: _buildSectionTitle(
                              'About Elisha "EJ" Williams',
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildAnimatedSection(
                            delay: 400,
                            child: const Text(
                              'Elisha "EJ" Williams, born March 31, 2009, in Dunn, North Carolina, is an American actor and voice artist known for standout roles in television and animation. Best recognized as Dean Williams in ABC\'s The Wonder Years reboot and as the voice of Bingo in Disney Jr.\'s Puppy Dog Pals, the portfolio also includes appearances in Nickelodeon\'s Henry Danger and Danger Force.\n\nRaised in a creative household with professional basketball player Harold "Lefty" Williams and author–entrepreneur Shyneefa Williams as parents, the passion for acting began at age eight with a lead role in a school production. That early spark grew into a career combining live-action and voice performances.\n\nBeyond the screen, interests include reading, singing, sports, and exploring technology through coding and app development, with science as a favorite academic pursuit.',
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.6,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildAnimatedSection(
                            delay: 600,
                            child: _buildSectionTitle('Notable Works'),
                          ),
                          const SizedBox(height: 12),
                          _buildAnimatedSection(
                            delay: 800,
                            child: Column(
                              children: [
                                _buildFeatureItem(
                                  Icons.tv,
                                  'The Wonder Years (ABC)',
                                  'Dean Williams - Lead role in the acclaimed reboot series',
                                ),
                                _buildFeatureItem(
                                  Icons.pets,
                                  'Puppy Dog Pals (Disney Jr.)',
                                  'Voice of Bingo - Animated series character',
                                ),
                                _buildFeatureItem(
                                  Icons.flash_on,
                                  'Henry Danger & Danger Force',
                                  'Featured appearances on Nickelodeon productions',
                                ),
                                _buildFeatureItem(
                                  Icons.theater_comedy,
                                  'Early Theater Work',
                                  'Started acting journey at age 8 with school productions',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildAnimatedSection(
                            delay: 1000,
                            child: _buildSectionTitle('Interests & Skills'),
                          ),
                          const SizedBox(height: 12),
                          _buildAnimatedSection(
                            delay: 1200,
                            child: Column(
                              children: [
                                _buildFeatureItem(
                                  Icons.book,
                                  'Reading',
                                  'Passionate about literature and learning',
                                ),
                                _buildFeatureItem(
                                  Icons.music_note,
                                  'Singing',
                                  'Musical expression and performance',
                                ),
                                _buildFeatureItem(
                                  Icons.sports_basketball,
                                  'Sports',
                                  'Active in various athletic pursuits',
                                ),
                                _buildFeatureItem(
                                  Icons.code,
                                  'Technology',
                                  'Coding and app development exploration',
                                ),
                                _buildFeatureItem(
                                  Icons.science,
                                  'Science',
                                  'Favorite academic subject and area of study',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFF618DAC),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF618DAC).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF618DAC), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
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
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF618DAC), size: 20),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
