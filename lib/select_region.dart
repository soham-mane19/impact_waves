import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impact_waves/constants.dart';
import 'package:impact_waves/ngo_listing.dart';

class SelectRegionScreen extends StatefulWidget {
  const SelectRegionScreen({super.key});

  @override
  State<SelectRegionScreen> createState() => _SelectRegionScreenState();
}

class _SelectRegionScreenState extends State<SelectRegionScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
   
  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFF), Color(0xFFE8EEFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }

  PreferredSizeWidget _buildAppBar(bool isMobile) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Image.asset('assets/logo.png', height: 36),
      centerTitle: isMobile,
      actions: isMobile
          ? null
          : [
              _buildAppBarButton('Discover', () {}),
              const SizedBox(width: 16),
              _buildAppBarButton('How it Works', () {}),
              const SizedBox(width: 16),
              _buildAppBarButton('Sign In', () {}),
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
    );
  }

  Widget _buildAppBarButton(String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 16,
          color: const Color(0xFF1A1A1A),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isMobile, bool isWeb, double screenWidth) {
    final double fontScale = isMobile ? 0.8 : isWeb ? 1.0 : 0.9;
    final double padding = screenWidth * 0.05;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 32),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isWeb ? 1200 : screenWidth * 0.9),
          child: isMobile
              ? Column(
                  children: [
                    _buildHeroCard(context, fontScale, screenWidth, isMobile),
                    const SizedBox(height: 24),
                    _buildHeroImage(screenWidth, isMobile),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: _buildHeroCard(context, fontScale, screenWidth, isMobile)),
                    const SizedBox(width: 24),
                    Expanded(child: _buildHeroImage(screenWidth, isMobile)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, double fontScale, double screenWidth, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Hero(
            tag: 'hero-text',
            child: Text(
              'Every Drop Creates a Wave of Change',
              style: GoogleFonts.inter(
                fontSize: 32 * fontScale,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A1A),
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'India’s first transparent donation platform empowering you to choose what, where, and why you give.',
            style: GoogleFonts.inter(
              fontSize: 16 * fontScale,
              color: const Color(0xFF4A4A4A),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
          _buildStatCounter(fontScale, screenWidth, isMobile),
          const SizedBox(height: 24),
          _buildPrimaryButton(
            'Start Giving Now',
            () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NgoListingScreen()),
            ),
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(double screenWidth, bool isMobile) {
    return Container(
      constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 600),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=600&auto=format&fit=crop&q=80',
              height: isMobile ? screenWidth * 0.7 : 400,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.2), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCounter(double fontScale, double screenWidth, bool isMobile) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      alignment: WrapAlignment.start,
      children: [
        _buildCounterItem('5,412 Donors', 5412, fontScale, screenWidth, isMobile),
        _buildCounterItem('1.2L+ Goods Delivered', 120000, fontScale, screenWidth, isMobile),
        _buildCounterItem('100% Verified NGOs', 100, fontScale, screenWidth, isMobile),
      ],
    );
  }

  Widget _buildCounterItem(String label, int end, double fontScale, double screenWidth, bool isMobile) {
    return Container(
      constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 200),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder(
            tween: IntTween(begin: 0, end: end),
            duration: const Duration(seconds: 2),
            builder: (context, value, child) {
              return Text(
                value.toString(),
                style: GoogleFonts.inter(
                  fontSize: 16 * fontScale,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF007BFF),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14 * fontScale,
                color: const Color(0xFF4A4A4A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRippleSection(BuildContext context, bool isMobile, double screenWidth) {
    final double padding = screenWidth * 0.05;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 40),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reimagining Donations for Impact',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 24 : 32,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 16),
              isMobile
                  ? Column(
                      children: [
                        _buildProblemCard(screenWidth, isMobile),
                        const SizedBox(height: 16),
                        _buildSolutionCard(screenWidth, isMobile),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildProblemCard(screenWidth, isMobile)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildSolutionCard(screenWidth, isMobile)),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProblemCard(double screenWidth, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'The Challenge',
            style: GoogleFonts.inter(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          _buildTableRow('Unneeded donations pile up', isMobile: isMobile),
          _buildTableRow('Opaque donation tracking', isMobile: isMobile),
          _buildTableRow('Generic giving options', isMobile: isMobile),
          _buildTableRow('Inefficient delivery systems', isMobile: isMobile),
        ],
      ),
    );
  }

  Widget _buildSolutionCard(double screenWidth, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: const Color(0xFF007BFF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF007BFF).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Our Solution',
            style: GoogleFonts.inter(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF007BFF),
            ),
          ),
          const SizedBox(height: 12),
          _buildTableRow('Real-time NGO needs', isSolution: true, isMobile: isMobile),
          _buildTableRow('End-to-end tracking', isSolution: true, isMobile: isMobile),
          _buildTableRow('Customized giving options', isSolution: true, isMobile: isMobile),
          _buildTableRow('Fast, reliable delivery', isSolution: true, isMobile: isMobile),
        ],
      ),
    );
  }

  Widget _buildTableRow(String text, {bool isSolution = false, required bool isMobile}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: isMobile ? 14 : 16,
          color: isSolution ? const Color(0xFF007BFF) : const Color(0xFF4A4A4A),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDonorFlowSection(BuildContext context, bool isMobile, double screenWidth) {
    final double padding = screenWidth * 0.05;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 40),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Give with Purpose',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 24 : 32,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Control every aspect of your donation:',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 16 : 18,
                  color: const Color(0xFF4A4A4A),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  _buildFlowCard(
                    icon: Icons.volunteer_activism,
                    title: 'What to Give',
                    description: 'Food, books, clothes, kits',
                    width: isMobile ? screenWidth * 0.9 : 320,
                    isMobile: isMobile,
                    imageUrl: 'https://images.unsplash.com/photo-1577896851231-70ef18881754?w=600&auto=format&fit=crop&q=80',
                  ),
                  _buildFlowCard(
                    icon: Icons.place,
                    title: 'Where to Give',
                    description: 'Choose by state, district, or cause',
                    width: isMobile ? screenWidth * 0.9 : 320,
                    isMobile: isMobile,
                    imageUrl: 'https://media.istockphoto.com/id/1318617341/photo/low-angle-view-group-of-volunteers-busy-working-by-arranging-vegetables-and-clothes-on.jpg?s=2048x2048&w=is&k=20&c=vcTgoyASX5duS-rW7N6va8rKpbu8kgOnp5fNZaoqGCY=',
                  ),
                  _buildFlowCard(
                    icon: Icons.favorite,
                    title: 'Why You Give',
                    description: 'Support hunger, education, or health',
                    width: isMobile ? screenWidth * 0.9 : 320,
                    isMobile: isMobile,
                    imageUrl: 'https://media.istockphoto.com/id/693322828/photo/make-a-difference.jpg?s=2048x2048&w=is&k=20&c=9CIkSiYTHcfQBLhBCS0FkkHnQM17CQ4HsK4KYsV_Zz0=',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlowCard({
    required IconData icon,
    required String title,
    required String description,
    required double width,
    required bool isMobile,
    required String imageUrl,
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              height: isMobile ? 80 : 100,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Icon(icon, color: const Color(0xFF007BFF), size: isMobile ? 36 : 40),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 14 : 16,
              color: const Color(0xFF4A4A4A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackImpactSection(BuildContext context, bool isMobile, double screenWidth) {
    final double padding = screenWidth * 0.05;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 40),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Track Your Impact in Real-Time',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 24 : 32,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Watch your donation make a difference:\n- Live delivery updates\n- Impact dashboard\n- Beneficiary stories',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 16 : 18,
                  color: const Color(0xFF4A4A4A),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              AnimatedDonationPath(),
              const SizedBox(height: 24),
              Text(
                'Voices of Change',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: isMobile ? 200 : 240,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    TestimonialCard(
                      imagePath: 'https://images.unsplash.com/photo-1559028012-481c04fa702d?w=600&auto=format&fit=crop&q=80',
                      name: 'Hope Foundation',
                      feedback: '“Your support helped 500+ children thrive.”',
                      isMobile: isMobile,
                    ),
                    const SizedBox(width: 16),
                    TestimonialCard(
                      imagePath: 'https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=600&auto=format&fit=crop&q=80',
                      name: 'Seva Trust',
                      feedback: '“Donations aided flood-affected families.”',
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

  Widget _buildPillarsSection(BuildContext context, bool isMobile, double screenWidth) {
    final double padding = screenWidth * 0.05;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 40),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Our Core Values',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 24 : 32,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  _buildPillarCard(
                    icon: Icons.verified,
                    title: 'Trust',
                    description: '100% verified NGO partners',
                    width: isMobile ? screenWidth * 0.9 : 320,
                    isMobile: isMobile,
                  ),
                  _buildPillarCard(
                    icon: Icons.track_changes,
                    title: 'Transparency',
                    description: 'Track every donation live',
                    width: isMobile ? screenWidth * 0.9 : 320,
                    isMobile: isMobile,
                  ),
                  _buildPillarCard(
                    icon: Icons.accessibility,
                    title: 'Accessibility',
                    description: 'For all donors, big or small',
                    width: isMobile ? screenWidth * 0.9 : 320,
                    isMobile: isMobile,
                  ),
                ],
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
    return Container(
      width: width,
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF007BFF), size: isMobile ? 36 : 40),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 14 : 16,
              color: const Color(0xFF4A4A4A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalCtaSection(BuildContext context, bool isMobile, double screenWidth) {
    final double fontScale = isMobile ? 0.8 : 1.0;
    final double padding = screenWidth * 0.05;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF007BFF), Color(0xFF005BBB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 1200),
          child: Column(
            children: [
              Text(
                'Be the Spark for Change',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 32 * fontScale,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your donation starts a ripple effect that transforms lives.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16 * fontScale,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  _buildPrimaryButton(
                    'Donate Now',
                    () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const NgoListingScreen()),
                    ),
                    isMobile: isMobile,
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
    );
  }

  Widget _buildPrimaryButton(String text, VoidCallback onPressed, {required bool isMobile}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 32, vertical: isMobile ? 12 : 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF007BFF), Color(0xFF00C4FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF007BFF).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 16 : 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
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
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 32, vertical: isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF007BFF)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 16 : 18,
              color: const Color(0xFF007BFF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isMobile, double screenWidth) {
    final double padding = screenWidth * 0.05;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 32),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
      ),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isMobile ? screenWidth * 0.9 : 1200),
          child: Column(
            children: [
              Image.asset('assets/logo.png', height: isMobile ? 28 : 32),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.facebook, color: Colors.white, size: 28),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.abc, color: Colors.white, size: 28),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.abc, color: Colors.white, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 24,
                runSpacing: 16,
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
              const SizedBox(height: 24),
              Text(
                '© 2025 Impact Waves',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 12 : 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: isMobile ? 16 : 18,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map(
          (item) => TextButton(
            onPressed: () {},
            child: Text(
              item,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 14 : 15,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
        ),
      ],
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
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
              child: Image.asset('assets/logo.png', height: 36),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDrawerItem(title: 'Discover Fundraisers', onTap: () => Navigator.pop(context)),
                  _buildDrawerItem(title: 'How It Works', onTap: () => Navigator.pop(context)),
                  _buildDrawerItem(title: 'Sign In', onTap: () => Navigator.pop(context)),
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
                  fontSize: 12,
                  color: const Color(0xFF4A4A4A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFF1A1A1A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// Animated Donation Path Widget (Unchanged)
class AnimatedDonationPath extends StatefulWidget {
  @override
  _AnimatedDonationPathState createState() => _AnimatedDonationPathState();
}

class _AnimatedDonationPathState extends State<AnimatedDonationPath>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: false);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: DonationPathPainter(progress: _animation.value),
          size: const Size(double.infinity, 200),
        );
      },
    );
  }
}

