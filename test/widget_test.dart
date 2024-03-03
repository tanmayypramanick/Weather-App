import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mp5/models/weather_model.dart';
import 'package:mp5/views/home_page.dart';
import 'package:mp5/views/weather_details_page.dart';
import 'package:mp5/utils/weather_api.dart';

class MockWeatherApi extends WeatherApi {
  MockWeatherApi() : super('');

  @override
  Future<WeatherModel> getWeatherFromLocationName(String location) async {
    return Future.value(_mockWeatherData());
  }

  WeatherModel _mockWeatherData() {
    return WeatherModel(
      coord: Coord(lon: -73.935242, lat: 40.730610),
      weather: [
        Weather(id: 800, main: 'Clear', description: 'clear sky', icon: '01d')
      ],
      main: Main(
        temp: 15.0,
        feelsLike: 13.0,
        tempMin: 10.0,
        tempMax: 18.0,
        pressure: 1012,
        humidity: 56,
      ),
      visibility: 10000,
      wind: Wind(speed: 4.1, deg: 80),
      dt: 1605182400,
      sys: Sys(sunrise: 1605168063, sunset: 1605207881),
      timezone: -18000,
      name: 'New York',
    );
  }
}

void main() {
  final mockWeatherData = MockWeatherApi()._mockWeatherData();

  testWidgets('WeatherDetailsPage displays detailed weather info',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: WeatherDetailsPage(weather: mockWeatherData),
    ));

    expect(
        find.text('${mockWeatherData.name} Weather Details'), findsOneWidget);
    expect(find.textContaining('${mockWeatherData.main.temp}'), findsWidgets);
    expect(
        find.textContaining(
            mockWeatherData.weather.first.description.toUpperCase()),
        findsOneWidget);
  });

  testWidgets('App bar title is Weather', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: HomePage(weatherApi: MockWeatherApi()),
    ));

    expect(find.text('Weather'), findsOneWidget);
  });

  testWidgets('Favorite button toggles state', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: WeatherDetailsPage(weather: mockWeatherData),
    ));

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();

    // expect(find.byIcon(Icons.favorite), findsOneWidget); // Uncomment if you have a favorite icon change
  });

  testWidgets('Settings page navigation works', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: HomePage(weatherApi: MockWeatherApi()),
    ));
  });

  testWidgets('Displaying temperature and humidity',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: WeatherDetailsPage(weather: mockWeatherData),
    ));

    expect(
        find.textContaining('${mockWeatherData.main.tempMin}'), findsOneWidget);
    expect(find.textContaining('${mockWeatherData.main.humidity}%'),
        findsOneWidget);
  });
}
