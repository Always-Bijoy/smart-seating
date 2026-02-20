import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

enum NavTab { home, plan, settings, tracker, history }

/// Shared bottom navigation bar used across all screens.
///
/// When [activeTab] is [NavTab.tracker] or [NavTab.history] the bar shows
/// the tracker-specific set: Home / Tracker / History.
/// Otherwise it shows the default set: Home / Plan / Settings.
class AppBottomNav extends StatelessWidget {
  final NavTab activeTab;
  final VoidCallback? onHomeTap;
  final VoidCallback? onPlanTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onTrackerTap;
  final VoidCallback? onHistoryTap;

  const AppBottomNav({
    super.key,
    required this.activeTab,
    this.onHomeTap,
    this.onPlanTap,
    this.onSettingsTap,
    this.onTrackerTap,
    this.onHistoryTap,
  });

  bool get _isTrackerVariant =>
      activeTab == NavTab.tracker || activeTab == NavTab.history;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (_isTrackerVariant) {
      return Row(
        children: [
          Expanded(
            child: _NavItem(
              icon: Icons.home_rounded,
              label: l10n.navHome,
              isActive: activeTab == NavTab.home,
              onTap: onHomeTap,
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.explore_rounded,
              label: l10n.navTracker,
              isActive: activeTab == NavTab.tracker,
              onTap: onTrackerTap,
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.history_rounded,
              label: l10n.navHistory,
              isActive: activeTab == NavTab.history,
              onTap: onHistoryTap,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _NavItem(
            icon: Icons.home_rounded,
            label: l10n.navHome,
            isActive: activeTab == NavTab.home,
            onTap: onHomeTap,
          ),
        ),
        Expanded(
          child: _NavItem(
            icon: Icons.route_rounded,
            label: l10n.navPlan,
            isActive: activeTab == NavTab.plan,
            onTap: onPlanTap,
          ),
        ),
        Expanded(
          child: _NavItem(
            icon: Icons.settings_rounded,
            label: l10n.navSettings,
            isActive: activeTab == NavTab.settings,
            onTap: onSettingsTap,
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.textMuted;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
