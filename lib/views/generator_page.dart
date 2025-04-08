import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruokasuunnittelija/providers/my_app_state.dart';
import 'package:ruokasuunnittelija/widgets/swipeable_cards.dart';

class GeneratorPage extends StatefulWidget {
  const GeneratorPage({super.key});

  @override
  _GeneratorPageState createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Päivän ateriat",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          SwipeableCards(),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              appState.randomMeals();
            },
            child: Text("Arvo päivän ateriat"),
          ),
        ],
      ),
    );
  }
}
