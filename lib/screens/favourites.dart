import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weatherappk/screens/home_screen.dart';
import 'package:weatherappk/screens/loading_screen.dart';
import 'package:weatherappk/utilities/customs/mycard.dart';
import '../services/database.dart';
import '../services/weather.dart';
import 'city_search_screen.dart';
import 'network_search.dart';

class FavouriteScreens extends StatefulWidget {
  const FavouriteScreens({Key? key}) : super(key: key);

  @override
  State<FavouriteScreens> createState() => _FavouriteState();
}

class _FavouriteState extends State<FavouriteScreens> {
  bool fav = false;
  List<Map<String, dynamic>> favs = [];
  DatabaseManager _manager = DatabaseManager();
  List<String> weatherdescription = [];
  List<String> temp = [];
  List<String> images = [];
  @override
  fetchFavs() async {
    WeatherModel weather = WeatherModel();
    favs = [];
    weatherdescription = [];
    temp = [];
    images = [];
    List<DataModel>? model;
    // if(isFav)
      model = await _manager.getFav();
    // else
    //   model = await _manager.getRecent();
    for (var dataModel in model) {
      await WeatherModel.getCityWeather(dataModel.toJson()["cityName"]).then((value) async {
        weatherdescription.add(jsonDecode(value.body)["weather"][0]["description"]);
        temp.add(jsonDecode(value.body)["main"]["temp"].toString());
        // images.add(ImageUtility.getImage(jsonDecode(value.body)["weather"][0]["icon"]));
      }).onError((error, stackTrace) {
        print(error.toString());
      });
      favs.add(dataModel.toJson());
      print(favs);
    }
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.black,
    //   ),
    // );
    // bool isFav = ["fav"] as String;
    return Scaffold(
      appBar: AppBar(
        // systemOverlayStyle: const SystemUiOverlayStyle(
        //   statusBarColor: Colors.black,
        // ),
        backgroundColor: Colors.white,
        leading:IconButton(
          onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoadingScreen()));
        },
        icon: const Icon(Icons.arrow_back),
          color: Colors.black,
         ),
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
                  MaterialPageRoute(builder: (context) =>  CityScreen()));
            },),
        ],
      ),
      body: FutureBuilder<dynamic>(
        future: fetchFavs(),
        builder: (BuildContext context,
            AsyncSnapshot<dynamic> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator(),);
          else if(snapshot.connectionState == ConnectionState.done){
            return Stack(
            children: [
              Container(
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
                       Center(
                      child: Text('${favs.length} City added as favourite',
                      style: const TextStyle(
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
                                TextButton(onPressed: ()  {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const FavouriteScreens()));
                                  // Navigator.pop(context);
                                   _manager.deleteAllFav().whenComplete(() {
                                    print("Success deletion");
                                    setState(() {
                                      Navigator.pop(context);
                                    });
                                  }).onError((error, stackTrace) {
                                    print(error.toString());
                                  });
                                  // setState(() {});
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
                  ],
                ),
                // SizedBox(height: 4,),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    // color: Colors.white.withOpacity(0.1),
                    margin: const EdgeInsets.only(left: 15,right: 15),
                    child: ListView.builder(
                      itemCount: favs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                              height: 100,
                              child: Card(
                                  margin: const EdgeInsets.only(bottom: 2),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero),
                                  color: Colors.white24,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 30,top: 5),
                                            child: Text('${favs[index]["cityName"].toString()},${favs[index]['country'].toString()}',
                                              // "${favs[index]["cityName"]}, ${favs[index]["country"]}",
                                              style: const TextStyle(
                                                  color: Colors.yellow,
                                                  fontSize: 25),
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: SizedBox(
                                              width: 290,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceAround,
                                                children:  [
                                                  Image.asset(
                                                    'assets/conditions/mostly_sunny.png',
                                                    // images[index],
                                                    width: 22,
                                                    height: 25,
                                                  ),
                                                  Text(
                                                    // 'hi',
                                                    "${temp}°C",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 22),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: Text(
                                                        // 'hi',
                                                        "${weatherdescription}",
                                                        style: const TextStyle(
                                                            color:
                                                            Colors.white,
                                                            fontSize: 18)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      fav
                                          ?
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          child: Icon(Icons.favorite,
                                            color: Colors.yellow.shade600,),
                                          onTap: () async {
                                            fav = false;
                                            await  _manager
                                                .deleteFav(DataModel(
                                                cityName: favs[index]['cityName'],
                                                country: favs[index]['country']))
                                                .whenComplete(() {
                                              print("success Deletion");
                                            }).onError((error, stackTrace) {
                                              print(error.toString());
                                            });
                                            setState(() {});
                                          },
                                        ),
                                      )
                                          :Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                            onTap: () async {
                                            fav = true;
                                            await _manager
                                                .insertFav(DataModel(
                                                cityName: favs[index]['cityName'],
                                                country: favs[index]['country']))
                                                .whenComplete(() {
                                              print("success");
                                            }).onError((error, stackTrace) {
                                              print(error.toString());
                                            });
                                            setState(() {});
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
                                      ),
                                          ),
                                    ],
                                  ),
                              ),
                          );
                            // const MyCard();
                        },
                         ),
                  ),
                ),
              ],
            )
          ),
            ],
        );
          } else return const Text('Error');},
      ),
    );
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
