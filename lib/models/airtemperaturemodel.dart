class AirTemperatureModel {
  DateTime x;
  int y;

  AirTemperatureModel({
    required this.x,
    required this.y,
  });
}

List<AirTemperatureModel> airTemperatureModelList = [
  AirTemperatureModel(x: DateTime(2015, 2), y: 35),
  AirTemperatureModel(x: DateTime(2015, 3), y: 35),
  AirTemperatureModel(x: DateTime(2015, 4), y: 35),
  AirTemperatureModel(x: DateTime(2015, 5), y: 35),
  AirTemperatureModel(x: DateTime(2015, 6), y: 35),
  AirTemperatureModel(x: DateTime(2015, 7), y: 35),
  AirTemperatureModel(x: DateTime(2015, 8), y: 35),
];
