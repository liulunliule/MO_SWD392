import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mo_swd392/api/auth.dart';
import 'package:mo_swd392/layouts/second_layout.dart';
import 'package:mo_swd392/layouts/sticky_layout.dart';
import 'package:mo_swd392/model/account_profile.dart';
import 'package:mo_swd392/resource/color_const.dart';
import 'package:mo_swd392/resource/form_field_widget.dart';
import 'package:mo_swd392/resource/reponsive_utils.dart';
import 'package:mo_swd392/resource/text_style.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AccountProfile account = AccountProfile();
  bool isLoading = false;
  bool isLockUpdate = true;

  TextEditingController phoneController = TextEditingController(text: '');

  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      isLoading = true;
    });
    AuthApi.getProfile().then((value) {
      account = value;
      phoneController.text = account.phone ?? '';
      nameController.text = account.name ?? '';
      emailController.text = account.email ?? '';
      log(account.email.toString());
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  cancelUpdate() {
    isLockUpdate = true;
    phoneController.text = account.phone ?? '';
    nameController.text = account.name ?? '';
    emailController.text = account.email ?? '';
    setState(() {});
  }

  updateProfile() {
    setState(() {
      isLoading = true;
    });
    AuthApi.updateProfile(
            accountId: '${account.id}',
            name: nameController.text,
            phone: phoneController.text)
        .then((value) {
      account = value;
      phoneController.text = account.phone ?? '';
      nameController.text = account.name ?? '';
      emailController.text = account.email ?? '';
      log(account.email.toString());
      setState(() {
        isLoading = false;
        isLockUpdate = true;
      });
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
    return SecondLayout(
      title: 'Profile',
      currentPage: 'profile',
      body: SafeArea(
        child: Column(
          children: [
            UtilsReponsive.sizedBoxHeight(context, value: 20),
            Expanded(
              child: isLoading
                  ? Center(child: CupertinoActivityIndicator())
                  : Material(
                      child: Container(
                        width: UtilsReponsive.width(
                          375,
                          context,
                        ),
                        height: UtilsReponsive.height(
                          812,
                          context,
                        ),
                        color: Colors.white,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              isLoading ? SizedBox() : SizedBox(),
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      clipBehavior: Clip.hardEdge,
                                      height:
                                          UtilsReponsive.height(80, context),
                                      width: UtilsReponsive.height(80, context),
                                      decoration: BoxDecoration(
                                          color: ColorsManager.primary,
                                          shape: BoxShape.circle),
                                      child: Image.network(
                                        '${account.avatar}',
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(Icons.person),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              UtilsReponsive.sizedBoxHeight(context, value: 20),
                           
                            '${account.role}' == 'MENTOR'?  GestureDetector(
                                onTap: () {
                                   Navigator.pushNamed(context, '/achievement');
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                      Icon(Icons.archive),
                                      TextConstant.subTile3(context, text: 'Achievement')
                                  ],
                                ),
                              ):SizedBox.shrink(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.person),
                                      UtilsReponsive.sizedBoxWidth(context,
                                          value: 5),
                                      TextConstant.subTile3(
                                        context,
                                        text: "Full name",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              UtilsReponsive.sizedBoxHeight(context, value: 5),
                              FormFieldWidget(
                                controllerEditting: nameController,
                                padding: 20,
                                borderColor: Colors.grey,
                                radiusBorder: 10,
                                setValueFunc: (v) {},
                                isEnabled: !isLockUpdate,
                              ),
                              UtilsReponsive.sizedBoxHeight(context, value: 15),
                              Row(
                                children: [
                                  Icon(Icons.email),
                                  UtilsReponsive.sizedBoxWidth(context,
                                      value: 5),
                                  TextConstant.subTile3(
                                    context,
                                    text: "Email",
                                  ),
                                ],
                              ),
                              UtilsReponsive.sizedBoxHeight(context, value: 5),
                              FormFieldWidget(
                                padding: 20,
                                fillColor: Colors.grey.withOpacity(0.3),
                                borderColor: Colors.grey,
                                radiusBorder: 10,
                                isEnabled: false,
                                setValueFunc: (v) {},
                                controllerEditting: emailController,
                                // initValue: ,
                              ),
                              UtilsReponsive.sizedBoxHeight(context, value: 15),
                              Row(
                                children: [
                                  Icon(Icons.phone),
                                  UtilsReponsive.sizedBoxWidth(context,
                                      value: 5),
                                  TextConstant.subTile3(
                                    context,
                                    text: "Phone",
                                  ),
                                ],
                              ),
                              UtilsReponsive.sizedBoxHeight(context, value: 5),
                              FormFieldWidget(
                                controllerEditting: phoneController,
                                padding: 20,
                                borderColor: Colors.grey,
                                radiusBorder: 10,
                                isEnabled: !isLockUpdate,
                                setValueFunc: (v) {},
                              ),
                              isLockUpdate
                                  ? _buttonOpenEdit(context)
                                  : Row(
                                      children: [
                                        Expanded(child: _buttonCancel(context)),
                                        Expanded(child: _buttonConfirm(context))
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buttonCancel(BuildContext context) {
    return Padding(
      padding: UtilsReponsive.paddingOnly(context,
          top: 50, left: 20, right: 20, bottom: 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: UtilsReponsive.paddingOnly(context, top: 15, bottom: 15),
        ),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            'Huỷ bỏ',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: UtilsReponsive.formatFontSize(13, context),
                fontWeight: FontWeight.bold),
          ),
        ),
        onPressed: () async {
          cancelUpdate();
        },
      ),
    );
  }

  Padding _buttonOpenEdit(BuildContext context) {
    return Padding(
      padding: UtilsReponsive.paddingOnly(context,
          top: 50, left: 20, right: 20, bottom: 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: UtilsReponsive.paddingOnly(context, top: 15, bottom: 15),
        ),

        // ignore: sort_child_properties_last
        child: Container(
          alignment: Alignment.center,
          child: Text(
            'Chỉnh sửa',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: UtilsReponsive.formatFontSize(13, context),
                fontWeight: FontWeight.bold),
          ),
        ),
        onPressed: () async {
          setState(() {
            isLockUpdate = false;
          });
        },
      ),
    );
  }

  Padding _buttonConfirm(BuildContext context) {
    return Padding(
      padding: UtilsReponsive.paddingOnly(context,
          top: 50, left: 20, right: 20, bottom: 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: UtilsReponsive.paddingOnly(context, top: 15, bottom: 15),
        ),

        // ignore: sort_child_properties_last
        child: Container(
          alignment: Alignment.center,
          child: Text(
            'Cập nhật',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: UtilsReponsive.formatFontSize(13, context),
                fontWeight: FontWeight.bold),
          ),
        ),
        onPressed: () async {
          await updateProfile();
        },
      ),
    );
  }
}
