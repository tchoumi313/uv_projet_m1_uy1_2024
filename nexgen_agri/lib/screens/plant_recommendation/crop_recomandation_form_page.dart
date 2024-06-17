import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexgen_agri/utils/constants.dart';

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
            padding:  EdgeInsets.all(getHeight(20, context)),
            child: Column(
              children: [
                _buildTextFormField(context,'Nitrogen', cropController.nitrogen),
                _buildTextFormField(context,'Phosphorus', cropController.phosphorus),
                _buildTextFormField(context,'Potassium', cropController.potassium),
                _buildTextFormField(context,'pH', cropController.ph, max: 14),
                _buildTextFormField(context,'Humidity (%)', cropController.humidity),
                _buildTextFormField(context,'Rainfall', cropController.rainfall),
                _buildTextFormField(context,
                    'Temperature (°C)', cropController.temperature),
                SizedBox(height: getHeight(20, context)),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      cropController.predictCrop();
                    }
                  }, child: Text('Predict'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.green, // Example button color
                    padding: EdgeInsets.symmetric(horizontal: getWidth(50, context), vertical: getHeight(20, context)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(BuildContext context, String label, RxDouble controllerValue,
      {double? max}) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: getHeight(10, context)),
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
