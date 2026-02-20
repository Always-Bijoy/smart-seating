import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../models/trip_model.dart';
import '../providers/trip_provider.dart';
import '../services/sun_calculator.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/buttons.dart';

class SunTrackerScreen extends StatelessWidget {
  const SunTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TripProvider>(
      builder: (context, tripProvider, _) {
        final trip = tripProvider.hasTrip
            ? tripProvider.currentTrip!
            : SunCalculator.calculate('Manikganj', 'Dhaka', DateTime.now());

        final l10n = context.l10n;
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.planScreenGradient,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildAppBar(context, l10n),
                  _buildHeaderChips(trip, l10n),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          _buildCompass(trip),
                          const SizedBox(height: 28),
                          _buildStatusSection(trip, l10n),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                  _buildFooter(context, trip, l10n),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── App bar ────────────────────────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.textPrimary.withValues(alpha: 0.6),
              size: 24,
            ),
          ),
          const Spacer(),
          Column(
            children: [
              Text(
                l10n.liveTrackerLabel,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary.withValues(alpha: 0.4),
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                l10n.sunPosition,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(
            Icons.more_horiz_rounded,
            color: AppColors.textPrimary.withValues(alpha: 0.6),
            size: 24,
          ),
        ],
      ),
    );
  }

  // ─── Header chips (time + direction) ────────────────────────────────────────

  Widget _buildHeaderChips(TripModel trip, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _chip(icon: Icons.schedule_rounded, label: trip.formattedTime),
          const SizedBox(width: 8),
          _chip(
            icon: Icons.explore_rounded,
            label: l10n.headingChip(trip.headingLabel),
          ),
        ],
      ),
    );
  }

  Widget _chip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Compass ────────────────────────────────────────────────────────────────

  Widget _buildCompass(TripModel trip) {
    const compassSize = 288.0;
    const sunRadius = 115.0;

    final sunOffset = trip.isNight
        ? const Offset(0, -sunRadius)
        : SunCalculator.sunDotOffset(trip.sunAzimuth, sunRadius);

    final headingRad = trip.headingDegrees * math.pi / 180;

    return Center(
      child: SizedBox(
        width: compassSize,
        height: compassSize,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Outer frosted circle
            Container(
              width: compassSize,
              height: compassSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.05),
                ),
              ),
            ),

            // Inner dashed ring
            SizedBox(
              width: compassSize - 32,
              height: compassSize - 32,
              child: CustomPaint(painter: _DashedCirclePainter()),
            ),

            // Sun arc trajectory
            SizedBox(
              width: compassSize,
              height: compassSize,
              child: CustomPaint(painter: _SunArcPainter()),
            ),

            // Cardinal labels
            Positioned(top: 12, child: _cardinalLabel('N')),
            Positioned(right: 12, child: _cardinalLabel('E')),
            Positioned(bottom: 12, child: _cardinalLabel('S')),
            Positioned(left: 12, child: _cardinalLabel('W')),

            // Sun icon with glow
            Transform.translate(
              offset: sunOffset,
              child: trip.isNight
                  ? const Icon(
                      Icons.nightlight_round,
                      color: Colors.indigo,
                      size: 28,
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(alpha: 0.30),
                          ),
                        ),
                        const Icon(
                          Icons.wb_sunny_rounded,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      ],
                    ),
            ),

            // Bus — landscape, rotated to heading, with navigation arrow
            Transform.rotate(
              angle: headingRad,
              child: _buildBusView(trip),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardinalLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Colors.black.withValues(alpha: 0.2),
      ),
    );
  }

  /// Landscape bus centred in the compass.
  /// [clipBehavior: Clip.none] lets the nav arrow overflow above the bus.
  Widget _buildBusView(TripModel trip) {
    final leftColor = trip.sunSide == 'left'
        ? AppColors.primary.withValues(alpha: 0.4)
        : const Color(0xFF60A5FA).withValues(alpha: 0.3);
    final rightColor = trip.sunSide == 'right'
        ? AppColors.primary.withValues(alpha: 0.4)
        : const Color(0xFF60A5FA).withValues(alpha: 0.3);

    return SizedBox(
      width: 96,
      height: 48,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Navigation arrow above the bus (outside clip bounds)
          const Positioned(
            top: -28,
            left: 0,
            right: 0,
            child: Center(
              child: Icon(
                Icons.navigation_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),

          // Bus body
          Container(
            width: 96,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF181611),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.30),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  Expanded(child: Container(color: leftColor)),
                  Container(width: 1.5, color: Colors.black26),
                  Expanded(child: Container(color: rightColor)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Status section ──────────────────────────────────────────────────────────

  Widget _buildStatusSection(TripModel trip, AppLocalizations l10n) {
    final shadeParts = l10n.shadeIsMovingRich(trip.shadeSide);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.light_mode_rounded,
                color: AppColors.primary,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                trip.isNight
                    ? l10n.noSunlightNighttime
                    : l10n.intenseSunlightOnSide(trip.sunSide),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
            children: [
              TextSpan(text: shadeParts[0]),
              TextSpan(
                text: shadeParts[1],
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF3B82F6),
                ),
              ),
              TextSpan(text: shadeParts[2]),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Footer ──────────────────────────────────────────────────────────────────

  Widget _buildFooter(
      BuildContext context, TripModel trip, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTimeProjection(trip, l10n),
          const SizedBox(height: 16),
          SecondaryButton(
            label: l10n.notifyOnShadeChange,
            icon: Icons.notifications_active_rounded,
            iconColor: AppColors.primary,
            onPressed: () {},
          ),
          const SizedBox(height: 22),
          AppBottomNav(
            activeTab: NavTab.tracker,
            onHomeTap: () => Navigator.popUntil(context, (r) => r.isFirst),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeProjection(TripModel trip, AppLocalizations l10n) {
    // Range: 12:00 PM (12h) → 8:00 PM (20h) = 8 hours
    final hour = trip.departureTime.hour + trip.departureTime.minute / 60.0;
    final fraction = ((hour - 12.0) / 8.0).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.timeProjection,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary.withValues(alpha: 0.4),
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  trip.formattedTime,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                l10n.live,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        LayoutBuilder(builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final fillWidth = fraction * totalWidth;
          final dotLeft = (fraction * totalWidth - 12).clamp(0.0, totalWidth - 24.0);
          return SizedBox(
            height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Track
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                // Fill
                Positioned(
                  left: 0,
                  child: Container(
                    height: 6,
                    width: fillWidth,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.30),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                // Thumb
                Positioned(
                  left: dotLeft,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.10),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _timeLabel(l10n.timeLabelNoon),
            _timeLabel(l10n.timeLabelAfternoon),
            _timeLabel(l10n.timeLabelEvening),
          ],
        ),
      ],
    );
  }

  Widget _timeLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Colors.black.withValues(alpha: 0.30),
      ),
    );
  }

}

// ─── Custom painters ─────────────────────────────────────────────────────────

/// Draws a dashed circle to match the HTML's inner `border-2 border-dashed border-black/5`.
class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;

    const totalSegments = 48;
    const totalAngle = 2 * math.pi;
    const dashFraction = 0.5;

    for (int i = 0; i < totalSegments; i++) {
      final startAngle = totalAngle * i / totalSegments;
      const sweepAngle = totalAngle / totalSegments * dashFraction;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Draws a dashed gradient arc representing the sun's path (yellow → blue).
/// Mirrors the HTML SVG `stroke="url(#sunPath)" stroke-dasharray="2 2"`.
class _SunArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.38;

    const totalSegments = 36;
    // Arc from West (π) sweeping counterclockwise to East (0) through North
    const startAngle = math.pi;
    const totalSweep = -math.pi;

    for (int i = 0; i < totalSegments; i++) {
      final t = i / totalSegments;
      final color = Color.lerp(
        const Color(0xFFF4C025),
        const Color(0xFF60A5FA),
        t,
      )!
          .withValues(alpha: 0.5);

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round;

      final segStart = startAngle + totalSweep * i / totalSegments;
      const segSweep = totalSweep / totalSegments;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        segStart,
        segSweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
