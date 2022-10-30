//
//


import 'package:flutter/material.dart';
import 'package:weatherappk/screens/favourites.dart';

import '../utilities/constants.dart';

class AutoSearch extends StatefulWidget {
  const AutoSearch({Key? key}) : super(key: key);

  @override
  State<AutoSearch> createState() => _AutoSearchState();
}

class _AutoSearchState extends State<AutoSearch> {
  late String cityName;

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
          onChanged: (value) {
            cityName = value;
          },
        ),
        // TextField(),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const FavouriteScreens()));
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          iconSize: 30,
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.pop(context, cityName);
            },
            icon: const Icon(Icons.clear),
            color: Colors.black,
          ),
        ],
      ),
      backgroundColor: Colors.white,
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
    );
}




// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:weatherappk/screens/home_screen.dart';
// import 'package:weatherappk/services/weathersec.dart';
//
// class AutoSearch extends SearchDelegate<String> {
//   final cities = [
//     'Berlin',
//     'Paris',
//     'Munich',
//     'Hamburg',
//     'London',
//   ];
//
//   final recentCities = [
//     'Berlin',
//     'Munich',
//     'London',
//   ];
//
//   @override
//   List<Widget> buildActions(BuildContext context) =>
//       [
//         IconButton(onPressed: () {
//           // if(query.isEmpty){
//           //   close(context, null.toString());
//           // }else {
//           //   query = '';
//           //   showSuggestions(context);
//           // }
//         },
//             icon: const Icon(Icons.clear))
//       ];
//
//   @override
//   Widget buildLeading(BuildContext context) =>
//       IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back));
//
//   @override
//   Widget buildResults(BuildContext context) => Container();
//
//   // @override
//   // Widget buildSuggestions(BuildContext context) {
//   //   FutureBuilder<List<String>>(
//   //     future: WeatherApi.searchCities(query: query),
//   //       builder:(context, snapshot){
//   //       if(query.isEmpty) return buildNoSuggestions();
//   //       switch(snapshot.connectionState){
//   //         case ConnectionState.waiting:
//   //           return Center(child: CircularProgressIndicator(),);
//   //         default:
//   //           return buildSuggestionsSuccess(snapshot.data!);
//   //       }
//   //       }
//   //       );
//   //   return Container();
//   //   // final suggestions = query.isEmpty
//   //   // ?recentCities
//   //   //     :cities.where((city) {
//   //   //       final cityLower = city.toLowerCase();
//   //   //       final queryLower = city.toLowerCase();
//   //   //       return cityLower.startsWith(queryLower);
//   //   // }).toList();
//   //   // return buildSuggestionsSucess(suggestions);
//   // }
//   // Widget buildNoSuggestions()=> const Center(
//   //   child: Text('No Suggestions',
//   //   style: TextStyle(
//   //     fontSize: 28,
//   //     color: Colors.white,
//   //   ),),
//   // );
//
//   // Widget buildSuggestionsSuccess(List<String> suggestions) => ListView.builder(
//   //   itemCount: suggestions.length,
//   //     itemBuilder: (context,index){
//   //     final suggestion = suggestions[index];
//   //     final queryText = suggestion.substring(0,query.length);
//   //     final remainingText = suggestion.substring(query.length);
//   //
//   //
//   //       return ListTile(
//   //         // leading: ,
//   //         onTap: (){
//   //           query = suggestion;
//   //            // close(context, suggestion);
//   //           // suggestion
//   //           // Navigator.pushReplacement(context,
//   //           //     MaterialPageRoute(builder: (context) => LocationScreen()));
//   //           showResults(context);
//   //         },
//   //         // title: Text(suggestion),
//   //         title: RichText(
//   //           text: TextSpan(
//   //             text: queryText,
//   //             style: TextStyle(
//   //               color: Colors.black,
//   //               fontWeight: FontWeight.bold,
//   //               fontSize: 18,
//   //             ),
//   //             children: [
//   //               TextSpan(
//   //                 text: remainingText,
//   //                 style: TextStyle(
//   //                   color: Colors.grey,
//   //                   fontSize: 18,
//   //                 )
//   //               )
//   //             ]
//   //           ),
//   //         ),
//   //       );
//   //     });
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     // TODO: implement buildSuggestions
//     throw UnimplementedError();
//   }
 }