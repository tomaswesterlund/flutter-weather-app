import 'dart:convert';
import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService({required this.apiKey});

  Future<String> readApiKey() async {
    try {
      var file = File('assets/api_key.txt');

      if(file.exists() == false ) {
        print('Error reading API key. Make sure /assets/api_key.txt exists with the API key from OpenWeather');
        return "";
      } else {
        final content = await file.readAsString();

        if(content == "") {
          print('The file /assets/api_key.txt exists but is empty. Make sure it contains the API key from OpenWeather');
        }

        return content;
      }
    } catch (e) {
      print('Error reading API key. Make sure /assets/api_key.txt exists with the API key from OpenWeather');
      return "";
    }
  }
  
  Future<Weather> getWeather(String cityName) async {
    final url = '$BASE_URL?q=$cityName&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error fetching weather data');
    }
  }

  Future<String> getCurrentCity() async {

    // Get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Fetch the current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Convert the location into a list of placemark objects
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    // Extract the city name from the first placemark
    String? city = placemarks[0].locality;

    return city ?? "";
  }
}