class DonationPathPainter extends CustomPainter {
  final double progress;

  DonationPathPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF007BFF)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width * progress, size.height / 2);

    canvas.drawPath(path, paint);

    final circlePaint = Paint()..color = Color(0xFF007BFF);
    canvas.drawCircle(
      Offset(size.width * progress, size.height / 2),
      8,
      circlePaint,
    );

    // Add labels for the donation path stages
    final textStyle = TextStyle(
      color: Color(0xFF1A1A1A),
      fontSize: 14,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    );
    final textPainter = (String text, double x) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        textDirection: TextDirection.ltr,
      );
      painter.layout();
      painter.paint(canvas, Offset(x - painter.width / 2, size.height / 2 + 20));
    };

    // Define positions for each stage
    final stages = ['Donor', 'Fulfilment', 'NGO', 'Beneficiaries'];
    final stagePositions = [
      0.0,
      size.width * 0.33,
      size.width * 0.66,
      size.width * 1.0
    ];

    for (int i = 0; i < stages.length; i++) {
      textPainter(stages[i], stagePositions[i]);
      canvas.drawCircle(
        Offset(stagePositions[i], size.height / 2),
        6,
        Paint()..color = Color(0xFF007BFF),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class TestimonialCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String feedback;
  final bool isMobile;

  const TestimonialCard({
    required this.imagePath,
    required this.name,
    required this.feedback,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imagePath,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            feedback,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 14 : 16,
              color: const Color(0xFF4A4A4A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}