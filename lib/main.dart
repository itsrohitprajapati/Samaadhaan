import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:samaadhaan/firebase_options.dart';
import 'package:samaadhaan/screens/get_complaint_screen.dart';
import 'package:samaadhaan/screens/get_details_screen.dart';
import 'package:samaadhaan/screens/home_screen.dart';
import 'package:samaadhaan/screens/phone_number_registration.dart';
import 'package:samaadhaan/screens/video_complaint.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade400),
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const PhoneNumberRegistration());
  }
}
