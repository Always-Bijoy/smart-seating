import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/trip_model.dart';
import '../providers/trip_provider.dart';
import '../services/sun_calculator.dart';
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

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, trip),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildSunDial(trip),
                        const SizedBox(height: 20),
                        _buildIntensityBanner(trip),
                        const SizedBox(height: 12),
                        _buildShadeMovingCard(trip),
                        const SizedBox(height: 20),
                        _buildTimelineCard(trip),
                        const SizedBox(height: 28),
                        SecondaryButton(
                          label: 'Plan Another Trip',
                          icon: Icons.directions_bus_rounded,
                          onPressed: () =>
                              Navigator.popUntil(context, (r) => r.isFirst),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, TripModel trip) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            ),
          ),
          const Spacer(),
          Column(
            children: [
              Text(
                'LIVE TRACKER',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                'Sun Position',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.more_horiz_rounded, size: 24),
        ],
      ),
    );
  }

  Widget _buildSunDial(TripModel trip) {
    // Sun dot position on the compass ring (radius 105)
    final Offset sunOffset = trip.isNight
        ? const Offset(0, -105)
        : SunCalculator.sunDotOffset(trip.sunAzimuth, 105);

    return Center(
      child: SizedBox(
        width: 260,
        height: 260,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring
            Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFEEEEEE),
                  width: 1.5,
                ),
              ),
            ),
            // Inner ring
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFEEEEEE),
                  width: 1.5,
                ),
              ),
            ),
            // Tick marks
            ...List.generate(12, (i) {
              final angle = (i * 30.0) * math.pi / 180;
              return Transform.rotate(
                angle: angle,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 1.5,
                      height: 8,
                      color: const Color(0xFFDDDDDD),
                    ),
                    const SizedBox(height: 110),
                  ],
                ),
              );
            }),

            // Bus icon in centre
            _buildBusTopView(trip),

            // Sun dot
            if (!trip.isNight)
              Transform.translate(
                offset: sunOffset,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('☀', style: TextStyle(fontSize: 10)),
                  ),
                ),
              )
            else
              Transform.translate(
                offset: const Offset(0, -105),
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('🌙', style: TextStyle(fontSize: 9)),
                  ),
                ),
              ),

            // Cardinal labels
            Positioned(
              top: 8,
              child: Text('N',
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.textMuted)),
            ),
            Positioned(
              bottom: 8,
              child: Text('S',
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.textMuted)),
            ),
            Positioned(
              right: 8,
              child: Text('E',
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.textMuted)),
            ),
            Positioned(
              left: 8,
              child: Text('W',
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.textMuted)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusTopView(TripModel trip) {
    // Rotate the bus icon to match the heading
    final headingRad = trip.headingDegrees * math.pi / 180;
    return Transform.rotate(
      angle: headingRad,
      child: Container(
        width: 56,
        height: 90,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _busWindow(const Color(0xFF1A3A5C)),
              const SizedBox(height: 3),
              _busWindow(const Color(0xFF1A3A5C)),
              const SizedBox(height: 3),
              _busWindow(const Color(0xFF4A90D9)),
              const SizedBox(height: 3),
              _busWindow(const Color(0xFF4A90D9)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _busWindow(Color color) =>
      Container(width: 36, height: 14, color: color);

  Widget _buildIntensityBanner(TripModel trip) {
    return Row(
      children: [
        Icon(
          trip.isNight ? Icons.nightlight_round : Icons.wb_sunny_rounded,
          color: trip.isNight ? AppColors.textMuted : AppColors.sunYellow,
          size: 18,
        ),
        const SizedBox(width: 6),
        Text(
          trip.isNight
              ? 'No sunlight — nighttime travel'
              : 'Intense Sunlight on ${_cap(trip.sunSide)}',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: trip.isNight
                ? AppColors.textSecondary
                : const Color(0xFF8B6914),
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              trip.formattedTime,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.navigation_rounded,
                color: AppColors.textSecondary, size: 14),
            const SizedBox(width: 4),
            Text(
              trip.headingLabel,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShadeMovingCard(TripModel trip) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommended seat side',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Sit on the ',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextSpan(
                  text: _cap(trip.shadeSide),
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${trip.origin} → ${trip.destination} · ${trip.formattedTime}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(TripModel trip) {
    // Fraction of daylight elapsed (6 AM = 0, 6 PM = 1)
    final hour = trip.departureTime.hour + trip.departureTime.minute / 60.0;
    final fraction = ((hour - 6.0) / 12.0).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TIME PROJECTION',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    trip.formattedTime,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: trip.isNight
                      ? Colors.indigo.shade100
                      : AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  trip.isNight ? 'NIGHT' : 'DAY',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: trip.isNight
                        ? Colors.indigo.shade700
                        : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final dotLeft =
                (fraction * totalWidth - 7).clamp(0.0, totalWidth - 14);
            final fillWidth = fraction * totalWidth;
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Positioned(
                  left: 0,
                  child: Container(
                    height: 4,
                    width: fillWidth,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFFFFE082)],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Positioned(
                  left: dotLeft,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('6:00 AM',
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.textMuted)),
              Text('12:00 PM',
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.textMuted)),
              Text('6:00 PM',
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }

  String _cap(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
