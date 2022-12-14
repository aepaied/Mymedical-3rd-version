import 'package:date_count_down/date_count_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/defaultTheme/utils/globals.dart';
import 'package:my_medical_app/funcs.dart';
import 'package:my_medical_app/shopHop/screens/ShProductDetail.dart';
import 'package:my_medical_app/ui/models/product.dart';
import 'package:my_medical_app/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:my_medical_app/main/utils/AppWidget.dart';
import 'package:my_medical_app/main/utils/dots_indicator/dots_indicator.dart';
import 'package:my_medical_app/shopHop/models/ShProduct.dart';
// import 'package:my_medical_app/shopHop/screens/ShCartScreen.dart';
// import 'package:my_medical_app/shopHop/screens/ShProductDetail.dart';
import 'package:my_medical_app/shopHop/utils/ShColors.dart';
import 'package:my_medical_app/shopHop/utils/ShExtension.dart';
import 'package:my_medical_app/shopHop/utils/ShImages.dart';
import 'package:snaplist/snaplist_view.dart';

import 'ShConstant.dart';
import 'ShStrings.dart';

var textFiledBorderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(32.0),
    borderSide: BorderSide(width: 0, color: sh_editText_background));

InputDecoration formFieldDecoration(String hint_text) {
  return InputDecoration(
    labelText: hint_text,
    focusColor: sh_colorPrimary,
    counterText: "",
    labelStyle: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
    contentPadding: new EdgeInsets.only(bottom: 2.0),
  );
}

class ProductHorizontalList extends StatelessWidget {
  final bool haveCounter;
  final List<Product> list;
  final bool isHorizontal;
  final String flashSaleEndDate;

  ProductHorizontalList(
      {Key key,
      @required this.list,
      @required this.isHorizontal,
      @required this.haveCounter,
      this.flashSaleEndDate});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: 300,
      margin: EdgeInsets.only(top: spacing_standard_new),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: list.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(right: spacing_standard_new),
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(left: spacing_standard_new),
              width: width * 0.4,
              child: InkWell(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => ShProductDetail(product: list[index])));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ShProductDetail(
                              is_ad: false,
                              product: list[index],
                              productID: list[index].id,
                            );
                          }));
                        },
                        child: Image.network(
                            Constants.IMAGE_BASE_URL +
                                list[index].thumbnail_image,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover)),
                    SizedBox(height: spacing_standard),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child: text(list[index].name,
                                  maxLine: 2,
                                  textColor: sh_textColorPrimary,
                                  fontFamily: fontMedium,
                                  fontSize: textSizeMedium)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              list[index].base_discounted_price ==
                                      list[index].base_price
                                  ? Text(
                                      // list[index].regular_price.toString().toCurrencyFormat(),
                                      "${Funcs().removeTrailingZero(list[index].base_discounted_price)}  ${translator.translate("egp")}",
                                      style: TextStyle(
                                          color: sh_textColorSecondary,
                                          fontFamily: fontRegular,
                                          fontSize: textSizeMedium),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${list[index].base_price} ${translator.translate("egp")}",
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: sh_textColorSecondary,
                                              fontFamily: fontRegular,
                                              fontSize: textSizeMedium),
                                        ),
                                        Text(
                                          "${list[index].base_discounted_price}  ${translator.translate("egp")}",
                                          style: TextStyle(
                                              color: sh_textColorSecondary,
                                              fontFamily: fontRegular,
                                              fontSize: textSizeMedium),
                                        ),
                                      ],
                                    ),
                              SizedBox(width: spacing_control_half),
                              // text(
                              //   list[index].on_sale ? list[index].sale_price.toString().toCurrencyFormat() : list[index].price.toString().toCurrencyFormat(),
                              //   textColor: sh_colorPrimary,
                              //   fontFamily: fontMedium,
                              //   fontSize: textSizeMedium,
                              // ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

Widget networkImage(String image,
    {double aWidth, double aHeight, var fit = BoxFit.fill}) {
  return Image.asset(image, width: aWidth, height: aHeight, fit: BoxFit.fill);
}

Widget checkbox(String title, bool boolValue) {
  return Row(
    children: <Widget>[
      Text(title),
      Checkbox(
        activeColor: sh_colorPrimary,
        value: boolValue,
        onChanged: (bool value) {
          boolValue = value;
        },
      )
    ],
  );
}

class TopBar extends StatefulWidget {
  var titleName;

  TopBar({var this.titleName = ""});

  @override
  State<StatefulWidget> createState() {
    return TopBarState();
  }
}

class TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: Stack(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.keyboard_arrow_left, size: 45),
              onPressed: () {
                finish(context);
              },
            ),
            Center(
                child: text(widget.titleName,
                    textColor: sh_textColorPrimary,
                    fontSize: textSizeNormal,
                    fontFamily: fontBold))
          ],
        ),
      ),
    );
  }
}

class HorizontalTab extends StatefulWidget {
  final List<String> images;
  var currentIndexPage = 0;

  HorizontalTab(this.images);

  @override
  State<StatefulWidget> createState() {
    return HorizontalTabState();
  }
}

class HorizontalTabState extends State<HorizontalTab> {
  //final VoidCallback loadMore;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    width = width - 40;
    final Size cardSize = Size(width, width / 1.5);
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width / 2,
          child: SnapList(
            padding: EdgeInsets.only(left: 16),
            sizeProvider: (index, data) => cardSize,
            separatorProvider: (index, data) => Size(12, 12),
            positionUpdate: (int index) {
              widget.currentIndexPage = index;
            },
            builder: (context, index, data) {
              return ClipRRect(
                borderRadius: new BorderRadius.circular(12.0),
                child: Image.network(
                  widget.images[index],
                  fit: BoxFit.fill,
                ),
              );
            },
            count: widget.images.length,
          ),
        ),
        DotsIndicator(
          dotsCount: 3,
          position: widget.currentIndexPage,
          decorator: DotsDecorator(
            color: sh_view_color,
            activeColor: sh_colorPrimary,
          ),
        )
      ],
    );
  }
}

Widget ring(String description) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150.0),
          border: Border.all(width: 16.0, color: sh_colorPrimary),
        ),
      ),
      SizedBox(height: 16),
      text(description,
          textColor: sh_textColorPrimary,
          fontSize: textSizeNormal,
          fontFamily: fontSemibold,
          isCentered: true,
          maxLine: 2)
    ],
  );
}

Widget shareIcon(String iconPath) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: Image.asset(iconPath, width: 28, height: 28, fit: BoxFit.fill),
  );
}

class Slider extends StatelessWidget {
  final String file;

  Slider({Key key, @required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 0,
        margin: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Image.asset(file, fit: BoxFit.fill),
      ),
    );
  }
}

showToast(BuildContext aContext, String caption) {
  Scaffold.of(aContext).showSnackBar(
      SnackBar(content: text(caption, textColor: sh_white, isCentered: true)));
}

class PinEntryTextField extends StatefulWidget {
  final String lastPin;
  final int fields;
  final onSubmit;
  final fieldWidth;
  final fontSize;
  final isTextObscure;
  final showFieldAsBox;

  PinEntryTextField(
      {this.lastPin,
      this.fields: 4,
      this.onSubmit,
      this.fieldWidth: 40.0,
      this.fontSize: 20.0,
      this.isTextObscure: false,
      this.showFieldAsBox: false})
      : assert(fields > 0);

  @override
  State createState() {
    return PinEntryTextFieldState();
  }
}

class PinEntryTextFieldState extends State<PinEntryTextField> {
  List<String> _pin;
  List<FocusNode> _focusNodes;
  List<TextEditingController> _textControllers;

  Widget textfields = Container();

