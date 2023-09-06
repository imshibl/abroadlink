import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../const/colors.dart';

class CustomTextFormField1 extends StatelessWidget {
  const CustomTextFormField1({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.onTap,
    this.readOnly,
    this.prefixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final Function()? onTap;
  final bool? readOnly;
  final Widget? prefixIcon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        onTap: onTap,
        readOnly: readOnly ?? false,
        controller: controller,
        style: GoogleFonts.poppins(color: Colors.white),
        keyboardType: keyboardType ?? TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          fillColor: ConstColors.boxBgColor,
          filled: true,
          isDense: true,
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ConstColors.boxBgColor),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: ConstColors.buttonColor,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ConstColors.boxBgColor),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: ConstColors.buttonColor,
            ),
          ),
        ),
      ),
    );
  }
}
