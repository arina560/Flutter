import 'package:flutter/material.dart';

class CourseMetaRow extends StatelessWidget{
  final String imageUrl;
  const CourseMetaRow({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      children: [
        ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(Icons.image, size: 80),
                ),
              ),
      ],
    );
  }
}