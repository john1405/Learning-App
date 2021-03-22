import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:learning/constant/Constantcolors.dart';
import 'package:learning/screen/AltProfile/alt_profile_helper.dart';
import 'package:provider/provider.dart';

class AltProfile extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();
  final String userUid;
  AltProfile({@required this.userUid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          Provider.of<AltProfileHelper>(context, listen: false).appBar(context),
      body: SingleChildScrollView(
        child: Container(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userUid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: [
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .hedaerProfile(context, snapshot, userUid),
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .divider(),
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .middleProfile(context, snapshot),
                    Provider.of<AltProfileHelper>(context, listen: false)
                        .footerProfile(context, snapshot),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                );
              }
            },
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.blueGreyColor.withOpacity(0.6),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0))),
        ),
      ),
    );
  }
}
