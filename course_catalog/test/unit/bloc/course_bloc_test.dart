import 'package:bloc_test/bloc_test.dart';
import 'package:course_catalog/domain/entities/course.dart';
import 'package:course_catalog/domain/usecases/filter_courses.dart';
import 'package:course_catalog/domain/usecases/get_courses.dart';
import 'package:course_catalog/domain/usecases/toggle_favorite.dart';
import 'package:course_catalog/presentation/bloc/course_bloc.dart';
import 'package:course_catalog/presentation/bloc/course_event.dart';
import 'package:course_catalog/presentation/bloc/course_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCoursesUseCase extends Mock implements GetCoursesUseCase {}
class MockFilterCourses extends Mock implements FilterCourses {}
class MockToggleFavorite extends Mock implements ToggleFavorite {}

const tCourse1 = Course(
  id: '1', title: 'Python', description: 'desc', imageUrl: '', isBeginner: true,
);
const tCourse2 = Course(
  id: '2', title: 'C#', description: 'desc', imageUrl: '', isBeginner: false, isFavorite: true,
);
final tCourses = [tCourse1, tCourse2];
CourseBloc makeBloc({
  required MockGetCoursesUseCase getCourses,
  required MockFilterCourses filterCourses,
  required MockToggleFavorite toggleFavorite,
}) =>
    CourseBloc(
      getCourses: getCourses,
      filterCourses: filterCourses,
      toggleFavorite: toggleFavorite,
    );

