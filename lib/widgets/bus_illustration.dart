import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Horizontal bus with sunlight on one side and cooling on the other.
class BusIllustration extends StatelessWidget {
  final bool sunOnLeft;

  const BusIllustration({super.key, this.sunOnLeft = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sunlight rays (horizontal yellow lines) on the sunny side
          if (sunOnLeft)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: _SunRaysWidget(),
            )
          else
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: _SunRaysWidget(),
            ),

          // Snowflakes on the shade/cool side
          if (sunOnLeft)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: _SnowflakesWidget(),
            )
          else
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: _SnowflakesWidget(),
            ),

          // Bus body (horizontal, centered)
          Center(child: _BusBody()),
        ],
      ),
    );
  }
}

class _SunRaysWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (_) => const _SunRayLine()),
      ),
    );
  }
}

class _SunRayLine extends StatelessWidget {
  const _SunRayLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      height: 3,
      decoration: BoxDecoration(
        color: AppColors.sunlightLines,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _SnowflakesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(Icons.ac_unit_rounded, color: AppColors.snowflakeBlue, size: 20),
          Icon(Icons.ac_unit_rounded, color: AppColors.snowflakeBlue, size: 20),
        ],
      ),
    );
  }
}

class _BusBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 56,
      child: CustomPaint(
        painter: _BusPainter(),
      ),
    );
  }
}

class _BusPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    const radius = 8.0;

    // Thick black border (stroke)
    final borderPaint = Paint()
      ..color = AppColors.busBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      const Radius.circular(radius),
    );
    canvas.drawRRect(bodyRect, borderPaint);

    // Bus body fill - dark olive-brown
    final fillPaint = Paint()..color = AppColors.busBody;
    canvas.drawRRect(bodyRect, fillPaint);

    // Four sections (vertical dividers)
    final dividerPaint = Paint()
      ..color = AppColors.busBorder
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 1; i <= 3; i++) {
      final x = w * (i / 4);
      canvas.drawLine(Offset(x, 2), Offset(x, h - 2), dividerPaint);
    }

    // Front marker (left) - black circle with white inner
    final dotOuter = Paint()..color = AppColors.busBorder;
    final dotInner = Paint()..color = Colors.white;
    const dotRadius = 5.0;
    const innerRadius = 2.0;

    canvas.drawCircle(Offset(dotRadius + 2, h / 2), dotRadius, dotOuter);
    canvas.drawCircle(Offset(dotRadius + 2, h / 2), innerRadius, dotInner);

    // Back marker (right)
    canvas.drawCircle(Offset(w - dotRadius - 2, h / 2), dotRadius, dotOuter);
    canvas.drawCircle(Offset(w - dotRadius - 2, h / 2), innerRadius, dotInner);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
