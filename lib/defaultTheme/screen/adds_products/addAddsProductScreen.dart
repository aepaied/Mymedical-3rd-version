import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/data/remote/models/AddAdvsProductModel.dart';
import 'package:my_medical_app/data/remote/models/addsProductsModel.dart';
import 'package:my_medical_app/data/remote/models/allCategoriesModel.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:my_medical_app/shopHop/utils/ShColors.dart';
import 'package:my_medical_app/ui/models/user.dart';
import 'package:my_medical_app/defaultTheme/screen/adds_products/addsProductsPresenter.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:my_medical_app/utils/sizeConfig.dart';
import 'package:file_picker/file_picker.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/alert_dialoge.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/custom_messaeg_dialog.dart';
import 'package:my_medical_app/widgets/screensAndWidgets/drawer_widget.dart';
import 'package:my_medical_app/data/fetched_constans.dart' as consts;

class AddAddsProductScreen extends StatefulWidget {
  AddsProductsData productsData;

  AddAddsProductScreen({this.productsData});

  @override
  State<StatefulWidget> createState() {
    return AddAddsProductScreenState();
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

class AddAddsProductScreenState extends State<AddAddsProductScreen>
    implements AddProductCallBack {
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
  // List<AdvsProductPhotoWidget> productImagesWidgetList = List();

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

      metaImage = widget.productsData.metaImg == null
          ? ""
          : Constants.IMAGE_BASE_URL + widget.productsData.metaImg;
      thumbImage = widget.productsData.thumbnailImg == null
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
  }

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
    if (conditionsList.length == 0) {
      conditionsList
          .add(Condition(key: "new", value: translator.translate('new')));
      conditionsList
          .add(Condition(key: "used", value: translator.translate('used')));

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

/*
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
*/

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

    return Scaffold(
        key: _scaffoldKey,
        drawer: DrawerWidget(
          categoriesList: consts.categoriesList,
        ),
        appBar: AppBar(
          backgroundColor: sh_white,
          iconTheme: IconThemeData(color: sh_textColorPrimary),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
            )
          ],
          title: text("${translator.translate("no_productsf")}",
              textColor: sh_textColorPrimary),
        ),
        body: isLoadingData
            ? SpinKitChasingDots(
                color: primaryColor,
              )
            : Container());
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
            ));
  }

  @override
  void onUpdateProductSuccess(String message, AddAdvsProductData data) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomMessageDialog(
              errorText: message,
            ));
  }
}
