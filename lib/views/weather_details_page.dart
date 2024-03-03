import 'package:flutter/material.dart';
import '/models/weather_model.dart';
import '/utils/metric_change.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherDetailsPage extends StatefulWidget {
  final WeatherModel weather;

  const WeatherDetailsPage({super.key, required this.weather});

  @override
  _WeatherDetailsPageState createState() => _WeatherDetailsPageState();
}

class _WeatherDetailsPageState extends State<WeatherDetailsPage> {
  bool isMetric = true;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  void _checkIfFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      _isFavorite = favorites.contains(widget.weather.name);
    });
  }

  void _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    if (_isFavorite) {
      favorites.remove(widget.weather.name);
    } else {
      if (favorites.length >= 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maximum of 5 favorites allowed.')),
        );
        return;
      }
      favorites.add(widget.weather.name);
    }

    await prefs.setStringList('favorites', favorites);
    setState(() {
      _isFavorite = !favorites.contains(widget.weather.name);
    });

    Navigator.of(context).popAndPushNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    double convertTemperature(double temp) =>
        isMetric ? temp : (temp * 9 / 5) + 32;
    double convertSpeed(double speed) => isMetric ? speed : speed * 2.237;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.weather.name} Weather Details',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingsPage(isMetric: isMetric)),
              );
              if (result != null) {
                setState(() {
                  isMetric = result;
                });
              }
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple, Colors.indigo],
          ),
        ),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    '${convertTemperature(widget.weather.main.temp).toStringAsFixed(1)}${isMetric ? '°C' : '°F'}',
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.weather.weather.first.description.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    'H:${convertTemperature(widget.weather.main.tempMax).toStringAsFixed(1)}${isMetric ? '°C' : '°F'} L:${convertTemperature(widget.weather.main.tempMin).toStringAsFixed(1)}${isMetric ? '°C' : '°F'}',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white70,
                    ),
                  ),
                  _weatherAttributeRow(
                    '🌡️ Feels like',
                    '${convertTemperature(widget.weather.main.feelsLike).toStringAsFixed(1)}${isMetric ? '°C' : '°F'}',
                    fontSize: 20,
                  ),
                  _weatherAttributeRow(
                    '💧 Humidity',
                    '${widget.weather.main.humidity}%',
                    fontSize: 20,
                  ),
                  _weatherAttributeRow(
                    '🔽 Pressure',
                    '${widget.weather.main.pressure} hPa',
                    fontSize: 20,
                  ),
                  _weatherAttributeRow(
                    '💨 Wind Speed',
                    '${convertSpeed(widget.weather.wind.speed).toStringAsFixed(1)} ${isMetric ? 'm/s' : 'mph'}',
                    fontSize: 20,
                  ),
                  _weatherAttributeRow(
                    '🌅 Sunrise',
                    _formatTime(
                        widget.weather.sys.sunrise, widget.weather.timezone),
                    fontSize: 20,
                  ),
                  _weatherAttributeRow(
                    '🌛 Sunset',
                    _formatTime(
                        widget.weather.sys.sunset, widget.weather.timezone),
                    fontSize: 20,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: _buildFavoriteButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _weatherAttributeRow(String attribute, String value,
      {double fontSize = 16}) {
    return ListTile(
      title: Text(attribute,
          style: TextStyle(color: Colors.white70, fontSize: fontSize)),
      trailing: Text(value,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize)),
    );
  }

  String _formatTime(int timestamp, int timezoneOffset) {
    DateTime time =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
    time = time.add(Duration(seconds: timezoneOffset));
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  FloatingActionButton _buildFavoriteButton() {
    return FloatingActionButton(
      onPressed: _toggleFavorite,
      backgroundColor: Colors.white,
      child: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
      ),
    );
  }
}
