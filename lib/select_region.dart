import 'package:carousel_slider/carousel_slider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impact_waves/constants.dart';
import 'package:impact_waves/ngo_listing.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SelectRegionScreen extends StatefulWidget {
  const SelectRegionScreen({super.key});

  @override
  State<SelectRegionScreen> createState() => _SelectRegionScreenState();
}

class _SelectRegionScreenState extends State<SelectRegionScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _waterDropController;
  late AnimationController _rippleController;
  late ScrollController _scrollController;
  late AnimationController _parallaxController;
  late Animation<Offset> _parallaxAnimation;
  late AnimationController _buttonPulseController;
  late Animation<double> _buttonPulseAnimation;
  double _rippleOpacity = 0.0;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutQuint),
    );
    _waterDropController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _rippleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _parallaxController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
    _parallaxAnimation = Tween<Offset>(
      begin: const Offset(0, -0.05),
      end: const Offset(0, 0.05),
    ).animate(CurvedAnimation(parent: _parallaxController, curve: Curves.easeInOut));
    _buttonPulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _buttonPulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _buttonPulseController, curve: Curves.easeInOut),
    );
    _scrollController = ScrollController()
      ..addListener(() {
        final offset = _scrollController.offset;
        setState(() {
          _rippleOpacity = (offset / 300).clamp(0.0, 1.0);
        });
      });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _waterDropController.dispose();
    _rippleController.dispose();
    _parallaxController.dispose();
    _buttonPulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;
    final bool isWeb = screenWidth > 1200;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(isMobile),
      drawer: isMobile ? _buildDrawer() : null,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFF8FAFF),
              Colors.blue.shade50,
              Colors.blue.shade100.withOpacity(0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Background particle animation
            Lottie.asset(
              'assets/particle.json',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              repeat: true,
            ),
            SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 600),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(child: widget),
                      ),
                      children: [
                        _buildHeroSection(context, isMobile, isWeb, screenWidth),
                        _buildRippleSection(context, isMobile, screenWidth),
                        _buildDonorFlowSection(context, isMobile, screenWidth),
                        _buildTrackImpactSection(context, isMobile, screenWidth),
                        _buildPillarsSection(context, isMobile, screenWidth),
                        _buildFinalCtaSection(context, isMobile, screenWidth),
                        _buildFooter(context, isMobile, screenWidth),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isMobile) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 600),
        child: Image.asset('assets/logo.png', height: 36),
      ),
      centerTitle: isMobile,
      actions: isMobile
          ? null
          : AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 400),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                MouseRegion(
                  onEnter: (_) => setState(() => _isHovered = true),
                  onExit: (_) => setState(() => _isHovered = false),
                  child: _buildAppBarButton('Discover', () {}),
                ),
                const SizedBox(width: 16),
                MouseRegion(
                  onEnter: (_) => setState(() => _isHovered = true),
                  onExit: (_) => setState(() => _isHovered = false),
                  child: _buildAppBarButton('How it Works', () {}),
                ),
                const SizedBox(width: 16),
                MouseRegion(
                  onEnter: (_) => setState(() => _isHovered = true),
                  onExit: (_) => setState(() => _isHovered = false),
                  child: _buildAppBarButton('Sign In', () {}),
                ),
                const SizedBox(width: 16),
                _buildPrimaryButton(
                  'Start Giving',
                  () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const NgoListingScreen()),
                  ),
                  isMobile: false,
                ),
                const SizedBox(width: 16),
              ],
            ),
    );
  }

  Widget _buildAppBarButton(String text, VoidCallback onPressed) {
    return AnimatedScale(
      scale: _isHovered ? 1.1 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          backgroundColor: Colors.white.withOpacity(0.1),
          shadowColor: Colors.blue.shade200,
          elevation: _isHovered ? 5 : 0,
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 16,
            color: const Color(0xFF1A1A1A),
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(
                color: Colors.blue.shade200.withOpacity(0.3),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isMobile, bool isWeb, double screenWidth) {
    final double fontScale = isMobile ? 0.8 : isWeb ? 1.2 : 1.0;
    final double padding = screenWidth * 0.05;

    return GestureDetector(
      onTap: () => _waterDropController.forward(from: 0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 40),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _parallaxAnimation,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, _parallaxAnimation.value.dy * 100),
                child: Lottie.asset(
                  'assets/water_drop_1.json',
                  controller: _waterDropController,
                  height: 400,
                  width: screenWidth,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: isWeb ? 1400 : screenWidth * 0.9),
                child: isMobile
                    ? Column(
                        children: [
                          _buildHeroCard(context, fontScale, screenWidth, isMobile),
                          const SizedBox(height: 32),
                          _buildHeroImage(screenWidth, isMobile),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: _buildHeroCard(context, fontScale, screenWidth, isMobile)),
                          const SizedBox(width: 32),
                          Expanded(child: _buildHeroImage(screenWidth, isMobile)),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, double fontScale, double screenWidth, bool isMobile) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 24 : 40),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100.withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 600),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 20.0,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              Hero(
                tag: 'hero-text',
                child: Text(
                  'Every Drop Creates a Wave of Change',
                  style: GoogleFonts.inter(
                    fontSize: 36 * fontScale,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0D47A1),
                    height: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.blue.shade200,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'India’s first transparent donation platform empowering you to choose what, where, and why you give.',
                style: GoogleFonts.inter(
                  fontSize: 16 * fontScale,
                  color: const Color(0xFF455A64),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 32),
              _buildStatCounter(fontScale, screenWidth, isMobile),
              const SizedBox(height: 32),
              _buildPrimaryButton(
                'Start Giving Now',
                () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const NgoListingScreen()),
                ),
                isMobile: isMobile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroImage(double screenWidth, bool isMobile) {
    final List<String> imagePaths = [
      'assets/child_img.jpg',
      'assets/done_img.jpg',
      'assets/don_img.jpg',
    ];

    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 600),
      child: Container(
        height: 300,
        constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 600),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: CarouselSlider(
            options: CarouselOptions(
              height: isMobile ? screenWidth * 0.8 : 450,
              autoPlay: true,
              viewportFraction: 1.0,
              enableInfiniteScroll: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              pauseAutoPlayOnTouch: true,
            ),
            items: imagePaths.map((path) {
              return Stack(
                children: [
                  Image.asset(
                    path,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCounter(double fontScale, double screenWidth, bool isMobile) {
    return Wrap(
      spacing: 24,
      runSpacing: 16,
      alignment: WrapAlignment.start,
      children: AnimationConfiguration.toStaggeredList(
        duration: const Duration(milliseconds: 800),
        childAnimationBuilder: (widget) => ScaleAnimation(
          child: FadeInAnimation(child: widget),
        ),
        children: [
          _buildCounterItem('5,412 Donors', 5412, fontScale, screenWidth, isMobile),
          _buildCounterItem('1.2L+ Goods', 120000, fontScale, screenWidth, isMobile),
          _buildCounterItem('100% Verified NGOs', 100, fontScale, screenWidth, isMobile),
        ],
      ),
    );
  }

  Widget _buildCounterItem(String label, int end, double fontScale, double screenWidth, bool isMobile) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 800),
      child: Container(
        constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 220),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder(
              tween: IntTween(begin: 0, end: end),
              duration: const Duration(seconds: 3),
              builder: (context, value, child) {
                return Text(
                  value.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 18 * fontScale,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1565C0),
                    shadows: [
                      Shadow(
                        color: Colors.blue.shade200,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14 * fontScale,
                  color: const Color(0xFF455A64),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRippleSection(BuildContext context, bool isMobile, double screenWidth) {
    final double padding = screenWidth * 0.00;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
      child: Stack(
        children: [
          AnimatedOpacity(
            opacity: _rippleOpacity,
            duration: const Duration(milliseconds: 500),
            child: CustomPaint(
              size: Size(screenWidth, 400),
              painter: RippleTransitionPainter(_rippleController),
            ),
          ),
          Lottie.asset(
            'assets/wave.json',
            width: screenWidth,
            height: 400,
            fit: BoxFit.cover,
            repeat: true,
          ),
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 1400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 600),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: [
                    Text(
                      'Reimagining Donations for Impact',
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 28 : 36,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.blue.shade200,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    isMobile
                        ? Column(
                            children: [
                              _buildProblemCard(screenWidth, isMobile),
                              const SizedBox(height: 24),
                              _buildSolutionCard(screenWidth, isMobile),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildProblemCard(screenWidth, isMobile)),
                              const SizedBox(width: 24),
                              Expanded(child: _buildSolutionCard(screenWidth, isMobile)),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProblemCard(double screenWidth, bool isMobile) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, offset, child) {
        return Transform.translate(
          offset: Offset(0, offset.dy * 100),
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            child: child,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(isMobile ? 20 : 32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'The Challenge',
              style: GoogleFonts.inter(
                fontSize: isMobile ? 20 : 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D47A1),
                shadows: [
                  Shadow(
                    color: Colors.blue.shade200,
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildTableRow('Unneeded donations pile up', isMobile: isMobile),
            _buildTableRow('Opaque donation tracking', isMobile: isMobile),
            _buildTableRow('Generic giving options', isMobile: isMobile),
            _buildTableRow('Inefficient delivery systems', isMobile: isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildSolutionCard(double screenWidth, bool isMobile) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: AnimatedOpacity(
            opacity: _rippleOpacity,
            duration: const Duration(milliseconds: 500),
            child: child,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(isMobile ? 20 : 32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Our Solution',
              style: GoogleFonts.inter(
                fontSize: isMobile ? 20 : 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1565C0),
                shadows: [
                  Shadow(
                    color: Colors.blue.shade200,
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildTableRow('Real-time NGO needs', isSolution: true, isMobile: isMobile),
            _buildTableRow('End-to-end tracking', isSolution: true, isMobile: isMobile),
            _buildTableRow('Customized giving options', isSolution: true, isMobile: isMobile),
            _buildTableRow('Fast, reliable delivery', isSolution: true, isMobile: isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(String text, {bool isSolution = false, required bool isMobile}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          AnimatedScale(
            scale: isSolution ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: Icon(
              isSolution ? Icons.check_circle : Icons.cancel,
              color: isSolution ? Colors.green.shade400 : Colors.red.shade400,
              size: isMobile ? 20 : 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 15 : 16,
                color: isSolution ? const Color(0xFF1565C0) : const Color(0xFF455A64),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonorFlowSection(BuildContext context, bool isMobile, double screenWidth) {
    final double padding = screenWidth * 0.05;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 48),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 1400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 600),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                Text(
                  'Give with Purpose',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 28 : 36,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0D47A1),
                    shadows: [
                      Shadow(
                        color: Colors.blue.shade200,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Control every aspect of your donation.',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 16 : 18,
                    color: const Color(0xFF455A64),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),
                InteractiveDonorFlow(isMobile: isMobile, screenWidth: screenWidth),
                const SizedBox(height: 32),
                _buildNgoCarousel(isMobile, screenWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNgoCarousel(bool isMobile, double screenWidth) {
    return SizedBox(
      height: isMobile ? 120 : 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 600),
          childAnimationBuilder: (widget) => ScaleAnimation(
            child: FadeInAnimation(child: widget),
          ),
          children: [
            _buildNgoNeedCard('200 nutrition kits needed in Jharkhand', isMobile),
            const SizedBox(width: 16),
            _buildNgoNeedCard('300 school bags required in Nashik', isMobile),
            const SizedBox(width: 16),
            _buildNgoNeedCard('150 hygiene kits for Odisha', isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildNgoNeedCard(String text, bool isMobile) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.bounceOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: AnimatedOpacity(
            opacity: value,
            duration: const Duration(milliseconds: 600),
            child: child,
          ),
        );
      },
      child: Container(
        width: isMobile ? 220 : 260,
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 3,
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 14 : 16,
              color: const Color(0xFF0D47A1),
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  color: Colors.blue.shade200,
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrackImpactSection(BuildContext context, bool isMobile, double screenWidth) {
    final double padding = screenWidth * 0.05;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 48),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 1400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 600),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                Text(
                  'Track Your Impact in Real-Time',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 28 : 36,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0D47A1),
                    shadows: [
                      Shadow(
                        color: Colors.blue.shade200,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Watch your donation make a difference:\n- Live delivery updates\n- Impact dashboard\n- Beneficiary stories',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 16 : 18,
                    color: const Color(0xFF455A64),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),
                AnimatedDonationPath(),
                const SizedBox(height: 32),
                Text(
                  'Voices of Change',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 20 : 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D47A1),
                    shadows: [
                      Shadow(
                        color: Colors.blue.shade200,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: isMobile ? 260 : 260,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 600),
                      childAnimationBuilder: (widget) => ScaleAnimation(
                        child: FadeInAnimation(child: widget),
                      ),
                      children: [
                        TestimonialCard(
                          imagePath: 'assets/class_img.jpg',
                          name: 'Hope Foundation',
                          feedback: '“Your support helped 500+ children thrive.”',
                          isMobile: isMobile,
                        ),
                        const SizedBox(width: 16),
                        TestimonialCard(
                          imagePath: 'assets/done_img.jpg',
                          name: 'Seva Trust',
                          feedback: '“Donations aided flood-affected families.”',
                          isMobile: isMobile,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPillarsSection(BuildContext context, bool isMobile, double screenWidth) {
    final double padding = screenWidth * 0.05;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 48),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 1400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Our Core Values',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 28 : 36,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0D47A1),
                  shadows: [
                    Shadow(
                      color: Colors.blue.shade200,
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 600),
                  childAnimationBuilder: (widget) => FlipAnimation(
                    child: FadeInAnimation(child: widget),
                  ),
                  children: [
                    _buildPillarCard(
                      icon: Icons.verified,
                      title: 'Trust',
                      description: '100% verified NGO partners',
                      width: isMobile ? screenWidth * 0.9 : 360,
                      isMobile: isMobile,
                    ),
                    _buildPillarCard(
                      icon: Icons.track_changes,
                      title: 'Transparency',
                      description: 'Track every donation live',
                      width: isMobile ? screenWidth * 0.9 : 360,
                      isMobile: isMobile,
                    ),
                    _buildPillarCard(
                      icon: Icons.accessibility,
                      title: 'Accessibility',
                      description: 'For all donors, big or small',
                      width: isMobile ? screenWidth * 0.9 : 360,
                      isMobile: isMobile,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillarCard({
    required IconData icon,
    required String title,
    required String description,
    required double width,
    required bool isMobile,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Container(
          width: width,
          padding: EdgeInsets.all(isMobile ? 20 : 28),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade100.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: 1.0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  icon,
                  color: const Color(0xFF1565C0),
                  size: isMobile ? 40 : 48,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 20 : 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D47A1),
                  shadows: [
                    Shadow(
                      color: Colors.blue.shade200,
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 15 : 16,
                  color: const Color(0xFF455A64),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinalCtaSection(BuildContext context, bool isMobile, double screenWidth) {
    final double fontScale = isMobile ? 0.8 : 1.2;
    final double padding = screenWidth * 0.05;
    final confettiController = ConfettiController(duration: const Duration(seconds: 3));

    return GestureDetector(
      onTap: () {
        confettiController.play();
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 48),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              children: [
                Lottie.asset(
                  'assets/water_pulse.json',
                  height: 300,
                  width: screenWidth,
                  fit: BoxFit.cover,
                  repeat: true,
                ),
                Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 1400),
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 600),
                        childAnimationBuilder: (widget) => ScaleAnimation(
                          child: FadeInAnimation(child: widget),
                        ),
                        children: [
                          Text(
                            'Be the Spark for Change',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 36 * fontScale,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.blue.shade200,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Your donation starts a ripple effect that transforms lives.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 16 * fontScale,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            alignment: WrapAlignment.center,
                            children: [
                              AnimatedBuilder(
                                animation: _buttonPulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _buttonPulseAnimation.value,
                                    child: _buildPrimaryButton(
                                      'Donate Now',
                                      () {
                                        confettiController.play();
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => const NgoListingScreen()),
                                        );
                                      },
                                      isMobile: isMobile,
                                    ),
                                  );
                                },
                              ),
                              _buildSecondaryButton(
                                'Partner With Us',
                                () {},
                                isMobile: isMobile,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirection: 0 / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 100,
              minBlastForce: 20,
              colors: [
                Colors.blue.shade200,
                Colors.blue.shade400,
                Colors.white,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(String text, VoidCallback onPressed, {required bool isMobile}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 28 : 36,
            vertical: isMobile ? 14 : 18,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.blue.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade300.withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 5,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 16 : 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  color: Colors.blue.shade200,
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String text, VoidCallback onPressed, {required bool isMobile}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 28 : 36,
            vertical: isMobile ? 14 : 18,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue.shade400, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade100.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 5,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 16 : 18,
              color: Colors.blue.shade600,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  color: Colors.blue.shade200,
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isMobile, double screenWidth) {
    final double padding = screenWidth * 0.05;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutExpo,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 40),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
        ),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 1400),
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 600),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(child: widget),
                ),
                children: [
                  Image.asset('assets/logo.png', height: isMobile ? 32 : 36),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 400),
                      childAnimationBuilder: (widget) => ScaleAnimation(
                        child: FadeInAnimation(child: widget),
                      ),
                      children: [
                        _animatedIconButton(Icons.facebook),
                        _animatedIconButton(Icons.abc),
                        _animatedIconButton(Icons.abc),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 32,
                    runSpacing: 24,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildFooterColumn(
                        title: 'About',
                        items: ['Our Mission', 'Team'],
                        isMobile: isMobile,
                      ),
                      _buildFooterColumn(
                        title: 'Help Center',
                        items: ['FAQs', 'Contact Us'],
                        isMobile: isMobile,
                      ),
                      _buildFooterColumn(
                        title: 'More',
                        items: ['Blog', 'Careers', 'Privacy'],
                        isMobile: isMobile,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '© 2025 Impact Waves',
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 13 : 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterColumn({
    required String title,
    required List<String> items,
    required bool isMobile,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 18 : 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                shadows: [
                  Shadow(
                    color: Colors.blue.shade200,
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {},
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        item,
                        style: GoogleFonts.inter(
                          fontSize: isMobile ? 15 : 16,
                          color: Colors.white.withOpacity(0.75),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _animatedIconButton(IconData icon) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 32),
        onPressed: () {},
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFF), Color(0xFFE8EEFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 400),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: -50.0,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                child: Image.asset('assets/logo.png', height: 40),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDrawerItem(
                      title: 'Discover Fundraisers',
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildDrawerItem(
                      title: 'How It Works',
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildDrawerItem(
                      title: 'Sign In',
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildDrawerItem(
                      title: 'Start Giving Now',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const NgoListingScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '© 2025 Impact Waves',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF455A64),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(20 * (1 - value), 0),
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFF0D47A1),
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    color: Colors.blue.shade200,
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Ripple Transition Painter for Problem/Solution Section
class RippleTransitionPainter extends CustomPainter {
  final AnimationController controller;

  RippleTransitionPainter(this.controller) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.blue.shade200.withOpacity(0.3),
          Colors.blue.shade100.withOpacity(0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width * controller.value,
      ));

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * controller.value,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Interactive Donor Flow Widget
class InteractiveDonorFlow extends StatefulWidget {
  final bool isMobile;
  final double screenWidth;

  const InteractiveDonorFlow({super.key, required this.isMobile, required this.screenWidth});

  @override
  State<InteractiveDonorFlow> createState() => _InteractiveDonorFlowState();
}

class _InteractiveDonorFlowState extends State<InteractiveDonorFlow> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _onCardTap(int index) {
    setState(() {
      _selectedIndex = index;
      _animationController.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> flowItems = [
      {
        'icon': Icons.volunteer_activism,
        'title': 'What to Give',
        'description': 'Food, books, clothes, kits',
        'imageUrl': 'assets/don_img.jpg',
        'fallbackImage': 'assets/images/food.jpg',
      },
      {
        'icon': Icons.place,
        'title': 'Where to Give',
        'description': 'Choose by state, district, or cause',
        'imageUrl': 'assets/class_img.jpg',
        'fallbackImage': 'assets/images/location.jpg',
      },
      {
        'icon': Icons.favorite,
        'title': 'Why You Give',
        'description': 'Support hunger, education, or health',
        'imageUrl': 'assets/digg_img.jpg',
        'fallbackImage': 'assets/images/cause.jpg',
      },
    ];

    return Wrap(
      spacing: 24,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: flowItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return AnimatedBuilder(
          animation: Listenable.merge([_animationController, _glowController]),
          builder: (context, child) {
            return Transform.scale(
              scale: _selectedIndex == index ? _scaleAnimation.value : 0.95,
              child: GestureDetector(
                onTap: () => _onCardTap(index),
                child: _buildFlowCard(
                  icon: item['icon'],
                  title: item['title'],
                  description: item['description'],
                  width: widget.isMobile ? widget.screenWidth * 0.9 : 360,
                  isMobile: widget.isMobile,
                  imageUrl: item['imageUrl'],
                  fallbackImage: item['fallbackImage'],
                  isSelected: _selectedIndex == index,
                  glowOpacity: _glowAnimation.value,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildFlowCard({
    required IconData icon,
    required String title,
    required String description,
    required double width,
    required bool isMobile,
    required String imageUrl,
    required String fallbackImage,
    required bool isSelected,
    required double glowOpacity,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.bounceOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        width: width,
        padding: EdgeInsets.all(isMobile ? 20 : 28),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isSelected ? Colors.blue.shade400.withOpacity(glowOpacity) : Colors.white.withOpacity(0.2),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.blue.shade200.withOpacity(glowOpacity * 0.5) : Colors.blue.shade100.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: isSelected ? 10 : 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                imageUrl,
                height: isMobile ? 100 : 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  fallbackImage,
                  height: isMobile ? 100 : 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: isMobile ? 100 : 120,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                icon,
                color: const Color(0xFF1565C0),
                size: isMobile ? 40 : 48,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 20 : 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D47A1),
                shadows: [
                  Shadow(
                    color: Colors.blue.shade200,
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 15 : 16,
                color: const Color(0xFF455A64),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Animated Donation Path Widget
class AnimatedDonationPath extends StatefulWidget {
  const AnimatedDonationPath({super.key});

  @override
  State<AnimatedDonationPath> createState() => _AnimatedDonationPathState();
}

class _AnimatedDonationPathState extends State<AnimatedDonationPath> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: EnhancedDonationPathPainter(progress: _animation.value),
                size: const Size(double.infinity, 250),
              );
            },
          ),
          // Particle effect for donation path
          Lottie.asset(
            'assets/particle.json',
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
            repeat: true,
            
          
          ),
        ],
      ),
    );
  }
}

class EnhancedDonationPathPainter extends CustomPainter {
  final double progress;

  EnhancedDonationPathPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final pathPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.blue.shade300,
          Colors.blue.shade600,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final points = [
      Offset(0, size.height / 2),
      Offset(size.width * 0.33, size.height / 2 - 50),
      Offset(size.width * 0.66, size.height / 2 + 50),
      Offset(size.width, size.height / 2),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      final t = (progress * (points.length - 1)).clamp(0, i).toDouble();
      if (t >= i) {
        path.lineTo(points[i].dx, points[i].dy);
      } else {
        final fraction = t - t.floor();
        final start = points[i - 1];
        final end = points[i];
        final x = start.dx + (end.dx - start.dx) * fraction;
        final y = start.dy + (end.dy - start.dy) * fraction;
        path.lineTo(x, y);
        break;
      }
    }

    canvas.drawPath(path, pathPaint);

    final circlePaint = Paint()
      ..color = Colors.blue.shade600
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: [
          Colors.blue.shade200,
          Colors.blue.shade600,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: 10,
      ));
    final currentX = path.computeMetrics().first.getTangentForOffset(
              path.computeMetrics().first.length * progress,
            )?.position.dx ??
        0;
    final currentY = path.computeMetrics().first.getTangentForOffset(
              path.computeMetrics().first.length * progress,
            )?.position.dy ??
        size.height / 2;
    canvas.drawCircle(Offset(currentX, currentY), 10, circlePaint);

    final textStyle = GoogleFonts.inter(
      color: const Color(0xFF0D47A1),
      fontSize: 14,
      fontWeight: FontWeight.w600,
      shadows: [
        Shadow(
          color: Colors.blue.shade200,
          blurRadius: 4,
        ),
      ],
    );
    final stages = ['Donor', 'Fulfillment', 'NGO', 'Beneficiaries'];
    final icons = [
      Icons.person,
      Icons.local_shipping,
      Icons.group,
      Icons.favorite,
    ];

    for (int i = 0; i < stages.length; i++) {
      final textPainter = TextPainter(
        text: TextSpan(text: stages[i], style: textStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(points[i].dx - textPainter.width / 2, points[i].dy + 30),
      );

      final iconPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(icons[i].codePoint),
          style: TextStyle(
            fontFamily: icons[i].fontFamily,
            fontSize: 24,
            color: Colors.blue.shade600,
            shadows: [
              Shadow(
                color: Colors.blue.shade200,
                blurRadius: 4,
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      iconPainter.layout();
      iconPainter.paint(
        canvas,
        Offset(points[i].dx - iconPainter.width / 2, points[i].dy - 20),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Testimonial Card
class TestimonialCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String feedback;
  final bool isMobile;

  const TestimonialCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.feedback,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Container(
          width: 300,
          padding: EdgeInsets.all(isMobile ? 20 : 24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade100.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imagePath,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 20 : 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D47A1),
                  shadows: [
                    Shadow(
                      color: Colors.blue.shade200,
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                feedback,
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 15 : 16,
                  color: const Color(0xFF455A64),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}