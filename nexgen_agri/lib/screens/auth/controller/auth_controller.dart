import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nexgen_agri/main.dart';
import 'package:nexgen_agri/screens/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  Rxn<User> _firebaseUser = Rxn<User>();
  RxBool loading = false.obs;
  User? get user => _firebaseUser.value;

  @override
  void onInit() {
    _firebaseUser.bindStream(auth.authStateChanges());
    super.onInit();
  }

  Future<void> createUser(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Get.snackbar("Account created", "Now login to proceed");
      loading(false);
      Get.to(() => LoginScreen());
    } catch (e) {
      loading(false);
      Get.snackbar("Error creating account", e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      loading(false);
      Get.snackbar("Login Successful", "Welcome");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      Get.offAll(() => const MyApp());
    } catch (e) {
      loading(false);
      print(e.toString());
      Get.snackbar("Login Error", "Please try back", backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await auth.signInWithCredential(credential);
      loading = false.obs;
    } catch (e) {
      loading = false.obs;
      Get.snackbar("Google Sign-In Error", e.toString());
    }
  }

  void signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', false);
    await auth.signOut();
    //await GoogleSignIn().signOut();

  }
}
