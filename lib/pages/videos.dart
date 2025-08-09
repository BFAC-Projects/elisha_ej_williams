import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late WebViewController _webViewController;

  // Video data
  final List<Map<String, String>> videos = [
    {
      'id': 'LnfKHD3k2QU',
      'url': 'https://www.youtube.com/embed/LnfKHD3k2QU?si=EU7pNmWvVjw0f36g',
      'title': 'Elisha EJ Williams Interview',
      'description':
          'Exclusive interview discussing acting career and future projects',
      'thumbnail': 'https://img.youtube.com/vi/LnfKHD3k2QU/maxresdefault.jpg',
    },
    {
      'id': 'QWBALk5csbU',
      'url': 'https://www.youtube.com/embed/QWBALk5csbU',
      'title': 'Behind the Scenes',
      'description': 'Behind the scenes footage from The Wonder Years',
      'thumbnail': 'https://img.youtube.com/vi/QWBALk5csbU/maxresdefault.jpg',
    },
    {
      'id': 'gaJt6SDVm1Q',
      'url': 'https://www.youtube.com/embed/gaJt6SDVm1Q',
      'title': 'Voice Acting Session',
      'description': 'Recording session for Puppy Dog Pals character Bingo',
      'thumbnail': 'https://img.youtube.com/vi/gaJt6SDVm1Q/maxresdefault.jpg',
    },
  ];

  int currentVideoIndex = 0;

  @override
  void initState() {
    super.initState();

    // Initialize WebView controller
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(videos[currentVideoIndex]['url']!));

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

  void _changeVideo(int index) {
    if (index != currentVideoIndex) {
      print('Changing video to index: $index, ID: ${videos[index]['id']}');
      setState(() {
        currentVideoIndex = index;
      });
      // Load the new video in the WebView
      _webViewController.loadRequest(
        Uri.parse(videos[currentVideoIndex]['url']!),
      );
    }
  }

  Future<void> _playVideo(String videoId) async {
    final youtubeUrl = 'https://www.youtube.com/watch?v=$videoId';
    final youtubeAppUrl = 'youtube://watch?v=$videoId';

    try {
      // Try to open in YouTube app first
      if (await canLaunchUrl(Uri.parse(youtubeAppUrl))) {
        await launchUrl(Uri.parse(youtubeAppUrl));
      } else {
        // Fallback to web browser
        await launchUrl(
          Uri.parse(youtubeUrl),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      print('Error opening YouTube: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Videos',
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
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/feature_background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: CustomScrollView(
                  slivers: [
                    // Video player section
                    SliverToBoxAdapter(
                      child: _buildAnimatedSection(
                        delay: 400,
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Video player
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: SizedBox(
                                  height: 250,
                                  child: WebViewWidget(
                                    controller: _webViewController,
                                  ),
                                ),
                              ),

                              // Video info
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      videos[currentVideoIndex]['title']!,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF618DAC),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      videos[currentVideoIndex]['description']!,
                                      style: TextStyle(
                                        fontSize: 16,
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
                      ),
                    ),

                    // Video selection section
                    SliverToBoxAdapter(
                      child: _buildAnimatedSection(
                        delay: 600,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'More Videos',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF618DAC),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Video list
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final video = videos[index];
                          final isSelected = index == currentVideoIndex;

                          return _buildAnimatedSection(
                            delay: 800 + (index * 100),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF618DAC).withOpacity(0.1)
                                    : Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected
                                    ? Border.all(
                                        color: const Color(0xFF618DAC),
                                        width: 2,
                                      )
                                    : null,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    _changeVideo(index);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        // Thumbnail
                                        Container(
                                          width: 80,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            color: Colors.grey[300],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Image.network(
                                              video['thumbnail']!,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[300],
                                                      child: const Icon(
                                                        Icons
                                                            .play_circle_outline,
                                                        color: Color(
                                                          0xFF618DAC,
                                                        ),
                                                        size: 30,
                                                      ),
                                                    );
                                                  },
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 12),

                                        // Video info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                video['title']!,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: isSelected
                                                      ? const Color(0xFF618DAC)
                                                      : Colors.black87,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                video['description']!,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Selection indicator
                                        Icon(
                                          isSelected
                                              ? Icons.check_circle
                                              : Icons.play_circle_outline,
                                          color: const Color(0xFF618DAC),
                                          size: 32,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }, childCount: videos.length),
                      ),
                    ),

                    // Bottom spacing
                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
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
}
