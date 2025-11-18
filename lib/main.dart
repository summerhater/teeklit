import 'package:flutter/material.dart';
import 'package:teeklit/ui/community/go_router.dart';

void main() {
  runApp(Teeklit());
}

class Teeklit extends StatelessWidget {
  const Teeklit({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(fontFamily: 'Paperlogy'),
      debugShowCheckedModeBanner: false,
    );
  }
}
