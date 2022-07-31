import 'package:my_medical_app/defaultTheme/screen/categories/sub_sub_category_model.dart';

class SubCategoryModel {
  int id;
  String name;
  List<SubSubCategoryModel> subSubCates = [];

  SubCategoryModel({this.id, this.name, this.subSubCates});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

}