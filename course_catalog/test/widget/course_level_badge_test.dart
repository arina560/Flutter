import 'package:course_catalog/presentation/widgets/course_level_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_helpers.dart';

void main() {
  setUpAll(ensureTestLocalization);

  group('CourseLevelBadge', () {
    testWidgets('отображает текст для начинающих', (tester) async {
      await pumpWithDeps(tester, const CourseLevelBadge(isBeginner: true));
      expect(find.text('Beginner'), findsOneWidget);
    });

    testWidgets('отображает текст для продвинутых', (tester) async {
      await pumpWithDeps(tester, const CourseLevelBadge(isBeginner: false));
      expect(find.text('Advanced'), findsOneWidget);
    });

    testWidgets('использует зелёный цвет для начинающих', (tester) async {
      await pumpWithDeps(tester, const CourseLevelBadge(isBeginner: true));
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      final border = decoration.border! as Border;
      expect(border.top.color, Colors.green);
    });

    testWidgets('использует красный цвет для продвинутых', (tester) async {
      await pumpWithDeps(tester, const CourseLevelBadge(isBeginner: false));
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      final border = decoration.border! as Border;
      expect(border.top.color, Colors.red);
    });
  });
}