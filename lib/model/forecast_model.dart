
class ForecastModel {
  final String date;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final String iconCode;
  final String description;

  ForecastModel({
    required this.date,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.iconCode,
    required this.description,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];

    return ForecastModel(
      date: json['dt_txt'],
      temperature: main['temp'].toDouble(),
      tempMin: main['temp_min'].toDouble(),
      tempMax: main['temp_max'].toDouble(),
      iconCode: weather['icon'],
      description: weather['description'],
    );
  }
}

