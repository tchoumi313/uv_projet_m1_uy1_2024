import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nexgen_agri/models/chat_history.dart';
import 'package:nexgen_agri/services/database.dart';
import 'package:nexgen_agri/services/firebase_auth.dart';
import 'package:nexgen_agri/services/network-helper.dart';
import 'package:sqflite/sqflite.dart';

class ChatbotController extends GetxController {
  var isLoading = false.obs;
  var chatHistory = <ChatHistory>[].obs;

  Future<bool> sendMessage(String prompt) async {
    isLoading.value = true;
    var response = await NetworkHelper.getChatbotResponse(prompt);
    isLoading.value = false;
    if (kDebugMode) {
      print('In Controller');
      print(response);
    }
    if (response.containsKey('response')) {
      ChatHistory userMessage = ChatHistory(
        userId:
            getCurrentUserId()!, // Assuming you have a method to get the current user ID
        role: 'user',
        content: prompt,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
      ChatHistory assistantMessage = ChatHistory(
        userId: getCurrentUserId()!,
        role: 'assistant',
        content: response['response'],
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      chatHistory.addAll([userMessage, assistantMessage]);
      await saveMessageToDatabase(userMessage);
      await saveMessageToDatabase(assistantMessage);
      return true;
    } else {
      Get.snackbar('Error', 'Failed to get response from chatbot');
      return false;
    }
  }

  Future<void> saveMessageToDatabase(ChatHistory message) async {
    Database db = await NoteDatabase.instance.database;
    await db.insert('chat_history', {
      'user_id': message.userId,
      'role': message.role,
      'content': message.content,
      'timestamp': message.timestamp,
    });
  }
}
