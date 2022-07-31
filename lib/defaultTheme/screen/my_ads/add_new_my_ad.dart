import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/app_localizations.dart';
import 'package:my_medical_app/controllers/image_upload_controller.dart';
import 'package:my_medical_app/data/remote/models/AddAdvsProductModel.dart';
import 'package:my_medical_app/data/remote/models/addsProductsModel.dart';
import 'package:my_medical_app/data/remote/models/allCategoriesModel.dart';
import 'package:my_medical_app/defaultTheme/screen/my_ads/my_ads_presenter.dart';
import 'package:my_medical_app/defaultTheme/screen/my_ads/my_ads_screen.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/ui/dialogs/imageDialog.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/utils/oColors.dart';
import 'package:my_medical_app/widgets/advsProductPhotoWidget.dart';
import 'package:my_medical_app/widgets/custom_app_bar.dart';
import 'package:my_medical_app/widgets/image_upload_dialog.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/custom_messaeg_dialog.dart';

class AddNewMyAd extends StatefulWidget {
  AddsProductsData productsData;
  bool isEdit;

  AddNewMyAd({this.productsData, @required this.isEdit});

  @override
  State<StatefulWidget> createState() {
    return AddNewMyAdState();
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

class AddNewMyAdState extends State<AddNewMyAd> implements AddProductCallBack {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLogged = false;
  User user;
  bool isLoadingData = false;

  AddsProductsPresenter presenter;

  bool editMode = false;

  bool categoreyEditMode = false;
  bool subCategoreyEditMode = false;
  bool subSubCategoreyEditMode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.productsData != null) {
      editMode = true;
      loadEditViewData();
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
      presenter =
          AddsProductsPresenter(context: context, addProductCallBack: this);
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

  List<Condition> conditionsList = List();
  Condition selectedCondition;

  List<String> enTagsList = List();
  List<String> arTagsList = List();

  // List<ProductImage> productImagesList = List();
  List<AdvsProductPhotoWidget> productImagesWidgetList = List();

  TextEditingController nameEnController = TextEditingController();
  TextEditingController nameArController = TextEditingController();
  TextEditingController enTagsController = TextEditingController();
  TextEditingController arTagsController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController locationEnController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController videoUrlController = TextEditingController();
  TextEditingController metaTitleArController = TextEditingController();
  TextEditingController metaTitleEnController = TextEditingController();
  TextEditingController metaDescriptionArController = TextEditingController();
  TextEditingController metaDescriptionEnController = TextEditingController();
  TextEditingController descriptionArController = TextEditingController();
  TextEditingController descriptionEnController = TextEditingController();
  TextEditingController unitPriceController = TextEditingController();
  TextEditingController unitPriceDiscountController = TextEditingController();
  ImageUploadController imageUploadC = Get.put(ImageUploadController());

  removeLastChars(String str, int chars) {
    return str.substring(0, str.length - chars);
  }

  loadEditViewData() {
    if (widget.productsData != null) {
      nameEnController.text = widget.productsData.name;
      nameArController.text = widget.productsData.name;
      locationController.text = widget.productsData.location;
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

      imageUploadC.metaImage.value = widget.productsData.metaImg == null
          ? ""
          : Constants.IMAGE_BASE_URL + widget.productsData.metaImg;
      imageUploadC.thumbImage.value = widget.productsData.thumbnailImg == null
          ? ""
          : Constants.IMAGE_BASE_URL + widget.productsData.thumbnailImg;

      if (widget.productsData.tagsEn != null) {
        enTagsList = widget.productsData.tagsEn.split('|');
        if (enTagsList.last == "") {
          enTagsList.removeLast();
        }
      }
      if (widget.productsData.tagsAr != null) {
        arTagsList = widget.productsData.tagsAr.split('|');
        if (arTagsList.last == "") {
          arTagsList.removeLast();
        }
      }

      fileName = widget.productsData.pdf == null
          ? ""
          : Constants.IMAGE_BASE_URL + widget.productsData.pdf;
    }
    setState(() {});
  }

  final picker = ImagePicker();

  Future getMetaImage(ImageSource source) async {
    await imageUploadC.getMetaImage(source).then((pickedFile) {
      setState(() {});
    });
  }

  Future getThumbImage(ImageSource source) async {
    await imageUploadC.getThumbImage(source).then((pickedFile) {
      setState(() {});
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

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double wUnit;
  static double vUnit;

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    wUnit = screenWidth / 100;
    vUnit = screenHeight / 100;
    if (conditionsList.length == 0) {
      conditionsList
          .add(Condition(key: "new", value: "${translator.translate("new")}"));
      conditionsList.add(
          Condition(key: "used", value: "${translator.translate("used")}"));

      if (widget.productsData != null) {
        if (widget.productsData.conditon != null) {
          switch (widget.productsData.conditon) {
            case 'new':
              selectedCondition = conditionsList[0];
              break;
            case 'used':
              selectedCondition = conditionsList[1];
              break;
          }
        }
      }
    }

    if (productImagesWidgetList.length == 0) {
      if (widget.productsData != null) {
        if (widget.productsData.photos != null) {
          for (String p in widget.productsData.photos) {
            productImagesWidgetList.add(AdvsProductPhotoWidget(
                photoPath: Constants.IMAGE_BASE_URL + p, photoFile: null));
          }
        } else {
          productImagesWidgetList
              .add(AdvsProductPhotoWidget(photoPath: "", photoFile: null));
        }
      } else {
        productImagesWidgetList
            .add(AdvsProductPhotoWidget(photoPath: "", photoFile: null));
      }
    }

    if (videoProvider.length == 0) {
      videoProvider.add("youtube");
      videoProvider.add("dailymotion");
      videoProvider.add("vimeo");

      if (widget.productsData != null) {
        if (widget.productsData.videoProvider != null) {
          switch (widget.productsData.videoProvider) {
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
      }
    }

    return Obx(
      () => Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBar(
            title: "${translator.translate("add_new_ad")}",
            isHome: false,
          ),
          body: isLoadingData
              ? SpinKitChasingDots(
                  color: primaryColor,
                )
              : SingleChildScrollView(
                  child: Form(
                    key: _inputsformKey,
                    child: Container(
                      padding: EdgeInsets.all(wUnit * 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                                      return "${translator.translate("required")}";
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
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    labelText:
                                        "${translator.translate("name_english")}",
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
                                      return "${translator.translate("required")}";
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
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    labelText:
                                        "${translator.translate("name_arabic")}",
                                  ),
                                ),
                                SizedBox(
                                  height: vUnit,
                                ),
                                DropdownButtonFormField(
                                  isExpanded: true,
                                  hint: Text(
                                      "${translator.translate("category")}"),
                                  value: selectedCategory,
                                  validator: (value) {
                                    if (categoriesList.length > 0) {
                                      if (value == null) {
                                        return "${translator.translate("required")}";
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
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
                                SizedBox(
                                  height: vUnit,
                                ),
                                DropdownButtonFormField(
                                  isExpanded: true,
                                  hint: Text(
                                      "${translator.translate("sub_category")}"),
                                  value: selectedsubCategory,
                                  validator: (value) {
                                    if (subCategoriesList.length > 0) {
                                      if (value == null) {
                                        return "${translator.translate("required")}";
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedsubCategory = newValue;

                                      if (selectedsubCategory
                                              .subSubCategories !=
                                          null) {
                                        subSubCategoriesList.clear();
                                        subSubCategoriesList.addAll(
                                            selectedsubCategory
                                                .subSubCategories);
                                      }
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: vUnit,
                                ),
                                DropdownButtonFormField(
                                  isExpanded: true,
                                  hint: Text(
                                      "${translator.translate("sub_category")}"),
                                  value: selectedSubSubCategory,
                                  validator: (value) {
                                    if (subSubCategoriesList.length > 0) {
                                      if (value == null) {
                                        return "${translator.translate("required")}";
                                      }
                                    }
                                    return null;
                                  },
                                  items: subSubCategoriesList
                                      .map((SubSubCategories category) {
                                    return new DropdownMenuItem<
                                        SubSubCategories>(
                                      value: category,
                                      child: new Text(
                                        category.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedSubSubCategory = newValue;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: vUnit,
                                ),
                                DropdownButtonFormField(
                                  isExpanded: true,
                                  hint: Text(
                                      "${translator.translate("condition")}"),
                                  value: selectedCondition,
                                  validator: (value) {
                                    if (conditionsList.length > 0) {
                                      if (value == null) {
                                        return "${translator.translate("required")}";
                                      }
                                    }
                                    return null;
                                  },
                                  items:
                                      conditionsList.map((Condition condition) {
                                    return new DropdownMenuItem<Condition>(
                                      value: condition,
                                      child: new Text(
                                        condition.value,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedCondition = newValue;
                                    });
                                  },
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  controller: locationEnController,
                                  onFieldSubmitted: (String value) {},
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "${translator.translate("required")}";
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
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    labelText:
                                        "${translator.translate("location_en")}",
                                  ),
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  controller: locationController,
                                  onFieldSubmitted: (String value) {
                                    /*  setState(() {
                                _requestSent = false;
                        _mobileValidation = "";
                        this._mobile = value;
                        });*/
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "${translator.translate("required")}";
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
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    labelText:
                                        "${translator.translate("location_ar")}",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: Text(
                              "${translator.translate("tag_en")}",
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
                                color: Colors.white,
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
                                      return Divider(
                                        /*color: Theme.of(context).accentColor,*/
                                        height: vUnit,
                                      );
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
                                              padding: EdgeInsets.all(wUnit),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0)),
                                                // border: Border.all(color: OColors.colorGray3)
                                                color: OColors.colorRed,
                                              ),
                                              child: SvgPicture.asset(
                                                  "assets/icons/ic_remove3.svg",
                                                  semanticsLabel: "ic_remove3",
                                                  color: OColors.colorWhite,
                                                  width: wUnit * 6,
                                                  height: wUnit * 6),
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
                                        borderSide: BorderSide(
                                            color: OColors.colorGray2),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: OColors.colorGray2),
                                      ),
                                      labelStyle:
                                          Theme.of(context).textTheme.bodyText1,
                                      labelText:
                                          "${translator.translate("add_tag_en")}",
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: Text(
                              "${translator.translate("tag_ar")}",
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
                                color: Colors.white,
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
                                      return Divider(
                                        /*color: Theme.of(context).accentColor,*/
                                        height: vUnit,
                                      );
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
                                              padding: EdgeInsets.all(wUnit),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0)),
                                                // border: Border.all(color: OColors.colorGray3)
                                                color: OColors.colorRed,
                                              ),
                                              child: SvgPicture.asset(
                                                  "assets/icons/ic_remove3.svg",
                                                  semanticsLabel: "ic_remove3",
                                                  color: OColors.colorWhite,
                                                  width: wUnit * 6,
                                                  height: wUnit * 6),
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
                                        borderSide: BorderSide(
                                            color: OColors.colorGray2),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: OColors.colorGray2),
                                      ),
                                      labelStyle:
                                          Theme.of(context).textTheme.bodyText1,
                                      labelText:
                                          "${translator.translate("add_tag_ar")}",
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: Text(
                              "${translator.translate("images")}",
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
                              color: Colors.white,
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
                                SizedBox(
                                  height: vUnit * 2,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${translator.translate("main_images")}",
                                      textAlign: TextAlign.start,
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                    SizedBox(
                                      width: wUnit * 2,
                                    ),
                                    Expanded(
                                        child: ListView.separated(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: productImagesWidgetList.length,
                                      separatorBuilder: (context, index) {
                                        return Divider(
                                          /*color: Theme.of(context).accentColor,*/
                                          height: vUnit,
                                        );
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
                                  child: Text(
                                    "${translator.translate("required")}",
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .apply(color: OColors.colorRed),
                                  ),
                                ),
                                SizedBox(
                                  height: vUnit,
                                ),
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
                                        TextSpan(
                                            text:
                                                "${translator.translate("add_photo")}",
                                            style:
                                                TextStyle(color: primaryColor)),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: vUnit * 2,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${translator.translate("thumbnail_image")}",
                                      textAlign: TextAlign.start,
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                    SizedBox(
                                      width: wUnit * 2,
                                    ),
                                    Expanded(
                                        child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              ImageUploadDialog(type: "thumb"),
                                        );
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
                                            image: imageUploadC
                                                        .thumbImage.value ==
                                                    ""
                                                ? imageUploadC.thumb_image
                                                            .value ==
                                                        null
                                                    ? AssetImage(
                                                        'assets/images/add.png')
                                                    : FileImage(imageUploadC
                                                        .thumb_image.value)
                                                : NetworkImage(imageUploadC
                                                    .thumbImage.value),
                                          ),
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                                Visibility(
                                  visible: noThumbImage,
                                  child: Text(
                                    "${translator.translate("required")}",
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: Text(
                              "${translator.translate("videos")}",
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
                              color: Colors.white,
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
                                SizedBox(
                                  height: vUnit,
                                ),
                                DropdownButton(
                                  isExpanded: true,
                                  hint: Text(
                                      "${translator.translate("video_from")}"),
                                  value: videoFrom,
                                  items: videoProvider.map((String host) {
                                    return new DropdownMenuItem<String>(
                                      value: host,
                                      child: new Text(
                                        host,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      videoFrom = newValue;
                                    });
                                  },
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  controller: videoUrlController,
                                  onFieldSubmitted: (String value) {},
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
                                    labelText:
                                        "${translator.translate("video_url")}",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: Text(
                              "${translator.translate("meta_tags")}",
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
                              color: Colors.white,
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
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    labelText:
                                        "${translator.translate("meta_title_en")}",
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
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    labelText:
                                        "${translator.translate("meta_title_ar")}",
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
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    labelText:
                                        "${translator.translate("description_en")}",
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
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    labelText:
                                        "${translator.translate("description_ar")}",
                                  ),
                                ),
                                SizedBox(
                                  height: vUnit * 2,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${translator.translate("imageUploadC.meta_image.value")}",
                                      textAlign: TextAlign.start,
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                    SizedBox(
                                      width: wUnit * 2,
                                    ),
                                    Expanded(
                                        child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              ImageUploadDialog(type: "meta"),
                                        );
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
                                            image: imageUploadC
                                                        .metaImage.value ==
                                                    ""
                                                ? imageUploadC
                                                            .meta_image.value ==
                                                        null
                                                    ? AssetImage(
                                                        'assets/images/add.png')
                                                    : FileImage(imageUploadC
                                                        .meta_image.value)
                                                : NetworkImage(imageUploadC
                                                    .metaImage.value),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: Text(
                              "${translator.translate("price")}",
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
                              color: Colors.white,
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
                                      return "${translator.translate("required")}";
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
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    labelText: "${translator.translate("qty")}",
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
                                      return "${translator.translate("required")}";
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
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    labelText:
                                        "${translator.translate("unit_price")}",
                                  ),
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  controller: unitPriceDiscountController,
                                  onFieldSubmitted: (String value) {},
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
                                    labelText:
                                        "${translator.translate("discount")}",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: Text(
                              "${translator.translate("description_en")}",
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
                              color: Colors.white,
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
                                      return "${translator.translate("required")}";
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
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    labelText:
                                        "${translator.translate("description_en")}",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: Text(
                              "${translator.translate("description_ar")}",
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
                              color: Colors.white,
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
                                      return "${translator.translate("required")}";
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
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    labelText:
                                        "${translator.translate("description_ar")}",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: Text(
                              "${translator.translate("attachments")}",
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
                                color: Colors.white,
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
                                          padding: EdgeInsets.all(wUnit * 3),
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
                                                  ? "${translator.translate("attachments")}"
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
                                      SizedBox(
                                        width: wUnit * 4,
                                      ),
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
                                    child: Text(
                                      "${translator.translate("required_file")}",
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .apply(color: OColors.colorRed),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: vUnit * 2,
                          ),
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
                                  if (imageUploadC.thumb_image.value == null) {
                                    noThumbImage = true;
                                    result = false;
                                  } else {
                                    noThumbImage = false;
                                  }
                                }
                                /*else{
                                  if (thumbImage.isEmpty) {
                                    noThumbImage = true;
                                    result = false;
                                  } else {
                                    noThumbImage = false;
                                  }
                                }*/

                                /*   if(fileName.isEmpty){
                                  noAttachmentFile = true;
                                  result = false;
                                } else{
                                  noAttachmentFile = false;
                                }*/

                                if (widget.productsData == null) {
                                  if (productImagesWidgetList[0].photoFile ==
                                      null) {
                                    noMainImage = true;
                                    result = false;
                                  } else {
                                    noMainImage = false;
                                  }
                                }
                                /*else{
                                  if (productImagesWidgetList[0]
                                      .photoPath
                                      .isEmpty) {
                                    noMainImage = true;
                                    result = false;
                                  } else {
                                    noMainImage = false;
                                  }
                                }*/

                                if (result) {
                                  if (widget.productsData != null) {
                                    presenter.updateProduct(
                                        widget.productsData.id,
                                        nameEnController.text.toString().trim(),
                                        nameArController.text.toString().trim(),
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
                                        null,
                                        selectedCondition == null
                                            ? null
                                            : selectedCondition.key,
                                        locationController.text
                                            .toString()
                                            .trim(),
                                        locationEnController.text
                                            .toString()
                                            .trim(),
                                        productImagesWidgetList,
                                        imageUploadC.thumb_image.value,
                                        unitController.text.toString().trim(),
                                        enTagsList,
                                        arTagsList,
                                        descriptionArController.text
                                            .toString()
                                            .trim(),
                                        descriptionEnController.text
                                            .toString()
                                            .trim(),
                                        videoFrom == null ? "" : videoFrom,
                                        videoUrlController.text
                                            .toString()
                                            .trim(),
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
                                        imageUploadC.meta_image.value,
                                        attachmentFile,
                                        unitPriceDiscountController.text
                                                .trim()
                                                .isEmpty
                                            ? "0"
                                            : unitPriceDiscountController.text
                                                .trim());
                                  } else {
                                    presenter.addNewProduct(
                                        nameEnController.text.toString().trim(),
                                        nameArController.text.toString().trim(),
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
                                        null,
                                        selectedCondition == null
                                            ? null
                                            : selectedCondition.key,
                                        locationController.text
                                            .toString()
                                            .trim(),
                                        locationEnController.text
                                            .toString()
                                            .trim(),
                                        productImagesWidgetList,
                                        imageUploadC.thumb_image.value,
                                        unitController.text.toString().trim(),
                                        enTagsList,
                                        arTagsList,
                                        descriptionArController.text
                                            .toString()
                                            .trim(),
                                        descriptionEnController.text
                                            .toString()
                                            .trim(),
                                        videoFrom == null ? "" : videoFrom,
                                        videoUrlController.text
                                            .toString()
                                            .trim(),
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
                                        imageUploadC.meta_image.value,
                                        attachmentFile,
                                        unitPriceDiscountController.text
                                                .trim()
                                                .isEmpty
                                            ? "0"
                                            : unitPriceDiscountController.text
                                                .trim());
                                  }
                                } else {
                                  setState(() {
                                    print(result);
                                  });
                                }
                              },
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 30),
                              color: primaryColor,
                              shape: StadiumBorder(),
                              child: Text(
                                "${translator.translate("save")}",
//                        textAlign: TextAlign.ce,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: vUnit * 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
    );
  }

  @override
  void onCategoriesDataSuccess(List<CategoriesData> data) {
    setState(() {
      categoriesList.clear();
      categoriesList.addAll(data);

      if (!categoreyEditMode) {
        if (widget.productsData != null) {
          for (CategoriesData c in categoriesList) {
            if (widget.productsData.categoryId == c.id) {
              selectedCategory = c;

              subCategoriesList.clear();
              subCategoriesList.addAll(selectedCategory.subCategories);

              for (SubCategories sc in subCategoriesList) {
                if (widget.productsData.subcategoryId == sc.id) {
                  selectedsubCategory = sc;

                  subSubCategoriesList.clear();
                  subSubCategoriesList
                      .addAll(selectedsubCategory.subSubCategories);

                  for (SubSubCategories ssc in subSubCategoriesList) {
                    if (widget.productsData.subsubcategoryId == ssc.id) {
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
  void onAddProductSuccess(String message, AddAdvsProductData data) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomMessageDialog(
              errorText: message,
            )).then((value) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return MyAdsScreen();
      }));
    });
  }

  @override
  void onUpdateProductSuccess(String message, AddAdvsProductData data) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return MyAdsScreen();
    }));
  }
}
