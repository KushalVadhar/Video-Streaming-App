import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.buttonColor,
    this.textColor,
    required this.fontsize,
  });

  final String text;
  final VoidCallback onTap;
  final Color? buttonColor;
  final Color? textColor;
  final double fontsize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor ?? Theme.of(context).primaryColor,
          minimumSize: const Size(double.infinity, 50)),
      onPressed: onTap,
      child: Text(
        text,
        style: GoogleFonts.pacifico(
          color: textColor,
          fontSize: fontsize,
        ),
      ),
    );
  }
}
