import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexgen_agri/services/firebase_auth.dart';
import 'package:nexgen_agri/services/network-helper.dart';

class CropController extends GetxController {
  final RxDouble nitrogen = 0.0.obs;
  final RxDouble phosphorus = 0.0.obs;
  final RxDouble potassium = 0.0.obs;
  final RxDouble ph = 0.0.obs;
  final RxDouble humidity = 0.0.obs;
  final RxDouble rainfall = 0.0.obs;
  final RxDouble temperature = 0.0.obs;

  Future<void> predictCrop() async {
    final Map<String, String> body = {
      'nitrogen': nitrogen.value.toString(),
      'phosphorus': phosphorus.value.toString(),
      'potassium': potassium.value.toString(),
      'ph': ph.value.toString(),
      'temperature': temperature.value.toString(),
      'humidity': humidity.value.toString(),
      'rainfall': rainfall.value.toString(),
    };
    var response = await NetworkHelper.findCropPrediction(body);
    if (kDebugMode) {
      print(response);
    }
    if (response['message'] == 'Error') {
      Get.snackbar("Error", "Failed to fetch prediction",
          snackPosition: SnackPosition.BOTTOM);
    } else {
      if (kDebugMode) {
        print(" Result ${response['result']}");
      }
      saveCropRecommendation(response['result']);
      Get.snackbar("Prediction Result", response['result'],
          snackPosition: SnackPosition.TOP,
          duration: const Duration(minutes: 1),
          backgroundColor: Colors.greenAccent);
    }
  }

  Future<void> saveCropRecommendation(String recommendation) async {
    String? userId = getCurrentUserId();
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('recommendations')
          .add({
        'nitrogen': nitrogen.value,
        'phosphorus': phosphorus.value,
        'potassium': potassium.value,
        'ph': ph.value,
        'temperature': temperature.value,
        'humidity': humidity.value,
        'rainfall': rainfall.value,
        'recommendation': recommendation,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }
}
