import 'package:my_medical_app/data/remote/models/searchModel.dart';
import 'package:my_medical_app/ui/models/product.dart';
import 'package:get/get.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/search/searchPresenter.dart';

class SearchController extends GetxController implements SearchBack {
  List<Product> productsList = List<Product>().obs;

  SearchPresenter presenter;
  String nextURL;
  var isLoadingMore = false.obs;

  @override
  void onInit() {
    print(nextURL);
    if (presenter == null) {
      presenter = SearchPresenter(context: Get.context, callBack: this);
    }
    super.onInit();
  }

  doSearch(String key, String value, String sort_by, bool scrollSearch) {
    isLoadingMore.value = nextURL == null ? false : true;
    // presenter.loadSearch(key, value, sort_by, scrollSearch? nextURL:null,scrollSearch);
  }

  @override
  void onDataError(String message) {
    // TODO: implement onDataError
  }

  @override
  void onDataLoading(bool show) {
    // TODO: implement onDataLoading
  }

  @override
  void onSearchDataSuccess(SearchModel data) {
    nextURL = data.links.next;
    // if (!scrollSearch){
    //   productsList.clear();
    // }
    for (SearchData p in data.data) {
      productsList.add(Product(
        p.id,
        p.name,
        null,
        p.thumbnailImage,
        double.parse(p.basePrice.toString()),
        double.parse(p.baseDiscountedPrice.toString()),
        0,
        0,
        p.current_stock.toString(),
        null,
        null,
        0,
        null,
        p.rating,
        null,
        0,
        p.links.details,
        p.links.reviews,
        p.links.related,
        p.links.topFromSeller,
        p.country,
        p.isFavorite,
      ));
    }
    isLoadingMore.value = false;
  }
}
