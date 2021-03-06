import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:weather_app/application/ui/weather_app_ui_config.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:weather_app/application/bindings/application_bindings.dart';
import 'package:weather_app/modules/home/home_module.dart';
import 'package:weather_app/modules/search_cities/search_cities_module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  RemoteConfig.instance.fetchAndActivate();
  await GetStorage.init();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      color: Color(0xff8375D7),
      debugShowCheckedModeBanner: false,
      initialBinding: ApplicationBindings(),
      title: WeatherAppUIConfig.title,
      theme: WeatherAppUIConfig.theme,
      getPages: [
        ...HomeModule().routers,
        ...SearchCitiesModule().routers,
      ],
      initialRoute: '/home',
    );
  }
}
