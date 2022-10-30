// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:weatherappk/models/weather_data.dart';
//
// import '../api/fetch_weather.dart';
//
// class GlobalController extends GetxController{
//   // create various variables
//
//   final RxBool _isLoading = true.obs;
//   final RxDouble _lattitude = 0.0.obs;
//   final RxDouble _longitude = 0.0.obs;
//
//
//   // instance for these to be called
//   RxBool checkLoading() => _isLoading;
//   RxDouble getLattitude() => _lattitude;
//   RxDouble getLongitude() => _longitude;
//
//   // final weatherData = WeatherData().obs;
//   //
//   //  WeatherData getData(){
//   //   return weatherData.value;
//   // }
//
//  @override
//   void onInit() {
//     // TODO: implement onInit
//    if(_isLoading.isTrue){
//      getLocation();
//    }
//     super.onInit();
//   }
//
//   getLocation() async{
//    bool isServiceEnabled;
//    LocationPermission locationPermission;
//
//    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
//    if(!isServiceEnabled){
//      return Future.error("Location not enabled");
//    }
//    //status of permission
//     locationPermission = await Geolocator.checkPermission();
//
//    if(locationPermission == LocationPermission.deniedForever){
//        return Future.error("Location permission are denied forever");
//    }else if(locationPermission == LocationPermission.denied){
//      //request permission
//      locationPermission = await Geolocator.requestPermission();
//      if(locationPermission == LocationPermission.denied){
//       return Future.error("Location permission is denied");
//      }
//    }
//
//
//    //getting current position
//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high)
//         .then((value) {
//       //latitude and longitude updating
//       _lattitude.value = value.latitude;
//       _longitude.value = value.longitude;
//       // calling our weather api
//       // return FetchWeatherAPI().
//       // processData(value.latitude, value.longitude).
//       // then((value) {
//       //   // weatherData.value = value!;
//         _isLoading.value = false;
//       //   // print(weatherData.value);
//       //   // print(_lattitude.value);
//       //   // print(_longitude.value);
//       // });
//       print(_lattitude.value);
//       print(_longitude.value);
//     });
//  }
//
//   // @override
//   // void onClose() {
//   //   // TODO: implement onClose
//   //   super.onClose();
//   // }
// }