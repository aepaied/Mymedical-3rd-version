import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_medical_app/app_localizations.dart';
import 'package:my_medical_app/data/remote/models/AddAdvsProductModel.dart';
import 'package:my_medical_app/data/remote/models/AddVendorProductModel.dart';
import 'package:my_medical_app/data/remote/models/addsProductsModel.dart';
import 'package:my_medical_app/data/remote/models/allBrandsModel.dart';
import 'package:my_medical_app/data/remote/models/allCategoriesModel.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/ui/dialogs/imageDialog.dart';
import 'package:my_medical_app/ui/models/product.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/defaultTheme/screen/adds_products/addsProductsPresenter.dart';
import 'package:my_medical_app/screens/vendor/products/vendorProductsPresenter.dart';
import 'package:my_medical_app/widgets/advsProductPhotoWidget.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/utils/oColors.dart';
import 'package:my_medical_app/utils/sizeConfig.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/custom_messaeg_dialog.dart';

class AddVendorProductScreen extends StatefulWidget {
  Product productsData;

  AddVendorProductScreen({this.productsData});

  @override
  State<StatefulWidget> createState() {
    return AddVendorProductScreenState();
  }
}

class Condition {
  String key;
  String value;

  Condition({this.key, this.value});
}

class ProductImage {
  String photoPath;
  File photoFile;

  ProductImage({this.photoPath, this.photoFile});
}

class AddVendorProductScreenState extends State<AddVendorProductScreen>
    implements VendorAddProductCallBack {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLogged = false;
  User user;
  bool isLoadingData = false;

  VendorProductsPresenter presenter;

  bool editMode = false;

  bool categoreyEditMode = false;
  bool subCategoreyEditMode = false;
  bool subSubCategoreyEditMode = false;
  bool isRefundable = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.productsData != null) {
      editMode = true;
    }

    Helpers.getUserData().then((_user) {
      setState(() {
        user = _user;
        isLogged = _user.isLoggedIn;
        if (isLogged) {
          // presenter.getProfileData();
          // presenter.getMyAdresses();
        }
      });
    });

    if (presenter == null) {
      presenter = VendorProductsPresenter(
          context: context, vendorAddProductCallBack: this);

      presenter.getAllCategoriesData();
    }
  }

  List<String> videoProvider = List();
  String videoFrom;

  List<CategoriesData> categoriesList = List();
  CategoriesData selectedCategory;

  List<SubCategories> subCategoriesList = List();
  SubCategories selectedsubCategory;

  List<SubSubCategories> subSubCategoriesList = List();
  SubSubCategories selectedSubSubCategory;

  List<BrandsData> brandsList = List();
  BrandsData selectedBrand;

  List<String> enTagsList = List();
  List<String> arTagsList = List();

  // List<ProductImage> productImagesList = List();
  List<AdvsProductPhotoWidget> productImagesWidgetList = List();

  TextEditingController nameEnController = TextEditingController();
  TextEditingController nameArController = TextEditingController();
  TextEditingController countryEnController = TextEditingController();
  TextEditingController countryArController = TextEditingController();
  TextEditingController enTagsController = TextEditingController();
  TextEditingController arTagsController = TextEditingController();
  TextEditingController currentStockController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController minQtyController = TextEditingController();
  TextEditingController videoUrlController = TextEditingController();
  TextEditingController metaTitleArController = TextEditingController();
  TextEditingController metaTitleEnController = TextEditingController();
  TextEditingController metaDescriptionArController = TextEditingController();
  TextEditingController metaDescriptionEnController = TextEditingController();
  TextEditingController descriptionArController = TextEditingController();
  TextEditingController descriptionEnController = TextEditingController();
  TextEditingController unitPriceController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController unitPriceDiscountController = TextEditingController();

  removeLastChars(String str, int chars) {
    return str.substring(0, str.length - chars);
  }

