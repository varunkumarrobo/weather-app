
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database.dart';
import '../services/weather.dart';
import '../utilities/constants.dart';
import '../utilities/customs/drawer.dart';
import 'city_search_screen.dart';
import 'package:http/http.dart' as http;




class LocationScreen extends StatefulWidget {

//Udemy's
  final locationWeather;
  LocationScreen({this.locationWeather});
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
   late Future MyDate;
  // Stream MyDate = Stream.fromFuture(fetchAlbum());
  var MyDay = '';

  //Udemy's
   Future fetchAlbum() async {
     const apiKey = '9a7d3e1b5bf44bf2a500c40f7109ea05';
     final response = await http.get(
         Uri.parse('https://api.ipgeolocation.io/timezone?apiKey=$apiKey&location=$cityName'));
     if (response.statusCode == 200) {
       print(jsonDecode(response.body)["date_time_txt"]);
       return jsonDecode(response.body);
     } else {
       throw Exception('Failed to load album');
     }
   }

   bool fav = false;
   bool c = false;
   bool color = false;
  late String weatherdescription;
  // late int temperature;
  late String weatherIcon;
  late String cityName;
  late String message;
  late int humidity;
  late double feelslike;
  late int visibility;
  late String country;
  late int tempratureinC;
  late double tempratureinF;
  late int mintemprature;
  late int maxtemprature;
  WeatherModel weather = WeatherModel();
  DatabaseManager _manager = DatabaseManager();

  String date = DateFormat('yMMMEd').format(DateTime.now());
  // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);

  //Udemy's

  gethomeweather() async {
    var weatherData = await weather.getLocationWeather();
    updateUI(weatherData);
  }
  @override
  void initState() {
    super.initState();
    gethomeweather();
    updateUI(widget.locationWeather);
    MyDate = fetchAlbum();
    // setState(() {
    //   Timer.periodic(const
    //   Duration(seconds: 30),
    //           (timer) {MyDate = Stream.fromFuture(fetchAlbum());});
    // });
  }
  //
  void updateUI(dynamic weatherData) {
    print(weatherData);
    setState(() {
      if (weatherData == null) {
        tempratureinC = 0;
        weatherIcon = 'Error';
        weatherdescription = 'unable to get weather data';
        message = 'Unable to get weather data';
        cityName = '';
        return;
      }
      double temp = double.parse(weatherData['main']['temp'].toString());
      tempratureinC = temp.toInt();
       double feels = weatherData['main']['feels_like'];
      feelslike = feels.toDouble();
      tempratureinF = (tempratureinC * 1.80000) + 32;
      String icon = weatherData['weather'][0]['icon'];
      weatherdescription = weatherData['weather'][0]['description'];
      weatherIcon = weather.getWeatherIcon(icon);
      message = weather.getMessage(tempratureinC);
      cityName = weatherData['name'];
      double mintemp = weatherData['main']['temp_min'];
      double maxtemp = weatherData['main']['temp_max'];
      mintemprature = mintemp.toInt();
      maxtemprature = maxtemp.toInt();
      humidity = weatherData['main']['humidity'];
      visibility = weatherData['visibility'];
      country = weatherData['sys']['country'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background_android.png'),
          fit: BoxFit.fill,
        ),
      ),
      constraints: const BoxConstraints.expand(),
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            width: 120,
            child: Image.asset('assets/logo/logo_splash.png'),
          ),
            actions:  [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child:
                TextButton(
                  onPressed: () async {
                    var typedName = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CityScreen();
                        },
                      ),
                    );
                    if (typedName != null) {
                      var weatherData =
                      await WeatherModel.getCityWeather(typedName);
                      updateUI(weatherData);
                    }
                  },

