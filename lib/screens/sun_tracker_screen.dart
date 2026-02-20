import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/bottom_nav_bar.dart';

class SunTrackerScreen extends StatelessWidget {
  const SunTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildSunDial(),
                    const SizedBox(height: 20),
                    _buildIntensityBanner(),
                    const SizedBox(height: 12),
                    _buildShadeMovingCard(),
                    const SizedBox(height: 20),
                    _buildTimelineCard(),
                    const SizedBox(height: 28),
                    SecondaryButton(
                      label: 'Notify on Shade Change',
                      icon: Icons.notifications_outlined,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
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

  Widget _buildSunDial() {
    return Center(
      child: Container(
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

            // Tick marks around outer ring
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

            // Sun dot at position (roughly top-right, heading SE)
            Transform.translate(
              offset: const Offset(70, -50),
              child: Container(
                width: 16,
                height: 16,
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
              ),
            ),

            // Bus icon in center
            _buildBusTopView(),

            // Cardinal labels
            Positioned(
              top: 8,
              child: Text(
                'N',
                style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted),
              ),
            ),
            Positioned(
              bottom: 8,
              child: Text(
                'S',
                style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted),
              ),
            ),
            Positioned(
              right: 8,
              child: Text(
                'E',
                style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted),
              ),
            ),
            Positioned(
              left: 8,
              child: Text(
                'W',
                style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusTopView() {
    return Container(
      width: 60,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 40, height: 16, color: const Color(0xFF1A3A5C), margin: const EdgeInsets.only(bottom: 4)),
            Container(width: 40, height: 16, color: const Color(0xFF1A3A5C), margin: const EdgeInsets.only(bottom: 4)),
            Container(width: 40, height: 16, color: const Color(0xFF4A90D9)),
            Container(width: 40, height: 16, color: const Color(0xFF4A90D9), margin: const EdgeInsets.only(top: 4)),
          ],
        ),
      ),
    );
  }

  Widget _buildIntensityBanner() {
    return Row(
      children: [
        const Icon(Icons.wb_sunny_rounded, color: AppColors.sunYellow, size: 18),
        const SizedBox(width: 6),
        Text(
          'Intense Sunlight on Left',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF8B6914),
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
              '2:15 PM',
              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.navigation_rounded, color: AppColors.textSecondary, size: 14),
            const SizedBox(width: 4),
            Text(
              'Heading SE',
              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShadeMovingCard() {
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
            'Shade is moving',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Shade is moving ',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextSpan(
                  text: 'Right',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard() {
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
                    '2:15 PM',
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'LIVE',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Timeline slider
          Stack(
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
                  width: 160,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFFFFE082)],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Positioned(
                left: 154,
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
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '12:00 PM',
                style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted),
              ),
              Text(
                '4:00 PM',
                style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted),
              ),
              Text(
                '8:00 PM',
                style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return AppBottomNavBar(
      selectedIndex: 0,
      onItemSelected: (_) {},
      items: const [
        BottomNavItem(icon: Icons.home_rounded, label: 'HOME'),
        BottomNavItem(icon: Icons.event_seat_rounded, label: 'SEATS'),
        BottomNavItem(icon: Icons.route_rounded, label: 'ROUTE'),
      ],
    );
  }
}
