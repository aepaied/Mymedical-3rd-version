

import 'package:my_medical_app/data/local/dbInfo.dart';
import 'package:my_medical_app/data/local/models/recentSearch.dart';

import 'dbHelper.dart';

class DbActions {


  static Future<List<RecentSearch>> getRecentSearch() async {
    final sql = "SELECT DISTINCT * FROM  " + DbInfo.RECENT_SEARCH + " GROUP BY searchText ORDER BY id DESC LIMIT 10";


    final data = await db.rawQuery(sql);
    List<RecentSearch> recentSearch = List();

    for (final node in data) {
      final a = RecentSearch.fromJson(node);
      recentSearch.add(a);
    }
    return recentSearch;
  }

  static Future<void> addRecentSearch(RecentSearch recentSearch) async {
    final sql = "INSERT INTO " +
        DbInfo.RECENT_SEARCH +
        "(searchText) VALUES(?)";

    List<dynamic> params = [
      recentSearch.searchText,
    ];
    final result = await db.rawInsert(sql, params);
    DbHelper.databaseLog('Insert RecentSearch', sql, null, result, params);
  }

  static Future<void> deleteRecentSearch() async {
    final sql = "DELETE FROM " + DbInfo.RECENT_SEARCH;

    final result = await db.rawUpdate(sql, null);

    DbHelper.databaseLog('Delete recent_search', sql, null, result, null);
  }
}
