import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class BusSeatMap extends StatelessWidget {
  final Set<int> shadedSeats;
  final Set<int> selectedSeats;

  /// Which side is shaded: 'left', 'right', or '' (unknown)
  final String shadeSide;

  const BusSeatMap({
    super.key,
    required this.shadedSeats,
    this.selectedSeats = const {},
    this.shadeSide = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Side labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sideLabel('LEFT', shadeSide == 'left'),
              _sideLabel('RIGHT', shadeSide == 'right'),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 210,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Driver seat row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSeat(type: _SeatType.driver),
                  const SizedBox(width: 28),
                ],
              ),
              const SizedBox(height: 10),
              // Passenger rows
              ...List.generate(5, (rowIndex) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSeat(
                        index: rowIndex * 4,
                        shaded: shadedSeats.contains(rowIndex * 4),
                        selected: selectedSeats.contains(rowIndex * 4),
                      ),
                      const SizedBox(width: 6),
                      _buildSeat(
                        index: rowIndex * 4 + 1,
                        shaded: shadedSeats.contains(rowIndex * 4 + 1),
                        selected: selectedSeats.contains(rowIndex * 4 + 1),
                      ),
                      // Aisle gap
                      const SizedBox(width: 20),
                      _buildSeat(
                        index: rowIndex * 4 + 2,
                        shaded: shadedSeats.contains(rowIndex * 4 + 2),
                        selected: selectedSeats.contains(rowIndex * 4 + 2),
                      ),
                      const SizedBox(width: 6),
                      _buildSeat(
                        index: rowIndex * 4 + 3,
                        shaded: shadedSeats.contains(rowIndex * 4 + 3),
                        selected: selectedSeats.contains(rowIndex * 4 + 3),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 6),
              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _legendDot(const Color(0xFF5A4A2A), 'Hot'),
                  const SizedBox(width: 12),
                  _legendDot(AppColors.primary, 'Shaded'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sideLabel(String label, bool isShaded) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isShaded
            ? AppColors.primary.withOpacity(0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isShaded ? AppColors.primary : Colors.transparent,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isShaded ? AppColors.primary : Colors.grey.shade400,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }

  Widget _buildSeat({
    int? index,
    bool shaded = false,
    bool selected = false,
    _SeatType type = _SeatType.normal,
  }) {
    Color color;
    if (type == _SeatType.driver) {
      color = const Color(0xFF3A3A3A);
    } else if (selected || shaded) {
      color = AppColors.primary;
    } else {
      color = const Color(0xFF5A4A2A);
    }

    return Container(
      width: 34,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        border: selected
            ? Border.all(color: Colors.white, width: 1.5)
            : null,
      ),
    );
  }
}

enum _SeatType { normal, driver }
