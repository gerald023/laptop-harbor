import 'package:aptech_project/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:aptech_project/screens/authentication/screens/signup_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes.dart';
import 'screens/onboarding/onboarding_screen.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  try{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true // Enable offline persistence
    );
    runApp(
    const ProviderScope(
      child:  MyApp()
    )
  );
  }catch(e){
    debugPrint('Firebase initialization failed: $e');
  }
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laptop Harbor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: OnBoardingScreen.routeName,
      routes: routes,
      home: const OnBoardingScreen(),
    );
  }
}

