import 'package:flutter/material.dart';
import 'package:learning/constant/Constantcolors.dart';
import 'package:learning/screen/Feed/Feed.dart';
import 'package:learning/screen/HomePage/HomePageHelper.dart';
import 'package:learning/screen/Profile/Profile.dart';
import 'package:learning/screen/chatroom/chatroom.dart';
import 'package:learning/services/FIrebaseOperation.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    Provider.of<FirebaseOperation>(context, listen: false)
        .initUserData(context);
    super.initState();
  }

  ConstantColors constantColors = ConstantColors();
  final PageController homepageController = PageController();
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: PageView(
        controller: homepageController,
        children: [Feed(), Chatroom(), Profile()],
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            pageIndex = page;
          });
        },
      ),
      bottomNavigationBar: Provider.of<HomepageHelpers>(context, listen: false)
          .bootomNavBar(context, pageIndex, homepageController),
    );
  }
}
