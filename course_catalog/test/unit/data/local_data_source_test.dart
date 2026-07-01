import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:course_catalog/data/datasources/local_course_data_source.dart';
import 'package:course_catalog/app/app_constants.dart'; 

void main() {
  late LocalCourseDataSource dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    dataSource = LocalCourseDataSource(prefs);
  });

  group('LocalCourseDataSource', () {
    group('getFavoriteIds', () {
      test('возвращает пустой Set если нет сохранённых избранных', () {
        expect(dataSource.getFavoriteIds(), isEmpty);
      });

      test('возвращает Set с сохранёнными ID', () async {
        SharedPreferences.setMockInitialValues({
          AppConstants.favoriteCourseIdsKey: ['1', '2', '3'],
        });
        final prefs = await SharedPreferences.getInstance();
        dataSource = LocalCourseDataSource(prefs);

        expect(dataSource.getFavoriteIds(), {'1', '2', '3'});
      });
    });

    group('toggleFavorite', () {
      test('добавляет курс в избранные и возвращает true', () async {
        final isNowFavorite = await dataSource.toggleFavorite('1');

        expect(isNowFavorite, isTrue);
        expect(dataSource.getFavoriteIds(), contains('1'));
      });

      test('убирает курс из избранных и возвращает false', () async {
        await dataSource.toggleFavorite('1');
        final isNowFavorite = await dataSource.toggleFavorite('1');

        expect(isNowFavorite, isFalse);
        expect(dataSource.getFavoriteIds(), isNot(contains('1')));
      });

      test('не затрагивает другие ID при toggle', () async {
        await dataSource.toggleFavorite('1');
        await dataSource.toggleFavorite('2');
        await dataSource.toggleFavorite('1'); 

        final ids = dataSource.getFavoriteIds();
        expect(ids, {'2'});
        expect(ids, isNot(contains('1')));
      });

      test('данные персистируются между экземплярами', () async {
        await dataSource.toggleFavorite('42');

        final prefs = await SharedPreferences.getInstance();
        final dataSource2 = LocalCourseDataSource(prefs);
        expect(dataSource2.getFavoriteIds(), contains('42'));
      });
    });

    group('isFavorite', () {
      test('возвращает false для несохранённого курса', () {
        expect(dataSource.isFavorite('999'), isFalse);
      });

      test('возвращает true после добавления', () async {
        await dataSource.toggleFavorite('5');
        expect(dataSource.isFavorite('5'), isTrue);
      });

      test('возвращает false после удаления', () async {
        await dataSource.toggleFavorite('5');
        await dataSource.toggleFavorite('5');
        expect(dataSource.isFavorite('5'), isFalse);
      });
    });
  });
}