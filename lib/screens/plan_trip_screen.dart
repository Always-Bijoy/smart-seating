import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/buttons.dart';
import '../providers/trip_provider.dart';
import '../services/location_service.dart';
import 'best_seat_screen.dart';
import 'settings_screen.dart';

class PlanTripScreen extends StatefulWidget {
  const PlanTripScreen({super.key});

  @override
  State<PlanTripScreen> createState() => _PlanTripScreenState();
}

class _PlanTripScreenState extends State<PlanTripScreen> {
  final _fromController = TextEditingController(text: 'Manikganj');
  final _toController = TextEditingController();
  bool _isNow = true;
  TimeOfDay? _laterTime;
  bool _loadingLocation = false;

  // Exact GPS coords — set when the user taps the GPS icon
  double? _fromLat;
  double? _fromLon;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  // ---------- helpers ----------

  String _formatTimeOfDay(TimeOfDay t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    final p = t.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $p';
  }

  String _nowLabel(AppLocalizations l10n) {
    final now = TimeOfDay.now();
    return l10n.nowLabel(_formatTimeOfDay(now));
  }

  String _laterLabel(AppLocalizations l10n) {
    if (_laterTime != null) return _formatTimeOfDay(_laterTime!);
    return l10n.later;
  }

  void _swapLocations() {
    final temp = _fromController.text;
    _fromController.text = _toController.text;
    _toController.text = temp;
    setState(() {});
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _loadingLocation = true);
    final result = await LocationService.getNearestCity();
    if (!mounted) return;
    setState(() {
      _loadingLocation = false;
      if (result.isSuccess) {
        _fromController.text = result.city!;
        _fromLat = result.lat;
        _fromLon = result.lon;
      }
    });
    if (!result.isSuccess) {
      _showSnack(LocationService.errorMessage(result.error!));
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _laterTime ?? TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _laterTime = picked;
        _isNow = false;
      });
    }
  }

  void _findShadySide() {
    final from = _fromController.text.trim();
    final to = _toController.text.trim();
    final l10n = context.l10n;

    if (from.isEmpty) {
      _showSnack(l10n.pleaseEnterOrigin);
      return;
    }
    if (to.isEmpty) {
      _showSnack(l10n.pleaseEnterDestination);
      return;
    }
    if (from.toLowerCase() == to.toLowerCase()) {
      _showSnack(l10n.sameCityError);
      return;
    }

    DateTime departure;
    if (_isNow) {
      departure = DateTime.now();
    } else if (_laterTime != null) {
      final now = DateTime.now();
      departure = DateTime(
          now.year, now.month, now.day, _laterTime!.hour, _laterTime!.minute);
    } else {
      _pickTime();
      return;
    }

    final trip = context.read<TripProvider>().planTrip(
          from,
          to,
          departure,
          fromLat: _fromLat,
          fromLon: _fromLon,
        );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BestSeatScreen(trip: trip)),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // ---------- help sheet ----------

  void _showHelpSheet(BuildContext context) {
    final l10n = context.l10n;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.wb_sunny_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  l10n.howItWorks,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _helpStep(
              icon: Icons.my_location_rounded,
              title: l10n.helpStep1Title,
              detail: l10n.helpStep1Detail,
            ),
            const SizedBox(height: 18),
            _helpStep(
              icon: Icons.schedule_rounded,
              title: l10n.helpStep2Title,
              detail: l10n.helpStep2Detail,
            ),
            const SizedBox(height: 18),
            _helpStep(
              icon: Icons.event_seat_rounded,
              title: l10n.helpStep3Title,
              detail: l10n.helpStep3Detail,
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    l10n.gotIt,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _helpStep({
    required IconData icon,
    required String title,
    required String detail,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                detail,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------- build ----------

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      _buildHeading(l10n),
                      const SizedBox(height: 32),
                      _buildLocationFields(l10n),
                      const SizedBox(height: 28),
                      _buildDepartureSection(l10n),
                      const SizedBox(height: 20),
                      _buildInfoCard(),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              _buildFooter(context, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppLocalizations l10n) {
    final canGoBack = Navigator.canPop(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          if (canGoBack)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary.withValues(alpha: 0.6),
                size: 24,
              ),
            )
          else
            const SizedBox(width: 24),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.directions_bus_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.planYourTrip,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _showHelpSheet(context),
            child: Icon(
              Icons.help_outline_rounded,
              color: AppColors.textPrimary.withValues(alpha: 0.6),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeading(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          l10n.whereAreYouHeading,
          style: GoogleFonts.poppins(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.findCoolestSeat,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary.withValues(alpha: 0.5),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLocationFields(AppLocalizations l10n) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 28,
          top: 44,
          bottom: 44,
          child: Container(
            width: 1.5,
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
        ),

        Column(
          children: [
            _buildPillField(
              controller: _fromController,
              hint: l10n.originHint,
              prefixIcon: Icons.my_location_rounded,
              onPrefixTap: _useCurrentLocation,
              prefixLoading: _loadingLocation,
              onChanged: (_) {
                _fromLat = null;
                _fromLon = null;
              },
            ),
            const SizedBox(height: 14),
            _buildPillField(
              controller: _toController,
              hint: l10n.destinationHint,
              prefixIcon: Icons.location_on_rounded,
            ),
          ],
        ),

        // Swap button centered on the right
        Positioned(
          right: 12,
          top: 0,
          bottom: 0,
          child: Center(
            child: GestureDetector(
              onTap: _swapLocations,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.05),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.09),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.swap_vert_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPillField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    VoidCallback? onPrefixTap,
    bool prefixLoading = false,
    void Function(String)? onChanged,
  }) {
    final prefix = GestureDetector(
      onTap: onPrefixTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 10),
        child: prefixLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            : Icon(prefixIcon, color: AppColors.primary, size: 20),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        textCapitalization: TextCapitalization.words,
        onChanged: onChanged,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            color: AppColors.textPrimary.withValues(alpha: 0.3),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: prefix,
          prefixIconConstraints:
              const BoxConstraints(minWidth: 52, minHeight: 52),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildDepartureSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.departureTimeLabel,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            color: AppColors.textPrimary.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildTimeToggle(
              label: _nowLabel(l10n),
              icon: Icons.schedule_rounded,
              isActive: _isNow,
              onTap: () => setState(() => _isNow = true),
            ),
            const SizedBox(width: 10),
            _buildTimeToggle(
              label: _laterLabel(l10n),
              icon: _laterTime != null ? Icons.schedule_rounded : null,
              isActive: !_isNow,
              onTap: _pickTime,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeToggle({
    required String label,
    IconData? icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary
              : Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isActive
                ? AppColors.primary.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.5),
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
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
            if (icon != null) ...[
              Icon(
                icon,
                size: 15,
                color: isActive ? Colors.black87 : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isActive ? Colors.black87 : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.wb_sunny_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.sunnyForecast,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.directExposure,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textPrimary.withValues(alpha: 0.5),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            label: l10n.findShadySide,
            icon: Icons.event_seat_rounded,
            onPressed: _findShadySide,
          ),
          const SizedBox(height: 22),
          AppBottomNav(
            activeTab: NavTab.plan,
            onHomeTap: () => Navigator.popUntil(context, (r) => r.isFirst),
            onSettingsTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
