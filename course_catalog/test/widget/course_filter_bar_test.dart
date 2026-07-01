import 'package:course_catalog/presentation/widgets/course_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_helpers.dart';

void main() {
  setUpAll(ensureTestLocalization);

  group('CourseFilterBar', () {
    Widget buildFilterBar({
      bool? onlyBeginners,
      bool onlyFavorites = false,
      ValueChanged<bool?>? onLevelFilterChange,
      VoidCallback? onFavoritesFilterToggle,
    }) {
      return CourseFilterBar(
        onlyBeginners: onlyBeginners,
        onlyFavorites: onlyFavorites,
        onLevelFilterChange: onLevelFilterChange ?? (_) {},
        onFavoritesFilterToggle: onFavoritesFilterToggle ?? () {},
      );
    }

    testWidgets('отображает DropdownButton и IconButton', (tester) async {
      await pumpWithDeps(tester, Scaffold(body: buildFilterBar()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(DropdownButton<bool?>), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('иконка избранных — favorite_border когда onlyFavorites=false', (tester) async {
      await pumpWithDeps(tester, Scaffold(body: buildFilterBar(onlyFavorites: false)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('иконка избранных — favorite когда onlyFavorites=true', (tester) async {
      await pumpWithDeps(tester, Scaffold(body: buildFilterBar(onlyFavorites: true)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('вызывает onFavoritesFilterToggle при нажатии на иконку', (tester) async {
      var called = false;
      await pumpWithDeps(
        tester,
        Scaffold(body: buildFilterBar(onFavoritesFilterToggle: () => called = true)),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(called, isTrue);
    });

    testWidgets('вызывает onLevelFilterChange при выборе в DropdownButton', (tester) async {
      bool? received;
      await pumpWithDeps(
        tester,
        Scaffold(body: buildFilterBar(onLevelFilterChange: (v) => received = v)),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.byType(DropdownButton<bool?>));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.text('Beginner').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(received, isTrue);
    });

    testWidgets('hint показывает filterAll когда onlyBeginners=null', (tester) async {
      await pumpWithDeps(tester, Scaffold(body: buildFilterBar(onlyBeginners: null)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('All'), findsAtLeast(1));
    });
  });
}