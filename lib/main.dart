
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:weatherappk/screens/home_screen.dart';
import 'package:weatherappk/screens/loading_screen.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor:
      // Colors.black,
      Color.fromRGBO(255, 255, 255, 0.15),
      // Color.fromRGBO(147, 92, 177, 1),
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // theme: getTheme(),
      home: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_android.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: AnimatedSplashScreen(
          duration: 3000,
          splash: "assets/logo/logo_splash.png",
          splashIconSize: 20,
          backgroundColor: Colors.transparent,
          nextScreen: LoadingScreen(),
        ),
      ),
    );
  }
}