/*  loadEditViewData() {
    if (widget.productsData != null) {
      nameEnController.text = widget.productsData.nameEn;
      nameArController.text = widget.productsData.nameAr;
      unitController.text = widget.productsData.unit;
      videoUrlController.text = widget.productsData.videoLink;
      metaTitleArController.text = widget.productsData.metaTitleAr;
      metaTitleEnController.text = widget.productsData.metaTitleEn;
      metaDescriptionArController.text = widget.productsData.metaDescriptionAr;
      metaDescriptionEnController.text = widget.productsData.metaDescriptionEn;
      descriptionArController.text = widget.productsData.descriptionAr;
      descriptionEnController.text = widget.productsData.descriptionEn;
      unitPriceController.text = widget.productsData.unitPrice.toString();
      unitPriceDiscountController.text =
          widget.productsData.unitDiscount == null
              ? "0"
              : widget.productsData.unitDiscount.toString();

      metaImage = widget.productsData.metaImg == null
          ? ""
          : Constants.IMAGE_BASE_URL + widget.productsData.metaImg;
      thumbImage = widget.productsData.thumbnailImg == null
          ? ""
          : Constants.IMAGE_BASE_URL + widget.productsData.thumbnailImg;

      if (widget.productsData.tagsEn != null) {
        enTagsList = widget.productsData.tagsEn.split('|');
      }
      if (widget.productsData.tagsAr != null) {
        arTagsList = widget.productsData.tagsAr.split('|');
      }

      fileName = widget.productsData.pdf == null
          ? ""
          : Constants.IMAGE_BASE_URL + widget.productsData.pdf;
    }
  }*/

  final picker = ImagePicker();

  String metaImage = "";
  File meta_image;

  Future getMetaImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      if (pickedFile != null) {
        metaImage = "";
        meta_image = File(pickedFile.path);
        print('_image path => ' + pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  String thumbImage = "";
  File thumb_image;

  Future getThumbImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      if (pickedFile != null) {
        thumbImage = "";
        thumb_image = File(pickedFile.path);
        print('_image path => ' + pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  String fileName = "";
  File attachmentFile = null;

  Future<File> getAttachmentFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    File file = null;
    if (result != null) {
      PlatformFile firstFile = result.files.first;

      if (firstFile.size <= 5000) {
        file = File(result.files.single.path);
        // path = result.files.single.path;
        setState(() {
          noAttachmentFile = false;
          fileName = result.files.single.name;
        });
      } else {
        setState(() {
          noAttachmentFile = true;
        });
      }
    } else {
      // User canceled the picker
    }

    return file;
  }

  final _inputsformKey = GlobalKey<FormState>();

  bool noMainImage = false;
  bool noThumbImage = false;
  bool noAttachmentFile = false;

  @override
  Widget build(BuildContext context) {
    if (videoProvider.length == 0) {
      videoProvider.add("youtube");
      videoProvider.add("dailymotion");
      videoProvider.add("vimeo");
    }

    return Scaffold(
        key: _scaffoldKey,
      appBar: CustomAppBar(title: "vendor ads",),
        body: isLoadingData
            ? SpinKitChasingDots(
            color: primaryColor,
              )
            : SingleChildScrollView(
                child: Form(
                  key: _inputsformKey,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.15),
                                  offset: Offset(0, 3),
                                  blurRadius: 10)
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                controller: nameEnController,
                                onFieldSubmitted: (String value) {
                                  /*setState(() {
                              _requestSent = false;
                      _mobileValidation = "";
                      this._mobile = value;
                      });*/
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'required';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                  color: OColors.colorGray2,
                                ),
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: OColors.colorGray2)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  labelStyle: Theme.of(context).textTheme.bodyText1,
                                  labelText: 'name_english',
                                ),
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                controller: nameArController,
                                onFieldSubmitted: (String value) {
                                  /*  setState(() {
                              _requestSent = false;
                      _mobileValidation = "";
                      this._mobile = value;
                      });*/
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'required';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                  color: OColors.colorGray2,
                                ),
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: OColors.colorGray2)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  labelStyle: Theme.of(context).textTheme.bodyText1,
                                  labelText: 'name_arabic',
                                ),
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                controller: countryEnController,
                                onFieldSubmitted: (String value) {
                                  /*setState(() {
                              _requestSent = false;
                      _mobileValidation = "";
                      this._mobile = value;
                      });*/
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'required';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                  color: OColors.colorGray2,
                                ),
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: OColors.colorGray2)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  labelStyle: Theme.of(context).textTheme.bodyText1,
                                  labelText: 'country_origin_en',
                                ),
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                controller: countryArController,
                                onFieldSubmitted: (String value) {
                                  /*  setState(() {
                              _requestSent = false;
                      _mobileValidation = "";
                      this._mobile = value;
                      });*/
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'required';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                  color: OColors.colorGray2,
                                ),
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: OColors.colorGray2)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  labelStyle: Theme.of(context).textTheme.bodyText1,
                                  labelText: 'country_origin_ar',
                                ),
                              ),
