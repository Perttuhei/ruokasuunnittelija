import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:ruokasuunnittelija/providers/my_app_state.dart';
import 'package:ruokasuunnittelija/views/my_home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  print("terve");
  await dotenv.load(fileName: ".env");
  print("POSTGRE USER: ${dotenv.env["POSTGRE_USER"]}");

  runApp(
    ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ruokasuunnittelija',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
    );
  }
}
