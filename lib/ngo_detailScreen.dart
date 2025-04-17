import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impact_waves/constants.dart';
import 'dart:ui';

// Custom Tab Indicator to control width
class CustomTabIndicator extends Decoration {
  final double widthFactor;
  final BorderRadius borderRadius;
  final Gradient gradient;
  final EdgeInsets padding;

  const CustomTabIndicator({
    required this.widthFactor,
    required this.borderRadius,
    required this.gradient,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomTabIndicatorPainter(
      widthFactor: widthFactor,
      borderRadius: borderRadius,
      gradient: gradient,
      padding: padding,
    );
  }
}

class _CustomTabIndicatorPainter extends BoxPainter {
  final double widthFactor;
  final BorderRadius borderRadius;
  final Gradient gradient;
  final EdgeInsets padding;

  _CustomTabIndicatorPainter({
    required this.widthFactor,
    required this.borderRadius,
    required this.gradient,
    required this.padding,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final double tabWidth = configuration.size!.width * widthFactor;
    final Rect rect = Offset(
          offset.dx + (configuration.size!.width - tabWidth) / 2 + padding.left,
          offset.dy + padding.top,
        ) &
        Size(
          tabWidth - padding.horizontal,
          configuration.size!.height - 4 - padding.vertical,
        );
    final Paint paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, borderRadius.topLeft),
      paint,
    );
  }
}

class NgoDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> ngo;

  const NgoDetailsScreen({super.key, required this.ngo});

  @override
  State<NgoDetailsScreen> createState() => _NgoDetailsScreenState();
}

class _NgoDetailsScreenState extends State<NgoDetailsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _fabScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.ngo['photos'] as List<String>;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: Text(
                widget.ngo['name'] as String,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  shadows: [const Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2))],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'ngo-image-${widget.ngo['name']}-${photos[0]}',
                    child: Image.network(
                      photos[0],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator(color: Colors.white));
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, color: Colors.red, size: 50);
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.2),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.teal[900],
                    unselectedLabelColor: Colors.grey[600],
                    indicator: UnderlineTabIndicator(
                    
                      borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color:Colors.teal[400]!)
                    ),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 16), // Wider tab spacing
                    indicatorPadding: const EdgeInsets.symmetric(vertical: 4),
                    labelStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    unselectedLabelStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                    padding: const EdgeInsets.all(4),
                    tabs: const [
                      Tab(text: 'Info'),
                      Tab(text: 'Needs'),
                      Tab(text: 'Stories'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[200]!, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: TabBarView(
            controller: _tabController,
            children: [
              // Info Tab
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: const Duration(milliseconds: 500),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.ngo['name'] as String,
                              style: GoogleFonts.poppins(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          if (widget.ngo['verified'] as bool)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.green[400]!, Colors.green[200]!],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.verified, color: Colors.white, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Verified',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.ngo['mission'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'About Us',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'We are dedicated to transforming lives through education and community support. '
                      'Our programs reach thousands of children annually, providing them with essential resources.',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[800],
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 180,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.85,
                      ),
                      items: photos.map((url) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, color: Colors.red, size: 50);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              // Needs Tab
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Monthly Needs',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...(widget.ngo['needs'] as List).asMap().entries.map((entry) {
                    final need = entry.value;
                    return AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 500 + entry.key * 100),
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white.withOpacity(0.2),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: Text(
                                  '${need['item']} (x${need['quantity']})',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Text(
                                  need['impact'],
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.teal[400]!, Colors.teal[200]!],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${need['quantity']}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              // Stories Tab
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Impact Stories',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...(widget.ngo['stories'] as List).asMap().entries.map((entry) {
                    final story = entry.value;
                    return AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 500 + entry.key * 100),
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white.withOpacity(0.2),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                    child: Image.network(
                                      story['image'],
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return const SizedBox(
                                          height: 180,
                                          child: Center(child: CircularProgressIndicator()),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.error, color: Colors.red, size: 50);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          story['title'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          story['description'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                            height: 1.5,
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
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/donation-cart'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.card_giftcard),
        label: const Text('Donate Items'),
      ),
    );
  }
}