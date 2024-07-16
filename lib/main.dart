import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tanam/api/FirebaseApi.dart';
import 'package:tanam/firebase_options.dart';
import 'package:tanam/screens/splashscreen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await dotenv.load(fileName: "env/.env");
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(MobileAds.instance.initialize());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotification();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}


// import 'dart:async';

// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
// // import 'package:tanam/screens/MyBannerAdWidget.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:tanam/api/FirebaseApi.dart';
// import 'package:tanam/screens/housescreen.dart';
// import 'package:tanam/screens/loginscreen.dart';
// import 'package:tanam/screens/mainscreen.dart';
// import 'package:tanam/screens/notificationdetailscreen.dart';
// import 'package:tanam/screens/notificationscreen.dart';
// import 'package:tanam/screens/splashscreen.dart';
// import 'package:tanam/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';

// // AppOpenAd? _appOpenAd;//super global variable

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Future<void> main() async {

//   // AwesomeNotifications().initialize(
//   //   // set the icon to null if you want to use the default app iconcd
//   //   // 'resource://drawable/res_app_icon',
//   //   // 'tanam/assets/images/logo.png',
//   //   '',
//   //   [
//   //     NotificationChannel(
//   //       channelGroupKey: 'basic_channel_group',
//   //       channelKey: 'basic_channel',
//   //       channelName: 'Basic notifications',
//   //       channelDescription: 'Notification channel for basic tests',
//   //       defaultColor: Color(0xFF9D50DD),
//   //       ledColor: Colors.white,
//   //       importance: NotificationImportance.Max,
//   //       channelShowBadge: true,
//   //       onlyAlertOnce: true,
//   //       playSound: true,
//   //       criticalAlerts: true,
//   //     )
//   //   ],
//   //   // Channel groups are only visual and are not required, below is list []
//   //   channelGroups: [
//   //     NotificationChannelGroup(
//   //         channelGroupKey: 'basic_channel_group',
//   //         channelGroupName: 'Basic group')
//   //   ],
//   //   debug: true,
//   // );

//   WidgetsFlutterBinding.ensureInitialized();
//   // unawaited requires async library
//   // unawaited(MobileAds.instance.initialize());
//   // MobileAds.instance.initialize();
//   // await loadAd();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await FirebaseApi().initNotification();
//   // final _firebaseMessaging = FirebaseMessaging.instance;
//   // await _firebaseMessaging.requestPermission();
//   // final token = await _firebaseMessaging.getToken();
//   // // ignore: avoid_print
//   // print(token);
//   runApp(const MainApp());
// }

// Future<void> loadAd() async {
//   // AppOpenAd.load(adUnitId: adUnitId, request: request, adLoadCallback: adLoadCallback)
//   AppOpenAd.load(
//     adUnitId: 'ca-app-pub-6311242713601440/2915991038',
//     // orientation: AppOpenAd.orientationPortrait,
//     // adRequest: AdRequest(),
//     request: const AdRequest(),
//     adLoadCallback: AppOpenAdLoadCallback(
//       onAdLoaded: (ad) {
//         // _appOpenAd = ad;
//         // _appOpenAd!.show();
//         // _appOpenLoadTime = DateTime.now();
//         // _appOpenAd = ad;
//       },
//       onAdFailedToLoad: (error) {
//         // ignore: avoid_print
//         print('AppOpenAd failed to load: $error');
//         // Handle the error.
//       },
//     ),
//   );
// }

// class MainApp extends StatelessWidget {
//   const MainApp({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // navigatorKey: navigatorKey,
//       debugShowCheckedModeBanner: false,
//       // home: const MainScreen(index: 0),
//       home: MainScreen(index: 0),
//       // routes: {
//       //   '/notificationDetail': (context) => NotificationDetailScreen(),
//       // },
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'dart:typed_data';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late MqttClient client;
//   // late Uint8List imageBytes;
//   Uint8List imageBytes = Uint8List(0);

//   @override
//   void initState() {
//     super.initState();
//     setupMqtt();
//   }

//   void setupMqtt() async {
//     client = MqttClient('mqtt.tanam.software', '');
//     client.port = 1883;
//     client.logging(on: true);
//     client.keepAlivePeriod = 60;
//     final connMess = MqttConnectMessage()
//         .authenticateAs('tanam-broker', 't4nAm_br0k3r')
//         .withClientIdentifier('FlutterClient')
//         .startClean();
//     client.connectionMessage = connMess;

//     client.onConnected = () {
//       print('Connected to MQTT broker');
//       client.subscribe('video/stream', MqttQos.atMostOnce);
//     };

//     client.onDisconnected = () {
//       print('Disconnected from MQTT broker');
//     };

//     client.onUnsubscribed = () {
//       print('Unsubscribed from topic');
//     } as UnsubscribeCallback?;

//     client.onSubscribed = (topic) {
//       print('Subscribed to topic: $topic');
//     };

//     client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
//       final MqttPublishMessage message = c![0].payload as MqttPublishMessage;
//       final payload =
//           MqttPublishPayload.bytesToStringAsString(message.payload.message);
//       setState(() {
//         // Assuming payload contains image bytes
//         imageBytes = Uint8List.fromList(payload.codeUnits);
//       });
//     });

//     try {
//       await client.connect();
//     } catch (e) {
//       print('Exception: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('MQTT Video Stream'),
//         ),
//        body: Center(
//           child: imageBytes.isNotEmpty
//               ? _buildImage()
//               : CircularProgressIndicator(),
//         ),
//       ),
//     );
//   }
//   Widget _buildImage() {
//     try {
//       return Image.memory(
//         imageBytes,
//       );
//     } catch (e) {
//       print('Error loading image: $e');
//       return Text('Error loading image');
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:tanam/home_page.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(
//       SystemUiOverlayStyle.light.copyWith(
//         systemNavigationBarIconBrightness: Brightness.dark,
//         systemNavigationBarColor: Colors.white,
//         statusBarIconBrightness: Brightness.light,
//         statusBarColor: Colors.black,
//       ),
//     );

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Image Picker',
//       theme: ThemeData(
//         primarySwatch: Colors.blueGrey,
//       ),
//       home: MyPage()
//     );
//   }
// }

// import 'package:flutter/material.dart';
// // import 'package:image_cropper_app/main_page.dart';
// import 'package:tanam/main_page.dart';

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MainPage(),
//     );
//   }
// }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Image Upload Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ImageUploadScreen(),
//     );
//   }
// }

// class ImageUploadScreen extends StatefulWidget {
//   @override
//   _ImageUploadScreenState createState() => _ImageUploadScreenState();
// }

// class _ImageUploadScreenState extends State<ImageUploadScreen> {
//   final picker = ImagePicker();
//   File? _image;

//   Future getImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   Future uploadImage() async {
//     if (_image == null) return;

//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('https://api.tanam.software:8488/upload'),
//     );

//     request.fields['productName'] = 'MyImage'; // Replace with actual product name

//     request.files.add(
//       await http.MultipartFile.fromPath(
//         'myFile',
//         _image!.path,
//         filename: 'image.png',
//       ),
//     );

//     var response = await request.send();
//     if (response.statusCode == 200) {
//       print('Image uploaded successfully');
//       // Handle success response
//     } else {
//       print('Failed to upload image: ${response.reasonPhrase}');
//       // Handle failure response
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Upload Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _image == null
//                 ? Text('No image selected.')
//                 : Image.file(_image!),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: getImage,
//               child: Text('Select Image'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: uploadImage,
//               child: Text('Upload Image'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

