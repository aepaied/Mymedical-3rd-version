import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/defaultTheme/screen/categories/categoriesPresenter.dart';
import 'package:my_medical_app/defaultTheme/screen/categories/main_category_model.dart';

class CategoryController extends GetxController implements MainCategoriesCallBack {
  List<MainCategoryModel> mainCategoriesList = List<MainCategoryModel>().obs;

  CategoriesPresenter presenter;

  @override
  void onInit() {
    if  (presenter==null){
      presenter = CategoriesPresenter(context: Get.context,mainCategoriesCallBack:this);
      presenter.getMainCategoriesData();
    }
    super.onInit();
  }

  @override
  void onDataError(String message) {
    Get.snackbar("${translator.translate("error")}", message);
  }

  @override
  void onDataLoading(bool show) {
    // HERE WE DO NOTHING
  }

  @override
  void onDataSuccess(List<MainCategoryModel> data) {
    mainCategoriesList = data;
    for (var item in data){
      print(item.icon);
    }

  }
}