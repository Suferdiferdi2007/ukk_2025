import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase flutter.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('selamat datang'),
        ),
      ),
    );
  }
}