/*
                              SizedBox(
                                height: SizeConfig.vUnit,
                              ),
*/
                              DropdownButtonFormField(
                                isExpanded: true,
                                hint: Text('category'),
                                value: selectedCategory,
                                validator: (value) {
                                  if (categoriesList.length > 0) {
                                    if (value == null) {
                                      return 'required';
                                    }
                                  }
                                  return null;
                                },
                                items: categoriesList
                                    .map((CategoriesData category) {
                                  return new DropdownMenuItem<CategoriesData>(
                                    value: category,
                                    child: new Text(
                                      category.name,
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedCategory = newValue;

                                    if (selectedCategory.subCategories !=
                                        null) {
                                      subCategoriesList.clear();
                                      subCategoriesList.addAll(
                                          selectedCategory.subCategories);
                                    }
                                  });
                                },
                              ),
/*
                              SizedBox(
                                height: SizeConfig.vUnit,
                              ),
*/
                              DropdownButtonFormField(
                                isExpanded: true,
                                hint: Text('sub_category'),
                                value: selectedsubCategory,
                                validator: (value) {
                                  if (subCategoriesList.length > 0) {
                                    if (value == null) {
                                      return 'required';
                                    }
                                  }
                                  return null;
                                },
                                items: subCategoriesList
                                    .map((SubCategories category) {
                                  return new DropdownMenuItem<SubCategories>(
                                    value: category,
                                    child: new Text(
                                      category.name,
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedsubCategory = newValue;

                                    if (selectedsubCategory.subSubCategories !=
                                        null) {
                                      subSubCategoriesList.clear();
                                      subSubCategoriesList.addAll(
                                          selectedsubCategory.subSubCategories);
                                    }
                                  });
                                },
                              ),
/*
                              SizedBox(
                                height: SizeConfig.vUnit,
                              ),
*/
                              DropdownButtonFormField(
                                isExpanded: true,
                                hint: Text('sub_sub_category'),
                                value: selectedSubSubCategory,
                                validator: (value) {
                                  if (subSubCategoriesList.length > 0) {
                                    if (value == null) {
                                      return 'required';
                                    }
                                  }
                                  return null;
                                },
                                items: subSubCategoriesList
                                    .map((SubSubCategories category) {
                                  return new DropdownMenuItem<SubSubCategories>(
                                    value: category,
                                    child: new Text(
                                      category.name,
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedSubSubCategory = newValue;
                                  });
                                },
                              ),
/*
                              SizedBox(
                                height: SizeConfig.vUnit,
                              ),
*/
                              DropdownButtonFormField(
                                isExpanded: true,
                                hint: Text('brand'),
                                value: selectedBrand,
                                validator: (value) {
                                  if (brandsList.length > 0) {
                                    if (value == null) {
                                      return'required';
                                    }
                                  }
                                  return null;
                                },
                                items: brandsList.map((BrandsData brand) {
                                  return new DropdownMenuItem<BrandsData>(
                                    value: brand,
                                    child: new Text(
                                      brand.name,
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedBrand = newValue;
                                  });
                                },
                              ),
/*
                              SizedBox(
                                height: SizeConfig.vUnit,
                              ),
*/
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: Text('tag_en',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.15),
                                    offset: Offset(0, 3),
                                    blurRadius: 10)
                              ],
                            ),
                            child: Column(
                              children: [
                                ListView.separated(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: enTagsList.length,
                                  separatorBuilder: (context, index) {
                                    return Divider(  );
                                  },
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            enTagsList[index],
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              enTagsList.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              // border: Border.all(color: OColors.colorGray3)
                                              color: OColors.colorRed,
                                            ),
                                            child: SvgPicture.asset(
                                                "assets/icons/ic_remove3.svg",
                                                semanticsLabel: "ic_remove3",
                                                color: OColors.colorWhite,),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.text,
                                  controller: enTagsController,
                                  onFieldSubmitted: (String value) {
                                    setState(() {
                                      enTagsList.add(
                                          enTagsController.text.toString());
                                      enTagsController.clear();
                                    });
                                  },
                                  style: TextStyle(
                                    color: OColors.colorGray2,
                                  ),
                                  decoration: InputDecoration(
                                    border: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: OColors.colorGray2)),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: OColors.colorGray2),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: OColors.colorGray2),
                                    ),
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    labelText: 'add_tag_en',
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: Text('tag_ar',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.15),
                                    offset: Offset(0, 3),
                                    blurRadius: 10)
                              ],
                            ),
                            child: Column(
                              children: [
                                ListView.separated(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: arTagsList.length,
                                  separatorBuilder: (context, index) {
                                    return Divider();
                                  },
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            arTagsList[index],
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              arTagsList.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              // border: Border.all(color: OColors.colorGray3)
                                              color: OColors.colorRed,
                                            ),
                                            child: SvgPicture.asset(
                                                "assets/icons/ic_remove3.svg",
                                                semanticsLabel: "ic_remove3",
                                                color: OColors.colorWhite,),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.text,
                                  controller: arTagsController,
                                  onFieldSubmitted: (String value) {
                                    setState(() {
                                      arTagsList.add(
                                          arTagsController.text.toString());
                                      arTagsController.clear();
                                    });
                                  },
                                  style: TextStyle(
                                    color: OColors.colorGray2,
                                  ),
                                  decoration: InputDecoration(
                                    border: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: OColors.colorGray2)),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: OColors.colorGray2),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: OColors.colorGray2),
                                    ),
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    labelText: 'add_tag_ar',
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: Text('images',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.15),
                                  offset: Offset(0, 3),
                                  blurRadius: 10)
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
/*
                              SizedBox(
                                height: SizeConfig.vUnit * 2,
                              ),
*/
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('main_images',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
/*
                                  SizedBox(
                                    width: SizeConfig.wUnit * 2,
                                  ),
*/
                                  Expanded(
                                      child: ListView.separated(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: productImagesWidgetList.length,
                                    separatorBuilder: (context, index) {
                                      return Divider();
                                    },
                                    itemBuilder: (context, index) {
                                      /*return AdvsProductPhotoWidget(
                                      photoPath:
                                          productImagesList[index].photoPath,
                                      photoFile:
                                          productImagesList[index].photoFile,
                                    );*/
                                      return productImagesWidgetList[index];
                                    },
                                  )),
                                ],
                              ),
                              Visibility(
                                visible: noMainImage,
                                child: Text('required',
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .apply(color: OColors.colorRed),
                                ),
                              ),
