import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_streaming_app/pages/home_screen.dart';
import 'package:video_streaming_app/pages/signup_page.dart';
import 'package:video_streaming_app/resources/auth_methods.dart';
import 'package:video_streaming_app/widgets/custom_button.dart';
import 'package:video_streaming_app/widgets/custom_textfield.dart';
import 'package:video_streaming_app/widgets/loading_indicator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  final AuthMethods _authMethods = AuthMethods();
  bool _isLoading = false;

  loginUser() async {
    setState(() {
      _isLoading = true;
    });
    bool res = await _authMethods.loginUser(
        context, emailController.text, passwordController.text);

    setState(() {
      _isLoading = false;
    });

    if (res) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: _isLoading
            ? LoadingIndicator()
            : SingleChildScrollView(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(children: [
                      // Background Circles
                      Align(
                        alignment: const AlignmentDirectional(20, -1.2),
                        child: Container(
                          height: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.purpleAccent, // Purple accent
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(-2.7, -1.2),
                        child: Container(
                          height: MediaQuery.of(context).size.width / 1.3,
                          width: MediaQuery.of(context).size.width / 1.3,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.amber, // Lavender color
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(2.7, -1.2),
                        child: Container(
                          height: MediaQuery.of(context).size.width / 1.3,
                          width: MediaQuery.of(context).size.width / 1.3,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFF7F50), // Coral color
                          ),
                        ),
                      ),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
                        child: Container(),
                      ),

                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.5,
                        left: 16,
                        right: 16,
                        child: Column(
                          children: [
                            CustomTextField(
                              hintText: 'Email',
                              icon: Icons.email,
                              controller: emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                              hintStyle: GoogleFonts.pacifico(
                                fontSize: 18,
                              ),
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 16.0),
                            CustomTextField(
                              hintText: 'Password',
                              icon: Icons.lock,
                              isPassword: true,
                              isVisible: _isPasswordVisible,
                              controller: passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              hintStyle: GoogleFonts.pacifico(
                                fontSize: 18,
                              ),
                              textStyle: const TextStyle(fontSize: 18),
                              onToggleVisibility: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            const SizedBox(height: 30),
                            CustomButton(
                              onTap: loginUser,
                              text: 'Login In',
                              textColor: Colors.black,
                              buttonColor: Colors.purpleAccent,
                              fontsize: 25,
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'Or',
                              style: GoogleFonts.pacifico(
                                  fontSize: 17, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignupPage()),
                                );
                              },
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.pacifico(
                                      fontSize: 20, color: Colors.black),
                                  children: [
                                    TextSpan(
                                        text: "If you Don't have an Account, "),
                                    TextSpan(
                                      text: 'Create One',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]))));
  }
}
