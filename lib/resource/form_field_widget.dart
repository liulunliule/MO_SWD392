import '/resource/text_style.dart';

import 'reponsive_utils.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FormFieldWidget extends StatelessWidget {
  FormFieldWidget(
      {super.key,
      this.focusNode,
      this.icon,
      this.errorText = "",
      this.labelText,
      this.controllerEditting,
      required this.setValueFunc,
      this.textInputType = TextInputType.text,
      this.isObscureText = false,
      this.isEnabled = true,
      this.initValue,
      this.padding = 0,
      this.suffixIcon,
      this.enableInteractiveSelection = true,
      this.styleInput = const TextStyle(color: Colors.black),
      this.radiusBorder = 0,
      this.maxLine = 1,
      this.paddingVerti = 0,
      this.fillColor = Colors.white,
      this.directLTR = true,
      this.borderColor = Colors.black,
      this.forcusColor = Colors.black,
      this.isCenter = false
      });
  final FocusNode? focusNode;
  final Icon? icon;
  final Widget? suffixIcon;
  String? errorText;
  final String? labelText;
  final TextEditingController? controllerEditting;
  final Function setValueFunc;
  final TextInputType textInputType;
  final bool isObscureText;
  final bool? isEnabled;
  final String? initValue;
  final double? padding;
  final bool? enableInteractiveSelection;
  final TextStyle? styleInput;
  final double? radiusBorder;
  final int? maxLine;
  final double? paddingVerti;
  final Color? fillColor;
  final bool directLTR ;
  final Color borderColor;
  final bool isCenter;
  final Color forcusColor;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textDirection:directLTR?TextDirection.ltr: TextDirection.rtl,
      cursorColor: Colors.white,
      textAlign: isCenter?TextAlign.center:TextAlign.start,
      style: styleInput,
      enableInteractiveSelection: enableInteractiveSelection,
      initialValue: initValue,
      enabled: isEnabled,
      obscureText: isObscureText,
      obscuringCharacter: '*',
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextConstant.textStyleDefine(context, size: 16, fontWeight: FontWeight.normal, color: Colors.grey),
        fillColor:fillColor,
        filled: true,
        contentPadding:
            EdgeInsets.symmetric(horizontal:UtilsReponsive.height( padding!, context), vertical: UtilsReponsive.width(paddingVerti!, context)),
        errorText: errorText != "" ? errorText : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UtilsReponsive.height(radiusBorder ?? 20, context)),
          borderSide: BorderSide(color: forcusColor, width: 2),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor,),
          borderRadius: BorderRadius.circular(UtilsReponsive.height(radiusBorder ?? 20, context)),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(UtilsReponsive.height(radiusBorder ?? 20, context)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(UtilsReponsive.height(radiusBorder ?? 20, context)),
        ),
        // labelText: labelText,
        // hintText: labelText,
        hintTextDirection: TextDirection.ltr,
        hintMaxLines: 3,
        prefixIcon: icon,
        suffixIcon: suffixIcon,
      ),
      keyboardType: textInputType,
      controller: controllerEditting,
      onChanged: (value) {
        setValueFunc(value);
      },
      maxLines: maxLine,
    );
  }
}