/*
                              SizedBox(
                                height: SizeConfig.vUnit,
                              ),
*/
                              FlatButton(
                                onPressed: () {
                                  setState(() {
                                    /*
                                  productImagesList.add(ProductImage(
                                      photoPath: "", photoFile: null));*/

                                    productImagesWidgetList.add(
                                        AdvsProductPhotoWidget(
                                            photoPath: "", photoFile: null));
                                  });
                                },
                                child: RichText(
                                  text: TextSpan(
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .merge(
                                          Theme.of(context)
                                              .textTheme
                                              .headline4
                                              .apply(
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                        ),
                                    children: [
                                      TextSpan(text:'add_photo'),
                                    ],
                                  ),
                                ),
                              ),
/*
                              SizedBox(
                                height: SizeConfig.vUnit * 2,
                              ),
*/
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('thumbnail_image',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
/*
                                  SizedBox(
                                    width: SizeConfig.wUnit * 2,
                                  ),
*/
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              ImageDialog(
                                                context: context,
                                                viewRemoveImage: false,
                                              )).then((type) {
                                        switch (type) {
                                          case 1: // take photo from camera
                                            {
                                              getThumbImage(ImageSource.camera);
                                            }
                                            break;
                                          case 2: // choose image from gallery
                                            {
                                              getThumbImage(
                                                  ImageSource.gallery);
                                            }
                                            break;
                                          /* case 3: // remove image
                                  {
                                    // presenter.removeProfileImage();
                                  }
                                  break;*/
                                        }
                                      });
                                    },
                                    child: Container(
                                      // width: 160,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(6),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        border: Border.all(
                                            color: OColors.colorGray),
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: thumbImage == ""
                                              ? thumb_image == null
                                                  ? AssetImage(
                                                      'assets/images/add.png')
                                                  : FileImage(thumb_image)
                                              : NetworkImage(thumbImage),
                                        ),
                                      ),
                                    ),
                                  ))
                                ],
                              ),
                              Visibility(
                                visible: noThumbImage,
                                child: Text('required',
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .apply(color: OColors.colorRed),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: Text('videos',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.15),
                                  offset: Offset(0, 3),
                                  blurRadius: 10)
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
/*
                              SizedBox(
                                height: SizeConfig.vUnit,
                              ),
*/
                              DropdownButton(
                                isExpanded: true,
                                hint: Text('video_from'),
                                value: videoFrom,
                                items: videoProvider.map((String host) {
                                  return new DropdownMenuItem<String>(
                                    value: host,
                                    child: new Text(
                                      host,
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    videoFrom = newValue;
                                  });
                                },
                              ),
                              /*                 DropdownButton(
                              isExpanded: true,
                              hint: Text(AppLocalizations.of(context)
                                  .translate('video_from')),
                              value: videoFrom,
                              items: videoProvider.map((String host) {
                                return new DropdownMenuItem<String>(
                                  value: host,
                                  child: new Text(
                                    host,
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  videoFrom = newValue;
                                });
                              },
                            ),*/
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                controller: videoUrlController,
                                onFieldSubmitted: (String value) {
                                  /*  setState(() {
                              _requestSent = false;
                      _mobileValidation = "";
                      this._mobile = value;
                      });*/
                                },
                                style: TextStyle(
                                  color: OColors.colorGray2,
                                ),
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: OColors.colorGray2)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  labelStyle: Theme.of(context).textTheme.bodyText1,
                                  labelText: 'video_url',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: Text('meta_tags',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.15),
                                  offset: Offset(0, 3),
                                  blurRadius: 10)
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                controller: metaTitleEnController,
                                onFieldSubmitted: (String value) {
                                  /*setState(() {
                              _requestSent = false;
                      _mobileValidation = "";
                      this._mobile = value;
                      });*/
                                },
                                style: TextStyle(
                                  color: OColors.colorGray2,
                                ),
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: OColors.colorGray2)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  labelStyle: Theme.of(context).textTheme.bodyText1,
                                  labelText: 'meta_title_en',
                                ),
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                controller: metaTitleArController,
                                onFieldSubmitted: (String value) {
                                  /*  setState(() {
                              _requestSent = false;
                      _mobileValidation = "";
                      this._mobile = value;
                      });*/
                                },
                                style: TextStyle(
                                  color: OColors.colorGray2,
                                ),
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: OColors.colorGray2)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  labelStyle: Theme.of(context).textTheme.bodyText1,
                                  labelText:'meta_title_ar',
                                ),
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.multiline,
                                minLines: 5,
                                maxLines: 5,
                                textAlign: TextAlign.start,
                                controller: metaDescriptionEnController,
                                onFieldSubmitted: (String value) {
                                  /*  setState(() {
                              _requestSent = false;
                      _mobileValidation = "";
                      this._mobile = value;
                      });*/
                                },
                                style: TextStyle(
                                  color: OColors.colorGray2,
                                ),
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: OColors.colorGray2)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  labelStyle: Theme.of(context).textTheme.bodyText1,
                                  labelText: 'description_en',
                                ),
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.multiline,
                                minLines: 5,
                                maxLines: 5,
                                textAlign: TextAlign.start,
                                controller: metaDescriptionArController,
                                onFieldSubmitted: (String value) {
                                  /*  setState(() {
                              _requestSent = false;
                      _mobileValidation = "";
                      this._mobile = value;
                      });*/
                                },
                                style: TextStyle(
                                  color: OColors.colorGray2,
                                ),
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: OColors.colorGray2)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  labelStyle: Theme.of(context).textTheme.bodyText1,
                                  labelText: 'description_ar',
                                ),
                              ),
