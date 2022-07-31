import 'package:my_medical_app/data/remote/models/productDetailsModel.dart';
import 'package:my_medical_app/defaultTheme/screen/categories/sub_category_model.dart';
import 'package:my_medical_app/defaultTheme/screen/categories/sub_sub_category_model.dart';

class MainCategoryModel {
  int id;
  String name;
  String icon;
  List<SubSubCategoryModel> subCats =[];

  MainCategoryModel({this.id, this.name, this.subCats});

  MainCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
  }
}