import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/trip_model.dart';
import '../providers/trip_provider.dart';
import '../services/sun_calculator.dart';
import '../widgets/bus_illustration.dart';
import '../widgets/buttons.dart';
import 'plan_trip_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Returns the trip to display — last planned trip or a live demo.
  TripModel _getDisplayTrip(TripProvider provider) {
    if (provider.hasTrip) return provider.currentTrip!;
    // Default demo: Manikganj → Dhaka at current time
    return SunCalculator.calculate('Manikganj', 'Dhaka', DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TripProvider>(
      builder: (context, tripProvider, _) {
        final trip = _getDisplayTrip(tripProvider);
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
                          _buildRoutePill(trip),
                          const SizedBox(height: 8),
                          _buildWeatherPill(trip),
                          const SizedBox(height: 28),
                          BusIllustration(sunOnLeft: trip.sunSide == 'left'),
                          const SizedBox(height: 24),
                          _buildSunlightBanner(trip),
                          const SizedBox(height: 16),
                          _buildRecommendationCard(trip, tripProvider.hasTrip),
                          const SizedBox(height: 28),
                          PrimaryButton(
                            label: tripProvider.hasTrip
                                ? 'Plan Another Trip'
                                : 'Find Best Seat',
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
      },
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

  Widget _buildRoutePill(TripModel trip) {
    return Center(
      child: _buildPill(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              trip.origin,
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
              trip.destination,
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

  Widget _buildWeatherPill(TripModel trip) {
    return Center(
      child: _buildPill(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              trip.isNight
                  ? Icons.nightlight_round
                  : Icons.wb_sunny_rounded,
              color: trip.isNight
                  ? AppColors.textMuted
                  : AppColors.sunYellow,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              trip.formattedTime,
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
              trip.isNight ? 'Nighttime' : 'Sunny',
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

  Widget _buildSunlightBanner(TripModel trip) {
    if (trip.isNight) {
      return Center(
        child: _buildPill(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.nightlight_round,
                  color: AppColors.textMuted, size: 18),
              const SizedBox(width: 8),
              Text(
                'No sunlight — nighttime travel',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      );
    }
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
                    text: trip.sunSideUpper,
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

  Widget _buildRecommendationCard(TripModel trip, bool hasTrip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!hasTrip)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'LIVE SUGGESTION',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        if (trip.isNight) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.nights_stay_rounded,
                  color: AppColors.accent, size: 28),
              const SizedBox(width: 10),
              Text(
                'All seats are fine!',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ] else ...[
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
                      text: trip.shadeSideUpper,
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
          const SizedBox(height: 4),
          Container(
            width: 56,
            height: 2,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            trip.isNight
                ? 'Travelling at night — no sun glare to worry about.'
                : 'Based on your route heading ${trip.headingLabel} at ${trip.formattedTime}, the ${trip.shadeSide} side will be in full shade.',
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
