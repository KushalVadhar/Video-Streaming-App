import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_streaming_app/pages/login_page.dart';
import 'package:video_streaming_app/pages/signup_page.dart';
import 'package:video_streaming_app/pages/phone_auth_page.dart'; // New Page for Phone Auth
import 'package:video_streaming_app/widgets/custom_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
                'lib/asset/14245138_SoApril_006.jpg',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 350.0,
              child: DefaultTextStyle(
                style: GoogleFonts.pacifico(
                  textStyle: const TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                    shadows: [
                      Shadow(
                        blurRadius: 7.0,
                        color: Colors.purple,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                child: const Text('Welcome to Video Streaming....'),
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupPage()),
                );
              },
              text: 'Get Started',
              textColor: Colors.black,
              buttonColor: Colors.purpleAccent,
              fontsize: 25,
            ),
            const SizedBox(height: 20),
            CustomButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              text: 'I Already Have An Account !',
              textColor: Colors.black,
              buttonColor: Colors.purpleAccent,
              fontsize: 25,
            ),
            const SizedBox(height: 20),
            CustomButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PhoneSignInPage()),
                );
              },
              text: 'Sign In With Phone Number',
              textColor: Colors.black,
              buttonColor: Colors.orangeAccent,
              fontsize: 25,
            ),
          ],
        ),
      ),
    );
  }
}
