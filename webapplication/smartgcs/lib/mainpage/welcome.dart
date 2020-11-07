import 'package:flutter/material.dart';

import '../widgets/custom_text.dart' as customText;

import '../background/getres.dart';

import '../mainpage/select.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) {
            return MenuApp();
          }), (Route route) => false);
        },
        child: Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.only(top: 50, bottom: 18, left: 10, right: 10),
          child: Column(
            children: <Widget>[
              Row(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child:
                        Image(height: 70, image: AssetImage('assets/images/logo-white.png')),
                  ),
                  SizedBox(height: 10,),
                  customText.LogoWelcome(),
                  SizedBox(height: 10,),
                  customText.LogoTextWhite()
                ],
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(70),
                      child: Image(image: AssetImage('assets/images/home_page.png'),
                      height: getSize(context, 230),),
                    ),
                    customText.TitleText(
                      text: 'Make city without waste',
                      textColor: Colors.black,

                    ),
                  ],
                ),
              ),
              customText.BodyText(
                text: 'TAP ANYWHERE TO CONTINUE',
                textColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
