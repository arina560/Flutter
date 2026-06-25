import 'package:flutter/material.dart';

class CourseFilterBar extends StatelessWidget{
  final bool? onlyBeginners;
  final bool onlyFavorites;
  final ValueChanged<bool?> onLevelFilterChange;
  final VoidCallback onFavoritesFilterToggle;
  const CourseFilterBar({super.key, required this.onlyBeginners, required this.onlyFavorites, required this.onLevelFilterChange, required this.onFavoritesFilterToggle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<bool?>(
          value: onlyBeginners,
          hint: const Text("Все уровни"),
          items: [
            DropdownMenuItem(value: null, child: Text("Все уровни")),
            DropdownMenuItem(value: true, child: Text("Начинающий")),
            DropdownMenuItem(value: false, child: Text("Продвинутый"))
          ],
          onChanged: onLevelFilterChange,
        ),
        IconButton(
          onPressed:onFavoritesFilterToggle, 
          icon: Icon(
            onlyFavorites ? Icons.favorite : Icons.favorite_border,
            color: onlyFavorites ? Colors.red : Colors.grey,
          ),
          tooltip: "Только избранные",
        )
      ],
    );
  }
}