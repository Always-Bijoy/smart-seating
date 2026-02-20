import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../providers/trip_provider.dart';
import '../services/location_service.dart';
import 'best_seat_screen.dart';

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

  String get _nowLabel {
    final now = TimeOfDay.now();
    return 'Now (${_formatTimeOfDay(now)})';
  }

  String get _laterLabel {
    if (_laterTime != null) return _formatTimeOfDay(_laterTime!);
    return 'Later';
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
    setState(() => _loadingLocation = false);
    if (result.isSuccess) {
      _fromController.text = result.city!;
    } else {
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

    if (from.isEmpty) {
      _showSnack('Please enter your starting location.');
      return;
    }
    if (to.isEmpty) {
      _showSnack('Please enter your destination.');
      return;
    }
    if (from.toLowerCase() == to.toLowerCase()) {
      _showSnack('Origin and destination cannot be the same.');
      return;
    }

    // Determine departure DateTime
    DateTime departure;
    if (_isNow) {
      departure = DateTime.now();
    } else if (_laterTime != null) {
      final now = DateTime.now();
      departure = DateTime(
          now.year, now.month, now.day, _laterTime!.hour, _laterTime!.minute);
    } else {
      // "Later" selected but no time chosen — open picker
      _pickTime();
      return;
    }

    final trip = context.read<TripProvider>().planTrip(from, to, departure);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BestSeatScreen(trip: trip)),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // ---------- build ----------

  @override
  Widget build(BuildContext context) {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildHeading(),
                      const SizedBox(height: 28),
                      _buildLocationFields(),
                      const SizedBox(height: 28),
                      _buildDepartureSection(),
                      const SizedBox(height: 24),
                      _buildInfoCard(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              _buildFindButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final canGoBack = Navigator.canPop(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          if (canGoBack)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.textPrimary,
                size: 24,
              ),
            )
          else
            const SizedBox(width: 24),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.directions_bus_rounded,
                  color: Colors.black87,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Plan Your Trip',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.textMuted, width: 1.5),
            ),
            child: const Icon(
              Icons.question_mark_rounded,
              size: 18,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Where are you\nheading?',
          style: GoogleFonts.poppins(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "We'll find the coolest seat for your journey.",
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationFields() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // From field
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
            child: TextField(
            controller: _fromController,
            textCapitalization: TextCapitalization.words,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'From',
              hintStyle: GoogleFonts.poppins(color: AppColors.textMuted),
              prefixIcon: const Icon(Icons.radio_button_checked,
                  color: AppColors.primary, size: 18),
              suffixIcon: _loadingLocation
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : Tooltip(
                      message: 'Use my current location',
                      child: IconButton(
                        icon: const Icon(Icons.my_location_rounded,
                            color: AppColors.primary, size: 20),
                        onPressed: _useCurrentLocation,
                        splashRadius: 20,
                      ),
                    ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              border: InputBorder.none,
            ),
          ),
        ),

        // Divider
        Positioned(
          left: 20,
          right: 20,
          bottom: 0,
          child: Divider(height: 1, color: Colors.grey.shade200),
        ),

        // To field
        Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _toController,
              textCapitalization: TextCapitalization.words,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Destination',
                hintStyle: GoogleFonts.poppins(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.location_on_rounded,
                    color: AppColors.accentOrange, size: 18),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                border: InputBorder.none,
              ),
            ),
          ),
        ),

        // Swap button
        Positioned(
          right: 16,
          top: 38,
          child: GestureDetector(
            onTap: _swapLocations,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.swap_vert,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDepartureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DEPARTURE TIME',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildTimeToggle(
              label: _nowLabel,
              icon: Icons.access_time_rounded,
              isActive: _isNow,
              onTap: () => setState(() => _isNow = true),
            ),
            const SizedBox(width: 10),
            _buildTimeToggle(
              label: _laterLabel,
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
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
                size: 16,
                color: isActive ? Colors.black87 : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF3D4),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('☀️', style: TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sun-Based Seat Finder',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'We calculate the sun angle for your route & time to find the shadiest side.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
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

  Widget _buildFindButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: PrimaryButton(
        label: 'Find Shady Side',
        icon: Icons.event_seat_rounded,
        onPressed: _findShadySide,
      ),
    );
  }
}
