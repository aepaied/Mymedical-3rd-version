import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class MustLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.symmetric(horizontal: 30),
      height:MediaQuery.of(context).size.height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: 150,
                height: 150,
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Theme.of(context).focusColor,
                          Theme.of(context).focusColor.withOpacity(0.1),
                        ])),
                /*child: Icon(
                  UiIcons.heart,
                  color: Theme.of(context).primaryColor,
                  size: 70,
                ),*/
                child: Image.asset('assets/images/logo.png'),
              ),
              Positioned(
                right: -30,
                bottom: -50,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(150),
                  ),
                ),
              ),
              Positioned(
                left: -20,
                top: -50,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(150),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 15),
          Opacity(
            opacity: 0.4,
            child: Text(
              translator.translate('must_sign_in'),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  .merge(TextStyle(fontWeight: FontWeight.w300)),
            ),
          ),
          SizedBox(height: 50),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/SignIn');
            },
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
            color: Theme.of(context).focusColor.withOpacity(0.15),
            shape: StadiumBorder(),
            child: Text(
              translator.translate('sign_in'),
//                        textAlign: TextAlign.ce,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ],
      ),
    );
  }
}
