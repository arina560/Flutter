import 'package:course_catalog/domain/entities/course.dart';
import 'package:course_catalog/domain/repositories/course_repository.dart';
import 'package:course_catalog/domain/usecases/filter_courses.dart';
import 'package:course_catalog/domain/usecases/get_courses.dart';
import 'package:course_catalog/domain/usecases/toggle_favorite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCourseRepository extends Mock implements CourseRepository {}

const tCourse1 = Course(
  id: '1', title: 'test1', description: 'desc', imageUrl: '', isBeginner: true,
);
const tCourse2 = Course(
  id: '2', title: 'test2', description: 'desc', imageUrl: '', isBeginner: false,
);

void main() {
  late MockCourseRepository mockRepo;

  setUp(() {
    mockRepo = MockCourseRepository();
  });

  group('GetCoursesUseCase', () {
    late GetCoursesUseCase useCase;

    setUp(() => useCase = GetCoursesUseCase(mockRepo));

    test('делегирует вызов в репозиторий и возвращает список', () async {
      when(() => mockRepo.getCourses()).thenAnswer((_) async => [tCourse1, tCourse2]);

      final result = await useCase();

      verify(() => mockRepo.getCourses()).called(1);
      expect(result, [tCourse1, tCourse2]);
    });

    test('пробрасывает исключение из репозитория', () {
      when(() => mockRepo.getCourses()).thenThrow(Exception('error'));

      expect(() => useCase(), throwsException);
    });
  });

  group('FilterCourses', () {
    late FilterCourses useCase;

    setUp(() => useCase = FilterCourses(mockRepo));

    test('передаёт параметры в репозиторий корректно', () async {
      const params = FilterCoursesParams(onlyBeginners: true, onlyFavorites: false);
      when(() => mockRepo.getFilteredCourses(onlyBeginners: true, onlyFavorites: false))
          .thenAnswer((_) async => [tCourse1]);

      final result = await useCase(params);

      verify(() => mockRepo.getFilteredCourses(onlyBeginners: true, onlyFavorites: false)).called(1);
      expect(result, [tCourse1]);
    });

    test('FilterCoursesParams.copyWith clearLevel сбрасывает onlyBeginners', () {
      const params = FilterCoursesParams(onlyBeginners: true);
      final updated = params.copyWith(clearLevel: true);

      expect(updated.onlyBeginners, isNull);
    });

    test('FilterCoursesParams.copyWith сохраняет существующие значения', () {
      const params = FilterCoursesParams(onlyBeginners: true, onlyFavorites: true);
      final updated = params.copyWith(onlyFavorites: false);

      expect(updated.onlyBeginners, isTrue);
      expect(updated.onlyFavorites, isFalse);
    });
  });

  group('ToggleFavorite', () {
    late ToggleFavorite useCase;

    setUp(() => useCase = ToggleFavorite(mockRepo));

    test('вызывает toggleFavorite с правильным id', () async {
      when(() => mockRepo.toggleFavorite('1')).thenAnswer((_) async {});

      await useCase('1');

      verify(() => mockRepo.toggleFavorite('1')).called(1);
    });
  });
}