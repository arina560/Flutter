import 'package:course_catalog/presentation/screens/course_detail_screen.dart';
import '../../app/app_constants.dart';
import '../../domain/entities/course.dart';
import 'course_level_badge.dart';
import 'course_meta_row.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatefulWidget {
  final Course course;
  final VoidCallback onFavoriteToggle;
  const CourseCard({super.key, required this.course, required this.onFavoriteToggle});

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard>{
  bool _isHidden = true;

  void _toggleHidden() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CourseDetailScreen(courseId: widget.course.id)));
        },
        borderRadius: BorderRadius.circular(AppConstants.radius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.course.title,
                      style: AppTextStyles.headline1,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onFavoriteToggle,
                    icon: Icon(
                      widget.course.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: widget.course.isFavorite ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
              CourseLevelBadge(isBeginner: widget.course.isBeginner),
              if (_isHidden) ...[
                const SizedBox(height: AppConstants.paddingMedium),
                CourseMetaRow(imageUrl: widget.course.imageUrl),
                const SizedBox(height: AppConstants.paddingMedium),
                Text(widget.course.description),
              ],
              const SizedBox(height: AppConstants.paddingMedium),
              GestureDetector(
                onTap: _toggleHidden,
                child: Icon(
                  _isHidden ? Icons.remove : Icons.add,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
