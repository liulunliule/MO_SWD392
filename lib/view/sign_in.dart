import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mo_swd392/api/auth.dart';
import 'package:mo_swd392/util/util_common.dart';
import '/resource/color_const.dart';
import '/resource/form_field_widget.dart';
import '/resource/reponsive_utils.dart';
import '/resource/text_style.dart';
import '/view/sign_up.dart';
import '../services/google/google_auth_servive.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailTextController = TextEditingController(text: '');
  TextEditingController passwordTextController =
      TextEditingController(text: '');

  String errorEmail = '';
  String errorPassword = '';

  bool hidePassword = true;
  bool isLoading = false;
  AuthApi service = AuthApi();

  Future<void> login() async {
    if (errorEmail.isEmpty && errorPassword.isEmpty) {
      setState(() {
        isLoading = true;
      });
      await AuthApi.login(
              email: emailTextController.text,
              password: passwordTextController.text)
          .then((value) {
        if (value) {
          log('Login success');
          Navigator.pushReplacementNamed(context, '/');
        }
        setState(() {
          isLoading = false;
        });
      }).catchError((error) {
        log('Login fail $error');
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: '${error.message}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: const Color.fromARGB(255, 255, 126, 126),
            fontSize: 16.0);
      });
    }
  }

  bool validationEmail() {
    errorEmail = '';
    if (!isValidEmail(emailTextController.text.trim())) {
      errorEmail = 'Email wrong format';
    }
    if (emailTextController.text.trim().isEmpty) {
      errorEmail = 'Email must not empty';
    }
    setState(() {});
    return errorEmail.isEmpty;
  }

  bool isValidEmail(String email) {
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  Future<void> googleLogin() async {
    try {
      User? user = await GoogleAuthService().signInWithGoogle();
      if (user != null) {
        log('Google Login success');
        Navigator.pushReplacementNamed(context, '/');
      } else {
        Fluttertoast.showToast(
          msg: 'Google Sign-In failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      log('Google Sign-In error: $e');
      Fluttertoast.showToast(
        msg: 'Google Sign-In error: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              UtilsReponsive.padding(context, horizontal: 20, vertical: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextConstant.titleH1(context, text: 'Sign In'),
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
                radiusBorder: 20,
              ),
              UtilsReponsive.sizedBoxHeight(context, value: 30),
              FormFieldWidget(
                controllerEditting: passwordTextController,
                setValueFunc: (value) {},
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
                radiusBorder: 20,
              ),
              UtilsReponsive.sizedBoxHeight(context),
              Align(
                alignment: Alignment.centerRight,
                child: TextConstant.subTile3(context,
                    text: 'Forgot password ?', color: Colors.red),
              ),
              UtilsReponsive.sizedBoxHeight(context, value: 30),
              _buttonLogin(context),
              UtilsReponsive.sizedBoxHeight(context),
              _buttonLoginWithGoogle(context),
              UtilsReponsive.sizedBoxHeight(context, value: 20),
              Row(
                children: [
                  TextConstant.subTile3(context,
                      text: "Don't have account ?", color: Colors.grey),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: TextConstant.subTile1(context,
                        text: "Sign Up", color: Colors.blue),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _buttonLogin(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          backgroundColor: WidgetStateProperty.all(ColorsManager.primary),
          padding: WidgetStateProperty.all(const EdgeInsets.all(14)),
        ),
        child: isLoading
            ? CupertinoActivityIndicator()
            : TextConstant.subTile2(context, text: 'SIGN IN'),
        onPressed: () async {
          await login();
        },
      ),
    );
  }

  SizedBox _buttonLoginWithGoogle(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          backgroundColor: WidgetStateProperty.all(ColorsManager.primary),
          padding: WidgetStateProperty.all(const EdgeInsets.all(14)),
        ),
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
              text: 'SIGN IN WITH GOOGLE',
            ),
          ],
        ),
        onPressed: googleLogin,
      ),
    );
  }
}