/*
                              SizedBox(
                                height: SizeConfig.vUnit * 2,
                              ),
*/
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('meta_image',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
/*
                                  SizedBox(
                                    width: SizeConfig.wUnit * 2,
                                  ),
*/
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              ImageDialog(
                                                context: context,
                                                viewRemoveImage: false,
                                              )).then((type) {
                                        switch (type) {
                                          case 1: // take photo from camera
                                            {
                                              getMetaImage(ImageSource.camera);
                                            }
                                            break;
                                          case 2: // choose image from gallery
                                            {
                                              getMetaImage(ImageSource.gallery);
                                            }
                                            break;
                                          /* case 3: // remove image
                                  {
                                    // presenter.removeProfileImage();
                                  }
                                  break;*/
                                        }
                                      });
                                    },
                                    child: Container(
                                      // width: 160,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(6),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        border: Border.all(
                                            color: OColors.colorGray),
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: metaImage == ""
                                              ? meta_image == null
                                                  ? AssetImage(
                                                      'assets/images/add.png')
                                                  : FileImage(meta_image)
                                              : NetworkImage(metaImage),
                                        ),
                                      ),
                                    ),
                                  ))
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: Text('price',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.15),
                                  offset: Offset(0, 3),
                                  blurRadius: 10)
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                controller: currentStockController,
                                onFieldSubmitted: (String value) {
                                  /*  setState(() {
                              _requestSent = false;
                      _mobileValidation = "";
                      this._mobile = value;
                      });*/
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'required';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                  color: OColors.colorGray2,
                                ),
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: OColors.colorGray2)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  labelStyle: Theme.of(context).textTheme.bodyText1,
                                  labelText: 'current_stock',
                                ),
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                controller: unitController,
                                onFieldSubmitted: (String value) {
                                  /*  setState(() {
                              _requestSent = false;
                      _mobileValidation = "";
                      this._mobile = value;
                      });*/
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'required';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                  color: OColors.colorGray2,
                                ),
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: OColors.colorGray2)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  labelStyle: Theme.of(context).textTheme.bodyText1,
                                  labelText: 'qty',
                                ),
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                controller: minQtyController,
                                onFieldSubmitted: (String value) {
                                  /*  setState(() {
                              _requestSent = false;
                      _mobileValidation = "";
                      this._mobile = value;
                      });*/
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'required';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                  color: OColors.colorGray2,
                                ),
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: OColors.colorGray2)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  labelStyle: Theme.of(context).textTheme.bodyText1,
                                  labelText: 'min_qty',
                                ),
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                controller: unitPriceController,
                                onFieldSubmitted: (String value) {
                                  /*  setState(() {
                              _requestSent = false;
                      _mobileValidation = "";
                      this._mobile = value;
                      });*/
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'required';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                  color: OColors.colorGray2,
                                ),
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: OColors.colorGray2)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  labelStyle: Theme.of(context).textTheme.bodyText1,
                                  labelText: 'unit_price',
                                ),
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                controller: purchasePriceController,
                                onFieldSubmitted: (String value) {
                                  /*  setState(() {
                              _requestSent = false;
                      _mobileValidation = "";
                      this._mobile = value;
                      });*/
                                },
                                /* validator: (value) {
                                  if (value.isEmpty) {
                                    return AppLocalizations.of(context)
                                        .translate('required');
                                  }
                                  return null;
                                },*/
                                style: TextStyle(
                                  color: OColors.colorGray2,
                                ),
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: OColors.colorGray2)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  labelStyle: Theme.of(context).textTheme.bodyText1,
                                  labelText: 'purchase_price',
                                ),
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                controller: unitPriceDiscountController,
                                onFieldSubmitted: (String value) {
                                  /*  setState(() {
                              _requestSent = false;
                      _mobileValidation = "";
                      this._mobile = value;
                      });*/
                                },
                                /* validator: (value) {
                                  if (value.isEmpty) {
                                    return AppLocalizations.of(context)
                                        .translate('required');
                                  }
                                  return null;
                                },*/
                                style: TextStyle(
                                  color: OColors.colorGray2,
                                ),
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: OColors.colorGray2)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  labelStyle: Theme.of(context).textTheme.bodyText1,
                                  labelText: 'discount',
                                ),
                              ),
