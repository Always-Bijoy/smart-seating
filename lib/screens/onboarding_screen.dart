import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

const String _kOnboardingDone = 'onboarding_complete';

Future<bool> hasSeenOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_kOnboardingDone) ?? false;
}

Future<void> markOnboardingDone() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_kOnboardingDone, true);
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _next() {
    if (_currentPage < _totalPages - 1) {
      _goToPage(_currentPage + 1);
    } else {
      _finish();
    }
  }

  void _back() {
    if (_currentPage > 0) {
      _goToPage(_currentPage - 1);
    }
  }

  void _skip() => _finish();

  void _finish() async {
    await markOnboardingDone();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _Page1(onNext: _next, onClose: _skip),
                  _Page2(onNext: _next, onBack: _back, onSkip: _skip),
                  _Page3(onGetStarted: _finish, onBack: _back),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          if (_currentPage == 0)
            GestureDetector(
              onTap: _skip,
              child: const Icon(Icons.close, size: 22, color: AppColors.textPrimary),
            )
          else
            GestureDetector(
              onTap: _back,
              child: const Icon(Icons.arrow_back, size: 22, color: AppColors.textPrimary),
            ),
          const Spacer(),
          Text(
            'STEP ${_currentPage + 1} OF $_totalPages',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const Spacer(),
          if (_currentPage == 1)
            GestureDetector(
              onTap: _skip,
              child: Text(
                'SKIP',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.0,
                ),
              ),
            )
          else
            const SizedBox(width: 22),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Page 1 — Stay Cool on Every Journey
// ─────────────────────────────────────────
class _Page1 extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onClose;

  const _Page1({required this.onNext, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          const _SunShadeIllustration(),
          const SizedBox(height: 40),
          Text(
            'Stay Cool on Every\nJourney',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Identify the shady side of the bus\nbefore you even board.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.55,
            ),
          ),
          const Spacer(),
          const _DotIndicator(current: 0, total: 3),
          const SizedBox(height: 24),
          _NextButton(label: 'Next', onPressed: onNext),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Page 2 — Smart Real-Time Updates
// ─────────────────────────────────────────
class _Page2 extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  const _Page2({required this.onNext, required this.onBack, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            flex: 5,
            child: _PhoneMockup(),
          ),
          const SizedBox(height: 32),
          Text(
            'Smart Real–Time\nUpdates',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Our intelligent tracker adjusts as the bus\nturns, ensuring you stay out of the sun.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.55,
            ),
          ),
          const Spacer(),
          const _DotIndicator(current: 1, total: 3),
          const SizedBox(height: 24),
          _NextButton(label: 'Next', onPressed: onNext),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Page 3 — Ready for a Better Commute?
// ─────────────────────────────────────────
class _Page3 extends StatelessWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onBack;

  const _Page3({required this.onGetStarted, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          const Expanded(
            flex: 5,
            child: _BusSeatCard(),
          ),
          const SizedBox(height: 32),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Ready for a\n',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.25,
                  ),
                ),
                TextSpan(
                  text: 'Better Commute?',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Enter your route and find your perfect seat\nnow. Stay cool, stay in the shade.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.55,
            ),
          ),
          const Spacer(),
          const _DotIndicator(current: 2, total: 3),
          const SizedBox(height: 24),
          _NextButton(label: 'Get Started', onPressed: onGetStarted),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Shared Widgets
// ─────────────────────────────────────────

class _NextButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _NextButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          color: AppColors.primaryButtonBg,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 18, color: Colors.black87),
          ],
        ),
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final int current;
  final int total;

  const _DotIndicator({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : const Color(0xFFDDDDDD),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────
// Illustration: Sun vs Shade cards (Page 1)
// ─────────────────────────────────────────
class _SunShadeIllustration extends StatelessWidget {
  const _SunShadeIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Row(
        children: [
          Expanded(child: _SideCard(isSunny: true)),
          SizedBox(width: 12),
          Expanded(child: _SideCard(isSunny: false)),
        ],
      ),
    );
  }
}

class _SideCard extends StatelessWidget {
  final bool isSunny;
  const _SideCard({required this.isSunny});

  @override
  Widget build(BuildContext context) {
    final bg = isSunny ? const Color(0xFFFFF8F0) : const Color(0xFFF0F7FF);
    final lineColor = isSunny ? const Color(0xFFFFD09B) : const Color(0xFFB3D4F0);
    final iconColor = isSunny ? const Color(0xFFFF8C00) : const Color(0xFF2196F3);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isSunny
              ? _SunIcon(color: iconColor)
              : Icon(Icons.cloud, size: 48, color: iconColor),
          const SizedBox(height: 12),
          Container(
            height: 3,
            width: 48,
            decoration: BoxDecoration(
              color: lineColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),
          isSunny
              ? Icon(Icons.sentiment_dissatisfied_rounded,
                  size: 38, color: iconColor)
              : Icon(Icons.sentiment_satisfied_alt_rounded,
                  size: 38, color: iconColor),
        ],
      ),
    );
  }
}

class _SunIcon extends StatelessWidget {
  final Color color;
  const _SunIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: CustomPaint(painter: _SunPainter(color: color)),
    );
  }
}

class _SunPainter extends CustomPainter {
  final Color color;
  const _SunPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    const radius = 11.0;
    const rayLen = 7.0;
    const outerR = radius + rayLen + 4;

