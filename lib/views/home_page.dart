import 'package:flutter/material.dart';
import '/utils/weather_api.dart';
import '/views/weather_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final WeatherApi weatherApi;

  const HomePage({super.key, required this.weatherApi});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController locationController = TextEditingController();
  List<String> favoriteCities = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteCities = prefs.getStringList('favorites') ?? [];
    });
  }

  void _removeCityFromFavorites(String city) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteCities.remove(city);
      prefs.setStringList('favorites', favoriteCities);
    });
  }

  void _searchWeather(String location, {bool fromFavorites = false}) async {
    try {
      final weather =
          await widget.weatherApi.getWeatherFromLocationName(location);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherDetailsPage(weather: weather),
        ),
      );
    } catch (e) {
      if (!fromFavorites) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"$location" city is not available')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Weather', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: 'Search for a city',
                  labelStyle: const TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () =>
                        _searchWeather(locationController.text.trim()),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: favoriteCities.length,
              itemBuilder: (context, index) {
                final city = favoriteCities[index];
                return Dismissible(
                  key: Key(city),
                  onDismissed: (direction) {
                    _removeCityFromFavorites(city);
                  },
                  background: Container(color: Colors.red),
                  child: Card(
                    color: Colors.deepPurple[400],
                    child: ListTile(
                      title: Text(
                        city,
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () => _searchWeather(city, fromFavorites: true),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.deepPurple[700],
    );
  }
}
