import 'dart:io';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
//Firebase Imports
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nexgen_agri/services/database.dart';
import 'package:nexgen_agri/services/firebase_auth.dart';
import 'package:nexgen_agri/services/network-helper.dart';
import 'package:nexgen_agri/utils/constants.dart';
import 'package:nexgen_agri/widgets/custom-text-button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
//UUID Import
import 'package:uuid/uuid.dart';

import 'diagnosis-screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  var uuid = const Uuid();
  String? imageFileName;
  bool isSpinning = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlurryModalProgressHUD(
        inAsyncCall: isSpinning,
        progressIndicator: const CircularProgressIndicator(
          color: Colors.green,
        ),
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 70.0,
                    backgroundImage: Image.asset('assets/logo.jpg').image,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Upload the image of the plant leaf you want to check',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: ListTile(
                      title: Text(
                        imageFileName ?? 'CLICK HERE TO UPLOAD',
                      ),
                      trailing: const Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                      ),
                      onTap: () async {
                        image = await showModalBottomSheet(
                          context: context,
                          builder: (context) => SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    margin: const EdgeInsets.only(top: 5.0),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      border: Border(
                                        top: BorderSide(
                                          color: kButtonTextColor,
                                        ),
                                        bottom: BorderSide(
                                          color: kButtonTextColor,
                                        ),
                                        left: BorderSide(
                                          color: kButtonTextColor,
                                        ),
                                        right: BorderSide(
                                          color: kButtonTextColor,
                                        ),
                                      ),
                                    ),
                                    child: TextButton(
                                        child: const Text(
                                          'Choose Image From Gallery',
                                          style: TextStyle(
                                              color: kButtonTextColor),
                                        ),
                                        onPressed: () async {
                                          image = await _picker.pickImage(
                                              source: ImageSource.gallery);
                                          Navigator.pop(context, image);
                                        }),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5.0),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      border: Border(
                                        top: BorderSide(
                                          color: kButtonTextColor,
                                        ),
                                        bottom: BorderSide(
                                          color: kButtonTextColor,
                                        ),
                                        left: BorderSide(
                                          color: kButtonTextColor,
                                        ),
                                        right: BorderSide(
                                          color: kButtonTextColor,
                                        ),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: TextButton(
                                        child: const Text(
                                          'Take a photo',
                                          style: TextStyle(
                                              color: kButtonTextColor),
                                        ),
                                        onPressed: () async {
                                          var image = await _picker.pickImage(
                                              source: ImageSource.camera);
                                          Navigator.pop(context, image);
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                        if (image != null) {
                          setState(() {
                            imageFileName = image!.name;
                          });
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextButton(
                    text: 'CHECK RESULTS',
                    textColor: Colors.white,
                    buttonBackgroundColor: const Color(0xff1A6A3D),
                    onPressedCallback: () async {
                      if (image != null) {
                        setState(() {
                          isSpinning = true;
                        });
                        File file = File(image!.path);
                        String imageId = uuid.v4();
                        String refString =
                            '/$imageId/${file.path.split('/').last}';
                        Reference ref = storage.ref(refString);
                        try {
                          await ref.putFile(file);
                          String imageUrl = await ref.getDownloadURL();
                          if (kDebugMode) {
                            print("image url $imageUrl");
                          }
                          Map response =
                              await NetworkHelper.findPlantDisease(imageUrl);
                          setState(() {
                            isSpinning = false;
                          });
                          if (response['message'] == 'Successful') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DiagnosisScreen(
                                  isHealthy: response['Healthy'],
                                  diseaseName: response['Disease'],
                                  description:
                                      response['Information'] ?? "NULL",
                                  solution: response['Solutions'],
                                  vegetable: response['Vegetable'],
                                  plantImage: Image.file(file),
                                ),
                              ),
                            );
                            saveDiseaseDetection(response, imageUrl);
                          } else if(response['message'] == 'The provided image is not a plant image' ) {
                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                duration: Duration(seconds: 10),
                                content: Text(
                                  response['message'],
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            );
                          }else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 10),
                                content: Text(
                                  'An Error Occurred',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            );
                          }
                        } on FirebaseException catch (e) {
                          if (kDebugMode) {
                            print(e);
                          }
                          setState(() {
                            isSpinning = false;
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'No Image Selected',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                // const Spacer(),
                const Text(
                  'Powered by NexGen Dev.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveDiseaseDetection(Map response, String imageUrl) async {
    // Get the application documents directory
    Directory directory = await getApplicationDocumentsDirectory();
    String directoryPath = '${directory.path}/plants';

    // Create the directory if it does not exist
    Directory plantsDirectory = Directory(directoryPath);
    if (!await plantsDirectory.exists()) {
      await plantsDirectory.create(
          recursive:
              true); // Use recursive: true to create all non-existent directories
    }

    String filePath = '$directoryPath/${uuid.v4()}.jpg';

    // Download the image
    http.Response imageData = await http.get(Uri.parse(imageUrl));
    File imageFile = File(filePath);
    await imageFile.writeAsBytes(imageData.bodyBytes);

    // Save to database
    Database db = await NoteDatabase.instance.database;
    await db.insert('diseases_detections', {
      'user_id':
          getCurrentUserId(), // Assuming you have a method to get the current user ID
      'isHealthy': response['Healthy'],
      'diseaseName': response['Disease'],
      'description': response['Information'] ?? "No description available",
      'solution': response['Solutions'],
      'vegetable': response['Vegetable'],
      'imagePath': filePath, // Save the local path
      //'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
}
