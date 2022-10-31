import 'package:flutter/material.dart';
import 'package:weatherappk/utilities/constants.dart';

import '../services/database.dart';

class CityScreen extends StatefulWidget {
  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  late String cityName;
  late String country;
  DatabaseManager _manager = DatabaseManager();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        title:  TextField(
          style:  const TextStyle(
            color: Colors.black,
          ),
          decoration: kTextFieldInputDecoration,
          onChanged: (value) async {
            cityName = value;
            country = value;
            await _manager
                .insertRecent(DataModel(
                cityName: cityName,
                country: country
            ),)
                .whenComplete(() {
              print("success");
            }).onError((error, stackTrace) {
              print(error.toString());
            });
          },
        ),
        // TextField(),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          iconSize: 30,
        ),
        actions: [
          IconButton(
            onPressed: ()  async {
              Navigator.pop(context, cityName,);

              //setState(() {});
            },
            icon: const Icon(Icons.location_city),
            color: Colors.black,
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}


//body:
// SafeArea(
//   child: Column(
//     children: <Widget>[
//       Align(
//         alignment: Alignment.topLeft,
//         child: TextButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: const Icon(
//             Icons.arrow_back,
//             size: 50.0,
//           ),
//         ),
//       ),
//       Container(
//         padding: const EdgeInsets.all(10.0),
//         child: TextField(
//           style: const TextStyle(
//             color: Colors.black,
//           ),
//           decoration: kTextFieldInputDecoration,
//           onChanged: (value) {
//             cityName = value;
//           },
//         ),
//       ),
//       TextButton(
//         onPressed: () {
//           Navigator.pop(context, cityName);
//         },
//         child: const Text(
//           'Get Weather',
//           style: kButtonTextStyle,
//         ),
//       ),
//     ],
//   ),
// ),


//
// Container(
// decoration: const BoxDecoration(
// image: DecorationImage(
// image: AssetImage('assets/images/background_android.png'),
// fit: BoxFit.cover,
// ),
// ),
// constraints: const BoxConstraints.expand(),
// child: SafeArea(
// child: Column(
// children: <Widget>[
// Align(
// alignment: Alignment.topLeft,
// child: TextButton(
// onPressed: () {
// Navigator.pop(context);
// },
// child: const Icon(
// Icons.arrow_back_ios,
// size: 50.0,
// ),
// ),
// ),
// Container(
// padding: const EdgeInsets.all(10.0),
// child: TextField(
// style: const TextStyle(
// color: Colors.black,
// ),
// decoration: kTextFieldInputDecoration,
// onChanged: (value) {
// cityName = value;
// },
// ),
// ),
// TextButton(
// onPressed: () {
// Navigator.pop(context, cityName);
// },
// child: const Text(
// 'Get Weather',
// style: kButtonTextStyle,
// ),
// ),
// ],
// ),
// ),
// ),