import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexgen_agri/screens/chatbot/chatbot_screen.dart';
import 'package:nexgen_agri/services/database.dart';
import 'package:nexgen_agri/services/firebase_auth.dart';
import 'package:nexgen_agri/services/network-helper.dart';
import 'package:nexgen_agri/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

class CropController extends GetxController {
  final RxDouble nitrogen = 0.0.obs;
  final RxDouble phosphorus = 0.0.obs;
  final RxDouble potassium = 0.0.obs;
  final RxDouble ph = 0.0.obs;
  final RxDouble humidity = 0.0.obs;
  final RxDouble rainfall = 0.0.obs;
  final RxDouble temperature = 0.0.obs;


  Future<void> deleteRecommendation(int id) async {
    Database db = await NoteDatabase.instance.database;
    await db.delete(
      'recommendations',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (kDebugMode) {
      print('Deleted recommendation with ID: $id');
    }
  }

  Future<bool> predictCrop() async {
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
      return false;
    } else {
      if (kDebugMode) {
        print(" Result ${response['result']}");
      }
      showCropDetailsModal(Get.context!, response['result']);
      return true;
    }
  }

  void showCropDetailsModal(BuildContext context, String cropName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(cropName.toUpperCase()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.asset(crop_images[cropName]!),
                SizedBox(height: 20),
                Text(
                    "Learn how to cultivate $cropName with the best practices for your soil."),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the chatbot screen
                    Get.to(()=>const ChatbotScreen(),
                        arguments: "How to cultivate $cropName?");
                  },
                  child: Text('Ask the Chatbot'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save Recommendation'),
              onPressed: () {
                Navigator.of(context).pop();
                confirmSaveRecommendation(context, cropName);
              },
            ),
          ],
        );
      },
    );
  }

  void confirmSaveRecommendation(BuildContext context, String recommendation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Save'),
          content: Text('Do you want to save this recommendation?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                saveRecommendation(recommendation);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> saveRecommendation(String recommendation) async {
    Database db = await NoteDatabase.instance.database;
    await db.insert('recommendations', {
      'user_id':
          getCurrentUserId(), // Assuming you have a method to get the current user ID
      'nitrogen': nitrogen.value,
      'phosphorus': phosphorus.value,
      'potassium': potassium.value,
      'ph': ph.value,
      'temperature': temperature.value,
      'humidity': humidity.value,
      'rainfall': rainfall.value,
      'recommendation': recommendation,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
}
