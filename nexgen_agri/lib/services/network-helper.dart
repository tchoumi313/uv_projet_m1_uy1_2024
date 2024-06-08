import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String domain = "http://10.0.2.2:5000";//'https://ve4h9pohto3k.share.zrok.io';
const String weatherUrl = "https://openweather.com";

class NetworkHelper {
  static Future<Map> findPlantDisease(String imageUrl) async {
    var url = Uri.parse('$domain/checkDisease');
    print(url);
    var body = json.encode({'link': imageUrl});
    print(body);
    var response = await http.post(
      url,
      body: body,
      headers: {'Content-Type': 'application/json'},
    );
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      Map decoded = jsonDecode(response.body) as Map;
      return decoded;
    } else {
      print(response);
      return {'message': 'Error'};
    }
  }

  static Future<Map> findCropPrediction(Map<String, String> body) async {
    var url = Uri.parse('$domain/predictCrop');
    print(url);
    var response = await http.post(
      url,
      body: body,
    );
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      Map decoded = jsonDecode(response.body) as Map;
      return decoded;
    } else {
      return {'message': 'Error'};
    }
  }

  static Future<List> getFourDayForecast(double latitude,
      double longitude) async {
    var url = Uri.parse('$domain/forecast?lat=$latitude&lon=$longitude');
    print(url);
    var response = await http.get(url);
    if (kDebugMode) {
      print("Forecast");
      print(response.body);
      print(response);
    }
    if (response.statusCode == 200) {
      List decoded = jsonDecode(response.body);
      return decoded;
    } else {
      print("Forecast");
      print(response.body);
      return [
        {'message': 'Error'}
      ];
    }
  }

  static Future<Map> getCurrentWeather(double latitude,
      double longitude) async {
    var url = Uri.parse('$domain/weather?lat=$latitude&lon=$longitude');
    var response = await http.get(url);
    if (kDebugMode) {
      print("current");
      print(response.body);
    }
    if (response.statusCode == 200) {
      Map decoded = jsonDecode(response.body) as Map;
      return decoded;
    } else {
      print("current");
      print(response);
      return {'message': 'Error'};
    }
  }

  static Future<Map> getChatbotResponse(String prompt) async {
    try {
      var url = Uri.parse('$domain/chat_completion');
      var body = json.encode({'prompt': prompt});
      var response = await http.post(
        url,
        body: body,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 360)); // Setting a 30-second timeout
      if (kDebugMode) {
        print('In Network helper');
        print(response.body);
      }
      if (response.statusCode == 200) {
        Map decoded = jsonDecode(response.body) as Map;
        return decoded;
      } else {
        return {'message': 'Error'};
      }
    }
    on Exception catch (e) {
      print(e);
      return {'message': 'Error'};
    }
  }
}