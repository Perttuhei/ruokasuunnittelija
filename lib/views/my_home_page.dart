import 'package:flutter/material.dart';
import 'package:ruokasuunnittelija/views/favorites_page.dart';
import 'package:ruokasuunnittelija/views/generator_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: [
          GeneratorPage(),
          FavoritesPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Etusivu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Suosikit",
          ),
        ],
      ),
    );
  }
}
