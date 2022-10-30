

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:get/instance_manager.dart';
// import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:weatherappk/screens/dummy.dart';
import 'package:weatherappk/screens/secocity.dart';
import 'package:weatherappk/utilities/customs/currnet_weather.dart';
// import 'package:clima/utilities/constants.dart';
// import 'package:clima/services/weather.dart';
// import 'package:weatherappk/services/weather.dart';
import '../controller/global_controller.dart';
import '../services/database.dart';
import '../services/suggestion.dart';
import '../services/weather.dart';
import '../utilities/constants.dart';
import '../utilities/customs/drawer.dart';
import '../utilities/customs/header_widget.dart';
import 'city_search_screen.dart';
import 'package:http/http.dart' as http;

import 'network_search.dart';

Future fetchAlbum() async {
  const apiKey = '9a7d3e1b5bf44bf2a500c40f7109ea05';
  final response = await http.get(
      Uri.parse('https://api.ipgeolocation.io/timezone?apiKey=$apiKey&location=Mountain View'));
  if (response.statusCode == 200) {
    print(jsonDecode(response.body)["date_time_txt"]);
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

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
      double temp = weatherData['main']['temp'];
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

  // final _controller = TextEditingController();

  // final GlobalController globalController =
  //     Get.put(GlobalController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background_android.png'),
          fit: BoxFit.fill,
          // colorFilter: ColorFilter.mode(
          //     Colors.white.withOpacity(0.8), BlendMode.dstATop),
        ),
      ),
      constraints: const BoxConstraints.expand(),
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            width: 120,
            child: Image.asset('assets/logo/logo_splash.png'),
          ),
          // automaticallyImplyLeading: true,
            actions:  [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child:
                TextButton(
                  onPressed: () async {
                    // await showSearch(context: context, delegate: AutoSearch());
                    // final Suggestion? result =
                    // final results =
                    // await showSearch(context: context, delegate: AutoSearch());
                    // if (result != null) {
                    //   setState(() {
                    //     _controller.text = result.description;
                    //   });
                    // }
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
          // Obx(() => globalController.checkLoading().isTrue? const Center(
          //   child: CircularProgressIndicator(),
          // ):
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 45,),
                  // Text(MyDay,
                  // style: const TextStyle(
                  //   color: Colors.white24,
                  // ),),
                  FutureBuilder<dynamic>(
                      future: fetchAlbum(),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(child: CircularProgressIndicator());
                        else if (snapshot.connectionState == ConnectionState.done) {
                          return Text('${snapshot.data['date_time_txt']}',
                          style: TextStyle(
                            color: Colors.white54,
                          ),);
                        } else
                          return Text("Error");
                      }),
                  const SizedBox(height: 15,),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:  [
                      Text("${cityName},",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),),
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
                      ?GestureDetector(
                        onTap: () {
                          fav = false;
                          _manager
                              .insertFav(DataModel(
                              cityName: cityName,
                              country: country))
                              .whenComplete(() {
                            print("success");
                          }).onError((error, stackTrace) {
                            print(error.toString());
                          });
                        },
                        child: const Icon(Icons.favorite_outline_rounded,
                        color: Colors.white,),
                        // Image(
                        //   image: AssetImage(
                        //     "images/favourite/icon_favourite.png",
                        //   ),
                        //   width: 40,
                        //   height: 40,
                        // ),
                      )
                      :GestureDetector(
                        child: Icon(Icons.favorite,
                        color: Colors.yellow.shade600,),
                        onTap: (){
                          fav = true;
                          _manager
                              .deleteFav(DataModel(
                              cityName: cityName,
                              country: country))
                              .whenComplete(() {
                            print("success Deletion");
                          }).onError((error, stackTrace) {
                            print(error.toString());
                          });
                        },
                      ),
                      const Text(
                        "Add to favourite",
                        style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
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
                            // color = true;
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
                            // color = false;
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
                              ),),
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
                  ),),
                  // Text(
                  //   "$message in $cityName!",
                  //   textAlign: TextAlign.right,
                  //   style: kMessageTextStyle,
                  // ),
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
                  // color: Colors.white.withOpacity(0.1),
                  margin: const EdgeInsets.only(top: 20),
                  //color: Colors.green,
                  // height: 125,
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    color: Colors.white.withOpacity(0.1),
                    child: Column(
                      // color: Colors.white.withOpacity(0.1),
                      children: [
                        // color: Colors.white.withOpacity(0.1),
                        // const Divider(
                        //   thickness: 1,
                        //   color: Colors.white38,
                        // ),
                        const SizedBox(height: 20,),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Container(
                                // color: Colors.white.withOpacity(0.2),
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
                                    // Text("$mintemprature - $maxtemprature",
                                    //     style: const TextStyle(
                                    //         color: Colors.white, fontSize: 25)),
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
                                        style: TextStyle(
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
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 25)),
                                  ],
                                ),
                              ),
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


