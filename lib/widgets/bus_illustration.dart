import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Horizontal bus with warm sun-side windows, cool shade-side window,
/// large bottom-mounted wheels, and contextual ray/snowflake indicators.
class BusIllustration extends StatelessWidget {
  final bool sunOnLeft;

  const BusIllustration({super.key, this.sunOnLeft = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 110,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Sunlight rays on the sunny side
          Positioned(
            left: sunOnLeft ? 0 : null,
            right: sunOnLeft ? null : 0,
            top: 0,
            bottom: 24,
            child: _SunRaysWidget(),
          ),

          // Snowflake on the cool/shade side
          Positioned(
            left: sunOnLeft ? null : 0,
            right: sunOnLeft ? 0 : null,
            top: 0,
            bottom: 24,
            child: _SnowflakesWidget(),
          ),

          // Bus body (centered with space for rays/snowflakes)
          Positioned(
            left: 48,
            right: 48,
            top: 0,
            child: _BusBody(sunOnLeft: sunOnLeft),
          ),
        ],
      ),
    );
  }
}

class _SunRaysWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 44,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _SunRayLine(width: 28),
          SizedBox(height: 8),
          _SunRayLine(width: 36),
          SizedBox(height: 8),
          _SunRayLine(width: 28),
        ],
      ),
    );
  }
}

class _SunRayLine extends StatelessWidget {
  final double width;
  const _SunRayLine({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.sunlightLines.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _SnowflakesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.ac_unit_rounded, color: AppColors.snowflakeBlue, size: 18),
          SizedBox(height: 10),
          Icon(Icons.ac_unit_rounded, color: AppColors.snowflakeBlue, size: 18),
        ],
      ),
    );
  }
}

class _BusBody extends StatelessWidget {
  final bool sunOnLeft;
  const _BusBody({required this.sunOnLeft});

  @override
  Widget build(BuildContext context) {
    // 3 warm (sun) sections + 1 cool (shade) section
    final sections = sunOnLeft
        ? [
            AppColors.busWarmWindow,
            AppColors.busWarmWindow,
            AppColors.busWarmWindow,
            AppColors.busCoolWindow,
          ]
        : [
            AppColors.busCoolWindow,
            AppColors.busWarmWindow,
            AppColors.busWarmWindow,
            AppColors.busWarmWindow,
          ];

    return SizedBox(
      height: 110, // 80px bus + 30px for wheels below
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Outer bus body
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.busBody,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.busBorder, width: 5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Row(
                children: List.generate(4, (i) {
                  return Expanded(
                    flex: i < 3 ? 3 : 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: sections[i],
                        border: i < 3
                            ? const Border(
                                right: BorderSide(
                                  color: Color(0x33000000),
                                  width: 1.5,
                                ),
                              )
                            : null,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // Left wheel
          const Positioned(
            bottom: 0,
            left: 16,
            child: _WheelWidget(),
          ),

          // Right wheel
          const Positioned(
            bottom: 0,
            right: 16,
            child: _WheelWidget(),
          ),
        ],
      ),
    );
  }
}

class _WheelWidget extends StatelessWidget {
  const _WheelWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF181611),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
