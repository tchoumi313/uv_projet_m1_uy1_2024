import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexgen_agri/screens/auth/controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(title: Text("Login")),
        body: Obx(()=>
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      authController.loading = true.obs;
                      authController.login(
                          emailController.text, passwordController.text);
                    },
                    child: authController.loading.value ? const CircularProgressIndicator() :  const Text("Login"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authController.loading = true.obs;
                      authController.createUser(
                          emailController.text, passwordController.text);
                    },
                    child: authController.loading.value ? const CircularProgressIndicator() : Text("Sign Up"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authController.loading = true.obs;
                      authController.signInWithGoogle();
                    },
                    child: authController.loading.value==true ? const CircularProgressIndicator() : Text("Sign in with Google"),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    ;
  }
}
