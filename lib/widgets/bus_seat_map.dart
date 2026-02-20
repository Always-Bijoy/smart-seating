import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BusSeatMap extends StatelessWidget {
  final Set<int> shadedSeats;
  final Set<int> selectedSeats;

  const BusSeatMap({
    super.key,
    required this.shadedSeats,
    this.selectedSeats = const {},
  });

  @override
  Widget build(BuildContext context) {
    // Bus has 5 rows x 4 cols (2+2 with aisle)
    return Container(
      width: 200,
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
          // Driver row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSeat(type: _SeatType.occupied),
              const SizedBox(width: 28),
            ],
          ),
          const SizedBox(height: 8),
          // Seat rows
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
                  // Aisle
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
        ],
      ),
    );
  }

  Widget _buildSeat({
    int? index,
    bool shaded = false,
    bool selected = false,
    _SeatType type = _SeatType.normal,
  }) {
    Color color;
    if (type == _SeatType.occupied) {
      color = const Color(0xFF6B5A1E);
    } else if (selected) {
      color = AppColors.primary;
    } else if (shaded) {
      color = AppColors.primary;
    } else {
      color = const Color(0xFF6B5A1E);
    }

    return Container(
      width: 36,
      height: 30,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        border: selected
            ? Border.all(color: Colors.white, width: 2)
            : null,
      ),
    );
  }
}

enum _SeatType { normal, occupied, shaded }
