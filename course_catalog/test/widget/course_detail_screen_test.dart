import 'package:bloc_test/bloc_test.dart';
import 'package:course_catalog/domain/entities/course.dart';
import 'package:course_catalog/presentation/bloc/course_bloc.dart';
import 'package:course_catalog/presentation/bloc/course_event.dart';
import 'package:course_catalog/presentation/bloc/course_state.dart';
import 'package:course_catalog/presentation/screens/course_detail_screen.dart';
import 'package:course_catalog/presentation/widgets/course_level_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'test_helpers.dart';

class MockCourseBloc extends MockBloc<CourseEvent, CourseState> implements CourseBloc {}

const tCourse = Course(
  id: '1',
  title: 'Python с нуля',
  description: 'Полное описание курса',
  imageUrl: 'https://picsum.photos/200/300',
  isBeginner: true,
  isFavorite: false,
);

const tFavoriteCourse = Course(
  id: '1',
  title: 'Python с нуля',
  description: 'Полное описание курса',
  imageUrl: 'https://picsum.photos/200/300',
  isBeginner: true,
  isFavorite: true,
);

void main() {
  late MockCourseBloc mockBloc;

  setUpAll(ensureTestLocalization);

  setUp(() {
    mockBloc = MockCourseBloc();
    registerFallbackValue(const CourseFavoriteToggled(''));
  });

  tearDown(() => mockBloc.close());

  group('CourseDetailScreen', () {
    testWidgets('показывает заголовок курса', (tester) async {
      stubBlocState(mockBloc, CourseLoaded(courses: [tCourse]));
      await pumpWithDeps(tester, const CourseDetailScreen(courseId: '1'), bloc: mockBloc);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Python с нуля'), findsOneWidget);
    });

    testWidgets('показывает описание курса', (tester) async {
      stubBlocState(mockBloc, CourseLoaded(courses: [tCourse]));
      await pumpWithDeps(tester, const CourseDetailScreen(courseId: '1'), bloc: mockBloc);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Полное описание курса'), findsOneWidget);
    });

    testWidgets('показывает CourseLevelBadge', (tester) async {
      stubBlocState(mockBloc, CourseLoaded(courses: [tCourse]));
      await pumpWithDeps(tester, const CourseDetailScreen(courseId: '1'), bloc: mockBloc);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(CourseLevelBadge), findsOneWidget);
    });

    testWidgets('показывает courseNotFound если курс не найден', (tester) async {
      stubBlocState(mockBloc, CourseLoaded(courses: const []));
      await pumpWithDeps(tester, const CourseDetailScreen(courseId: '999'), bloc: mockBloc);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Course not found'), findsOneWidget);
      expect(find.byType(CourseLevelBadge), findsNothing);
    });

    testWidgets('показывает descriptionLabel перед описанием', (tester) async {
      stubBlocState(mockBloc, CourseLoaded(courses: [tCourse]));
      await pumpWithDeps(tester, const CourseDetailScreen(courseId: '1'), bloc: mockBloc);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Course description'), findsOneWidget);
    });

    testWidgets('иконка favorite_border когда курс не в избранных', (tester) async {
      stubBlocState(mockBloc, CourseLoaded(courses: [tCourse]));
      await pumpWithDeps(tester, const CourseDetailScreen(courseId: '1'), bloc: mockBloc);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('иконка favorite (filled) когда курс в избранных', (tester) async {
      stubBlocState(mockBloc, CourseLoaded(courses: [tFavoriteCourse]));
      await pumpWithDeps(tester, const CourseDetailScreen(courseId: '1'), bloc: mockBloc);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('нажатие на иконку диспатчит CourseFavoriteToggled', (tester) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([CourseLoaded(courses: [tCourse])]),
        initialState: CourseLoaded(courses: [tCourse]),
      );
      when(() => mockBloc.add(any())).thenReturn(null);

      await pumpWithDeps(tester, const CourseDetailScreen(courseId: '1'), bloc: mockBloc);
      await tester.pumpAndSettle();

      final iconButtonFinder = find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(IconButton),
      );
      expect(iconButtonFinder, findsOneWidget);
      await tester.tap(iconButtonFinder);
      await tester.pumpAndSettle();

      verify(() => mockBloc.add(const CourseFavoriteToggled('1'))).called(1);
    });

    testWidgets('содержит AppBar', (tester) async {
      stubBlocState(mockBloc, CourseLoaded(courses: [tCourse]));
      await pumpWithDeps(tester, const CourseDetailScreen(courseId: '1'), bloc: mockBloc);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Course Details'), findsOneWidget);
    });
  });
}