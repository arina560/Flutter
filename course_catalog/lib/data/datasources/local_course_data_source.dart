import 'package:shared_preferences/shared_preferences.dart';
import '../../app/app_constants.dart';

class LocalCourseDataSource {
  final SharedPreferences _preferences;
  LocalCourseDataSource(this._preferences);

  Set<String> getFavoriteIds(){
    final list = _preferences.getStringList(AppConstants.favoriteCourseIdsKey) ?? [];
    return list.toSet();
  }

  Future<bool> toggleFavorite(String courseId) async{
    final listIds = getFavoriteIds();
    final isNowFavorite = !listIds.contains(courseId);
    if (isNowFavorite){
      listIds.add(courseId);
    } else{
      listIds.remove(courseId);
    }
    await _preferences.setStringList(AppConstants.favoriteCourseIdsKey, listIds.toList());
    return isNowFavorite;
  }

  bool isFavorite(String courseId) => getFavoriteIds().contains(courseId);
}