    paint.style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, paint);

    paint.style = PaintingStyle.stroke;
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * math.pi / 180;
      final start = Offset(
        center.dx + (radius + 4) * math.cos(angle),
        center.dy + (radius + 4) * math.sin(angle),
      );
      final end = Offset(
        center.dx + outerR * math.cos(angle),
        center.dy + outerR * math.sin(angle),
      );
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(_SunPainter old) => old.color != color;
}

// ─────────────────────────────────────────
// Illustration: Phone Mockup + Map (Page 2)
// ─────────────────────────────────────────
class _PhoneMockup extends StatefulWidget {
  @override
  State<_PhoneMockup> createState() => _PhoneMockupState();
}

class _PhoneMockupState extends State<_PhoneMockup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spinController;
  late final Animation<double> _spinAnimation;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _spinAnimation = CurvedAnimation(
      parent: _spinController,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 0.52,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(33),
            child: Stack(
              children: [
                // Map background
                const _MapBackground(),
                // Animated compass
                Center(
                  child: RotationTransition(
                    turns: _spinAnimation,
                    child: const _CompassWidget(),
                  ),
                ),
                // Bus icon
                Positioned(
                  top: 80,
                  left: 40,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.directions_bus,
                        color: Colors.white, size: 20),
                  ),
                ),
                // Bottom label
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3CD),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.wb_sunny,
                              color: AppColors.primary, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'OPTIMAL SIDE',
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                                letterSpacing: 0.8,
                              ),
                            ),
                            Text(
                              'Left Side (Shady)',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
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
}

class _MapBackground extends StatelessWidget {
  const _MapBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD4E8C2),
      child: CustomPaint(
        painter: _MapPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final minorRoadPaint = Paint()
      ..color = const Color(0xFFE8E8E8)
      ..strokeWidth = 4;

    final waterPaint = Paint()..color = const Color(0xFF9EC8E8);

    // Water body (left side)
    final waterPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.35, 0)
      ..lineTo(size.width * 0.25, size.height * 0.45)
      ..lineTo(0, size.height * 0.5)
      ..close();
    canvas.drawPath(waterPath, waterPaint);

    // Roads
    canvas.drawLine(
      Offset(0, size.height * 0.35),
      Offset(size.width, size.height * 0.4),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.4, 0),
      Offset(size.width * 0.45, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.6),
      Offset(size.width, size.height * 0.65),
      minorRoadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.65, 0),
      Offset(size.width * 0.7, size.height),
      minorRoadPaint,
    );
  }

  @override
  bool shouldRepaint(_MapPainter _) => false;
}

class _CompassWidget extends StatelessWidget {
  const _CompassWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 110,
      child: CustomPaint(painter: _CompassPainter()),
    );
  }
}

class _CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final ringPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius - 2, ringPaint);

    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Cross lines
    canvas.drawLine(
      Offset(center.dx, center.dy - radius + 12),
      Offset(center.dx, center.dy + radius - 12),
      linePaint,
    );
    canvas.drawLine(
      Offset(center.dx - radius + 12, center.dy),
      Offset(center.dx + radius - 12, center.dy),
      linePaint,
    );

    // North star
    final starPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(center.dx, center.dy - radius + 4)
      ..lineTo(center.dx - 7, center.dy - radius + 18)
      ..lineTo(center.dx, center.dy - radius + 14)
      ..lineTo(center.dx + 7, center.dy - radius + 18)
      ..close();
    canvas.drawPath(path, starPaint);
  }

  @override
  bool shouldRepaint(_CompassPainter _) => false;
}

// ─────────────────────────────────────────
// Illustration: Bus Seat Card (Page 3)
// ─────────────────────────────────────────
class _BusSeatCard extends StatelessWidget {
  const _BusSeatCard();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background blob
        Positioned(
          top: 0,
          right: -20,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Main card
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: const _BusSeatIllustration(),
          ),
        ),
        // Small floating card
        Positioned(
          bottom: 28,
          right: -8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle,
                    color: AppColors.greenCheck, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Seat 14A — Shady',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BusSeatIllustration extends StatelessWidget {
  const _BusSeatIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1B3A4B),
      padding: const EdgeInsets.all(20),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SeatWidget(highlighted: false),
              _SeatWidget(highlighted: true),
              _SeatWidget(highlighted: false),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SeatWidget(highlighted: true),
              _SeatWidget(highlighted: false),
              _SeatWidget(highlighted: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _SeatWidget extends StatelessWidget {
  final bool highlighted;
  const _SeatWidget({required this.highlighted});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 90,
      decoration: BoxDecoration(
        color: highlighted
            ? const Color(0xFF2A5C70)
            : const Color(0xFF243845),
        borderRadius: BorderRadius.circular(12),
        border: highlighted
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
      ),
      child: Column(
        children: [
          // Headrest
          Container(
            height: 22,
            margin: const EdgeInsets.fromLTRB(6, 6, 6, 0),
            decoration: BoxDecoration(
              color: highlighted
                  ? const Color(0xFF3A7090)
                  : const Color(0xFF2E4F60),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Seat back
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(6, 0, 6, 6),
              decoration: BoxDecoration(
                color: highlighted
                    ? const Color(0xFF3A7090)
                    : const Color(0xFF2E4F60),
                borderRadius: BorderRadius.circular(6),
              ),
              child: highlighted
                  ? const Center(
                      child: Icon(Icons.wb_sunny,
                          color: AppColors.primary, size: 16),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
