import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:course_catalog/presentation/bloc/course_bloc.dart';
import 'package:course_catalog/presentation/bloc/course_state.dart';
import 'package:mocktail/mocktail.dart';

class TestAssetLoader extends AssetLoader {
  final Map<String, Map<String, String>> translations = {
    'en': {
      'appTitle': 'Course Catalog',
      'courseDetails': 'Course Details',
      'filterAll': 'All',
      'filterBeginner': 'Beginner',
      'filterAdvanced': 'Advanced',
      'filterFavorites': 'Favorites',
      'descriptionLabel': 'Course description',
      'levelBeginner': 'Beginner',
      'levelAdvanced': 'Advanced',
      'addedToFavorites': 'Added to favorites',
      'removedFromFavorites': 'Removed from favorites',
      'undoAction': 'Undo',
      'noCourses': 'No courses',
      'courseNotFound': 'Course not found',
      'retryButton': 'Try again',
      'networkError': 'Network error: {detail}',
      'loadCoursesError': 'Failed to load courses: {code}',
    },
    'ru': {}
  };

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    return translations[locale.languageCode] ?? {};
  }
}

bool _localizationInitialized = false;

Future<void> ensureTestLocalization() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  if (!_localizationInitialized) {
    SharedPreferences.setMockInitialValues({});
    _localizationInitialized = true;
  }
}

void stubBlocState(CourseBloc bloc, CourseState state) {
  when(() => bloc.state).thenReturn(state);
  when(() => bloc.stream).thenAnswer((_) => Stream.value(state));
}

Future<void> pumpWithDeps(
  WidgetTester tester,
  Widget child, {
  CourseBloc? bloc,
  Locale locale = const Locale('en'),
  bool withSettle = false,
}) async {
  await ensureTestLocalization();

  await tester.pumpWidget(
    EasyLocalization(
      assetLoader: TestAssetLoader(),
      supportedLocales: const [Locale('en'), Locale('ru')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: locale,
      child: Builder(
        builder: (ctx) => MaterialApp(
          localizationsDelegates: ctx.localizationDelegates,
          supportedLocales: ctx.supportedLocales,
          locale: ctx.locale,
          home: bloc != null
              ? BlocProvider<CourseBloc>.value(value: bloc, child: child)
              : child,
        ),
      ),
    ),
  );

  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}