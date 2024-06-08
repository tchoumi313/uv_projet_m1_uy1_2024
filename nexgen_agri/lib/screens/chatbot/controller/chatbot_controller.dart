import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nexgen_agri/services/network-helper.dart';

class ChatbotController extends GetxController {
  var isLoading = false.obs;
  var chatHistory = <Map<String, String>>[
    {'role': 'user', 'content': 'Hello, what can you do?'},
    {
      'role': 'assistant',
      'content':
          'I am a Cameroonian agriculture aSssistant. I can help you with crop recommendations, disease identification, and more.'
    },
    {
      'role': 'user',
      'content':
          'Can you recommend a crop for me? I am in the west region and particularly in the menoua division'
    },
    {
      'role': 'assistant',
      'content':
          'Sure! Based on your location and soil type, I recommend growing maize.'
    },
  ].obs;

  Future<bool> sendMessage(String prompt) async {
    isLoading.value = true;
    var response = await NetworkHelper.getChatbotResponse(prompt);
    isLoading.value = false;
    if (kDebugMode) {
      print('In Controller');
      print(response);
    }
    if (response.containsKey('response')) {
      chatHistory.add({'role': 'user', 'content': prompt});
      chatHistory.add({'role': 'assistant', 'content': response['response']});
      return true;
    } else {
      Get.snackbar('Error', 'Failed to get response from chatbot');
      return false;
    }
  }
}
/* import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nexgen_agri/services/network-helper.dart';

class ChatbotController extends GetxController {
  var isLoading = false.obs;
  var chatHistory = <Map<String, String>>[].obs;
  final dbRef = FirebaseDatabase.instance.ref();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
    loadChatHistory();
  }

  Future<void> loadChatHistory() async {
    if (user != null) {
      dbRef.child('chatHistory/${user!.uid}').onValue.listen((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          chatHistory.value = List<Map<String, String>>.from(
              data.values.map((e) => Map<String, String>.from(e as Map)));
        }
      });
    }
  }

  Future<bool> sendMessage(String prompt) async {
    isLoading.value = true;
    var response = await NetworkHelper.getChatbotResponse(prompt);
    isLoading.value = false;
    if (kDebugMode) {
      print('In Controller');
      print(response);
    }
    if (response.containsKey('response')) {
      Map<String, String> userMessage = {'role': 'user', 'content': prompt};
      Map<String, String> assistantMessage = {
        'role': 'assistant',
        'content': response['response']
      };
      chatHistory.add(userMessage);
      chatHistory.add(assistantMessage);
      saveMessageToFirebase(userMessage);
      saveMessageToFirebase(assistantMessage);
      return true;
    } else {
      Get.snackbar('Error', 'Failed to get response from chatbot');
      return false;
    }
  }

  Future<void> saveMessageToFirebase(Map<String, String> message) async {
    if (user != null) {
      await dbRef.child('chatHistory/${user!.uid}').push().set(message);
    }
  }
}
 */