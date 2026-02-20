import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import 'best_seat_screen.dart';

class PlanTripScreen extends StatefulWidget {
  const PlanTripScreen({super.key});

  @override
  State<PlanTripScreen> createState() => _PlanTripScreenState();
}

class _PlanTripScreenState extends State<PlanTripScreen> {
  final TextEditingController _fromController =
      TextEditingController(text: 'Manikganj');
  final TextEditingController _toController = TextEditingController();
  bool _isNow = true;

  void _swapLocations() {
    final temp = _fromController.text;
    _fromController.text = _toController.text;
    _toController.text = temp;
    setState(() {});
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

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
                      _buildWeatherCard(),
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
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'From',
              hintStyle: GoogleFonts.poppins(color: AppColors.textMuted),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 18),
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
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Destination',
                hintStyle: GoogleFonts.poppins(color: AppColors.textMuted),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 18),
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
              label: 'Now (2:00 PM)',
              icon: Icons.access_time_rounded,
              isActive: _isNow,
              onTap: () => setState(() => _isNow = true),
            ),
            const SizedBox(width: 10),
            _buildTimeToggle(
              label: 'Later',
              isActive: !_isNow,
              onTap: () => setState(() => _isNow = false),
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
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
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
                size: 18,
                color: isActive ? Colors.black87 : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.black87 : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard() {
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
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF3D4),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('☀️', style: TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sunny Forecast',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Direct exposure expected on this route.',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const BestSeatScreen(),
            ),
          );
        },
      ),
    );
  }
}
