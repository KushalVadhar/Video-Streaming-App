import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_streaming_app/firebase_options.dart';
import 'package:video_streaming_app/pages/home_screen.dart';
import 'package:video_streaming_app/pages/onboarding_page.dart';
import 'package:video_streaming_app/pages/splash_screen.dart';
import 'package:video_streaming_app/providers/user_provider.dart';
import 'package:video_streaming_app/resources/auth_methods.dart';
import 'package:video_streaming_app/widgets/loading_indicator.dart';
import 'model/user.dart' as model;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: AuthMethods()
              .getCurrentUser(FirebaseAuth.instance.currentUser?.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingIndicator();
            }

            // If there is an error while fetching the user
            if (snapshot.hasError) {
              return const SplashScreen(); // Handle error case
            }

            // If data exists, set user and navigate to HomeScreen
            if (snapshot.hasData) {
              final userData = snapshot.data; // Get the user data
              if (userData != null) {
                Provider.of<UserProvider>(context, listen: false)
                    .setUser(model.User.fromMap(userData));
                return HomeScreen();
              }
            }

            // If no user is logged in, navigate to SplashScreen
            return const SplashScreen();
          }),
    );
  }
}
