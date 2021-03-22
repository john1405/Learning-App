import 'dart:async';

import 'package:flutter/material.dart';
import 'package:learning/constant/Constantcolors.dart';
import 'package:learning/screen/landingPage/landingPage.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ConstantColors constantColors = ConstantColors();

  @override
  void initState() {
    // TODO: implement initState
    Timer(
        Duration(seconds: 1),
        () => Navigator.pushReplacement(
            context,
            PageTransition(
                child: LandingPage(), type: PageTransitionType.leftToRight)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: Center(
        child: RichText(
            text: TextSpan(
                text: 'Learning',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
                children: <TextSpan>[
              TextSpan(
                  text: 'Media',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: constantColors.redColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ))
            ])),
      ),
    );
  }
}
