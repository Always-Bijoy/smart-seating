import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../models/trip_model.dart';
import '../providers/trip_provider.dart';
import '../services/sun_calculator.dart';
import '../widgets/bus_illustration.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/buttons.dart';
import 'plan_trip_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  TripModel _getDisplayTrip(TripProvider provider) {
    if (provider.hasTrip) return provider.currentTrip!;
    return SunCalculator.calculate('Manikganj', 'Dhaka', DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                  _buildAppBar(context, l10n),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 12),
                          _buildRoutePill(trip),
                          const SizedBox(height: 8),
                          _buildWeatherPill(trip, l10n),
                          const SizedBox(height: 28),
                          BusIllustration(sunOnLeft: trip.sunSide == 'left'),
                          const SizedBox(height: 20),
                          _buildSunlightBanner(trip, l10n),
                          const SizedBox(height: 16),
                          _buildRecommendationCard(
                              trip, tripProvider.hasTrip, l10n),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                  _buildFooter(context, tripProvider, l10n),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.directions_bus_rounded,
            color: AppColors.primary,
            size: 26,
          ),
          const SizedBox(width: 8),
          Text(
            l10n.appName,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPill({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.pillBackground,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                color: AppColors.primary,
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

  Widget _buildWeatherPill(TripModel trip, AppLocalizations l10n) {
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
              '${trip.formattedTime} • ${trip.isNight ? l10n.nighttime : l10n.sunny}',
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

  Widget _buildSunlightBanner(TripModel trip, AppLocalizations l10n) {
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
                l10n.noSunlightNighttime,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final parts = l10n.sunlightOnSideRich(trip.sunSide);
    return Center(
      child: _buildPill(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wb_sunny_rounded,
              color: AppColors.sunYellow,
              size: 20,
            ),
            const SizedBox(width: 8),
            RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                children: [
                  TextSpan(text: parts[0]),
                  TextSpan(
                    text: parts[1],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextSpan(text: parts[2]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(
      TripModel trip, bool hasTrip, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!hasTrip)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                l10n.liveSuggestion,
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
                  color: AppColors.accent, size: 34),
              const SizedBox(width: 10),
              Text(
                l10n.allSeatsAreFine,
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ] else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.greenCheck,
                size: 34,
              ),
              const SizedBox(width: 10),
              _buildSitOnSideRich(trip.shadeSide, l10n),
            ],
          ),
        ],
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            trip.isNight
                ? l10n.travellingAtNight
                : l10n.basedOnRoute(
                    trip.headingLabel, trip.formattedTime, trip.shadeSide),
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.55,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildSitOnSideRich(String side, AppLocalizations l10n) {
    final parts = l10n.sitOnSideRich(side);
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: parts[0],
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          TextSpan(
            text: parts[1],
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary.withValues(alpha: 0.35),
              decorationThickness: 3,
            ),
          ),
          TextSpan(
            text: parts[2],
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(
      BuildContext context, TripProvider tripProvider, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            label: tripProvider.hasTrip
                ? l10n.planAnotherTrip
                : l10n.findBestSeat,
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
          const SizedBox(height: 22),
          _buildBottomNav(context),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return AppBottomNav(
      activeTab: NavTab.home,
      onPlanTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PlanTripScreen()),
      ),
      onSettingsTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SettingsScreen()),
      ),
    );
  }
}
