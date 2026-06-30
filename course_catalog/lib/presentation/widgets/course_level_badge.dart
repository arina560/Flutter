import '../../app/app_localizations.dart';
import '/app/app_constants.dart';
import 'package:flutter/material.dart';

class CourseLevelBadge extends StatelessWidget{
  final bool isBeginner;
  const CourseLevelBadge({super.key, required this.isBeginner});

  @override
  Widget build(BuildContext context) {
    final label = isBeginner ? context.levelBeginner : context.levelAdvanced;
    final color = isBeginner ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium, vertical: AppConstants.paddingSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radius),
        border: Border.all(color: color, width: 2),
      ),
      child: Text(
        label,
        style: AppTextStyles.levelBadge
      ),
    );
  }
}