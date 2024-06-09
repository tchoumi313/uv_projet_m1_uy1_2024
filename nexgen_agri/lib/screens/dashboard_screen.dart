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

  DashboardScreen({Key? key}) : super(key: key) {
    loadInitialData();
  }

  void loadInitialData() async {
    Database db = await NoteDatabase.instance.database;
    List<Map> recs = await db.query('recommendations',
        where: 'user_id = ?', whereArgs: [getCurrentUserId()]);
    List<Map> dis = await db.query('disease_detections',
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
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              authController.signOut();
              Get.offAll(() => LoginScreen());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            UserInfoSection(
                email: authController.auth.currentUser?.email ?? "No Email"),
            Obx(() => SizedBox(
                  height: 200,
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
                            decoration:  BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(crop_images[recommendations[index].recommendation ]!),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken)
                              ),
                            ),
                            width: getWidth(160, context),
                            child: ListTile(
                              textColor: Colors.white,
                              title: Text(recommendations[index].recommendation.toUpperCase()),
                              subtitle: Text('Tap for details'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )),
            Obx(() => SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: diseases.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 160,
                        child: Card(
                          child: Wrap(
                            children: <Widget>[
                              Image.asset(//diseases[index].imagePath ??
                                  'assets/background2.png'),
                              ListTile(
                                title: Text(diseases[index].diseaseName),
                                subtitle: Text(diseases[index].description ??
                                    "No description"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )),
          ],
        ),
      ),
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
                Image.asset(
                    crop_images[recommendation.recommendation ]??
                        'assets/background2.png'),
                Text("PH: ${recommendation.ph}" ??
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
                Get.to(()=>ChatbotScreen(),arguments:
                "Advice on ${recommendation.recommendation}");
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
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text("Welcome!", style: TextStyle(color: Colors.green)),
        subtitle: Text(email, style: TextStyle(color: Colors.green)),
        leading: Icon(Icons.account_circle, size: 50, color: Colors.green),
      ),
    );
  }
}
