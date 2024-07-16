class IoT {
  String? deviceId;
  String? deviceImage;
  String? deviceName;
  String? deviceCategory;
  String? deviceDescription;
  String? devicePrice;

  // Constructor
  IoT({
    required this.deviceId,
    required this.deviceImage,
    required this.deviceName,
    required this.deviceCategory,
    required this.deviceDescription,
    required this.devicePrice,
  });
}

List iotList = [
  IoT(
    deviceId: '1',
    deviceImage: '',
    deviceName: '1',
    deviceCategory: 'hydroponics',
    deviceDescription: '',
    devicePrice: '100',
  ),
  IoT(
    deviceId: '2',
    deviceImage: '',
    deviceName: '2',
    deviceCategory: 'hydroponics',
    deviceDescription: '',
    devicePrice: '200',
  ),
  IoT(
    deviceId: '3',
    deviceImage: '',
    deviceName: '2',
    deviceCategory: 'hydroponics',
    deviceDescription: '',
    devicePrice: '200',
  ),
];
