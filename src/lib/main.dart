import 'package:flutter/material.dart';
import 'package:minimal_weather_app/pages/loading_page.dart';
import 'package:minimal_weather_app/providers/location_provider.dart';
import 'package:minimal_weather_app/providers/weather_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider(apiKey: '65b56408166bc2b50f81370d25492164')),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingPage(),
    );
  }
}
