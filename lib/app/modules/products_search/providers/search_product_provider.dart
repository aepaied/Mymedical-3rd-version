import 'package:get/get.dart';

import '../search_product_model.dart';

class SearchProductProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return SearchProduct.fromJson(map);
      if (map is List)
        return map.map((item) => SearchProduct.fromJson(item)).toList();
    };
    httpClient.baseUrl =
        'https://mymedicalshope.com/api/v1/products/advancedSearch?';
  }

  Future<SearchProduct> doInitialSearch(String initSearchText) async {
    Map<String, dynamic> body = {};
    if (initSearchText != "") {
      body['search_query'] = initSearchText;
      body['sort_by'] = "new_arrival";
    }

    final response = await post('page=1', body);
    return response.body;
  }

  Future<SearchProduct> doPaginationSearch(
      String initSearchText, String newSortBy, int page) async {
    Map<String, dynamic> body = {};
    if (initSearchText != "") {
      body['search_query'] = initSearchText;
      body['sort_by'] = newSortBy;
    }
    final response = await post('page=$page', body);
    return response.body;
  }

  Future<SearchProduct> changeSortBy(
      String initSearchText, String newSortBy) async {
    Map<String, dynamic> body = {};
    if (initSearchText != "") {
      body['search_query'] = initSearchText;
      body['sort_by'] = newSortBy;
    }

    final response = await post('page=1', body);
    return response.body;
  }
}