  @override
  void initState() {
    super.initState();
    _pin = List<String>(widget.fields);
    _focusNodes = List<FocusNode>(widget.fields);
    _textControllers = List<TextEditingController>(widget.fields);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (widget.lastPin != null) {
          for (var i = 0; i < widget.lastPin.length; i++) {
            _pin[i] = widget.lastPin[i];
          }
        }
        textfields = generateTextFields(context);
      });
    });
  }

  @override
  void dispose() {
    _textControllers.forEach((TextEditingController t) => t.dispose());
    super.dispose();
  }

  Widget generateTextFields(BuildContext context) {
    List<Widget> textFields = List.generate(widget.fields, (int i) {
      return buildTextField(i, context);
    });

    if (_pin.first != null) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: textFields);
  }

  void clearTextFields() {
    _textControllers.forEach(
        (TextEditingController tEditController) => tEditController.clear());
    _pin.clear();
  }

  Widget buildTextField(int i, BuildContext context) {
    if (_focusNodes[i] == null) {
      _focusNodes[i] = FocusNode();
    }
    if (_textControllers[i] == null) {
      _textControllers[i] = TextEditingController();
      if (widget.lastPin != null) {
        _textControllers[i].text = widget.lastPin[i];
      }
    }

    _focusNodes[i].addListener(() {
      if (_focusNodes[i].hasFocus) {}
    });

    final String lastDigit = _textControllers[i].text;

    return Container(
      width: widget.fieldWidth,
      margin: EdgeInsets.only(right: 10.0),
      child: TextField(
        controller: _textControllers[i],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: fontMedium,
            fontSize: widget.fontSize),
        focusNode: _focusNodes[i],
        obscureText: widget.isTextObscure,
        decoration: InputDecoration(
            counterText: "",
            border: widget.showFieldAsBox
                ? OutlineInputBorder(borderSide: BorderSide(width: 2.0))
                : null),
        onChanged: (String str) {
          setState(() {
            _pin[i] = str;
          });
          if (i + 1 != widget.fields) {
            _focusNodes[i].unfocus();
            if (lastDigit != null && _pin[i] == '') {
              FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
            } else {
              FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
            }
          } else {
            _focusNodes[i].unfocus();
            if (lastDigit != null && _pin[i] == '') {
              FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
            }
          }
          if (_pin.every((String digit) => digit != null && digit != '')) {
            widget.onSubmit(_pin.join());
          }
        },
        onSubmitted: (String str) {
          if (_pin.every((String digit) => digit != null && digit != '')) {
            widget.onSubmit(_pin.join());
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return textfields;
  }
}

Widget divider() {
  return Divider(
    height: 1,
    color: sh_view_color,
  );
}

Widget horizontalHeading(var title,
    {bool showViewAll = true,
    var callback,
    @required bool haveCounter,
    String theDate,
    @required BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.only(
      left: spacing_standard_new,
      right: spacing_standard_new,
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            text(title,
                fontSize: textSizeLargeMedium,
                textColor: sh_textColorPrimary,
                fontFamily: fontMedium),
          ],
        ),
        theDate != null
            ? theDate.length != 0
                ? CountdownTimer(
                    endTime: DateFormat("dd/MM/yyyy")
                            .parse("$theDate")
                            .millisecondsSinceEpoch +
                        1000 * 30,
                    widgetBuilder: (_, CurrentRemainingTime time) {
                      if (time == null) {
                        return Text('Sale is over');
                      }

                      return time.days == null
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Text('days:${time.days} : hours: [ ${time.hours} ], min: [ ${time.min} ], sec: [ ${time.sec} ]'),
                                Container(
                                  color: Colors.white,
                                  child: Text(
                                    "${time.days} days" ?? "",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(":"),
                                Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${time.hours} hours" ?? "",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Text(":"),
                                Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${time.min} min" ?? "",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Text(":"),
                                Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${time.sec} sec" ?? "",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            );
                    },
                  )
                : Container()
            : Container(),
      ],
    ),
  );
}

Widget loadingWidgetMaker() {
  return Container(
    alignment: Alignment.center,
    child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: spacing_control,
        margin: EdgeInsets.all(4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Container(
          width: 45,
          height: 45,
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            strokeWidth: 3,
          ),
        )),
  );
}

List<Widget> colorWidget(List<Attribute> attributes) {
  var maxWidget = 6;
  var currentIndex = 0;
  var color;
  List<Widget> list = List();

  attributes.forEach((attribute) {
    if (attribute.name == "Color") {
      color = attribute.options;
    }
  });
  if (color != null) {
    var totalColors = color.length;
    var flag = false;
    color.forEach((color) {
      if (currentIndex < maxWidget) {
        list.add(Container(
          padding: EdgeInsets.all(6),
          margin: EdgeInsets.only(right: spacing_middle),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color: sh_textColorPrimary, width: 0.5),
              color: getColorFromHex(color)),
        ));
        currentIndex++;
      } else {
        if (!flag) list.add(Text('+ ${totalColors - maxWidget} more'));
        flag = true;
        return;
      }
    });
  }

  return list;
}

Widget cartIcon(context, cartCount) {
  return InkWell(
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          margin: EdgeInsets.only(right: spacing_standard_new),
          padding: EdgeInsets.all(spacing_standard),
          child: SvgPicture.asset(
            sh_ic_cart,
          ),
        ),
        cartCount > 0
            ? Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(top: spacing_control),
                  padding: EdgeInsets.all(6),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  child: text(cartCount.toString(),
                      textColor: sh_white, fontSize: textSizeSmall),
                ),
              )
            : Container()
      ],
    ),
    onTap: () {
      // ShCartScreen().launch(context);
    },
    radius: spacing_standard_new,
  );
}

Widget headingText(String content) {
  return text(content,
      textColor: sh_textColorPrimary,
      fontFamily: fontMedium,
      fontSize: textSizeLargeMedium);
}
