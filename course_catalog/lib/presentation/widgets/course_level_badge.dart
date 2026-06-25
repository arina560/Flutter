import 'package:flutter/material.dart';

class CourseLevelBadge extends StatelessWidget{
  final bool isBeginner;
  const CourseLevelBadge({super.key, required this.isBeginner});

  @override
  Widget build(BuildContext context) {
    final label = isBeginner ? "Начинающий" : "Продвинутый";
    final color = isBeginner ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }
}