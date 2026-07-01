import 'package:bloc_test/bloc_test.dart';
import 'package:course_catalog/domain/entities/course.dart';
import 'package:course_catalog/presentation/bloc/course_bloc.dart';
import 'package:course_catalog/presentation/bloc/course_event.dart';
import 'package:course_catalog/presentation/bloc/course_state.dart';
import 'package:course_catalog/presentation/screens/course_list_screen.dart';
import 'package:course_catalog/presentation/widgets/course_card.dart';
import 'package:course_catalog/presentation/widgets/course_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'test_helpers.dart';

class MockCourseBloc extends MockBloc<CourseEvent, CourseState> implements CourseBloc {}

const tCourse1 = Course(
  id: '1',
  title: 'Python',
  description: 'desc',
  imageUrl: '',
  isBeginner: true,
);
const tCourse2 = Course(
  id: '2',
  title: 'C#',
  description: 'desc2',
  imageUrl: '',
  isBeginner: false,
);

void main() {
  late MockCourseBloc mockBloc;

  setUpAll(ensureTestLocalization);

  setUp(() {
    mockBloc = MockCourseBloc();
    registerFallbackValue(const CourseLoadRequested());
    registerFallbackValue(const CourseFavoritesFilter());
    registerFallbackValue(const CourseFavoriteToggled(''));
    registerFallbackValue(const ClearSnackbar());
  });

  tearDown(() => mockBloc.close());

  group('CourseListScreen', () {
    testWidgets('показывает CircularProgressIndicator при CourseInitial', (tester) async {
      stubBlocState(mockBloc, const CourseInitial());
      await pumpWithDeps(tester, const CourseListScreen(), bloc: mockBloc);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('показывает список CourseCard при CourseLoaded', (tester) async {
      stubBlocState(mockBloc, CourseLoaded(courses: [tCourse1, tCourse2]));
      await pumpWithDeps(tester, const CourseListScreen(), bloc: mockBloc);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(CourseCard), findsNWidgets(2));
      expect(find.text('Python'), findsOneWidget);
      expect(find.text('C#'), findsOneWidget);
    });

    testWidgets('показывает иконку ошибки и сообщение при CourseError', (tester) async {
      stubBlocState(mockBloc, const CourseError('Ошибка сети'));
      await pumpWithDeps(tester, const CourseListScreen(), bloc: mockBloc);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Ошибка сети').first, findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('кнопка retry диспатчит CourseLoadRequested', (tester) async {
      stubBlocState(mockBloc, const CourseError('err'));
      await pumpWithDeps(tester, const CourseListScreen(), bloc: mockBloc);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      verify(() => mockBloc.add(const CourseLoadRequested())).called(1);
    });

    testWidgets('показывает пустой список без CourseCard когда courses пустой', (tester) async {
      stubBlocState(mockBloc, CourseLoaded(courses: const []));
      await pumpWithDeps(tester, const CourseListScreen(), bloc: mockBloc);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(CourseCard), findsNothing);
      expect(find.text('No courses'), findsOneWidget);
    });

    testWidgets('отображает CourseFilterBar в AppBar', (tester) async {
      stubBlocState(mockBloc, CourseLoaded(courses: [tCourse1]));
      await pumpWithDeps(tester, const CourseListScreen(), bloc: mockBloc);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(CourseFilterBar), findsOneWidget);
    });

    testWidgets('нажатие на фильтр избранных диспатчит CourseFavoritesFilter', (tester) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([CourseLoaded(courses: [tCourse1], onlyFavorites: false)]),
        initialState: CourseLoaded(courses: [tCourse1], onlyFavorites: false),
      );
      when(() => mockBloc.add(any())).thenReturn(null);

      await pumpWithDeps(tester, const CourseListScreen(), bloc: mockBloc);
      await tester.pumpAndSettle();

      final iconButtonFinder = find.descendant(
        of: find.byType(CourseFilterBar),
        matching: find.byType(IconButton),
      );
      await tester.tap(iconButtonFinder);
      await tester.pumpAndSettle();

      verify(() => mockBloc.add(const CourseFavoritesFilter())).called(1);
    });

    testWidgets('нажатие на favorite в карточке диспатчит CourseFavoriteToggled', (tester) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([CourseLoaded(courses: [tCourse1])]),
        initialState: CourseLoaded(courses: [tCourse1]),
      );
      when(() => mockBloc.add(any())).thenReturn(null);

      await pumpWithDeps(tester, const CourseListScreen(), bloc: mockBloc);
      await tester.pumpAndSettle();

      final iconButtonFinder = find.descendant(
        of: find.byType(CourseCard),
        matching: find.byType(IconButton),
      );
      expect(iconButtonFinder, findsOneWidget);
      await tester.tap(iconButtonFinder);
      await tester.pumpAndSettle();

      verify(() => mockBloc.add(const CourseFavoriteToggled('1'))).called(1);
    });

    testWidgets('снекбар показывается при snackbarMessage в состоянии', (tester) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([
          CourseLoaded(
            courses: [tCourse1],
            snackbarMessage: 'addedToFavorites',
            toggledCourseId: '1',
          ),
        ]),
        initialState: CourseLoaded(courses: [tCourse1]),
      );
      when(() => mockBloc.add(any())).thenReturn(null);

      await pumpWithDeps(tester, const CourseListScreen(), bloc: mockBloc);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      
      expect(find.text('Added to favorites'), findsOneWidget);
    });

    testWidgets('снекбар содержит кнопку Undo когда toggledCourseId задан', (tester) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([
          CourseLoaded(
            courses: [tCourse1],
            snackbarMessage: 'addedToFavorites',
            toggledCourseId: '1',
          ),
        ]),
        initialState: CourseLoaded(courses: [tCourse1]),
      );
      when(() => mockBloc.add(any())).thenReturn(null);

      await pumpWithDeps(tester, const CourseListScreen(), bloc: mockBloc);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      
      expect(find.text('Undo'), findsOneWidget);
    });
  });
}