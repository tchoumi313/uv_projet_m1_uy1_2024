import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './controller/crop_controller.dart';

class CropPredictionScreen extends StatelessWidget {
  final CropController cropController = Get.put(CropController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crop Prediction')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nitrogen'),
                keyboardType: TextInputType.number,
                onChanged: (value) => cropController.nitrogen.value = double.parse(value),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phosphorus'),
                keyboardType: TextInputType.number,
                onChanged: (value) => cropController.phosphorus.value = double.parse(value),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Potassium'),
                keyboardType: TextInputType.number,
                onChanged: (value) => cropController.potassium.value = double.parse(value),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'pH'),
                keyboardType: TextInputType.number,
                onChanged: (value) => cropController.ph.value = double.parse(value),
              ),TextFormField(
                decoration: InputDecoration(labelText: 'Humidity'),
                keyboardType: TextInputType.number,
                onChanged: (value) => cropController.humidity.value = double.parse(value),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Rainfall'),
                keyboardType: TextInputType.number,
                onChanged: (value) => cropController.rainfall.value = double.parse(value),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Temperature'),
                keyboardType: TextInputType.number,
                onChanged: (value) => cropController.temperature.value = double.parse(value),
              ),
              ElevatedButton(
                onPressed: () => cropController.predictCrop(),
                child: Text('Predict'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}