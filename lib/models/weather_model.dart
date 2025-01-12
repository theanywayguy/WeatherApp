class Weather {
  final String cityName;
  final double temperature; // Ensure this is double
  final String mainCondition;

  Weather({
    required this.cityName,
    required this.temperature, // Ensure this is of type double
    required this.mainCondition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'], // This should be a String
      temperature: json['main']['temp'].toDouble(), // Ensure to convert to double
      mainCondition: json['weather'][0]['main'], // This should be a String
    );
  }
}
