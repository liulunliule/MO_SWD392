import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mo_swd392/api/auth.dart';
import 'package:mo_swd392/layouts/second_layout.dart';
import 'package:mo_swd392/model/achievement.dart';
import 'package:mo_swd392/resource/color_const.dart';
import 'package:mo_swd392/resource/reponsive_utils.dart';
import 'package:mo_swd392/resource/text_style.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  bool isLoading = true;
  List<Achievement> listAchievement = [];
  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  fetchData() {
    AuthApi.getAchievement().then((value) {
      setState(() {
        listAchievement = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: TextConstant.subTile2(context, text: 'Achievement'),
        ),
        body: isLoading
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : listAchievement.isEmpty
                ? Center(
                    child: TextConstant.subTile2(context,
                        text: 'Not have any data'),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(UtilsReponsive.height(15, context)),
                    itemCount: listAchievement.length,
                    separatorBuilder: (context, index) =>
                        UtilsReponsive.sizedBoxHeight(context),
                    itemBuilder: (context, index) => CardAchieve(
                      data: listAchievement[index],
                      refreshData: fetchData,
                    ),
                  ));
  }
}

class CardAchieve extends StatefulWidget {
  const CardAchieve({super.key, required this.data, required this.refreshData});
  final Achievement data;
  final Function refreshData;

  @override
  State<CardAchieve> createState() =>
      _CardAchieveState(data: data, refreshData: refreshData);
}

class _CardAchieveState extends State<CardAchieve> {
  _CardAchieveState({required this.data, required this.refreshData});
  final Achievement data;
  Function refreshData;

  bool isLoading = false;

  bool isDelete = false;

  removeData() {
    setState(() {
      isLoading = true;
    });
    AuthApi.deleteAchievement(achievementId: data.achievementId.toString())
        .then((value) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: 'Update success!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: ColorsManager.primary),
          borderRadius:
              BorderRadius.circular(UtilsReponsive.height(10, context)),
                color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: ColorsManager.primary,
              spreadRadius: 2,
              blurRadius: 0.2,
              offset: Offset(3, 4),
            ),
          ]),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextConstant.subTile2(context,
                    text: data.achievementName ?? '',),
                UtilsReponsive.sizedBoxHeight(context),
                TextConstant.subTile3(context,
                    size: 10,
                    fontWeight: FontWeight.w500,
                    text: data.achievementDescription ?? ''),
                TextConstant.subTile3(context,
                    size: 10,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    text: data.achievementLink ?? ''),
              ],
            ),
          ),
          isLoading
              ? CupertinoActivityIndicator()
              : isDelete
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              removeData();
                              isDelete = false;
                            });
                          },
                          child: Icon(
                            Icons.check,
                            color: Colors.red,
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                isDelete = false;
                              });
                            },
                            child: Icon(Icons.close))
                      ],
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          isDelete = true;
                        });
                      },
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                    ),
        ],
      ),
    );
  }
}
