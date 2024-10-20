import 'package:flutter/material.dart';
import 'package:mo_swd392/resource/color_const.dart';
import 'package:mo_swd392/resource/reponsive_utils.dart';
import 'package:mo_swd392/resource/text_style.dart';

class UtilCommon {
  static void showMessgaeError(BuildContext context,
      {required String textError}) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.all(0),
              content: Center(
                  child: Container(
                alignment: Alignment.bottomCenter,
                height: UtilsReponsive.height(240, context),
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        height: UtilsReponsive.height(200, context),
                        width: double.infinity,
                        child: Column(
                          children: [
                            UtilsReponsive.sizedBoxHeight(context, value: 50),
                            TextConstant.titleH2(context, text: 'OOPS, Sorry'),
                            TextConstant.subTile3(context,
                                text: textError,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                            UtilsReponsive.sizedBoxHeight(context),
                            TextConstant.subTile2(context,
                                text: 'Please try again',
                                size: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          width: UtilsReponsive.height(80, context),
                          height: UtilsReponsive.height(80, context),
                          decoration: BoxDecoration(
                              color: Colors.red, shape: BoxShape.circle),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: UtilsReponsive.height(50, context),
                          ),
                        ))
                  ],
                ),
              )),
              // title: ,
            ));
  }
}
