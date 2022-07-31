import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';

class SearchHistoryHelpers {
  saveSearchHistory(String newSearchData) async {
    final box = GetStorage();
    List<dynamic> searchHistory = box.read("search_history") ?? [];
    if (!searchHistory.contains(newSearchData)) {
      searchHistory.add(newSearchData);
      box.write("search_history", searchHistory);
    }

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // List<String> searchHistory = prefs.getStringList("search_history") ?? [];
    // if (!searchHistory.contains(newSearchData)) {
    //   searchHistory.add(newSearchData);
    //   prefs.setStringList("search_history", searchHistory);
    // }
  }

  Future<List<dynamic>> getSearchHistory(String pattern) async {
    final box = GetStorage();
    List<dynamic> preSearchHistoryData = box.read("search_history") ?? [];
    List<dynamic> searchHistoryData = [];
    for (String item in preSearchHistoryData) {
      if (item.contains(pattern)) {
        searchHistoryData.add(item);
      }
    }
    return searchHistoryData;

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // List<String> preSearchHistoryData =
    //     prefs.getStringList("search_history") ?? [];
    // List<String> searchHistoryData = [];
    // for (String item in preSearchHistoryData) {
    //   if (item.contains(pattern)) {
    //     searchHistoryData.add(item);
    //   }
    // }
    // return searchHistoryData;
  }

  Future<List<dynamic>> getInitialSearchHistory() async {
    final box = GetStorage();
    List<dynamic> preSearchHistoryData = box.read("search_history") ?? [];
    return preSearchHistoryData;

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // List<String> preSearchHistoryData =
    //     prefs.getStringList("search_history") ?? [];
    // return preSearchHistoryData;
  }

  Future<void> clearSearchHistory() async {
    final box = GetStorage();

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    box.write("search_history", []);
  }
}
