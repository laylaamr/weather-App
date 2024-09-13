
import 'package:flutter/foundation.dart';

import '../model/forecast_model.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';


class WeatherProvider with ChangeNotifier {
  List<ForecastModel>? _forecast;
  bool _isLoading = false;
  String? _error;
  String? _city;

  List<ForecastModel>? get forecast => _forecast;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get city => _city;

  Future<void> fetchWeather(String city) async {
    _city = city;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      List<ForecastModel> data = await getFiveDayForecast(city);
      _forecast = data;
      _isLoading = false;
    } catch (e) {
      _error = "Failed to load weather data";
      _isLoading = false;
    }

    notifyListeners();
  }
}