/*
                              SizedBox(
                                height: SizeConfig.vUnit,
                              ),
*/
                              Row(
                                children: [
                                  Text('refundable',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
                                  Switch(
                                    onChanged: (value) {
                                      setState(() {
                                        isRefundable = value;
                                      });
                                    },
                                    value: isRefundable,
                                    activeColor: Theme.of(context).primaryColor,
                                    activeTrackColor: OColors.colorGray3,
                                    inactiveThumbColor:
                                        Theme.of(context).primaryColor,
                                    inactiveTrackColor:
                                        Theme.of(context).accentColor,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: Text('description_en',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.15),
                                  offset: Offset(0, 3),
                                  blurRadius: 10)
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.multiline,
                                minLines: 5,
                                maxLines: 5,
                                textAlign: TextAlign.start,
                                controller: descriptionEnController,
                                onFieldSubmitted: (String value) {
                                  /*  setState(() {
                              _requestSent = false;
                      _mobileValidation = "";
                      this._mobile = value;
                      });*/
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'required';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                  color: OColors.colorGray2,
                                ),
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: OColors.colorGray2)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  labelStyle: Theme.of(context).textTheme.bodyText1,
                                  labelText: 'description_en',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: Text('description_ar',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.15),
                                  offset: Offset(0, 3),
                                  blurRadius: 10)
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.multiline,
                                minLines: 5,
                                maxLines: 5,
                                textAlign: TextAlign.start,
                                controller: descriptionArController,
                                onFieldSubmitted: (String value) {
                                  /*  setState(() {
                              _requestSent = false;
                      _mobileValidation = "";
                      this._mobile = value;
                      });*/
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'required';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                  color: OColors.colorGray2,
                                ),
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: OColors.colorGray2)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: OColors.colorGray2),
                                  ),
                                  labelStyle: Theme.of(context).textTheme.bodyText1,
                                  labelText: 'description_ar',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: Text('attachments',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            padding: EdgeInsets.only(
                                top: 20, left: 20, right: 20, bottom: 20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.15),
                                    offset: Offset(0, 3),
                                    blurRadius: 10)
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            // color: OColors.colorGreen,
                                            border: Border.all(
                                              color: OColors.colorBlack,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: GestureDetector(
                                          onTap: () {
                                            /*  if(fileName.isNotEmpty){
                                            Navigator.of(context).pushNamed('/Pdf', arguments: fileName);
                                          }*/
                                          },
                                          child: Text(
                                            attachmentFile == null
                                                ? 'attachments'
                                                : fileName,
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3
                                                .merge(TextStyle(
                                                    fontWeight:
                                                        FontWeight.w300)),
                                          ),
                                        ),
                                      ),
                                    ),
/*
                                    SizedBox(
                                      width: SizeConfig.wUnit * 4,
                                    ),
*/
                                    FlatButton(
                                      onPressed: () {
                                        getAttachmentFile().then((file) {
                                          if (file != null) {
                                            attachmentFile = file;
                                          }
                                        });
                                      },
                                      padding:
                                          EdgeInsets.symmetric(vertical: 14),
                                      color: Theme.of(context).accentColor,
                                      shape: StadiumBorder(),
                                      child: Icon(
                                        // UiIcons.planet_earth,
                                        Icons.upload_rounded,
                                        color: OColors.colorWhite,
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: noAttachmentFile,
                                  child: Text('required_file',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .apply(color: OColors.colorRed),
                                  ),
                                ),
                              ],
                            )),
