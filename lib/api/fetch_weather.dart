// import 'dart:convert';
// import 'package:weatherappk/models/weather_data.dart';
// import 'package:http/http.dart' as http;
// import '../models/weather_data_current.dart';
// import '../services/weather.dart';
//
// class FetchWeatherAPI{
//   WeatherData? weatherData;
//
//
//   //processing the data from response - to json
//
//   Future<WeatherData?> processData(lat,lon) async {
//     var response = await http.get(Uri.parse(apiURL(lat, lon)));
//     var jsonString = jsonDecode(response.body);
//     weatherData = WeatherData(WeatherDataCurrent.fromJson(jsonString));
//
//     return weatherData!;
//   }
// }
//
// String apiURL(var lat, var lon){
//   String url;
//
//   url =
//       "https://api.openweathermap.org/data/2.5/weather?q=udupi&appid=e031dcd3ad8b42c64dce6e16089389d6";
// return url;
// }