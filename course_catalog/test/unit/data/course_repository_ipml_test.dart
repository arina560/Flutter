import 'package:course_catalog/data/datasources/course_data_source.dart';
import 'package:course_catalog/data/datasources/local_course_data_source.dart';
import 'package:course_catalog/data/models/course_dto.dart';
import 'package:course_catalog/data/repositories/course_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockCourseDataSource extends Mock implements CourseDataSourse {}

Future<LocalCourseDataSource> makeLocalSource([Map<String, Object>? seed]) async {
  SharedPreferences.setMockInitialValues(seed ?? {});
  final prefs = await SharedPreferences.getInstance();
  return LocalCourseDataSource(prefs);
}

final tDto1 = CourseDto(
  id: '1', title: 'Python', description: 'Learn Python', imageUrl: '', isBeginner: true,
);
final tDto2 = CourseDto(
  id: '2', title: 'C#', description: 'Learn C#', imageUrl: '', isBeginner: false,
);

void main() {
  late MockCourseDataSource mockRemote;
  late LocalCourseDataSource localSource;
  late CourseRepositoryImpl repository;

  setUp(() async {
    mockRemote = MockCourseDataSource();
    localSource = await makeLocalSource();
    repository = CourseRepositoryImpl(mockRemote, localSource);
  });

  group('CourseRepositoryImpl', () {
    group('getCourses', () {
      test('возвращает список Course из DTO', () async {
        when(() => mockRemote.getCourses()).thenAnswer((_) async => [tDto1, tDto2]);

        final result = await repository.getCourses();

        expect(result.length, 2);
        expect(result[0].id, '1');
        expect(result[0].isBeginner, isTrue);
        expect(result[1].id, '2');
        expect(result[1].isBeginner, isFalse);
      });

      test('isFavorite проставляется корректно из localSource', () async {
        when(() => mockRemote.getCourses()).thenAnswer((_) async => [tDto1, tDto2]);
        await localSource.toggleFavorite('2');

        final result = await repository.getCourses();

        expect(result[0].isFavorite, isFalse);
        expect(result[1].isFavorite, isTrue);
      });

      test('пробрасывает исключение при ошибке сети', () async {
        when(() => mockRemote.getCourses()).thenThrow(Exception('network'));

        expect(() => repository.getCourses(), throwsException);
      });
    });

    group('getCourseById', () {
      test('возвращает Course если DTO найден', () async {
        when(() => mockRemote.getCourseById('1')).thenAnswer((_) async => tDto1);

        final result = await repository.getCourseById('1');

        expect(result, isNotNull);
        expect(result!.id, '1');
      });

      test('возвращает null если DTO не найден', () async {
        when(() => mockRemote.getCourseById('99')).thenAnswer((_) async => null);

        expect(await repository.getCourseById('99'), isNull);
      });

      test('isFavorite проставляется корректно', () async {
        when(() => mockRemote.getCourseById('1')).thenAnswer((_) async => tDto1);
        await localSource.toggleFavorite('1');

        final result = await repository.getCourseById('1');
        expect(result!.isFavorite, isTrue);
      });
    });

    group('getFilteredCourses', () {
      setUp(() {
        when(() => mockRemote.getCourses()).thenAnswer((_) async => [tDto1, tDto2]);
      });

      test('без фильтров возвращает все курсы', () async {
        expect((await repository.getFilteredCourses()).length, 2);
      });

      test('onlyBeginners: true возвращает только начальные', () async {
        final result = await repository.getFilteredCourses(onlyBeginners: true);
        expect(result.length, 1);
        expect(result[0].isBeginner, isTrue);
      });

      test('onlyBeginners: false возвращает только продвинутые', () async {
        final result = await repository.getFilteredCourses(onlyBeginners: false);
        expect(result.length, 1);
        expect(result[0].isBeginner, isFalse);
      });

      test('onlyFavorites: true возвращает только избранные', () async {
        await localSource.toggleFavorite('1');

        final result = await repository.getFilteredCourses(onlyFavorites: true);
        expect(result.length, 1);
        expect(result[0].id, '1');
      });

      test('onlyFavorites + onlyBeginners без совпадений — пустой список', () async {
        await localSource.toggleFavorite('1'); 

        final result = await repository.getFilteredCourses(
          onlyBeginners: false,
          onlyFavorites: true,
        );
        expect(result, isEmpty);
      });
    });

    group('toggleFavorite', () {
      test('добавляет курс в избранные', () async {
        await repository.toggleFavorite('1');
        expect(localSource.isFavorite('1'), isTrue);
      });

      test('убирает курс при повторном вызове', () async {
        await repository.toggleFavorite('1');
        await repository.toggleFavorite('1');
        expect(localSource.isFavorite('1'), isFalse);
      });
    });
  });
}