/*
                        SizedBox(
                          height: SizeConfig.vUnit * 2,
                        ),
*/
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: FlatButton(
                            onPressed: () {
                              bool result = true;

                              if (!_inputsformKey.currentState.validate()) {
                                result = false;
                              }

                              if (widget.productsData == null) {
                                if (thumb_image == null) {
                                  noThumbImage = true;
                                  result = false;
                                } else {
                                  noThumbImage = false;
                                }
                              } else {
                                if (thumbImage.isEmpty) {
                                  noThumbImage = true;
                                  result = false;
                                } else {
                                  noThumbImage = false;
                                }
                              }

                              /*   if (fileName.isEmpty) {
                                noAttachmentFile = true;
                                result = false;
                              } else {
                                noAttachmentFile = false;
                              }*/

                              if (widget.productsData == null) {
                                if (productImagesWidgetList.isEmpty) {
                                  noMainImage = true;
                                  result = false;
                                } else {
                                  if (productImagesWidgetList[0].photoFile ==
                                      null) {
                                    noMainImage = true;
                                    result = false;
                                  } else {
                                    noMainImage = false;
                                  }
                                }
                              } else {
                                if (productImagesWidgetList.isEmpty) {
                                  noMainImage = true;
                                  result = false;
                                } /*else {
                                  if (productImagesWidgetList[0]
                                      .photoPath
                                      .isEmpty) {
                                    noMainImage = true;
                                    result = false;
                                  } else {
                                    noMainImage = false;
                                  }
                                }*/
                              }

                              if (result) {
                                if (widget.productsData != null) {
                                  presenter.updateProduct(
                                      widget.productsData.id,
                                      nameEnController.text.toString().trim(),
                                      nameArController.text.toString().trim(),
                                      countryEnController.text
                                          .toString()
                                          .trim(),
                                      countryArController.text
                                          .toString()
                                          .trim(),
                                      selectedCategory == null
                                          ? null
                                          : selectedCategory.id.toString(),
                                      selectedsubCategory == null
                                          ? null
                                          : selectedsubCategory.id.toString(),
                                      selectedSubSubCategory == null
                                          ? null
                                          : selectedSubSubCategory.id
                                              .toString(),
                                      selectedBrand == null
                                          ? null
                                          : selectedBrand.id.toString(),
                                      productImagesWidgetList,
                                      thumb_image,
                                      unitController.text.trim().isEmpty
                                          ? "1"
                                          : unitController.text.trim(),
                                      minQtyController.text.trim().isEmpty
                                          ? "1"
                                          : minQtyController.text.trim(),
                                      enTagsList,
                                      arTagsList,
                                      isRefundable ? "1" : "0",
                                      videoFrom == null ? "" : videoFrom,
                                      videoUrlController.text.toString().trim(),
                                      unitPriceController.text
                                          .toString()
                                          .trim(),
                                      metaTitleArController.text
                                          .toString()
                                          .trim(),
                                      metaTitleEnController.text
                                          .toString()
                                          .trim(),
                                      metaDescriptionArController.text
                                          .toString()
                                          .trim(),
                                      metaDescriptionEnController.text
                                          .toString()
                                          .trim(),
                                      meta_image,
                                      purchasePriceController.text.trim(),
                                      attachmentFile,
                                      unitPriceDiscountController.text
                                              .trim()
                                              .isEmpty
                                          ? "0"
                                          : unitPriceDiscountController.text
                                              .trim(),
                                      currentStockController.text.trim().isEmpty
                                          ? "1"
                                          : currentStockController.text.trim(),
                                      descriptionEnController.text.trim(),
                                      descriptionArController.text.trim());
                                } else {
                                  presenter.addNewProduct(
                                      nameEnController.text.toString().trim(),
                                      nameArController.text.toString().trim(),
                                      countryEnController.text
                                          .toString()
                                          .trim(),
                                      countryArController.text
                                          .toString()
                                          .trim(),
                                      selectedCategory == null
                                          ? null
                                          : selectedCategory.id.toString(),
                                      selectedsubCategory == null
                                          ? null
                                          : selectedsubCategory.id.toString(),
                                      selectedSubSubCategory == null
                                          ? null
                                          : selectedSubSubCategory.id
                                              .toString(),
                                      selectedBrand == null
                                          ? null
                                          : selectedBrand.id.toString(),
                                      productImagesWidgetList,
                                      thumb_image,
                                      unitController.text.trim().isEmpty
                                          ? "1"
                                          : unitController.text.trim(),
                                      minQtyController.text.trim().isEmpty
                                          ? "1"
                                          : minQtyController.text.trim(),
                                      enTagsList,
                                      arTagsList,
                                      isRefundable ? "1" : "0",
                                      videoFrom == null ? "" : videoFrom,
                                      videoUrlController.text.toString().trim(),
                                      unitPriceController.text
                                          .toString()
                                          .trim(),
                                      metaTitleArController.text
                                          .toString()
                                          .trim(),
                                      metaTitleEnController.text
                                          .toString()
                                          .trim(),
                                      metaDescriptionArController.text
                                          .toString()
                                          .trim(),
                                      metaDescriptionEnController.text
                                          .toString()
                                          .trim(),
                                      meta_image,
                                      purchasePriceController.text.trim(),
                                      attachmentFile,
                                      unitPriceDiscountController.text
                                              .trim()
                                              .isEmpty
                                          ? "0"
                                          : unitPriceDiscountController.text
                                              .trim(),
                                      currentStockController.text.trim().isEmpty
                                          ? "1"
                                          : currentStockController.text.trim(),
                                      descriptionEnController.text.trim(),
                                      descriptionArController.text.trim());
                                }
                              } else {
                                setState(() {
                                  print(result);
                                });
                              }
                            },
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 30),
                            color:
                                Theme.of(context).focusColor.withOpacity(0.15),
                            shape: StadiumBorder(),
                            child: Text('save',
//                        textAlign: TextAlign.ce,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ),
/*
                        SizedBox(
                          height: SizeConfig.vUnit * 3,
                        ),
*/
                      ],
                    ),
                  ),
                ),
              ));
  }

  @override
  void onCategoriesDataSuccess(List<CategoriesData> data) {
    presenter.getAllBrandsData();
    setState(() {
      categoriesList.clear();
      categoriesList.addAll(data);
    });
  }

  @override
  void onDataError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(
              errorText: message,
            ));
  }

  @override
  void onDataLoading(bool show) {
    setState(() {
      isLoadingData = show;
    });
  }

  @override
  void onBrandsDataSuccess(List<BrandsData> data) {
    if (editMode) {
      presenter.getProductData(widget.productsData.id);
    }

    if (data != null) {
      setState(() {
        brandsList.clear();
        brandsList.addAll(data);
      });
    }
  }

  @override
  void onAddProductSuccess(String message, VendorProductProduct data) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomMessageDialog(
              errorText: message,
            ));
  }

  @override
  void onProductDataSuccess(VendorProductProduct productsData) {
    if (productsData != null) {
      setState(() {
        minQtyController.text =
            productsData.minQty == null ? "0" : productsData.minQty.toString();
        purchasePriceController.text = productsData.purchasePrice == null
            ? "0"
            : productsData.purchasePrice.toString();
        currentStockController.text = productsData.currentStock == null
            ? "0"
            : productsData.currentStock.toString();
        nameEnController.text = productsData.nameEn;
        nameArController.text = productsData.nameAr;
        countryEnController.text = productsData.countryEn;
        countryArController.text = productsData.countryAr;
        unitController.text = productsData.unit;
        videoUrlController.text = productsData.videoLink;
        metaTitleArController.text = productsData.metaTitleAr;
        metaTitleEnController.text = productsData.metaTitleEn;
        metaDescriptionArController.text = productsData.metaDescriptionAr;
        metaDescriptionEnController.text = productsData.metaDescriptionEn;
        descriptionArController.text = productsData.descriptionAr;
        descriptionEnController.text = productsData.descriptionEn;
        unitPriceController.text = productsData.unitPrice.toString();
        unitPriceDiscountController.text = productsData.discount == null
            ? "0"
            : productsData.discount.toString();

        metaImage = productsData.metaImg == null
            ? ""
            : Constants.IMAGE_BASE_URL + productsData.metaImg;
        thumbImage = productsData.thumbnailImg == null
            ? ""
            : Constants.IMAGE_BASE_URL + productsData.thumbnailImg;

        if (productsData.refundable != null) {
          productsData.refundable == 1
              ? isRefundable = true
              : isRefundable = false;
        }

        if (productsData.tagsEn != null) {
          enTagsList = productsData.tagsEn.split('|');
          if(enTagsList.last == ""){
            enTagsList.removeLast();
          }
        }
        if (productsData.tagsAr != null) {
          arTagsList = productsData.tagsAr.split('|');

          if(arTagsList.last == ""){
            arTagsList.removeLast();
          }
        }

        fileName = productsData.pdf == null
            ? ""
            : Constants.IMAGE_BASE_URL + productsData.pdf;

        if (productsData.videoProvider != null) {
          switch (productsData.videoProvider) {
            case 'youtube':
              videoFrom = videoProvider[0];
              break;
            case 'dailymotion':
              videoFrom = videoProvider[1];
              break;
            case 'vimeo':
              videoFrom = videoProvider[2];
              break;
          }
        }

        for (BrandsData brand in brandsList) {
          if (productsData.brandId == brand.id) {
            selectedBrand = brand;

            break;
          }
        }

        if (!categoreyEditMode) {
          if (productsData != null) {
            for (CategoriesData c in categoriesList) {
              if (productsData.categoryId == c.id) {
                selectedCategory = c;

                subCategoriesList.clear();
                subCategoriesList.addAll(selectedCategory.subCategories);

                for (SubCategories sc in subCategoriesList) {
                  if (productsData.subcategoryId == sc.id) {
                    selectedsubCategory = sc;

                    subSubCategoriesList.clear();
                    subSubCategoriesList
                        .addAll(selectedsubCategory.subSubCategories);

                    for (SubSubCategories ssc in subSubCategoriesList) {
                      if (productsData.subsubcategoryId == ssc.id) {
                        selectedSubSubCategory = ssc;

                        break;
                      }
                    }

                    break;
                  }
                }

                break;
              }
            }

            categoreyEditMode = true;
          }
        }

        if (productsData != null) {
          if (productsData.photos != null) {
            for (String p in productsData.photos) {
              productImagesWidgetList.add(AdvsProductPhotoWidget(
                photoPath: Constants.IMAGE_BASE_URL + p,
                photoFile: null,
                photoUrl: p,
              ));
            }
          } else {
            productImagesWidgetList.add(AdvsProductPhotoWidget(
              photoPath: "",
              photoFile: null,
              photoUrl: null,
            ));
          }
        } else {
          productImagesWidgetList.add(AdvsProductPhotoWidget(
            photoPath: "",
            photoFile: null,
            photoUrl: null,
          ));
        }
      });
    }
  }

/*  @override

  @override
  void onUpdateProductSuccess(String message, AddAdvsProductData data) {
    showDialog(
        context: context,
        builder: (BuildContext context) => InfoDialog(
              context: context,
              content: message,
            ));
  }*/
}
