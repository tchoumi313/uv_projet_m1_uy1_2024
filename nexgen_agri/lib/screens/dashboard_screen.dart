import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexgen_agri/models/disease_detections.dart';
import 'package:nexgen_agri/models/recommendations.dart';
import 'package:nexgen_agri/screens/auth/controller/auth_controller.dart';
import 'package:nexgen_agri/screens/auth/login.dart';
import 'package:nexgen_agri/screens/chatbot/chatbot_screen.dart';
import 'package:nexgen_agri/screens/plant_recommendation/controller/crop_controller.dart';
import 'package:nexgen_agri/services/database.dart';
import 'package:nexgen_agri/services/firebase_auth.dart';
import 'package:nexgen_agri/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

class DashboardScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final CropController cropController = Get.put(CropController());
  final RxList<Recommendation> recommendations = <Recommendation>[].obs;
  final RxList<DiseaseDetection> diseases = <DiseaseDetection>[].obs;
  final RxBool loading = false.obs;
  DashboardScreen({Key? key}) : super(key: key) {
    loadInitialData();
  }

  void loadInitialData() async {
    Database db = await NoteDatabase.instance.database;
    List<Map> recs = await db.query('recommendations',
        where: 'user_id = ?', whereArgs: [getCurrentUserId()]);
    List<Map> dis = await db.query('diseases_detections',
        where: 'user_id = ?', whereArgs: [getCurrentUserId()]);

    recommendations
        .assignAll(recs.map((e) => Recommendation.fromMap(e)).toList());
    diseases.assignAll(dis.map((e) => DiseaseDetection.fromMap(e)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Dashboard', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              loading(true);
              loadInitialData();
              loading(false);
              },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              authController.signOut();
              Get.offAll(() => LoginScreen());
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          loadInitialData(); // Call the loadBooks method from the controller to refresh data
          },
        child: Obx(() =>  loading.value? Center(child: CircularProgressIndicator(),) :
            SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfoSection(
                  email: authController.auth.currentUser?.email ?? "No Email"),
              Padding(
                  padding: EdgeInsets.only(left: getWidth(20, context)),
                  child: Text(
                    'Recommendations',
                    style: TextStyle(
                        fontSize: getHeight(20, context),
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  )),
              Obx(() => SizedBox(
                height: getHeight(200, context),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendations.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => showRecommendationModal(
                          context, recommendations[index]),
                      child: Card(
                        elevation: 1,
                        color: Colors.transparent,
                        child: Container(
                          margin: EdgeInsets.all(getHeight(10, context)),
                          padding: EdgeInsets.all(getHeight(10, context)),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(crop_images[
                                recommendations[index].recommendation]!),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black38, BlendMode.darken)),
                          ),
                          width: getWidth(180, context),
                          child: ListTile(
                            textColor: Colors.white,
                            title: Text(recommendations[index]
                                .recommendation
                                .toUpperCase()),
                            subtitle: Text('Tap for details'),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )),
              Padding(
                  padding: EdgeInsets.only(left: getWidth(20, context)),
                  child: Text(
                    'Plant disease detected',
                    style: TextStyle(
                        fontSize: getHeight(20, context),
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  )),
              Obx(() => SizedBox(
                height: getHeight(200, context),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: diseases.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => showDiseaseModal(context, diseases[index]),
                      child: Container(
                        width: getWidth(160, context),
                        child: Card(
                          child: Wrap(
                            children: <Widget>[
                              Image.file(File(diseases[index].imagePath) ??
                                  File('assets/background2.png')),
                              ListBody(
                                  children:[ Text(diseases[index].diseaseName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: getHeight(20, context)),),
                                    Text("${
                                        diseases[index]
                                            .description!
                                            .substring(0, 40)
                                    }\n more details..."),]
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )),
            ],
          ),
        ),
        ) ),
    );
  }

  void showRecommendationModal(
      BuildContext context, Recommendation recommendation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(recommendation.recommendation),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.asset(crop_images[recommendation.recommendation] ??
                    'assets/background2.png'),
                Text("PH: ${recommendation.ph}" ??
                    "No additional details available."),
                Text("Nitrogen: ${recommendation.nitrogen}" ??
                    "No additional details available."),
                Text("PhosphorusH: ${recommendation.phosphorus}" ??
                    "No additional details available."),
                Text("Potassium: ${recommendation.potassium}" ??
                    "No additional details available."),
                Text("Temperature: ${recommendation.temperature}" ??
                    "No additional details available."),
                Text("Humidity: ${recommendation.humidity}" ??
                    "No additional details available."),
                Text("Rainfall: ${recommendation.rainfall}" ??
                    "No additional details available."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                cropController.deleteRecommendation(recommendation.id);
                loadInitialData();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Chatbot'),
              onPressed: () {
                Get.to(() => ChatbotScreen(),
                    arguments: "Advice on ${recommendation.recommendation}");
              },
            ),
          ],
        );
      },
    );
  }

  void showDiseaseModal(BuildContext context, DiseaseDetection disease) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(disease.diseaseName),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.file(File(disease.imagePath) ??
                    File('assets/background2.png')),
                Text(disease.description ?? "No description available."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                cropController.deleteDiseaseDetection(disease.id);
                loadInitialData();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Chatbot'),
              onPressed: () {
                Get.to(() => ChatbotScreen(),
                    arguments: "Advice on ${disease.diseaseName}");
              },
            ),
          ],
        );
      },
    );
  }
}

class UserInfoSection extends StatelessWidget {
  final String email;

  UserInfoSection({required this.email});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(getHeight(8, context)),
      child: ListTile(
        title: Text("Welcome!", style: TextStyle(color: Colors.green)),
        subtitle: Text(email, style: TextStyle(color: Colors.green)),
        leading: Icon(Icons.account_circle, size: 50, color: Colors.green),
      ),
    );
  }
}
