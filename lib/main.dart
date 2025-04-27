import 'package:firebase_core/firebase_core.dart';
import 'package:aptech_project/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aptech_project/route/route_constants.dart';
import 'package:aptech_project/route/router.dart' as router;
import 'screens/onboarding/onboarding_screen.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  try{
    // print(Firebase.apps);
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
      
    );
    // print(Firebase.apps);
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: router.generateRoute,
      initialRoute: onboardingScreenRoute,
    );
  }
}

