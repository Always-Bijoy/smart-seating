import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/bus_illustration.dart';
import '../widgets/buttons.dart';
import 'plan_trip_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 12),
                        _buildRoutePill(),
                        const SizedBox(height: 8),
                        _buildWeatherPill(),
                        const SizedBox(height: 28),
                        const BusIllustration(sunOnLeft: true),
                        const SizedBox(height: 24),
                        _buildSunlightBanner(),
                        const SizedBox(height: 16),
                        _buildRecommendationCard(),
                        const SizedBox(height: 28),
                        PrimaryButton(
                          label: 'Find Best Seat',
                          icon: Icons.event_seat_rounded,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PlanTripScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          const Icon(
            Icons.menu_rounded,
            color: AppColors.textPrimary,
            size: 24,
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.directions_bus_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'Smart Seating',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(
            Icons.person_outline_rounded,
            color: AppColors.textMuted,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildPill({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.pillBackground,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildRoutePill() {
    return Center(
      child: _buildPill(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Manikganj',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: AppColors.accentOrange,
              ),
            ),
            Text(
              'Dhaka',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherPill() {
    return Center(
      child: _buildPill(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wb_sunny_rounded,
              color: AppColors.sunYellow,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              '2:00 PM',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              ' • ',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Sunny',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSunlightBanner() {
    return Center(
      child: _buildPill(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wb_sunny_rounded,
              color: AppColors.sunYellow,
              size: 18,
            ),
            const SizedBox(width: 8),
            RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                children: [
                  const TextSpan(text: 'Sunlight on '),
                  TextSpan(
                    text: 'LEFT',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const TextSpan(text: ' side'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.greenCheck,
              size: 28,
            ),
            const SizedBox(width: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Sit on ',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: 'RIGHT',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  TextSpan(
                    text: ' side',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Underline under "RIGHT"
        const SizedBox(height: 4),
        Container(
          width: 56,
          height: 2,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Based on your route heading South-East at 2:00 PM, the right side will remain in full shade.',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

}
