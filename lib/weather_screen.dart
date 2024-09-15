import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/model/forecast_model.dart';
import 'package:weather_app/service/forecast_provider.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatelessWidget {
  WeatherScreen({super.key});

  final TextEditingController _cityController = TextEditingController();

  String getDayOfWeek(String dateTime) {
    DateTime date = DateTime.parse(dateTime);
    return DateFormat('EEE').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: _cityController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'City Name',
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Search button part
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        String city = _cityController.text.trim();
                        if (city.isNotEmpty) {
                          weatherProvider.fetchWeather(city);
                        }
                      },
                      child: const Text(
                        'Search',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Consumer<WeatherProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (provider.error != null) {
                      return Center(child: Text(provider.error!));
                    } else if (provider.forecast != null && provider.forecast!.isNotEmpty) {
                      ForecastModel firstDayForecast = provider.forecast!.first;
                      double temperature = firstDayForecast.temperature;
                      double tempMin = firstDayForecast.tempMin;
                      double tempMax = firstDayForecast.tempMax;
                      String iconUrl = "https://openweathermap.org/img/wn/${firstDayForecast.iconCode}@2x.png";
                      String dayOfWeek = getDayOfWeek(firstDayForecast.date);

                      return Column(
                        children: [
                          Text(
                            provider.city ?? 'Unknown City',
                            style: const TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                         const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            child: Image.network(iconUrl),
                          ),
                         const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "$temperature°C",
                            style: const TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "H: ${tempMax.toStringAsFixed(1)} °C  L: ${tempMin.toStringAsFixed(1)} °C",
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          Expanded(
                            child: ListView.builder(
                              itemCount: provider.forecast!.length,
                              itemBuilder: (context, index) {
                                ForecastModel dayForecast = provider.forecast![index];
                                double temp = dayForecast.temperature;
                                String iconUrl = "https://openweathermap.org/img/wn/${dayForecast.iconCode}@2x.png";
                                String dayOfWeek = getDayOfWeek(dayForecast.date);
                                return ListTile(
                                  leading: Image.network(iconUrl),
                                  title: Text(dayOfWeek),
                                  subtitle: Text(
                                      "Temp: ${temp.toStringAsFixed(1)} °C\n${dayForecast.description}"),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: Text("No forecast available"));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

