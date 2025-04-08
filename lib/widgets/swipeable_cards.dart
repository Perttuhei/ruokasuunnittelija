import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:ruokasuunnittelija/providers/my_app_state.dart';

class SwipeableCards extends StatefulWidget {
  const SwipeableCards({super.key});

  @override
  _SwipeableCardsState createState() => _SwipeableCardsState();
}

class _SwipeableCardsState extends State<SwipeableCards> {
  final CardSwiperController controller = CardSwiperController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.currentMeals.isEmpty) {
      return Center(child: Text("Ei aterioita saatavilla."));
    }

    return Flexible(
      child: CardSwiper(
        controller: controller,
        cardsCount: appState.currentMeals.length,
        onSwipe: (previousIndex, currentIndex, direction) {
          var meal = appState.currentMeals[previousIndex];
          if (direction == CardSwiperDirection.right) {
            appState.addToFavorites(meal);
          } else if (direction == CardSwiperDirection.left) {
            appState.removeMeal(previousIndex);
          }
          return true;
        },
        cardBuilder: (context, index, thresholdX, thresholdY) {
          var meal = appState.currentMeals[index];

          return Card(
            color: Color.fromARGB(210, 195, 177, 104),
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
  }
}
