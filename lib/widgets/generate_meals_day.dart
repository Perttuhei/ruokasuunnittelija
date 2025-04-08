import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:ruokasuunnittelija/providers/my_app_state.dart';

class GenerateMeals extends StatefulWidget {
  final VoidCallback onClose;
  const GenerateMeals({super.key, required this.onClose});

  @override
  _GenerateMealsState createState() => _GenerateMealsState();
}

class _GenerateMealsState extends State<GenerateMeals> {
  final Random _random = Random();
  Map<String, Map<String, dynamic>>? selectedMeals;
  final CardSwiperController controller = CardSwiperController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Flexible(
      child: CardSwiper(
        controller: controller,
        cardsCount: selectedMeals!.length,
        onSwipe: (previousIndex, currentIndex, direction) {
          //var meal = selectedMeals[previousIndex];
          if (direction == CardSwiperDirection.right) {
            //appState.addToFavorites(meal);
          } else if (direction == CardSwiperDirection.left) {
            //appState.removeMeal(previousIndex);
          }
          return true;
        },
        cardBuilder: (context, index, thresholdX, thresholdY) {
          var meal = appState.currentMeals[index];

          return Card(
            color: Colors.orange.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  meal["image_url"] != null
                      ? Image.network(
                        "https://peda.net/p/tomi.ukkonen/Biologia_maantieto_5_6/kuvitus/kuvamappi/biogeo/biologia/kuvituskuvat/ravinto/ruokaympyr%C3%A4:file/download/2bc71f6e0651f34001134f9d6157be8682a254e8/ruoka-aineympyra_shutterstock_54212218.jpg",
                        fit: BoxFit.cover,
                        height: 120,
                        width: double.infinity,
                      )
                      : Container(height: 120),

                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      meal["name"],
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      meal["description"] ?? "Ei kuvausta saatavilla",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Kategoria: ${meal["category"] ?? "Tuntematon"}",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "${meal["calories"]} kcal",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    /*
    return Column(
      children: [
        ElevatedButton(
          onPressed: generateMeals,
          child: Text("Arvo päivän ateriat"),
        ),
        SizedBox(height: 20),
        selectedMeals == null
            ? Text("Paina nappia arpoaksesi päivän ateriat")
            : SizedBox(
                height: 400,
                child: CardSwiper(
                  controller: _cardController,
                  cardsCount: 1,
                  onSwipe: (previousIndex, currentIndex, direction) {
                    if (direction == CardSwiperDirection.right) {
                      print("Ateriat lisätty suosikkeihin");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Ateriat lisätty suosikkeihin!")),
                      );
                    } else if (direction == CardSwiperDirection.left) {
                      widget.onClose();
                      print("Ateriat hylätty");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Ateriat hylätty!")),
                      );
                    }
                    setState(() {
                      selectedMeals = null;
                    });
                    return true;
                  },
                  cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                    return Card(
                      color: Colors.orange.shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: selectedMeals!.entries.map((entry) {
                            return Column(
                              children: [
                                Text(
                                  "${entry.key}: ${entry.value['name']}",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(entry.value['description']),
                                if (entry.value['image_url'] != null)
                                  Image.network(entry.value['image_url'], height: 80, fit: BoxFit.cover),
                                SizedBox(height: 10),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ],
    );*/
  }
}