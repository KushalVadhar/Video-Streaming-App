import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_streaming_app/pages/home_screen.dart';
import 'package:video_streaming_app/widgets/custom_button.dart';
import 'package:video_streaming_app/widgets/custom_textfield.dart';

class OTPVerificationPage extends StatefulWidget {
  final String verificationId;

  OTPVerificationPage({super.key, required this.verificationId});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController otpController = TextEditingController();

  Future<void> verifyOTP() async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpController.text,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      print("Error during verification: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid OTP: Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Text(
                'Verify OTP',
                style: GoogleFonts.pacifico(fontSize: 30, color: Colors.black),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintText: 'Enter OTP',
                icon: Icons.security,
                controller: otpController,
                hintStyle: GoogleFonts.pacifico(fontSize: 18),
                textStyle: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: verifyOTP, // Verify OTP on button click
                child: Text('Verify Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
