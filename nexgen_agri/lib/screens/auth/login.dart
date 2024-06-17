import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexgen_agri/screens/auth/controller/auth_controller.dart';
import 'package:nexgen_agri/utils/constants.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.green[700], // Darker green shade for the AppBar
      ),
      body:Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        height: Get.height,
        padding: EdgeInsets.all(getHeight(20, context)),
        child: Center(
          child: SingleChildScrollView(
            child: Obx(
          () =>   Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Text("N", style: TextStyle(color: Colors.lightGreenAccent, fontWeight: FontWeight.bold, fontSize: getHeight(37,context)),),
                       Text("e", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: getHeight(37,context)),),
                       Text("x", style: TextStyle(color: Colors.lightGreenAccent, fontWeight: FontWeight.bold, fontSize: getHeight(37,context)),),
                       Text("G", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: getHeight(37,context)),),
                       Text("e", style: TextStyle(color: Colors.lightGreenAccent, fontWeight: FontWeight.bold, fontSize: getHeight(37,context)),),
                       Text("N", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: getHeight(37,context)),),
                       Text(" A", style: TextStyle(color: Colors.lightGreenAccent, fontWeight: FontWeight.bold, fontSize: getHeight(37,context)),),
                       Text("g", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: getHeight(37,context)),),
                       Text("r", style: TextStyle(color: Colors.lightGreenAccent, fontWeight: FontWeight.bold, fontSize: getHeight(37,context)),),
                       Text("i", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: getHeight(37,context)),),

                     ],
                   ),

                  Image.asset('assets/logo.jpg',
                      height: getHeight(60, context)), // Logo added here
                  SizedBox(height: getHeight(20, context)),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: getHeight(20, context)),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: getHeight(20, context)),
                  ElevatedButton(
                    onPressed: () {
                      authController.loading = true.obs;
                      authController.login(
                          emailController.text, passwordController.text);
                    },
                    child: authController.loading.value
                        ? const CircularProgressIndicator()
                        : const Text("Login"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Colors.green[800], // Dark green color for button
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authController.loading = true.obs;
                      authController.createUser(
                          emailController.text, passwordController.text);
                    },
                    child: authController.loading.value
                        ? const CircularProgressIndicator()
                        : Text("Sign Up"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Colors.green[500], // Lighter green color for button
                    ),
                  ),
                /*  ElevatedButton(
                    onPressed: () {
                      authController.loading = true.obs;
                      authController.signInWithGoogle();
                    },
                    child: authController.loading.value == true
                        ? const CircularProgressIndicator()
                        : Text("Sign in with Google"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Colors.green[300], // Light green color for button
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
