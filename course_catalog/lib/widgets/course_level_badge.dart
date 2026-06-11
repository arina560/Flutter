import 'package:flutter/material.dart';

class CourseLevelBadge extends StatelessWidget{
  final String level;
  const CourseLevelBadge({super.key, required this.level});

  Color _getColor() {
    switch (level) {
      case "Начинающий": 
        return Colors.green;
      case "Средний":
        return Colors.orange;
      case "Продвинутый":
      return Colors.red;
      default: 
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getColor(), width: 2),
      ),
      child: Text(
        level,
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }
}