                  child: const Icon(
                    Icons.search,
                    size: 30.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        drawer: const CustomWidget(),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 45,),
                  FutureBuilder<dynamic>(
                      future: fetchAlbum(),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(child: CircularProgressIndicator());
                        else if (snapshot.connectionState == ConnectionState.done) {
                          return Text('${snapshot.data['date_time_txt']}',
                          style: const TextStyle(
                            color: Colors.white54,
                          ),);
                        } else
                          return Text("Error");
                      }),
                  const SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:  [
                      Text("${cityName},",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      ),
                      Text(country,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      fav
                      ?
                      GestureDetector(
                        child: Icon(Icons.favorite,
                          color: Colors.yellow.shade600,),
                        onTap: () async {
                          fav = false;
                          await  _manager
                              .deleteFav(DataModel(
                              cityName: cityName,
                              country: country))
                              .whenComplete(() {
                            print("success Deletion");
                          }).onError((error, stackTrace) {
                            print(error.toString());
                          });
                          setState(() {});
                        },
                      )
                      :GestureDetector(
                        onTap: () async {
                          fav = true;
                          await _manager
                              .insertFav(DataModel(
                              cityName: cityName,
                              country: country))
                              .whenComplete(() {
                            print("success");
                          }).onError((error, stackTrace) {
                            print(error.toString());
                          });
                          setState(() {});
                        },
                        child: const Icon(Icons.favorite_outline_rounded,
                          color: Colors.white,),
                      ),
                      // GestureDetector(
                      //                         onTap: () async {
                      //                           fav = false;
                      //                           await _manager
                      //                               .insertFav(DataModel(
                      //                               cityName: cityName,
                      //                               country: country))
                      //                               .whenComplete(() {
                      //                             print("success");
                      //                           }).onError((error, stackTrace) {
                      //                             print(error.toString());
                      //                           });
                      //                           setState(() {});
                      //                         },
                      //                         child: const Icon(Icons.favorite_outline_rounded,
                      //                         color: Colors.white,),
                      //                         // Image(
                      //                         //   image: AssetImage(
                      //                         //     "images/favourite/icon_favourite.png",
                      //                         //   ),
                      //                         //   width: 40,
                      //                         //   height: 40,
                      //                         // ),
                      //                       )
                      //GestureDetector(
                      //                         child: Icon(Icons.favorite,
                      //                         color: Colors.yellow.shade600,),
                      //                         onTap: () async {
                      //                           fav = true;
                      //                          await  _manager
                      //                               .deleteFav(DataModel(
                      //                               cityName: cityName,
                      //                               country: country))
                      //                               .whenComplete(() {
                      //                             print("success Deletion");
                      //                           }).onError((error, stackTrace) {
                      //                             print(error.toString());
                      //                           });
                      //                          setState(() {});
                      //                         },
                      //                       )
                      fav ? TextButton(
                        onPressed: (){
                          fav = true;
                        },
                        child: const Text(
                          "Remove from favourites",
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ):TextButton(
                        onPressed: (){
                          fav = false;
                        },
                        child: const Text(
                          "Add to favourite",
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 120,),
                  Image.asset(weatherIcon),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        c ? '$tempratureinC': tempratureinF.toStringAsFixed(2),
                        style: kTempTextStyle,
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            c = true;
                          });
                        },
                        child: Container(
                          decoration: c
                              ?kcontainercolortapped
                          :kcontainercolor,
                          height: 25,
                          width: 25,
                          child: const Center(
                            child: Text("C°",
                            style: TextStyle(
                              color: Colors.redAccent,
                              textBaseline: TextBaseline.alphabetic,
                            ),),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            c = false;
                          });
                        },
                        child: Container(
                          decoration: c
                              ?kcontainercolor
                          :kcontainercolortapped,
                          height: 25,
                          width: 25,
                          child: const Center(
                            child: Text("F°",
                              style: TextStyle(
                                color: Colors.redAccent,
                                textBaseline: TextBaseline.alphabetic,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Text('$weatherdescription',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.white38,
                        ),
                      )
                  ),
                  margin: const EdgeInsets.only(top: 20),
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    color: Colors.white.withOpacity(0.1),
                    child: Column(
                      children: [
                        const SizedBox(height: 20,),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                width: 20,
                                height: 35,
                                child: Image.asset(
                                  "assets/fav/temperature.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  children:    [
                                    const Text("Min - Max",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18)),
                                    Text("${mintemprature.toString()} - ${maxtemprature.toString()}",
                                      style: const TextStyle(
                                        color: Colors.white,fontSize: 25,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                width: 30,
                                height: 25,
                                child: Image.asset(
                                  "assets/fav/visibility.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  children:  [
                                    const Text("Visibility",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18)),
                                    Text("${visibility.toString()}",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 25)),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                width: 25,
                                height: 30,
                                child: Image.asset(
                                  "assets/fav/humidity.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  children:   [
                                    const Text("Humidity",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18)),
                                    Text("${humidity.toString()} %",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 25)),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                width: 25,
                                height: 30,
                                child: Image.asset(
                                  "assets/logo/temperature-feels-like.png",
                                  color: Colors.white,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  children:   [
                                    const Text("Feels Like",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18)),
                                    Text("${feelslike.toString()} °C",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 25)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      //),
    );
  }
}

// TextButton(
//   onPressed: () async {
//     var weatherData = await weather.getLocationWeather();
//     updateUI(weatherData);
//   },
//   child: Text("${cityName},",
//   style: const TextStyle(
//     color: Colors.white,
//   ),),
//   // HeaderWidget(),
// ),


// Text("$mintemprature - $maxtemprature",
//     style: const TextStyle(
//         color: Colors.white, fontSize: 25)),

// Container(
//   margin: const EdgeInsets.only(left: 20),
//   width: 25,
//   height: 30,
//   child: Image.asset(
//     "assets/fav/humidity.png",
//     fit: BoxFit.fill,
//   ),
// ),
// Padding(
//   padding: const EdgeInsets.only(left: 20, right: 20),
//   child: Column(
//     children: const [
//       Text("Humidity",
//           style: TextStyle(
//               color: Colors.white, fontSize: 18)),
//       Text("47%",
//           style: TextStyle(
//               color: Colors.white, fontSize: 25)),
//     ],
//   ),
// ),

// FutureBuilder(
//   future: fetchAlbum(),
//   builder: (context, snapshot) {
//     print("${snapshot.data['date_time_txt'].toString()}......");
//     return Text('${snapshot.data['date_time_txt']}');
//   },),
// StreamBuilder(
//   stream: MyDate,
//     builder: (context,snapshot){
//     return Text(snapshot.data['date_time_txt']);
//     },),

// ListView(
// scrollDirection: Axis.vertical,
// children:  [
// TextButton(
// onPressed: () async {
// var weatherData = await weather.getLocationWeather();
// updateUI(weatherData);
// },
// child:  HeaderWidget(),
// // const Icon(
// //   Icons.near_me,
// //   size: 50.0,
// // ),
// ),
// Center(
// child: Text(
// '$temperature°',
// style: kTempTextStyle,
// ),
// ),
// //for our currnet temp
// // CurrentWeather(
// //   weatherDataCurrent:
// //   globalController.getData().getCurrentWeather(),
// // ),
// ],
// ),

// HeaderWidget(),
// Text(
// '$temperature°',
// style: kTempTextStyle,
// ),


// Udemy's
// Column(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// crossAxisAlignment: CrossAxisAlignment.stretch,
// children: <Widget>[
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: <Widget>[
// TextButton(
// onPressed: () async {
// var weatherData = await weather.getLocationWeather();
// updateUI(weatherData);
// },
// child: const Icon(
// Icons.near_me,
// size: 50.0,
// color: Colors.white,
// ),
// ),
// ],
// ),
// Padding(
// padding: const EdgeInsets.only(left: 15.0,right: 5),
// child: Row(
// children: <Widget>[
// Text('',
// // '$temperature°',
// style: kTempTextStyle,
// ),
// Text('',
// // weatherIcon,
// style: kConditionTextStyle,
// ),
// ],
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(right: 15.0),
// child: Text('',
// // '$weatherMessage in $cityName',
// textAlign: TextAlign.right,
// style: kMessageTextStyle,
// ),
// ),
// ],
// ),


// TextButton(
//   onPressed: () async {
//     var typedName = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) {
//           return CityScreen();
//         },
//       ),
//     );
//     if (typedName != null) {
//       var weatherData =
//       await weather.getCityWeather(typedName);
//       updateUI(weatherData);
//     }
//   },
//   child: const Icon(
//     Icons.location_city,
//     size: 50.0,
//     color: Colors.white,
//   ),
// ),


