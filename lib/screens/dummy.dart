// // import 'package:flutter/material.dart';
// //
// // class AutoSearch extends StatefulWidget {
// //   const AutoSearch({Key? key}) : super(key: key);
// //
// //   @override
// //   State<AutoSearch> createState() => _AutoSearchState();
// // }
// //
// // class _AutoSearchState extends State<AutoSearch> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container();
// //   }
// // }
//
//
//
//
//
// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:weatherapp/data_model.dart';
// import 'package:weatherapp/database_service.dart';
// import 'package:weatherapp/padding.dart';
// import 'package:weatherapp/weather_api_service.dart';
//
// import 'ImageUtility.dart';
//
// class Favourite extends StatefulWidget {
//   const Favourite({Key? key}) : super(key: key);
//
//   @override
//   State<Favourite> createState() => _FavouriteState();
// }
//
// class _FavouriteState extends State<Favourite> {
//   List<Map<String, dynamic>> favs = [];
//   DatabaseManager _manager = DatabaseManager();
//   List<String> description = [];
//   List<String> temp = [];
//   List<String> images = [];
//   @override
//   fetchFavs(isFav) async {
//     HttpService service = HttpService();
//     favs = [];
//     description = [];
//     temp = [];
//     images = [];
//     List<DataModel>? model;
//     if(isFav)
//       model = await _manager.getFav();
//     else
//       model = await _manager.getRecent();
//     for (var dataModel in model) {
//       await service.getData(dataModel.toJson()["place"]).then((value) async {
//         description.add(jsonDecode(value.body)["weather"][0]["description"]);
//         temp.add(jsonDecode(value.body)["main"]["temp"].toString());
//         images.add(ImageUtility.getImage(jsonDecode(value.body)["weather"][0]["icon"]));
//       }).onError((error, stackTrace) {
//         print(error.toString());
//       });
//       favs.add(dataModel.toJson());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final argument =
//     ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
//     bool isFav = argument["fav"];
//
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.black, size: 30),
//         title: Text(
//           isFav ? "Favourite":"Recent Search",
//           style: TextStyle(color: Colors.black, fontSize: 25),
//         ),
//         backgroundColor: Colors.white,
//         actions: [
//           InkWell(
//               onTap: () {},
//               child: Icon(
//                 Icons.search,
//                 size: 30,
//               )).all(0, 20, 0, 5),
//         ],
//       ),
//       body: FutureBuilder<dynamic>(
//           future: fetchFavs(isFav),
//           builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting)
//               return Center(child: CircularProgressIndicator());
//             else if (snapshot.connectionState == ConnectionState.done) {
//               return Stack(
//                 children: [
//                   Image.asset(
//                     'assets/background_android.png',
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                     height: double.infinity,
//                   ),
//                   favs.length != 0
//                       ? Positioned(
//                       top: 10,
//                       left: 18,
//                       right: 16,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "${favs.length} City added as favourite",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           TextButton(
//                               onPressed: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return AlertDialog(
//                                       content: Text(isFav?"Are you sure you want to remove all the favourites?":"Are you sure you want to remove all the recent searches?",style: TextStyle(color: Colors.grey.shade600,fontSize: 18),),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () {
//                                             Navigator.pop(context);
//                                           },
//                                           child: Text("NO",style: TextStyle(color: Colors.deepPurple)),),
//                                         TextButton(
//                                             onPressed: () {
//                                               if(isFav)
//                                               {
//                                                 _manager.deleteAllFav().whenComplete(() {
//                                                   print("Success deletion");
//                                                   setState(() {
//                                                     Navigator.pop(context);
//                                                   });
//                                                 }).onError((error, stackTrace) {
//                                                   print(error.toString());
//                                                 });
//                                               }
//                                               else{
//                                                 _manager.deleteAllRecent().whenComplete(() {
//                                                   print("Success deletion");
//                                                   setState(() {
//                                                     Navigator.pop(context);
//                                                   });
//                                                 }).onError((error, stackTrace) {
//                                                   print(error.toString());
//                                                 });
//                                               }
//                                             },
//                                             child: Text("YES",style: TextStyle(color: Colors.deepPurple))),
//                                       ],
//                                     );
//                                   },
//                                 );
//                               },
//                               child: Text(
//                                 "Remove All",
//                                 style: TextStyle(color: Colors.white),
//                               ))
//                         ],
//                       ))
//                       : Center(
//                     child: SizedBox(
//                       height: 130,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Image.asset("assets/fav_nothing.png"),
//                           Text(
//                             isFav?"No Favourites added":"No Recent Search",
//                             style: TextStyle(
//                                 color: Colors.white, fontSize: 20),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                       top: 65,
//                       left: 18,
//                       right: 16,
//                       child: Container(
//                         color: Colors.transparent,
//                         height: 570,
//                         child: ListView.builder(
//                             itemCount: favs.length,
//                             itemBuilder: (BuildContext ctxt, int index) {
//                               return SizedBox(
//                                 height: 100,
//                                 child: Card(
//                                     margin: EdgeInsets.only(bottom: 2),
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.zero),
//                                     color: Color(0xffCCCCFF).withOpacity(0.5),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.spaceAround,
//                                           children: [
//                                             Text(
//                                               "${favs[index]["place"]}, ${favs[index]["region"]}",
//                                               style: TextStyle(
//                                                   color: Colors.yellow,
//                                                   fontSize: 25),
//                                             ),
//                                             SingleChildScrollView(
//                                               scrollDirection: Axis.horizontal,
//                                               child: SizedBox(
//                                                 width: 290,
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                                   children: [
//                                                     Image.asset(
//                                                       images[index],
//                                                       width: 22,
//                                                       height: 25,
//                                                     ),
//                                                     Text(
//                                                       "${temp[index]}°C",
//                                                       style: TextStyle(
//                                                           color: Colors.white,
//                                                           fontSize: 22),
//                                                     ),
//                                                     SizedBox(
//                                                       width: 150,
//                                                       child: Text(
//                                                           "${description[index]}",
//                                                           style: TextStyle(
//                                                               color:
//                                                               Colors.white,
//                                                               fontSize: 18)),
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                         const Icon(
//                                           Icons.favorite_border_sharp,
//                                           color: Colors.yellow,
//                                         )
//                                       ],
//                                     ).all(20, 20, 0, 0)),
//                               );
//                             }),
//                       ))
//                 ],
//               );
//             } else
//               return Text("Error");
//           }),
//     );
//   }
// }
