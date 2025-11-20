import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:teeklit_application/login/login_screen.dart';
import 'package:teeklit_application/login/home_temp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teeklit',
      debugShowCheckedModeBanner: false,

      initialRoute: '/login',

      routes: {
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeTempPage(),   // ⭐ 임시 홈
      },
    );
  }
}
