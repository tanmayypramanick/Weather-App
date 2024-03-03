import 'package:flutter/material.dart';
import '/views/home_page.dart';
import '/utils/weather_api.dart';

void main() {
  const String apiKey = '621186f96dcfbb295c029d7c43ed6c88';
  WeatherApi weatherApi = WeatherApi(apiKey);

  runApp(MyApp(weatherApi: weatherApi));
}

class MyApp extends StatelessWidget {
  final WeatherApi weatherApi;

  const MyApp({super.key, required this.weatherApi});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(weatherApi: weatherApi),
      debugShowCheckedModeBanner: false,
    );
  }
}
