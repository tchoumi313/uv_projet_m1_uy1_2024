import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexgen_agri/screens/auth/controller/auth_controller.dart';
import 'package:nexgen_agri/screens/auth/login.dart';

class DashboardScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  DashboardScreen({Key? key}) : super(key: key);

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
            PreviousRecommendations(),
            DiseaseInformation(),
          ],
        ),
      ),
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

class PreviousRecommendations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy data for layout purposes
    List<String> recommendations = ["Recommendation 1", "Recommendation 2"];

    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(8),
      child: Column(
        children: recommendations
            .map((rec) => ListTile(
          title: Text(rec, style: TextStyle(color: Colors.green)),
          leading: Icon(Icons.recommend, color: Colors.green),
        ))
            .toList(),
      ),
    );
  }
}

class DiseaseInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy data for layout purposes
    List<String> diseases = ["Disease 1", "Disease 2"];

    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(8),
      child: Column(
        children: diseases
            .map((disease) => ListTile(
          title: Text(disease, style: TextStyle(color: Colors.redAccent)),
          leading: Icon(Icons.warning, color: Colors.redAccent),
          textColor: Colors.redAccent,
        ))
            .toList(),
      ),
    );
  }
}
