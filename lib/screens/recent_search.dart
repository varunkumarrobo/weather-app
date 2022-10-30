import 'package:flutter/material.dart';
import 'package:weatherappk/screens/home_screen.dart';
import 'package:weatherappk/screens/loading_screen.dart';
import 'package:weatherappk/screens/network_search.dart';
import 'package:weatherappk/utilities/customs/mycard.dart';

import '../services/weather.dart';

class RecentSearch extends StatefulWidget {
  const RecentSearch({Key? key}) : super(key: key);

  @override
  State<RecentSearch> createState() => _FavouriteState();
}

class _FavouriteState extends State<RecentSearch> {
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
    return Scaffold(
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
        title: const Text("Recent Search",
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
              Navigator.push(context, MaterialPageRoute(builder: (context)=> AutoSearch()));
            },),
        ],
      ),
      body: Stack(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:  [
                    const Center(
                      child: Text('You recently searched for',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 15
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
                            content:   Text('Are you sure want to clear all',
                              style: TextStyle(
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
                      }, child: const Text('Clear All'),
                    ),
                    // ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //       elevation: 0,
                    //       backgroundColor: Colors.transparent,
                    //     ) ,
                    //     onPressed: (){
                    //       showDialog(
                    //         context: context,
                    //         builder: (ctx) => AlertDialog(
                    //           // title: Text('alert dialog box'),
                    //           content:   Text('Are you sure want to remove all the favourites?',style: TextStyle(
                    //             color: Colors.grey.shade700,
                    //           ),),
                    //           actions: <Widget>[
                    //             TextButton(onPressed: (){
                    //               Navigator.pop(context);
                    //             }, child: Container(
                    //               color: Colors.transparent,
                    //               padding: const EdgeInsets.all(14),
                    //               child: const Text('NO',
                    //                 style: TextStyle(
                    //                   color: Colors.purple,
                    //                   fontSize: 15,
                    //                 ),),
                    //             ),),
                    //             const SizedBox(width: 15,),
                    //             TextButton(onPressed: (){
                    //               Navigator.pop(context);
                    //             }, child: Container(
                    //               color: Colors.transparent,
                    //               padding: const EdgeInsets.all(14),
                    //               child: const Text('YES',
                    //                 style: TextStyle(
                    //                   color: Colors.purple,
                    //                   fontSize: 15,
                    //                 ),),
                    //             ),),
                    //           ],
                    //         ),
                    //       );
                    //     }, child: const Text('Remove All'))
                    // TextButton(onPressed: (){
                    //
                    // }, child: const Text('Remove All')),
                  ],
                ),
                Expanded(child: Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 80,right: 80,top: 80,bottom: 30.0),
                        child: Image.asset('assets/logo/icon_nothing.png',),
                      ),
                      // const SizedBox(height: 0,),
                      const Text('No Recent Search',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                      ),)
                    ],
                  ),
                ))
                // SizedBox(height: 4,),
                // Expanded(
                //   child: Container(
                //     margin: const EdgeInsets.only(left: 15,right: 15),
                //     child: ListView.builder(
                //       itemCount: 10,
                //       itemBuilder: (BuildContext context, int index) {
                //         return const MyCard();
                //       },
                //     ),
                //   ),
                // ),
              ],
            )
        ),],
      ),
    );
  }
}
