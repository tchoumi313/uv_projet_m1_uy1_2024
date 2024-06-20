import 'package:flutter/material.dart';

const kButtonTextColor = Color(0xff20503B);

var crop_images = {
  "apple": "assets/Crops/apple.jpg",
  "banana": "assets/Crops/banana.jpg",
  "blackgram": "assets/Crops/blackgram.jpg",
  "chickpea": "assets/Crops/chickpea.jpg",
  "coconut": "assets/Crops/coconut.jpg",
  "coffee": "assets/Crops/coffee.jpg",
  "cotton": "assets/Crops/cotton.jpg",
  "grapes": "assets/Crops/grapes.jpg",
  "jute": "assets/Crops/jute.jpg",
  "kidneybeans": "assets/Crops/kidneybeans.jpg",
  "lentil": "assets/Crops/lentil.jpg",
  "maize": "assets/Crops/maize.jpg",
  "mango": "assets/Crops/mango.jpg",
  "mothbeans": "assets/Crops/mothbeans.jpg",
  "mungbean": "assets/Crops/mungbean.jpg",
  "muskmelon": "assets/Crops/muskmelon.jpg",
  "orange": "assets/Crops/orange.jpg",
  "papaya": "assets/Crops/papaya.jpg",
  "pigeonpeas": "assets/Crop/pigeonpeas.jpeg",
  "pomegranate": "assets/Crops/pomegranate.jpg",
  "rice": "assets/Crops/rice.jpg",


  "watermelon": "assets/Crops/watermelon.jpg"

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
