import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mo_swd392/api/auth.dart';
import 'package:mo_swd392/model/request_signup.dart';
import '/resource/color_const.dart';
import '/resource/form_field_widget.dart';
import '/resource/reponsive_utils.dart';
import '/resource/text_style.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailTextController = TextEditingController(text: '');
  TextEditingController nameTextController = TextEditingController(text: '');
  TextEditingController passwordTextController =
      TextEditingController(text: '');
  TextEditingController repasswordTextController =
      TextEditingController(text: '');

  String errorEmail = '';
  String errorName = '';

  String errorPassword = '';

  bool hidePassword = true;
  bool isLoading = false;

  bool validationName() {
    errorName = '';
    if (nameTextController.text.trim().isEmpty) {
      errorName = 'Name must not empty';
    }
    setState(() {});
    return errorName.isEmpty;
  }

  bool validationPassword() {
    errorPassword = '';
    if (passwordTextController.text.trim().isEmpty) {
      errorPassword = 'Password must not empty';
    }
    if (passwordTextController.text.trim() !=
        repasswordTextController.text.trim()) {
      errorPassword = 'Password confirm not matching';
    }
    setState(() {});
    return errorPassword.isEmpty;
  }

  bool validationEmail() {
    log('message');
    errorEmail = '';
    if (!isValidEmail(emailTextController.text.trim())) {
      errorEmail = 'Email wrong format';
    }
    if (emailTextController.text.trim().isEmpty) {
      errorEmail = 'Email must not empty';
    }
    setState(() {});
    log(errorEmail.isEmpty.toString());
    return errorEmail.isEmpty;
  }

  bool isValidEmail(String email) {
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  Future<void> signUp(BuildContext context) async {
    if (errorEmail.isEmpty && errorName.isEmpty && errorPassword.isEmpty) {
      setState(() {
        isLoading = true;
      });
      RequestSignUp body = RequestSignUp(
          name: nameTextController.text,
          password: passwordTextController.text,
          email: emailTextController.text);
      await AuthApi.register(bodyRequest: body).then((value) {
        if (value) {
          log('SignUp success');
        }
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: 'Sign up success!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }).catchError((error) {
        log('SignUp fail $error');
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: '${error.message}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
              padding:
                  UtilsReponsive.padding(context, horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Colors.grey,
                    ),
                  ),
                  UtilsReponsive.sizedBoxHeight(context, value: 30),
                  TextConstant.titleH1(context, text: 'Sign Up'),
                  UtilsReponsive.sizedBoxHeight(context, value: 30),
                  FormFieldWidget(
                      errorText: errorEmail,
                      controllerEditting: emailTextController,
                      setValueFunc: (value) {
                        validationEmail();
                      },
                      borderColor: Colors.grey,
                      labelText: 'EMAIL',
                      forcusColor: ColorsManager.primary,
                      padding: 20,
                      suffixIcon: errorEmail.isEmpty
                          ? Icon(Icons.check,
                              color: emailTextController.text.isEmpty
                                  ? Colors.white
                                  : Colors.green)
                          : const Icon(Icons.close, color: Colors.red),
                      radiusBorder: 20),
                  UtilsReponsive.sizedBoxHeight(context, value: 30),
                  FormFieldWidget(
                      errorText: errorName,
                      controllerEditting: nameTextController,
                      setValueFunc: (value) {
                        validationName();
                      },
                      borderColor: Colors.grey,
                      labelText: 'NAME',
                      forcusColor: ColorsManager.primary,
                      padding: 20,
                      suffixIcon: errorName.isEmpty
                          ? Icon(Icons.check,
                              color: nameTextController.text.isEmpty
                                  ? Colors.white
                                  : Colors.green)
                          : const Icon(Icons.close, color: Colors.red),
                      radiusBorder: 20),
                  UtilsReponsive.sizedBoxHeight(context, value: 30),
                  FormFieldWidget(
                      controllerEditting: passwordTextController,
                      setValueFunc: (value) {
                        validationPassword();
                      },
                      borderColor: Colors.grey,
                      labelText: 'PASSWORD',
                      forcusColor: ColorsManager.primary,
                      padding: 20,
                      isObscureText: hidePassword,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        child: Icon(
                          hidePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                      ),
                      radiusBorder: 20),
                  UtilsReponsive.sizedBoxHeight(context, value: 30),
                  FormFieldWidget(
                      controllerEditting: repasswordTextController,
                      errorText: errorPassword,
                      setValueFunc: (value) {
                        validationPassword();
                      },
                      borderColor: Colors.grey,
                      labelText: 'CONFIRM PASSWORD',
                      forcusColor: ColorsManager.primary,
                      padding: 20,
                      isObscureText: hidePassword,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        child: Icon(
                          hidePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                      ),
                      radiusBorder: 20),
                  UtilsReponsive.sizedBoxHeight(
                    context,
                  ),
                  UtilsReponsive.sizedBoxHeight(context, value: 30),
                  _buttonSignUp(context),
                  UtilsReponsive.sizedBoxHeight(context),
                  _buttonLoginWithGoogle(context),
                  UtilsReponsive.sizedBoxHeight(context, value: 20),
                  Row(
                    children: [
                      TextConstant.subTile3(context,
                          text: "Already have account ?", color: Colors.grey),
                      TextConstant.subTile1(context,
                          text: "Sign In", color: Colors.blue)
                    ],
                  )
                ],
              ))),
    );
  }

  SizedBox _buttonSignUp(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ButtonStyle(
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
              backgroundColor: WidgetStateProperty.all(ColorsManager.primary),
              padding: WidgetStateProperty.all(const EdgeInsets.all(14))),
          child: isLoading
              ? CupertinoActivityIndicator()
              : TextConstant.subTile2(context, text: 'SIGN UP'),
          onPressed: () async {
            await signUp(context);
          }),
    );
  }

  SizedBox _buttonLoginWithGoogle(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
            backgroundColor: WidgetStateProperty.all(ColorsManager.primary),
            padding: WidgetStateProperty.all(const EdgeInsets.all(14))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/google.png',
              height: UtilsReponsive.height(18, context),
              width: UtilsReponsive.height(18, context),
            ),
            UtilsReponsive.sizedBoxWidth(context),
            TextConstant.subTile2(
              context,
              text: 'SIGN UP WITH GOOGLE',
            )
          ],
        ),
        onPressed: () async {},
      ),
    );
  }
}
