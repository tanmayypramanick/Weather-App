class WeatherModel {
  final Coord coord;
  final List<Weather> weather;
  final Main main;
  final int visibility;
  final Wind wind;
  final int dt;
  final Sys sys;
  final int timezone;
  final String name;

  WeatherModel({
    required this.coord,
    required this.weather,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.dt,
    required this.sys,
    required this.timezone,
    required this.name,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      coord: json['coord'] != null
          ? Coord.fromJson(json['coord'])
          : Coord(lat: null, lon: null),
      weather: json['weather'] != null
          ? (json['weather'] as List)
              .map((weather) => Weather.fromJson(weather))
              .toList()
          : [],
      main: json['main'] != null
          ? Main.fromJson(json['main'])
          : Main(
              temp: 0,
              feelsLike: 0,
              tempMin: 0,
              tempMax: 0,
              pressure: 0,
              humidity: 0),
      visibility: int.tryParse(json['visibility'].toString()) ?? 0,
      wind: json['wind'] != null
          ? Wind.fromJson(json['wind'])
          : Wind(speed: 0, deg: 0),
      dt: int.tryParse(json['dt'].toString()) ?? 0,
      sys: json['sys'] != null
          ? Sys.fromJson(json['sys'])
          : Sys(sunrise: 0, sunset: 0),
      timezone: int.tryParse(json['timezone'].toString()) ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class Coord {
  double? lat;
  double? lon;

  Coord({this.lat, this.lon});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lat: json['lat'] is num ? json['lat'].toDouble() : null,
      lon: json['lon'] is num ? json['lon'].toDouble() : null,
    );
  }
}

class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json['id'],
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }
}

class Main {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: (json['temp'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (json['feels_like'] as num?)?.toDouble() ?? 0.0,
      tempMin: (json['temp_min'] as num?)?.toDouble() ?? 0.0,
      tempMax: (json['temp_max'] as num?)?.toDouble() ?? 0.0,
      pressure: int.tryParse(json['pressure'].toString()) ?? 0,
      humidity: int.tryParse(json['humidity'].toString()) ?? 0,
    );
  }
}

class Wind {
  final double speed;
  final int deg;

  Wind({
    required this.speed,
    required this.deg,
  });

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: (json['speed'] as num?)?.toDouble() ?? 0.0,
      deg: int.tryParse(json['deg'].toString()) ?? 0,
    );
  }
}

class Sys {
  final int sunrise;
  final int sunset;

  Sys({
    required this.sunrise,
    required this.sunset,
  });

  factory Sys.fromJson(Map<String, dynamic> json) {
    return Sys(
      sunrise: int.tryParse(json['sunrise'].toString()) ?? 0,
      sunset: int.tryParse(json['sunset'].toString()) ?? 0,
    );
  }
}
