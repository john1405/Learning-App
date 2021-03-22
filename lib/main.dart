import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learning/constant/Constantcolors.dart';
import 'package:learning/screen/AltProfile/alt_profile_helper.dart';
import 'package:learning/screen/Feed/Feed_Helper.dart';
import 'package:learning/screen/HomePage/HomePageHelper.dart';
import 'package:learning/screen/Messaging/GroupMessageHelper.dart';
import 'package:learning/screen/Profile/ProfileHelper.dart';
import 'package:learning/screen/SplashScreen/splashScreen.dart';
import 'package:learning/screen/chatroom/chatRoomHelper.dart';
import 'package:learning/screen/landingPage/landingServices.dart';
import 'package:learning/screen/landingPage/landingUtils.dart';
import 'package:learning/screen/landingPage/landinghelper.dart';
import 'package:learning/services/Authentication.dart';
import 'package:learning/services/FIrebaseOperation.dart';
import 'package:learning/utils/PostOption.dart';
import 'package:learning/utils/UploadPost.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return MultiProvider(
        child: MaterialApp(
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            accentColor: constantColors.blueColor,
            fontFamily: 'Poppins',
            canvasColor: Colors.transparent,
          ),
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => GroupMessagingHelper()),
          ChangeNotifierProvider(create: (_) => ChatRoomHelper()),
          ChangeNotifierProvider(create: (_) => AltProfileHelper()),
          ChangeNotifierProvider(create: (_) => PostFunction()),
          ChangeNotifierProvider(create: (_) => FeedHelpers()),
          ChangeNotifierProvider(create: (_) => UploadPost()),
          ChangeNotifierProvider(create: (_) => ProfileHelpers()),
          ChangeNotifierProvider(create: (_) => HomepageHelpers()),
          ChangeNotifierProvider(create: (_) => landingUtils()),
          ChangeNotifierProvider(create: (_) => FirebaseOperation()),
          ChangeNotifierProvider(create: (_) => Authentication()),
          ChangeNotifierProvider(create: (_) => LandingService()),
          ChangeNotifierProvider(create: (_) => LandingHelper())
        ]);
  }
}
