import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:learning/constant/Constantcolors.dart';
import 'package:learning/screen/landingPage/landinghelper.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.whiteColor,
      body: Stack(
        children: [
          bodyColor(),
          Provider.of<LandingHelper>(context, listen: false).bodyImage(context),
          Provider.of<LandingHelper>(context, listen: false)
              .taglineText(context),
          Provider.of<LandingHelper>(context, listen: false)
              .mainButton(context),
        ],
      ),
    );
  }

  bodyColor() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.5, 0.9],
        colors: [
          constantColors.darkColor,
          constantColors.blueGreyColor,
        ],
      )),
    );
  }
}
