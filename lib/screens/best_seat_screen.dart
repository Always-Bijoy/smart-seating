import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/bus_seat_map.dart';
import '../widgets/buttons.dart';
import 'sun_tracker_screen.dart';

class BestSeatScreen extends StatelessWidget {
  const BestSeatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Right side seats (cols 2,3 = index 2,3 per row) for rows 2-4
    const shadedSeats = {2, 3, 6, 7, 10, 11};

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.planScreenGradient,
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
                      const SizedBox(height: 16),
                      _buildRouteChip(),
                      const SizedBox(height: 24),
                      const BusSeatMap(
                        shadedSeats: shadedSeats,
                        selectedSeats: {2, 3, 6, 7, 10, 11},
                      ),
                      const SizedBox(height: 20),
                      _buildHeatBanner(),
                      const SizedBox(height: 16),
                      _buildRecommendationCard(),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
              _buildNotifyButton(context),
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
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.textPrimary,
              size: 24,
            ),
          ),
          const Spacer(),
          Text(
            'Best Seat Found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.share_rounded,
            color: AppColors.textMuted,
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildRouteChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '2:00 PM • Heading South-East',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatBanner() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.wb_sunny_rounded, color: AppColors.sunYellow, size: 18),
        const SizedBox(width: 6),
        Text(
          'Intense heat on LEFT',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8B6914),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Sit on ',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextSpan(
                  text: 'RIGHT',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                TextSpan(
                  text: ' side',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Seats in rows 2–4 on the right offer 100%\nshade for the next 45 minutes.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotifyButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: PrimaryButton(
        label: 'Notify Me on Arrival',
        icon: Icons.notifications_rounded,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SunTrackerScreen(),
            ),
          );
        },
      ),
    );
  }
}
