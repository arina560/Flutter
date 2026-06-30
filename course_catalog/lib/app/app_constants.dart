import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const double paddingSmall = 4.0;
  static const double paddingMedium  = 8.0;
  static const double radius = 8.0;
  static const double cardImage = 80.0;
  static const double cardElevation   = 2.0;
  static const double detailImageHeight = 350.0;
  static const double errorIconSize = 48.0;
  static const double filterBarHeight = 35.0;
  static const double fontS  = 12.0;
  static const double fontM  = 16.0;
  static const double fontL  = 18.0;
  static const double fontXL = 22.0;
  static const Duration snackbarDuration    = Duration(seconds: 2);
  static const Duration mockDelay = Duration(milliseconds: 400);
  static const Duration mockDetailDelay = Duration(milliseconds: 200);
  static const String favoriteCourseIdsKey = 'favorite_course_ids';
  static const String baseUrl = 'https://6a3bdbbce4a07f202e160ec3.mockapi.io/api/v1';
  static const String coursesPath = '/courses';
  static String coursePath(String id) => '/courses/$id';
}


class AppTextStyles {
  AppTextStyles._();

  static const TextStyle headline1 = TextStyle(
    fontSize: AppConstants.fontL,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: AppConstants.fontM,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static const TextStyle body = TextStyle(
    fontSize: AppConstants.fontM,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static const TextStyle caption = TextStyle(
    fontSize: AppConstants.fontS,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontSize: AppConstants.fontXL,
    fontWeight: FontWeight.bold,
    color: Colors.deepPurple
  );

  static const TextStyle courseTitle = TextStyle(
    fontSize: AppConstants.fontL,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle levelBadge = TextStyle(
    fontSize: AppConstants.fontS,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static const TextStyle errorMessage = TextStyle(
    fontSize: AppConstants.fontM,
    color: Colors.red,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.deepPurple,
        titleTextStyle: AppTextStyles.appBarTitle,
      ),
    );
  }
}