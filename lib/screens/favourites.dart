import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weatherappk/screens/home_screen.dart';
import 'package:weatherappk/screens/loading_screen.dart';
import 'package:weatherappk/utilities/customs/mycard.dart';

import '../services/database.dart';
import '../services/weather.dart';
import 'network_search.dart';

class FavouriteScreens extends StatefulWidget {
  const FavouriteScreens({Key? key}) : super(key: key);

  @override
  State<FavouriteScreens> createState() => _FavouriteState();
}

class _FavouriteState extends State<FavouriteScreens> {

  List<Map<String, dynamic>> favs = [];
  DatabaseManager _manager = DatabaseManager();
  List<String> description = [];
  List<String> temp = [];
  List<String> images = [];
  @override
  fetchFavs(isFav) async {
    WeatherModel weather = WeatherModel();
    favs = [];
    description = [];
    temp = [];
    images = [];
    List<DataModel>? model;
    if(isFav)
      model = await _manager.getFav();
    else
      model = await _manager.getRecent();
    for (var dataModel in model) {
      await WeatherModel.getCityWeather(dataModel.toJson()["cityName"]).then((value) async {
        description.add(jsonDecode(value.body)["weather"][0]["description"]);
        temp.add(jsonDecode(value.body)["main"]["temp"].toString());
        // images.add(ImageUtility.getImage(jsonDecode(value.body)["weather"][0]["icon"]));
      }).onError((error, stackTrace) {
        print(error.toString());
      });
      favs.add(dataModel.toJson());
    }
  }
  // @override
  // Future<void> GetlocationData() async {
  //   WeatherModel weatherModel = WeatherModel();
  //   var weatherData = await weatherModel.getLocationWeather();
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => LocationScreen(
  //           locationWeather: weatherData,
  //         )),
  //   );
  //   //  print(weatherData);
  // }
  //
  // initState() {
  //   GetlocationData();
  // }
  @override
  Widget build(BuildContext context) {
    // bool isFav = ["fav"] as String;
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        // toolbarHeight: 0,
        backgroundColor: Colors.white,
        leading:IconButton(
          onPressed: () {
          // Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoadingScreen()));
        },
        icon: const Icon(Icons.arrow_back),
          color: Colors.black,
         ),
        // backgroundColor: Colors.white,
           title: const Text("Favourite",
           style: TextStyle(
             fontSize: 20,
             letterSpacing: 1,
             color: Colors.black
           ),),
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
            color: Colors.black,
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const AutoSearch()));
            },),
        ],
      ),
      body: FutureBuilder<dynamic>(
        future: fetchFavs(favs),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator(),);
          else if(snapshot.connectionState == ConnectionState.done){
            return Stack(
            children: [ Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background_android.png'),
                fit: BoxFit.fill,
                // colorFilter: ColorFilter.mode(
                //     Colors.white.withOpacity(0.8), BlendMode.dstATop),
              ),
            ),
            constraints: const BoxConstraints.expand(),
            child: Column(
              children: [
                // favs.length != 0
                //     ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:  [
                     const Center(
                      child: Text('10 City added as favourite',
                      style: TextStyle(
                        color: Colors.white,
                      ),),
                    ),
                    const SizedBox(width: 80,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                      ) ,
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              // title: Text('alert dialog box'),
                              content:   Text('Are you sure want to remove all the favourites?',style: TextStyle(
                                color: Colors.grey.shade700,
                              ),),
                              actions: <Widget>[
                                TextButton(onPressed: (){
                                  Navigator.pop(context);
                                }, child: Container(
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.all(14),
                                  child: const Text('NO',
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 15,
                                  ),),
                                ),),
                                const SizedBox(width: 15,),
                                TextButton(onPressed: (){
                                  Navigator.pop(context);
                                }, child: Container(
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.all(14),
                                  child: const Text('YES',
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 15,
                                  ),),
                                ),),
                              ],
                            ),
                          );
                    }, child: const Text('Remove All'),
                    ),
                    // TextButton(onPressed: (){
                    //
                    // }, child: const Text('Remove All')),
                  ],
                ),
                // SizedBox(height: 4,),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 15,right: 15),
                    child: ListView.builder(
                      itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return const MyCard();
                        },
                         ),
                  ),
                ),
              ],
            )
          ),],
        );
          } else return const Text('Error');},
      ),
    );
  }
}
