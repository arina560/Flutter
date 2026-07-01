import 'package:course_catalog/domain/entities/course.dart';
import 'package:course_catalog/domain/usecases/filter_courses.dart';
import 'package:course_catalog/presentation/widgets/course_card.dart';
import 'package:course_catalog/presentation/widgets/course_level_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'test_helpers.dart';

const tCourse = Course(
  id: '1',
  title: 'Python с нуля',
  description: 'Описание курса Python',
  imageUrl: '',
  isBeginner: true,
  isFavorite: false,
);

const tFavoriteCourse = Course(
  id: '2',
  title: 'C# Pro',
  description: 'Описание C#',
  imageUrl: '',
  isBeginner: false,
  isFavorite: true,
);

void main() {
  setUpAll(() {
    registerFallbackValue(const FilterCoursesParams());
    ensureTestLocalization();
  });

  group('CourseCard', () {
    testWidgets('отображает заголовок курса', (tester) async {
      await pumpWithDeps(
        tester,
        Scaffold(body: CourseCard(course: tCourse, onFavoriteToggle: () {})),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Python с нуля'), findsOneWidget);
    });

    testWidgets('отображает CourseLevelBadge', (tester) async {
      await pumpWithDeps(
        tester,
        Scaffold(body: CourseCard(course: tCourse, onFavoriteToggle: () {})),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(CourseLevelBadge), findsOneWidget);
    });

    testWidgets('показывает favorite_border когда не в избранных', (tester) async {
      await pumpWithDeps(
        tester,
        Scaffold(body: CourseCard(course: tCourse, onFavoriteToggle: () {})),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('показывает favorite (filled) когда в избранных', (tester) async {
      await pumpWithDeps(
        tester,
        Scaffold(body: CourseCard(course: tFavoriteCourse, onFavoriteToggle: () {})),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('вызывает onFavoriteToggle при нажатии на иконку', (tester) async {
      var called = false;
      await pumpWithDeps(
        tester,
        Scaffold(body: CourseCard(course: tCourse, onFavoriteToggle: () => called = true)),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(called, isTrue);
    });

    testWidgets('изначально показывает контент (_isHidden=true) и иконку Icons.remove', (tester) async {
      await pumpWithDeps(
        tester,
        Scaffold(body: CourseCard(course: tCourse, onFavoriteToggle: () {})),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Описание курса Python'), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
    });

    testWidgets('скрывает контент после нажатия Icons.remove', (tester) async {
      await pumpWithDeps(
        tester,
        Scaffold(body: CourseCard(course: tCourse, onFavoriteToggle: () {})),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Описание курса Python'), findsNothing);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('показывает контент снова после нажатия Icons.add', (tester) async {
      await pumpWithDeps(
        tester,
        Scaffold(body: CourseCard(course: tCourse, onFavoriteToggle: () {})),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Описание курса Python'), findsOneWidget);
    });

    testWidgets('содержит InkWell для навигации на детальный экран', (tester) async {
      await pumpWithDeps(
        tester,
        Scaffold(body: CourseCard(course: tCourse, onFavoriteToggle: () {})),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(InkWell).first, findsOneWidget);
    });
  });
}