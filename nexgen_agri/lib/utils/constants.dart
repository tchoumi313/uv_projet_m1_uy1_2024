import 'package:flutter/material.dart';

const kButtonTextColor = Color(0xff20503B);

var crop_images = {
  "apple": "assets/Crops/apple.jpg",
  "banana": "assets/Crops/banana.jpg",
  "orange": "assets/Crops/orange.jpg",
  "grape": "assets/Crops/grape.jpg",
  "mango": "assets/Crops/mango.jpg",
  "strawberry": "assets/Crops/strawberry.jpg",
  "peach": "assets/Crops/peach.jpg",
  "pear": "assets/Crops/pear.jpg",
  "cherry": "assets/Crops/cherry.jpg",
  "watermelon": "assets/Crops/watermelon.jpg",
  "blueberry": "assets/Crops/blueberry.jpg",
  "raspberry": "assets/Crops/raspberry.jpg",
  "pomegranate": "assets/Crops/pomegranate.jpg",
  "plum": "assets/Crops/plum.jpg",
  "lime": "assets/Crops/lime.jpg",
  "lemon": "assets/Crops/lemon.jpg",
  "apricot": "assets/Crops/apricot.jpg",
  "blackberry": "assets/Crops/blackberry.jpg",
  "rice": "assets/Crops/rice.jpg",
  "mothbeans": "assets/Crops/mothbeans.jpg",
  "papaya": "assets/Crops/papaya.jpg",
  "passionfruit": "assets/Crops/passionfruit.jpg",
  "starfruit": "assets/Crops/starfruit.jpg",
  "coconut": "assets/Crops/coconut.jpg",
  "maize": "assets/Crops/maize.jpg",
  "jackfruit": "assets/Crops/jackfruit.jpg",
  "lychee": "assets/Crops/lychee.jpg",
  "mangosteen": "assets/Crops/mangosteen.jpg",
  "tamarind": "assets/Crops/tamarind.jpg",
  "muskmelon": "assets/Crops/muskmelon.jpg",
  "kidneybeans": "assets/Crops/kidneybeans.jpg"
  // Add more images here
};


double getHeight(double value, BuildContext context) {
  double size = 0;
  size = (MediaQuery.of(context).size.height * value) / 932;
  return size;
}

double getWidth(double value, BuildContext context) {
  double size = 0;
  size = (MediaQuery.of(context).size.width * value) / 430;
  return size;
}