void main() {
  late MockGetCoursesUseCase mockGetCourses;
  late MockFilterCourses mockFilterCourses;
  late MockToggleFavorite mockToggleFavorite;

  setUpAll(() {
    registerFallbackValue(const FilterCoursesParams());
  });

  setUp(() {
    mockGetCourses = MockGetCoursesUseCase();
    mockFilterCourses = MockFilterCourses();
    mockToggleFavorite = MockToggleFavorite();

    when(() => mockGetCourses()).thenAnswer((_) async => tCourses);
    when(() => mockFilterCourses(any())).thenAnswer((invocation) async {
      final params = invocation.positionalArguments[0] as FilterCoursesParams;
      if (params.onlyBeginners == true && params.onlyFavorites == false) {
        return [tCourse1];
      } else if (params.onlyFavorites == true && params.onlyBeginners == null) {
        return [tCourse2];
      } else if (params.onlyFavorites == true && params.onlyBeginners == true) {
        return [tCourse1];
      }
      return tCourses;
    });
    when(() => mockToggleFavorite(any())).thenAnswer((_) async {});
  });

  group('CourseLoadRequested', () {
    blocTest<CourseBloc, CourseState>(
      'эмитирует [CourseInitial, CourseLoaded] при успехе',
      build: () => makeBloc(
        getCourses: mockGetCourses,
        filterCourses: mockFilterCourses,
        toggleFavorite: mockToggleFavorite,
      ),
      act: (_) {}, 
      expect: () => [
        const CourseInitial(),
        isA<CourseLoaded>().having((s) => s.courses, 'courses', tCourses),
      ],
    );

    blocTest<CourseBloc, CourseState>(
      'эмитирует [CourseInitial, CourseError] при ошибке',
      setUp: () => when(() => mockGetCourses()).thenThrow(Exception('network')),
      build: () => makeBloc(
        getCourses: mockGetCourses,
        filterCourses: mockFilterCourses,
        toggleFavorite: mockToggleFavorite,
      ),
      act: (_) {},
      expect: () => [
        const CourseInitial(),
        isA<CourseError>(),
      ],
    );
  });

  group('CourseRefreshRequested', () {
    blocTest<CourseBloc, CourseState>(
      'эмитирует [CourseRefreshing, CourseLoaded] при успехе',
      build: () => makeBloc(
        getCourses: mockGetCourses,
        filterCourses: mockFilterCourses,
        toggleFavorite: mockToggleFavorite,
      ),
      act: (bloc) async {
        await Future.delayed(Duration.zero); 
        bloc.add(const CourseRefreshRequested());
      },
      expect: () => [
        const CourseInitial(),
        isA<CourseLoaded>(),
        isA<CourseRefreshing>(),
        isA<CourseLoaded>(),
      ],
    );
  });

  group('CourseFilterChange', () {
    blocTest<CourseBloc, CourseState>(
      'обновляет список и onlyBeginners при смене фильтра',
      build: () => makeBloc(
        getCourses: mockGetCourses,
        filterCourses: mockFilterCourses,
        toggleFavorite: mockToggleFavorite,
      ),
      act: (bloc) async {
        await Future.delayed(Duration.zero);
        bloc.add(const CourseFilterChange(true));
      },
      expect: () => [
        const CourseInitial(),
        isA<CourseLoaded>(),
        isA<CourseLoaded>()
            .having((s) => s.onlyBeginners, 'onlyBeginners', true)
            .having((s) => s.courses, 'courses', [tCourse1]),
      ],
    );

    blocTest<CourseBloc, CourseState>(
      'игнорирует событие если фильтр не изменился',
      build: () => makeBloc(
        getCourses: mockGetCourses,
        filterCourses: mockFilterCourses,
        toggleFavorite: mockToggleFavorite,
      ),
      act: (bloc) async {
        await Future.delayed(Duration.zero);
        bloc.add(const CourseFilterChange(null)); 
      },
      expect: () => [
        const CourseInitial(),
        isA<CourseLoaded>(),
      ],
    );
  });

  group('CourseFavoritesFilter', () {
    blocTest<CourseBloc, CourseState>(
      'переключает onlyFavorites',
      build: () => makeBloc(
        getCourses: mockGetCourses,
        filterCourses: mockFilterCourses,
        toggleFavorite: mockToggleFavorite,
      ),
      act: (bloc) async {
        await Future.delayed(Duration.zero);
        bloc.add(const CourseFavoritesFilter());
      },
      expect: () => [
        const CourseInitial(),
        isA<CourseLoaded>(),
        isA<CourseLoaded>()
            .having((s) => s.onlyFavorites, 'onlyFavorites', true)
            .having((s) => s.courses, 'courses', [tCourse2]),
      ],
    );
  });

  group('CourseFavoriteToggled', () {
    blocTest<CourseBloc, CourseState>(
      'вызывает toggleFavorite и эмитирует snackbarMessage',
      build: () => makeBloc(
        getCourses: mockGetCourses,
        filterCourses: mockFilterCourses,
        toggleFavorite: mockToggleFavorite,
      ),
      act: (bloc) async {
        await Future.delayed(Duration.zero);
        bloc.add(const CourseFavoriteToggled('1')); 
      },
      expect: () => [
        const CourseInitial(),
        isA<CourseLoaded>(),
        isA<CourseLoaded>()
            .having((s) => s.snackbarMessage, 'snackbarMessage', isNotNull)
            .having((s) => s.toggledCourseId, 'toggledCourseId', '1'),
      ],
      verify: (_) => verify(() => mockToggleFavorite('1')).called(1),
    );

    blocTest<CourseBloc, CourseState>(
      'игнорирует событие если курс не найден в текущем списке',
      build: () => makeBloc(
        getCourses: mockGetCourses,
        filterCourses: mockFilterCourses,
        toggleFavorite: mockToggleFavorite,
      ),
      act: (bloc) async {
        await Future.delayed(Duration.zero);
        bloc.add(const CourseFavoriteToggled('999'));
      },
      expect: () => [
        const CourseInitial(),
        isA<CourseLoaded>(),
      ],
      verify: (_) => verifyNever(() => mockToggleFavorite(any())),
    );
  });

  group('ClearSnackbar', () {
    blocTest<CourseBloc, CourseState>(
      'очищает snackbarMessage и toggledCourseId',
      build: () => makeBloc(
        getCourses: mockGetCourses,
        filterCourses: mockFilterCourses,
        toggleFavorite: mockToggleFavorite,
      ),
      act: (bloc) async {
        await Future.delayed(Duration.zero);
        bloc.add(const CourseFavoriteToggled('1'));
        await Future.delayed(Duration.zero);
        bloc.add(const ClearSnackbar());
      },
      expect: () => [
        const CourseInitial(),
        isA<CourseLoaded>(),
        isA<CourseLoaded>().having((s) => s.snackbarMessage, 'snackbarMessage', isNotNull),
        isA<CourseLoaded>()
            .having((s) => s.snackbarMessage, 'snackbarMessage', isNull)
            .having((s) => s.toggledCourseId, 'toggledCourseId', isNull),
      ],
    );
  });
}