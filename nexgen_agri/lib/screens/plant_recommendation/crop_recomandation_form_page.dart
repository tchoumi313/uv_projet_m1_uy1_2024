import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './controller/crop_controller.dart';

class CropPredictionScreen extends StatelessWidget {
  final CropController cropController = Get.put(CropController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Prediction', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green, // Example app color
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
                opacity: 0.2,
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildTextFormField('Nitrogen', cropController.nitrogen),
                _buildTextFormField('Phosphorus', cropController.phosphorus),
                _buildTextFormField('Potassium', cropController.potassium),
                _buildTextFormField('pH', cropController.ph, max: 14),
                _buildTextFormField('Humidity (%)', cropController.humidity),
                _buildTextFormField('Rainfall', cropController.rainfall),
                _buildTextFormField(
                    'Temperature (°C)', cropController.temperature),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      cropController.predictCrop();
                    }
                  }, child: Text('Predict'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.green, // Example button color
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, RxDouble controllerValue,
      {double? max}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        style: TextStyle(color: Colors.black45),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black), // Example label color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.green),
          ),
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) => controllerValue.value = double.parse(value),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value';
          }
          final numValue = double.tryParse(value);
          if (numValue == null) {
            return 'Please enter a valid number';
          }
          if (numValue < 0) {
            return 'Please enter a non-negative number';
          }
          if (max != null && numValue > max) {
            return 'Value cannot exceed $max';
          }
          return null;
        },
      ),
    );
  }
}
