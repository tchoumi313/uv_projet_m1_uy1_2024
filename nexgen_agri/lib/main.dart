import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexgen_agri/screens/auth/login.dart';
import 'package:nexgen_agri/screens/chatbot/chatbot_screen.dart';
import 'package:nexgen_agri/screens/dashboard_screen.dart';
import 'package:nexgen_agri/screens/plant_disease_classification/upload-screen.dart';
import 'package:nexgen_agri/screens/plant_recommendation/crop_recomandation_form_page.dart';
import 'package:nexgen_agri/screens/weather_screens/weather_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
  runApp(const MyApp());
}
//e6d987f9-0b81-4e7f-ac47-b94e8338adc4
/* class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Plant Disease Detector',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  UploadScreen(),//const CropPredictionScreen(),
    );
  }
} */

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = [
    DashboardScreen(),
    CropPredictionScreen(),
    UploadScreen(),
    WeatherScreen(),
    ChatbotScreen(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Plant Disease Detector',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: _widgetOptions[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.greenAccent,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard, ),
              label: 'Dashboard',

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.recommend),
              label: 'Recommend',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bug_report),
              label: 'Disease',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud),
              label: 'Weather',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chatbot',

            ),

          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.black45,
          selectedItemColor: Colors.green[800],
          onTap: _onItemTapped,
          elevation: 3,
        ),
      ),
    );
  }
}
