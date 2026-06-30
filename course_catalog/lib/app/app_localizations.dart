import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

extension AppStrings on BuildContext {
  String get appTitle => tr('appTitle');
  String get courseDetails => tr('courseDetails');
  String get filterAll => tr('filterAll');
  String get filterBeginner => tr('filterBeginner');
  String get filterAdvanced => tr('filterAdvanced');
  String get filterFavorites => tr('filterFavorites');
  String get descriptionLabel => tr('descriptionLabel');
  String get levelBeginner => tr('levelBeginner');
  String get levelAdvanced => tr('levelAdvanced');
  String get addedToFavorites => tr('addedToFavorites');
  String get removedFromFavorites => tr('removedFromFavorites');
  String get undoAction => tr('undoAction');
  String get noCourses => tr('noCourses');
  String get courseNotFound => tr('courseNotFound');
  String get retryButton => tr('retryButton');
  String get allLevels => tr('allLevels');
  String get favoritesOnlyTooltip => tr('favoritesOnlyTooltip');
  String get showDetails => tr('showDetails');
  String get hideDetails => tr('hideDetails');
  String get addToFavorites => tr('addToFavorites');
  String get removeFromFavorites => tr('removeFromFavorites');

  String networkError(String detail) => tr('networkError', args: [detail]);
  String loadCoursesError(int code) => tr('loadCoursesError', args: [code.toString()]);
}
