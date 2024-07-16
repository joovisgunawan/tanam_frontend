class DataModel {
  int? airTempC;
  int? airTempF;
  int? humidity;
  int? waterTempC;
  int? waterTempF;
  int? tds;
  int? pH;
  int? distanceCm;
  int? distanceInch;

  DataModel(
      {this.airTempC,
      this.airTempF,
      this.humidity,
      this.waterTempC,
      this.waterTempF,
      this.tds,
      this.pH,
      this.distanceCm,
      this.distanceInch});

  DataModel.fromJson(Map<String, dynamic> json) {
    airTempC = json['airTempC'];
    airTempF = json['airTempF'];
    humidity = json['humidity'];
    waterTempC = json['waterTempC'];
    waterTempF = json['waterTempF'];
    tds = json['tds'];
    pH = json['pH'];
    distanceCm = json['distanceCm'];
    distanceInch = json['distanceInch'];
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals, unnecessary_new
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['airTempC'] = airTempC;
    data['airTempF'] = airTempF;
    data['humidity'] = humidity;
    data['waterTempC'] = waterTempC;
    data['waterTempF'] = waterTempF;
    data['tds'] = tds;
    data['pH'] = pH;
    data['distanceCm'] = distanceCm;
    data['distanceInch'] = distanceInch;
    return data;
  }
}
