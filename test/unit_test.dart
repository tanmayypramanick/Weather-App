import 'package:flutter_test/flutter_test.dart';
import 'package:mp5/models/weather_model.dart';

void main() {
  group('WeatherModel Tests', () {
    test('WeatherModel correctly parses valid JSON', () {
      var mockJson = <String, dynamic>{
        "coord": {"lon": 139, "lat": 35},
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01d"
          }
        ],
        "main": {
          "temp": 30.0,
          "feels_like": 32.0,
          "temp_min": 28.0,
          "temp_max": 32.0,
          "pressure": 1013,
          "humidity": 65
        },
        "visibility": 10000,
        "wind": {"speed": 3.6, "deg": 210},
        "dt": 1600000000,
        "sys": {"sunrise": 1600000000, "sunset": 1600040000},
        "timezone": 32400,
        "name": "Shuzenji"
      };

      WeatherModel model = WeatherModel.fromJson(mockJson);
      expect(model.coord.lon, 139);
      expect(model.coord.lat, 35);
      expect(model.weather.first.main, "Clear");
      expect(model.main.temp, 30.0);
      expect(model.wind.speed, 3.6);
      expect(model.sys.sunrise, 1600000000);
      expect(model.name, "Shuzenji");
    });

    test('WeatherModel handles empty JSON', () {
      var emptyJson = <String, dynamic>{};

      WeatherModel model = WeatherModel.fromJson(emptyJson);
      expect(model.coord, isNotNull);
      expect(model.weather, isEmpty);
      expect(model.main, isNotNull);
      expect(model.wind, isNotNull);
      expect(model.sys, isNotNull);
      expect(model.name, isEmpty);
    });

    test('WeatherModel handles null values in JSON', () {
      var nullJson = <String, dynamic>{
        "coord": null,
        "weather": null,
        "main": null,
        "wind": null,
        "sys": null,
        "name": null
      };

      WeatherModel model = WeatherModel.fromJson(nullJson);
      expect(model.coord, isNotNull);
      expect(model.weather, isEmpty);
      expect(model.main, isNotNull);
      expect(model.wind, isNotNull);
      expect(model.sys, isNotNull);
      expect(model.name, isEmpty);
    });

    test('WeatherModel parses specific weather description', () {
      var mockJson = <String, dynamic>{
        "coord": {"lon": 139, "lat": 35},
        "weather": [
          {
            "id": 800,
            "main": "Clear",
            "description": "clear sky",
            "icon": "01d"
          }
        ],
      };
      WeatherModel model = WeatherModel.fromJson(mockJson);
      expect(model.weather.first.description, "clear sky");
    });
    test('WeatherModel handles incorrect data types in JSON', () {
      var incorrectJson = <String, dynamic>{
        "coord": "incorrect",
        "weather": "incorrect",
        "main": "incorrect",
        "wind": "incorrect",
        "sys": "incorrect",
        "name": 12345
      };

      expect(() => WeatherModel.fromJson(incorrectJson),
          throwsA(isA<TypeError>()));
    });
  });
}
