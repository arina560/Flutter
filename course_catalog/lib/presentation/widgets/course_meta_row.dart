import 'package:course_catalog/app/app_constants.dart';
import 'package:flutter/material.dart';

class CourseMetaRow extends StatelessWidget{
  final String imageUrl;
  const CourseMetaRow({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppConstants.radius),
      child: Image.network(
        imageUrl,
        width: AppConstants.cardImage,
        height: AppConstants.cardImage,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const Icon(Icons.image, size: AppConstants.cardImage),
      ),
    );
  }
}