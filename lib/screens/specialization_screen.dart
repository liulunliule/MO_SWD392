import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mo_swd392/api/auth.dart';
import 'package:mo_swd392/layouts/second_layout.dart';
import 'package:mo_swd392/model/achievement.dart';
import 'package:mo_swd392/resource/color_const.dart';
import 'package:mo_swd392/resource/reponsive_utils.dart';
import 'package:mo_swd392/resource/text_style.dart';

class SpecializationScreen extends StatefulWidget {
  const SpecializationScreen({super.key});

  @override
  State<SpecializationScreen> createState() => _SpecializationScreenState();
}

class _SpecializationScreenState extends State<SpecializationScreen> {
  bool isLoading = true;
  bool isCheck = false;

  List<String> listSpecial = [];
  List<String> tempSpecail = [];
  List<String> listSpecialConst = [];

  @override
  void initState() {
    // TODO: implement initState
    fetchSpecial();
    fetchData();
    super.initState();
  }

  fetchData() {
    AuthApi.getProfile().then((value) {
      listSpecial = value.specializations ?? [];
      tempSpecail = value.specializations ?? [];
      setState(() {
        isLoading = false;
      });
    });
  }

  fetchSpecial() {
    AuthApi.getSpecialization().then((value) {
      setState(() {
        listSpecialConst = value;
      });
    });
  }

  onTapSpecial(String data) {
    if (tempSpecail.contains(data)) {
      tempSpecail.remove(data);
    } else {
      tempSpecail.add(data);
    }
  }

  onTapUpdate() {
    Navigator.pop(context);
    AuthApi.updateSpecialization(listData: tempSpecail).then((value) {
      setState(() {
        isLoading = true;
      });
      Fluttertoast.showToast(
          msg: 'Update success!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      fetchSpecial();
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: TextConstant.subTile2(context, text: 'Specialization'),
          actions: [
            Builder(builder: (context) {
              return GestureDetector(
                  onTap: () {
                    Scaffold.of(context)
                        .showBottomSheet((BuildContext context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setModalState) {
                        return Container(
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.all(
                                UtilsReponsive.height(10, context)),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    UtilsReponsive.height(20, context))),
                            height: UtilsReponsive.height(400, context),
                            width: double.infinity,
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        UtilsReponsive.sizedBoxHeight(context),
                                    itemCount: listSpecialConst.length,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                      onTap: () {
                                        onTapSpecial(listSpecialConst[index]);
                                        setModalState(() {});
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(top: 10),
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: tempSpecail.contains(
                                                          listSpecialConst[
                                                              index])
                                                      ? ColorsManager.primary
                                                      : Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      UtilsReponsive.height(
                                                          10, context)),
                                              color: isCheck
                                                  ? Colors.red
                                                  : Colors.white,
                                              boxShadow: tempSpecail.contains(
                                                      listSpecialConst[index])
                                                  ? [
                                                      BoxShadow(
                                                        color: ColorsManager
                                                            .primary,
                                                        spreadRadius: 2,
                                                        blurRadius: 0.2,
                                                        offset: Offset(3, 4),
                                                      ),
                                                    ]
                                                  : []),
                                          child: Text(listSpecialConst[index])),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: UtilsReponsive.width(120, context),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              ColorsManager.primary,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Update',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontSize: UtilsReponsive
                                                    .formatFontSize(
                                                        13, context),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        onPressed: () async {
                                          onTapUpdate();
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: UtilsReponsive.width(120, context),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              ColorsManager.primary,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Cancel',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontSize: UtilsReponsive
                                                    .formatFontSize(
                                                        13, context),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        onPressed: () async {
                                          tempSpecail = listSpecial;
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ));
                      });
                    });
                  },
                  child: Icon(Icons.add));
            })
          ],
        ),
        body: isLoading
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : listSpecial.isEmpty
                ? Center(
                    child: TextConstant.subTile2(context,
                        text: 'Not have any data'),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(UtilsReponsive.height(15, context)),
                    itemCount: listSpecial.length,
                    separatorBuilder: (context, index) =>
                        UtilsReponsive.sizedBoxHeight(context),
                    itemBuilder: (context, index) => CardSpecial(
                      data: listSpecial[index],
                      refreshData: fetchData,
                    ),
                  ));
  }
}

class CardSpecial extends StatefulWidget {
  const CardSpecial({super.key, required this.data, required this.refreshData});
  final String data;
  final Function refreshData;

  @override
  State<CardSpecial> createState() =>
      _CardSpecialState(data: data, refreshData: refreshData);
}

class _CardSpecialState extends State<CardSpecial> {
  _CardSpecialState({required this.data, required this.refreshData});
  final String data;
  Function refreshData;

  bool isLoading = false;

  bool isDelete = false;

  removeData() {
    setState(() {
      isLoading = true;
    });
    // AuthApi.deleteAchievement(achievementId: data.achievementId.toString())
    //     .then((value) {
    //   Navigator.pop(context);
    //   Fluttertoast.showToast(
    //       msg: 'Update success!',
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Colors.green,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    // });
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
      child: TextConstant.subTile2(context, text: data),
    );
  }
}
