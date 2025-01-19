import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:geolocator/geolocator.dart';
import 'weather_model.dart';
import 'package:weatherapp/weather_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geocoding/geocoding.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('NICE TRY');
  Weather? _weather;
  String _selectedCity = 'Your Location';
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  _fetchWeather(double latitude, double longitude) async {
    try {
      final weather =
          await _weatherService.getWeatherByCoordinates(latitude, longitude);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      String cityName = placemarks.first.locality ?? "Unknown City";
      setState(() {
        _weather = weather;
        _selectedCity = cityName;
      });
    } catch (e) {
      print('Error fetching weather: $e');
      setState(() {
        _weather = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to fetch weather data. Please try again.')),
      );
    }
  }

  _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enable location services.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permission denied.')),
        );
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });

    if (_latitude != null && _longitude != null) {
      _fetchWeather(_latitude!, _longitude!);
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
        return 'assets/clouds.json';
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
      backgroundColor: Color(0xFF1C1C1E),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Weather App', style: GoogleFonts.bebasNeue()),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, color: Colors.white),
            Text(_weather == null ? 'Fetching Weather...' : '$_selectedCity',
                style: GoogleFonts.anton(color: Colors.white, fontSize: 25)),
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            SizedBox(height: 20),
            _weather == null
                ? CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${_weather!.temperature.round()} °C',
                          style: GoogleFonts.anton(
                              color: Colors.white, fontSize: 40)),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
