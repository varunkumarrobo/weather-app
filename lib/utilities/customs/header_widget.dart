// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:intl/intl.dart';
//
// import '../../controller/global_controller.dart';
//
// class HeaderWidget extends StatefulWidget {
//
//
//   @override
//   State<HeaderWidget> createState() => _HeaderWidgetState();
// }
//
// class _HeaderWidgetState extends State<HeaderWidget> {
//   String city = "";
//   String state = "";
//   String date = DateFormat('yMMMEd').format(DateTime.now());
//   final GlobalController globalController =
//   Get.put(GlobalController(), permanent: true);
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     getAddress(globalController.getLattitude().value,
//     globalController.getLongitude().value);
//     super.initState();
//   }
//
//   getAddress(lat, lon) async {
//     List<Placemark> placemark = await placemarkFromCoordinates(lat, lon);
//     Placemark place = placemark[0];
//     setState(() {
//       city = place.locality!;
//       state = place.administrativeArea!;
//     });
//     print(placemark);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           child: Column(
//             children: [
//               Text(
//                 date,
//               ),
//               Text(
//                   "$city, $state",
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }
