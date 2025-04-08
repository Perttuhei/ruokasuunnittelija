import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruokasuunnittelija/providers/my_app_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(child: Text('Ei suosikkeja vielä.'));
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Suosikit (${appState.favorites.length}):'),
        ),
        for (var meal in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.red),
            title: Text(meal["name"]),
            subtitle: Text("Hinta: ${meal["price"]}€"),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                appState.toggleFavorite(meal);
              },
            ),
          ),
      ],
    );
  }
}

