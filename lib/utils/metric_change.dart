import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final bool isMetric;

  const SettingsPage({super.key, required this.isMetric});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String temperatureUnit;
  late String windSpeedUnit;

  @override
  void initState() {
    super.initState();
    temperatureUnit = widget.isMetric ? '°C' : '°F';
    windSpeedUnit = widget.isMetric ? 'm/s' : 'km/h';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              ListTile(
                title: const Text('Temperature Unit'),
                trailing: DropdownButton<String>(
                  value: temperatureUnit,
                  items: <String>['°C', '°F'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      temperatureUnit = newValue!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Wind Speed Unit'),
                trailing: DropdownButton<String>(
                  value: windSpeedUnit,
                  items:
                      <String>['m/s', 'km/h', 'miles/hr'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      windSpeedUnit = newValue!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  Navigator.pop(context, temperatureUnit == '°C');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
