import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool? enabled, obscureText, readOnly;
  final int? maxLines, maxLength;
  final Widget? suffixIcon, prefixIcon;
  final String? fontFamily, hintText;
  final TextInputType? keyboardType;
  final double? inputTextSize, borderRadius, textFieldSize;
  final TextInputAction? textInputAction;
  final VoidCallback? onTap, onEditingComplete;
  final Color? cursorColor,
      filledColor,
      inputTextColor,
      hintTextColor,
      enabledBorderColor,
      focusedBorderColor;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged, onFieldSubmitted;
  CommonTextField(
      {Key? key,
      required this.controller,
      this.enabled = true,
      this.keyboardType,
      this.obscureText = false,
      this.readOnly = false,
      this.maxLines = 1,
      this.textInputAction = TextInputAction.next,
      this.cursorColor,
      this.inputTextColor,
      this.inputTextSize = 18,
      this.fontFamily = 'Poppins',
      this.validator,
      this.enabledBorderColor = Colors.black,
      this.focusedBorderColor = Colors.black,
      this.borderRadius = 10,
      this.hintText,
      this.suffixIcon,
      this.prefixIcon,
      this.textFieldSize = 17,
      this.onTap,
      this.onChanged,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.maxLength,
      this.hintTextColor,
      this.filledColor})
      : super(key: key);
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(100),
    borderSide: BorderSide(color: Colors.green),
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: TextFormField(
        onTap: onTap,
        onChanged: onChanged,
        readOnly: readOnly ?? false,
        onFieldSubmitted: onFieldSubmitted,
        onEditingComplete: onEditingComplete,
        maxLength: maxLength,
        validator: validator,
        style: TextStyle(
          color: inputTextColor,
          fontSize: inputTextSize,
          fontFamily: fontFamily,
        ),
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        obscureText: obscureText!,
        maxLines: maxLines,
        textInputAction: textInputAction,
        cursorColor: cursorColor,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
            borderSide: BorderSide(color: enabledBorderColor!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
            borderSide: BorderSide(color: focusedBorderColor!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
            borderSide: BorderSide(color: enabledBorderColor!),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
            borderSide: BorderSide(color: enabledBorderColor!),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: hintTextColor,
            fontSize: inputTextSize,
            fontFamily: fontFamily,
          ),
          filled: true,
          fillColor: filledColor,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          contentPadding: EdgeInsets.all(textFieldSize!),
          isDense: true,
          counter: Offstage(),
        ),
      ),
    );
  }
}
