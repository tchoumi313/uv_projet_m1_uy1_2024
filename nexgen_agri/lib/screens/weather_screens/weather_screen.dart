import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexgen_agri/services/network-helper.dart';

class WeatherScreen extends StatelessWidget {
  final Rx<Map<dynamic, dynamic>> currentWeather =
      Rx<Map<dynamic, dynamic>>({});
  final Rx<List<dynamic>> forecastData = Rx<List<dynamic>>([]);

  WeatherScreen() {
    getCurrentWeather();
    getForecast();
  }

  void getCurrentWeather() async {
    var weatherData = await NetworkHelper.getCurrentWeather(
        3.87, 11.52); // Use actual coordinates
    print("getCurrentWeather");
    print(weatherData);
    if (weatherData != null && weatherData.containsKey('current')) {
      currentWeather.value = weatherData['current'];
    } else {
      print("Error: Current weather data is not available");
    }
  }

  void getForecast() async {
    var forecast = await NetworkHelper.getFourDayForecast(
        3.87, 11.52); // Use actual coordinates
    print("getForecastWeather");
    print(forecast);
    if (forecast is List) {
      forecastData.value = forecast;
    } else {
      print("Error: Forecast data is not in expected format");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: <Widget>[
          Obx(() => currentWeather.value.isEmpty
              ? CircularProgressIndicator()
              : Expanded(
                child: Card(
                    margin: EdgeInsets.all(8.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              'Current Weather: ${currentWeather.value['temp_c']}°C',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text(currentWeather.value['condition']['text'],
                              style: TextStyle(fontSize: 16)),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  'Wind: ${currentWeather.value['wind_kph']} kph'),
                              Text(
                                  'Direction: ${currentWeather.value['wind_dir']}'),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                              'Humidity: ${currentWeather.value['humidity']}%'),
                          Text(
                              'Precipitation: ${currentWeather.value['precip_mm']} mm'),
                          Text(
                              'Visibility: ${currentWeather.value['vis_km']} km'),
                          Text(
                              'Feels like: ${currentWeather.value['feelslike_c']}°C'),
                          Text('UV Index: ${currentWeather.value['uv']}'),
                          Text(
                              'Air Quality: CO: ${currentWeather.value['air_quality']['co']} µg/m³'),
                        ],
                      ),
                    ),
                  ),
              )),
          forecastData.value.isEmpty || forecastData.value.first['message'] == Error || forecastData.value[0]['day'] == null
              ? CircularProgressIndicator()
              : Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: forecastData.value.length,
                  itemBuilder: (context, index) {
                    var dayForecast = forecastData.value[index]['day'];
                    print(dayForecast);
                    return dayForecast != null?
                     Card(
                      child: ListTile(
                        leading: Icon(Icons.wb_sunny),
                        title: Text('Day ${index + 1}'),
                        subtitle: Text(
                            '${dayForecast['avgtemp_c']}°C - ${dayForecast['condition']['text']}'),
                      ),
                    ) :
                    SizedBox();
                  },
                )),
          ),
        ],
      ),
    );
  }
}
