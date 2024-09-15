import 'package:dio/dio.dart';

import '../model/forecast_model.dart';


Future<List<ForecastModel>> getFiveDayForecast(String city) async {
  try {
    Dio dio = Dio();
    String apiKey = 'ae42a0ae8b4e866a8425d44f7a3f81b7';
    String url = 'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric';
    Response response = await dio.get(url);


    if (response.statusCode == 200) {

      List<dynamic> forecastList = response.data['list'];
      List<ForecastModel> dailyForecastsAt3AM = forecastList
          .where((forecast) {
        String dateTime = forecast['dt_txt'];
        return dateTime.contains("21:00:00");
      })
          .map<ForecastModel>((forecast) => ForecastModel.fromJson(forecast))
          .toList();

      return dailyForecastsAt3AM;
    } else {
      throw Exception('Failed to load weather data');
    }
  } catch (e) {
    print(e);
    throw Exception('Failed to load weather data');
  }
}


