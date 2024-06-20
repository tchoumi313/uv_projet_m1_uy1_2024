import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nexgen_agri/models/chat_history.dart';
import 'package:nexgen_agri/screens/chatbot/controller/chatbot_controller.dart';
import 'package:nexgen_agri/services/database.dart';
import 'package:nexgen_agri/services/firebase_auth.dart';
import 'package:nexgen_agri/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final ChatbotController _controller = Get.put(ChatbotController());
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToEndButton = false;

  @override
  void initState() {
    super.initState();
    loadChatHistory();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
          setState(() => _showScrollToEndButton = false);
        } else {
          setState(() => _showScrollToEndButton = false);
        }
      } else {
        setState(() => _showScrollToEndButton = true);
      }
    });
  }

  void loadChatHistory() async {
    Database db = await NoteDatabase.instance.database;
    List<Map> history = await db.query('chat_history',
        where: 'user_id = ?', whereArgs: [getCurrentUserId()]);
    _controller.chatHistory
        .assignAll(history.map((e) => ChatHistory.fromMap(e)).toList());
  }

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    _textController.text = ModalRoute.of(context)!.settings.arguments==null? "" : ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/profile.png'), // Add a profile image in your assets
            ),
            SizedBox(width: 10),
            Text('NexGen_Agri Chatbot', style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [

          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Add more actions if needed
            },
          ),
        ],
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(

              child: Obx(() {
                return ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,

                  itemCount: _controller.chatHistory.length,
                  itemBuilder: (context, index) {
                    ChatHistory message = _controller.chatHistory[index];
                    bool isUser = message.role == 'user';
                    return Align(
                      alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.green[100] : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.content,
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(height: getHeight(5, context)),
                            Text(
                              message.role,
                              style:
                              TextStyle(color: Colors.grey, fontSize: getHeight(12, context),
                              fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            Padding(
              padding: EdgeInsets.all(getHeight(8, context)),
              child: Row(
                children: [
                  Container(
                    width:getWidth(360, context),
                    child: TextField(
                      maxLines: null,
                      minLines: 1,
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Enter your message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: getHeight(20, context),
                            vertical: getWidth(5, context)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: getWidth(10, context)),
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: () async {
                        if (_textController.text.isNotEmpty) {
                          bool response = await _controller
                              .sendMessage(_textController.text);
                          if (response) {
                            _textController.clear();
                          } else {
                            print("Failed to send message");
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (_controller.isLoading.value) {
                return LinearProgressIndicator();
              } else {
                return SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
      floatingActionButton: _showScrollToEndButton
          ? FloatingActionButton(
        onPressed: _scrollToEnd,
        child: Icon(Icons.arrow_downward,color: Colors.green,),
      )
          : null,
    );
  }
}
