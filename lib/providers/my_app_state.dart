import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyAppState extends ChangeNotifier {
  List<Map<String, dynamic>> currentMeals = [];
  List<Map<String, dynamic>> databaseMeals = [];
  List<Map<String, dynamic>> favorites = [];
  Database? _database;
  User? _user;
  final Random _random = Random();

  MyAppState() {
    _initDB();
  }

  Future<void> initMealsFromDB() async {
    if (_database == null) {
      return;
    }
    try {
      final List<Map<String, dynamic>> meals = await _database!.query('meals');
      databaseMeals = meals;
      notifyListeners();
    } catch (e) {
      print("Virhe haettaessa aterioita SQLite:stä: $e");
    }
  }

  Future<void> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'meals_database.db');

    _database = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE meals (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            name TEXT, 
            description TEXT, 
            image_url TEXT, 
            category TEXT, 
            calories INTEGER
          )''',
        );
      },
    );
    await initMealsFromDB();
    await fetchMealsFromSupabase();
  }

  Future<void> fetchMealsFromSupabase() async {
  print("Aletaan muodostamaan yhteyttä Supabaseen");
  
  final supabaseUrl = dotenv.env["SUPABASE_URL"]!;
  final supabaseKey = dotenv.env["SUPABASE_KEY"]!;
  
  final supabase = SupabaseClient(supabaseUrl, supabaseKey);

  try {
    print("Yhteys Supabaseen onnistui.");

    final response = await supabase
        .from('meals')
        .select('id, name, description, image_url, categories(categoryname), calories');

    if (response == null) {
      print('Virhe tietojen hakemisessa Supabasesta');
      return;
    }

    if (_database != null) {
      await _database!.delete('meals');

      // Lisätään uudet ateriat SQLiteen
      for (var row in response) {
        await _database!.insert('meals', {
          'name': row['name'],
          'description': row['description'],
          'image_url': row['image_url'],
          'category': row['categories']['categoryname'],
          'calories': row['calories'],
        });
      }
      print('Ruoat haettu ja tallennettu SQLite-tietokantaan.');
      await fetchMealsFromDB();
      }
    } catch (e) {
      print('Virhe tietojen hakemisessa Supabasesta: $e');
    }
  }

  Future<void> fetchMealsFromDB() async {
    if (_database == null) return;

    final List<Map<String, dynamic>> meals = await _database!.query('meals');
    currentMeals = meals;
    notifyListeners();
  }

  void toggleFavorite(Map<String, dynamic> meal) {
    if (favorites.contains(meal)) {
      favorites.remove(meal);
    } else {
      favorites.add(meal);
    }
    notifyListeners();
  }

  void addToFavorites(Map<String, dynamic> meal) {
    if (!favorites.contains(meal)) {
      favorites.add(meal);
      notifyListeners();
    }
  }

  void removeMeal(int id) async {
    if (currentMeals != null) {
      currentMeals.removeWhere((meal) => meal["id"] == id);
      notifyListeners();
    }
  }

  void randomMeals() {
    currentMeals = [];
    List<Map<String, dynamic>> meals = [];

    List<Map<String, dynamic>> breakfastlist = databaseMeals.where((meal) => meal["category"] == "Aamiainen").toList();
    if (breakfastlist.isNotEmpty) {
      meals.add(breakfastlist[_random.nextInt(breakfastlist.length)]);
    }
    List<Map<String, dynamic>> lunchlist = databaseMeals.where((meal) => meal["category"] == "Lounas").toList();
    if (lunchlist.isNotEmpty) {
      meals.add(lunchlist[_random.nextInt(lunchlist.length)]);
    }
    List<Map<String, dynamic>> dinnerlist = databaseMeals.where((meal) => meal["category"] == "Päivällinen").toList();
    if (dinnerlist.isNotEmpty) {
      meals.add(dinnerlist[_random.nextInt(dinnerlist.length)]);
    }
    List<Map<String, dynamic>> snacklist = databaseMeals.where((meal) => meal["category"] == "Välipala").toList();
    if (snacklist.isNotEmpty) {
      meals.add(snacklist[_random.nextInt(snacklist.length)]);
    }
    List<Map<String, dynamic>> dessertlist = databaseMeals.where((meal) => meal["category"] == "Jälkiruoka").toList();
    if (dessertlist.isNotEmpty) {
      meals.add(dessertlist[_random.nextInt(dessertlist.length)]);
    }
    if (meals.isNotEmpty) {
      currentMeals = meals;
    } else {
      print("Ei saatavilla olevia aterioita.");
    }

    notifyListeners();
  }

}
