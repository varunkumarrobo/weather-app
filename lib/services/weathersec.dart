// import 'dart:convert';
// import 'dart:core';
// import 'package:flutter/widgets.dart';
// import 'package:http/http.dart' as http;
// import 'package:meta/meta.dart';
// // import 'package:search_appbar_example/api/weather_icons.dart';
// // import 'package:search_appbar_example/model/weather.dart';
//
// class WeatherApi {
//   static const apiKey = 'e031dcd3ad8b42c64dce6e16089389d6';
//       // 'aadf00cb2fedf3a1b8dbe762a5c4bed0';
//
//   static Future<List<String>> searchCities({required String query}) async {
//     final limit = 3;
//     final url =
//         'https://api.openweathermap.org/geo/1.0/direct?q=$query&limit=$limit&appid=$apiKey';
//
//     final response = await http.get(Uri.parse(url));
//     final body = json.decode(response.body);
//
//     return body.map((json) {
//       final city = json['name'];
//       final country = json['country'];
//
//       return '$city, $country';
//     }).toList();
//   }
//
//   /// Weather Api: https://openweathermap.org/current
//   static Future<Weather> getWeather({required String city}) async {
//     final url =
//         'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey';
//
//     final response = await http.get(Uri.parse(url));
//     final body = json.decode(response.body);
//
//     return _convert(body);
//   }
//
//   /// All Weather Conditions: https://openweathermap.org/weather-conditions
//   static Weather _convert(json) {
//     final main = json['weather'].first['main'];
//     final city = json['name'];
//     final int degrees = (json['main']['temp']).toInt();
//
//     print('main: $main');
//
//     if (main == 'Thunderstorm') {
//       return Weather(
//         city: city,
//         degrees: degrees,
//         description: 'Yikes, looks like a storm\'s brewing!',
//         icon: WeatherIcons.thunderstorm,
//       );
//     } else if (main == 'Drizzle') {
//       return Weather(
//         city: city,
//         degrees: degrees,
//         description: 'Yikes, looks like rain.',
//         icon: WeatherIcons.drizzle,
//       );
//     } else if (main == 'Rain') {
//       return Weather(
//         city: city,
//         degrees: degrees,
//         description: 'Looks like more rain.',
//         icon: WeatherIcons.rain,
//       );
//     } else if (main == 'Snow') {
//       return Weather(
//         city: city,
//         degrees: degrees,
//         description: 'Wrap up, it\'s going to snow!',
//         icon: WeatherIcons.snow,
//       );
//     } else if (main == 'Clear') {
//       return Weather(
//         city: city,
//         degrees: degrees,
//         description: 'Yay, sunshine!',
//         icon: WeatherIcons.clear,
//       );
//     } else if (main == 'Clouds') {
//       return Weather(
//         city: city,
//         degrees: degrees,
//         description: 'Looks like scattered clouds today.',
//         icon: WeatherIcons.clouds,
//       );
//     } else {
//       return Weather(
//         city: city,
//         degrees: degrees,
//         description: 'Oops, I couldn\'t find the weather for $city',
//         icon: WeatherIcons.none,
//       );
//     }
//   }
// }
//
//
// class Weather {
//   final String city;
//   final int degrees;
//   final String description;
//   final IconData icon;
//
//   const Weather({
//     required this.city,
//     required this.degrees,
//     required this.description,
//     required this.icon,
//   });
// }
//
//
// class WeatherIcons {
//   WeatherIcons._();
//
//   static const _kFontFam = 'WeatherIcons';
//   static const _kFontPkg = null;
//
//   static const IconData thunderstorm =
//   IconData(0xF033, fontFamily: _kFontFam, fontPackage: _kFontPkg);
//   static const IconData drizzle =
//   IconData(0xF037, fontFamily: _kFontFam, fontPackage: _kFontPkg);
//   static const IconData rain =
//   IconData(0xF036, fontFamily: _kFontFam, fontPackage: _kFontPkg);
//   static const IconData snow =
//   IconData(0xF038, fontFamily: _kFontFam, fontPackage: _kFontPkg);
//   static const IconData clear =
//   IconData(0xF00D, fontFamily: _kFontFam, fontPackage: _kFontPkg);
//   static const IconData clouds =
//   IconData(0xF013, fontFamily: _kFontFam, fontPackage: _kFontPkg);
//   static const IconData none =
//   IconData(0xF03E, fontFamily: _kFontFam, fontPackage: _kFontPkg);
// }
