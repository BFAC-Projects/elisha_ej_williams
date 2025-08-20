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
                              'Elisha "EJ" Williams is one of Hollywood\'s brightest rising stars, best known for his breakout role as Dean Williams in ABC\'s acclaimed reimagining of The Wonder Years. Created by Saladin K. Patterson, produced by Lee Daniels, and directed by Ken Whittingham, the series airing on ABC, Disney+, and Hulu shines a new light on the Black American experience in Montgomery, Alabama, in 1968. EJ, the youngest Black male lead on a network TV series in decades, stars alongside Dulé Hill, Saycon Sengbloh, and Laura Kariuki, with narration by Oscar winner Don Cheadle.\n\nAt just 16, EJ has already earned a Hollywood Critics Association Award nomination and four NAACP Image Award nominations including Outstanding Actor in a Comedy Series and Outstanding Performance by a Youth. He\'s a Peabody Award winner and part of the Critics\' Choice Award–winning ensemble cast of The Wonder Years. Expanding his creative reach, EJ serves as an Executive Producer on the award-winning docuseries The Real Stories of Basketball, alongside his father Harold "Lefty" Williams and NBA legend LeBron James.\n\nEJ\'s career began at age eight with recurring roles on Nickelodeon\'s Henry Danger and Danger Force. He has also built an impressive voiceover portfolio, bringing to life fan favorites such as Bingo on Disney Junior\'s Puppy Dog Pals, Flash on Firebuds, and Dirk on Nickelodeon\'s The Loud House.\n\nA talented athlete with Harlem Globetrotters roots, EJ combines his love for basketball with a passion for giving back. Through his family\'s Dare2Dream Foundation recently honored by the NBA G-League\'s Wisconsin Herd. He inspires youth through sports, education, and character-building programs.\n\nOff-screen, EJ enjoys reading, singing, competitive sports, and coding apps. While his favorite subject in school is science, he also has a growing passion for directing and a long-term goal of attending law school. With his talent, drive, and dedication, EJ is poised to leave a lasting mark both in entertainment and beyond.',
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
                                  'Dean Williams - Lead role in acclaimed reboot series with Peabody Award-winning ensemble cast',
                                ),
                                _buildFeatureItem(
                                  Icons.pets,
                                  'Puppy Dog Pals (Disney Jr.)',
                                  'Voice of Bingo - Beloved animated series character',
                                ),
                                _buildFeatureItem(
                                  Icons.flash_on,
                                  'Firebuds (Disney Jr.)',
                                  'Voice of Flash - Animated series character',
                                ),
                                _buildFeatureItem(
                                  Icons.family_restroom,
                                  'The Loud House (Nickelodeon)',
                                  'Voice of Dirk - Popular animated series character',
                                ),
                                _buildFeatureItem(
                                  Icons.sports_basketball,
                                  'The Real Stories of Basketball',
                                  'Executive Producer - Award-winning docuseries with LeBron James',
                                ),
                                _buildFeatureItem(
                                  Icons.emoji_events,
                                  'Awards & Recognition',
                                  'NAACP Image Award nominations, Hollywood Critics Association Award nomination',
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
                                  Icons.sports_basketball,
                                  'Basketball',
                                  'Harlem Globetrotters roots and competitive sports',
                                ),
                                _buildFeatureItem(
                                  Icons.volunteer_activism,
                                  'Philanthropy',
                                  'Dare2Dream Foundation - Inspiring youth through sports and education',
                                ),
                                _buildFeatureItem(
                                  Icons.code,
                                  'Technology',
                                  'Coding apps and exploring technology',
                                ),
                                _buildFeatureItem(
                                  Icons.science,
                                  'Science',
                                  'Favorite academic subject and passion for learning',
                                ),
                                _buildFeatureItem(
                                  Icons.movie,
                                  'Directing',
                                  'Growing passion for film direction and storytelling',
                                ),
                                _buildFeatureItem(
                                  Icons.gavel,
                                  'Law School',
                                  'Long-term goal of pursuing legal education',
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


}
