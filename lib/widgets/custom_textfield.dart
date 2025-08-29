import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final TextStyle? textStyle;
  final VoidCallback? onToggleVisibility; // Callback for toggling visibility
  final bool isVisible;
  final TextStyle hintStyle; // Track visibility state
  final Function(String)? onTap;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.icon,
    this.isPassword = false,
    required this.controller,
    this.validator,
    this.textStyle,
    this.onToggleVisibility,
    this.isVisible = true,
    required this.hintStyle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onTap,
      controller: controller,
      obscureText: isPassword && !isVisible,
      validator: validator,
      style: textStyle,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Colors.purpleAccent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}
