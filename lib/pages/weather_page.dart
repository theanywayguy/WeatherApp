// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('uh uh');
  Weather? _weather; // Holds the fetched weather data
  String _selectedCity = 'Mersin'; // Default selected city

  // List of Turkish cities
  final List<String> _cities = [
    'Adana', 'Adıyaman', 'Afyonkarahisar', 'Ağrı', 'Amasya',
    'Ankara', 'Antalya', 'Artvin', 'Aydın', 'Balıkesir',
    'Bilecik', 'Bingöl', 'Bitlis', 'Bolu', 'Burdur',
    'Bursa', 'Çanakkale', 'Çankırı', 'Denizli', 'Diyarbakır',
    'Edirne', 'Elazığ', 'Erzincan', 'Erzurum', 'Eskişehir',
    'Gaziantep', 'Giresun', 'Gümüşhane', 'Hakkari', 'Hatay',
    'Iğdır', 'Isparta', 'İstanbul', 'İzmir', 'Kahramanmaraş',
    'Karabük', 'Kars', 'Kastamonu', 'Kayseri', 'Kırklareli',
    'Kırşehir', 'Kocaeli', 'Konya', 'Kütahya', 'Malatya',
    'Manisa', 'Mardin', 'Mersin', 'Muğla', 'Nevşehir',
    'Niğde', 'Ordu', 'Osmaniye', 'Rize', 'Sakarya',
    'Samsun', 'Siirt', 'Sinop', 'Sivas', 'Tekirdağ',
    'Tokat', 'Trabzon', 'Tunceli', 'Şanlıurfa', 'Uşak',
    'Van', 'Yalova', 'Yozgat', 'Zonguldak'
  ];

  @override
  void initState() {
    super.initState();
    _fetchWeather(_selectedCity); // Fetch weather for the default city on load
  }

  // Method to fetch weather data for the selected city
  _fetchWeather(String cityName) async {
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather; // Update the weather state
      });
    } catch (e) {
      print('Error fetching weather: $e'); // Log error to console
      setState(() {
        _weather = null; // Reset to null in case of error
      });
      // Show a SnackBar to inform the user of the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch weather data. Please try again.')),
      );
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/rain.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50], // Soft light blue background
      appBar: AppBar(
        title: Text('Weather App'),
        backgroundColor: Colors.blueAccent, // Darker blue for AppBar
        leading: Icon(Icons.thermostat),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            // Dropdown menu for selecting a city
            Center(
              child: PopupMenuButton<String>(
                onSelected: (String newValue) {
                  setState(() {
                    _selectedCity = newValue;
                    _fetchWeather(_selectedCity); // Fetch weather for the selected city
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_city, color: Colors.blueAccent),
                      SizedBox(width: 8),
                      Text(
                        _selectedCity,
                        style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (BuildContext context) {
                  return _cities.map((String city) {
                    return PopupMenuItem<String>(
                      value: city,
                      child: Container(
                        height: 40, // Set a height for each item
                        child: Center(
                          child: Text(
                            city,
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            SizedBox(height: 20),

            // Show loading indicator or weather data
            _weather == null
                ? CircularProgressIndicator() // Show loading while fetching
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('City: ${_weather!.cityName}', style: TextStyle(color: Colors.black87, fontSize: 20)),
                Text('Temperature: ${_weather!.temperature.round()} °C', style: TextStyle(color: Colors.black87, fontSize: 20)),
                Text('Condition: ${_weather!.mainCondition}', style: TextStyle(color: Colors.black87, fontSize: 20)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
