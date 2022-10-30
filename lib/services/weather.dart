import 'dart:convert';

import '../services/networking.dart';
import 'location.dart';
import 'package:http/http.dart' as http;

// const apiKey = 'e031dcd3ad8b42c64dce6e16089389d6';
const apiKey = '9d3fd511637028c667538aec847749eb';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {


  static Future<List<String>> searchCities({required String query}) async {
    final limit = 3;
    final url =
        'https://api.openweathermap.org/geo/1.0/direct?q=$query&limit=$limit&appid=$apiKey';

    final response = await http.get(Uri.parse(url));
    final body = json.decode(response.body);

    return body.map<String>((json) {
      final city = json['name'];
      final country = json['country'];

      return '$city, $country';
    }).toList();
  }


  Future<dynamic> fetchAlbum(String cityName) async {
    // const apiKey = '9a7d3e1b5bf44bf2a500c40f7109ea05';
    final response = await http.get(
        Uri.parse('https://api.ipgeolocation.io/timezone?apiKey=9a7d3e1b5bf44bf2a500c40f7109ea05&location=$cityName'));
    if (response.statusCode == 200) {
      print(jsonDecode(response.body)["date_time_txt"]);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  static Future<dynamic> getCityWeather(String cityName) async {
    NetworkHelper networkHelper = NetworkHelper(
         '$openWeatherMapURL?q=$cityName&appid=$apiKey&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  String getWeatherIcon(icon) {
    if (icon == "01d") {
      return 'assets/conditions/mostly_sunny.png';
    } else if (icon == "01n") {
      return 'assets/conditions/clear.png';
    } else if (icon == "09d" ||
        icon == "09n" ||
        icon == "10d" ||
        icon == "10n") {
      return 'assets/conditions/rain.png';
    } else if (icon == "11d" || icon == "11n") {
      return 'assets/conditions/thunderstorm.png';
    } else if (icon == "03d" || icon == "03n") {
      return 'assets/conditions/mostly_cloudy.png';
    } else if (icon == "13d" || icon == "13n") {
      return 'assets/conditions/rain.png';
    } else if (icon == "50d" || icon == "50n") {
      return 'assets/conditions/rain.png';
    } else {
      return 'assets/conditions/partly_cloudy.png';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
