// import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:tanam/main.dart';
// import 'package:tanam/models/notificationmodel.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class FirebaseApi {
//   final _firebaseMessaging = FirebaseMessaging.instance;

//   final _androidChannel = const AndroidNotificationChannel(
//       'High_importance_channel', 'High_importance_notification',
//       description: "Thsi cannnel is for local",
//       importance: Importance.defaultImportance);
//   final _flutterLocalNotification = FlutterLocalNotificationsPlugin();
//   // the basic writing style of this method is
//   // void initFUnction()
//   // then void initFUnction() async
//   // then Future<void> initFUnction() async
//   Future<void> initNotification() async {
//     await _firebaseMessaging.requestPermission();
//     final token = await _firebaseMessaging.getToken();
//     // ignore: avoid_print
//     print("token $token");
//     initPushNotification();
//     initLocalNotification();
//   }

//   // void handleNotification(RemoteMessage? message, NavigatorState navigator) {
//   //   // guard condition
//   //   if (message == null) return;
//   //   navigator.pushReplacement(
//   //     MaterialPageRoute(
//   //       builder: (content) => const MainScreen(index: 0),
//   //     ),
//   //   );

//   void handleNotification(RemoteMessage? message) {
//     // guard condition
//     if (message == null) return;

//     // String? messageTitle = message.notification?.title;
//     // String? messageBody = message.notification?.body;
//    // NotificationModel notification = NotificationModel(
//     //   title: messageTitle,
//     //   body: messageBody,
//     // );
//     // final Map<String, dynamic> notificationJson = notification.toJson();
//     //to json is to post it to rest api, because we need to convert data to json for rx and tx data using api
//     // navigatorKey.currentState?.push(
//     //   MaterialPageRoute(
//     //     // builder: (context) => NotificationDetailScreen(notif: notification),
//     //     builder: (context) => NotificationDetailScreen(notif: notification),
//     //   ),
//     // );

//     navigatorKey.currentState?.pushNamed(
//       '/notificationDetail',
//       arguments: message,
//     );
//     // navigatorKey.currentState?.push(
//     //   MaterialPageRoute(
//     //     builder: (context) => NotificationDetailScreen(),
//     //     settings: RouteSettings(arguments: message),
//     //   ),
//     // );
//   }

//   Future initPushNotification() async {
//     // FirebaseMessaging.onBackgroundMessage((message) async{});//we can do it like this
//     //whatever notif occures, this method will do something, evento user didnt click anything, this method will be executed on incoming notification

//     // Handle initial messages when the app is opened from a terminated state
//     FirebaseMessaging.instance.getInitialMessage().then(handleNotification);
//     //this is for redirection, when notification open the app,
//     FirebaseMessaging.onMessageOpenedApp.listen(handleNotification);
//     FirebaseMessaging.onBackgroundMessage(backgroundNotificationHandler);
//     FirebaseMessaging.onMessage.listen((message) {
//       final notification = message.notification;
//       if (notification == null) return;
//       _flutterLocalNotification.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//               _androidChannel.id, _androidChannel.name,
//               channelDescription: _androidChannel.description,
//               icon: '@mipmap-xhdpi\ic_launcher'),
//         ),
//         payload: jsonEncode(message.toMap()),
//       );
//     });
//   }

//   Future initLocalNotification() async {
//   //   // const ios = IOSInitializationSettings();

//   //   const iOS =
//   //       DarwinInitializationSettings(
//   //     requestSoundPermission: false,
//   //     requestBadgePermission: false,
//   //     requestAlertPermission: false,
//   //     // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
//   //   );
//     const android = AndroidInitializationSettings('@mipmap-xhdpi\ic_launcher');
//     const settings = InitializationSettings(
//       // iOS: iOS,
//       android: android,
//     );

//     await _flutterLocalNotification.initialize(
//       settings,
//       // onDidReceiveBackgroundNotificationResponse: (payload) {
//       //   final message = RemoteMessage.fromMap(jsonDecode(payload as String));
//       //   handleNotification(message);
//       // },
//       onDidReceiveNotificationResponse: (payload) {
//         print("message arrived");
//         final message = RemoteMessage.fromMap(jsonDecode(payload as String));
//         handleNotification(message);
//       },
//     );
//     final platform =
//         _flutterLocalNotification.resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>();
//     await platform?.createNotificationChannel(_androidChannel);
//     // await _flutterLocalNotification.initialize(onDidReceiveBackgroundNotificationResponse: );
//   }
// }

// Future<void> backgroundNotificationHandler(RemoteMessage message) async {
//   String? messageTitle = message.notification?.title;
//   String? messageBody = message.notification?.body;
//   // ignore: avoid_print
//   print("Title:$messageTitle");
//   // print("Title:${message.notification!.title}");
//   // ignore: avoid_print
//   print("Body:$messageBody");
//   // ignore: avoid_print
//   print("Payload:${message.data}");
//   NotificationModel notification = NotificationModel(
//     title: messageTitle,
//     body: messageBody,
//   );
//   final Map<String, dynamic> notificationJson = notification.toJson();
//   // ignore: avoid_print
//   print(notificationJson);
// }

// ignore_for_file: avoid_print, duplicate_ignore, file_names

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tanam/main.dart';
// import 'package:tanam/models/notificationmodel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:tanam/screens/notificationdetailscreen.dart';
import 'package:tanam/screens/notificationdetailscreen2.dart';

//create instance
//init fcm
//ask for permission
//get token using await
//print token

//handle background
//include in init
//parse the message detail
//print message detail

//handle received message
//if message if null so return
//if not null so redirect
//pass the argument

//handle terminated
//getInitialMessage()
//on message open--this is for when the notif is clicked

//handle foreground
//install flutter local notification
//create notification channel for android
//set teh meta data for the channel created just now
//create instance
//create listener for

//init local notif
//init android, here we init the logo/icon for notification
//initialize setting by passing that android setting
//await initialize

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _flutterLocalNotification = FlutterLocalNotificationsPlugin();
  final _androidChannel = const AndroidNotificationChannel(
    'High_importance_channel',
    'High_importance_notification',
    description: "Thsi cannnel is for local",
    importance: Importance.defaultImportance,
  );

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    // ignore: avoid_print
    print("token $token");
    initPushNotification();
    initLocalNotification();
  }

  void handleNotification(RemoteMessage? message) {
    if (message == null) return;
    // navigatorKey.currentState?.pushNamed(
    //   '/notificationDetail',
    //   arguments: message,
    // );
    print("Message handled");
    String? messageTitle = message.notification?.title;
    String? messageBody = message.notification?.body;

    // final Map<String, dynamic> notificationJson = notification.toJson();

    // NotificationModel notification = NotificationModel(
    //   title: messageTitle,
    //   body: messageBody,
    // );
    // navigatorKey.currentState?.push(
    //   MaterialPageRoute(
    //     builder: (context) => NotificationDetailScreen(notif: notification),
    //   ),
    // );

    Map<String, dynamic> notificationData = {
      'title': messageTitle,
      'body': messageBody,
    };

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => NotificationDetailScreen2(notif: notificationData),
      ),
    );
  }

  Future initPushNotification() async {
    //handle notification when app is terminated
    FirebaseMessaging.instance.getInitialMessage().then(handleNotification);

    //handle message when notif received while app run in the background
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotification);
    // FirebaseMessaging.onBackgroundMessage(backgroundNotificationHandler);
    //this will do something when message arrive while app is in foreground
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      print(notification);
      print("notificationReceived on foreground");
      print(message.notification?.title);
      //when a notif arrived when we are in the foreground
      //and if the notification is not null
      //then show notification
      _flutterLocalNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
              _androidChannel.id, _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@drawable/ic_launcher'),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future initLocalNotification() async {
    //set the icon
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    //set setting for local, we can specifiy for ios, linux, web but here we just specify for android
    const settings = InitializationSettings(
      android: android,
    );

    //initialize the local notification
    await _flutterLocalNotification.initialize(
      settings, //pass the setting
      onDidReceiveNotificationResponse: (payload) {
        print("notificationClicked on foreground");
        print(payload);
        print(payload.payload);
        print(payload.notificationResponseType);
        print(payload.input);
        print(payload.id);
        print(payload.actionId);
        // final message = RemoteMessage.fromMap(jsonDecode(payload.payload));
        final dynamic data = jsonDecode(payload.payload ?? '{}');
        final RemoteMessage message = RemoteMessage.fromMap(data);

        String? messageTitle = message.notification?.title;
        String? messageBody = message.notification?.body;
        print(messageTitle);
        print(messageBody);
        handleNotification(message);
        // print(message);
        // print(message.notification?.title);
        // final notification = message.notification;
        // print(notification?.title);
        // print(notification?.body);
        // final message = RemoteMessage.fromMap(jsonDecode(payload as String));
        // print(message);
        // handleNotification(payload as RemoteMessage?);
      },
    );

    //resolve specific implementation
    final platform =
        _flutterLocalNotification.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }
}

Future<void> backgroundNotificationHandler(RemoteMessage message) async {
  String? messageTitle = message.notification?.title;
  String? messageBody = message.notification?.body;
  print("Title:$messageTitle");
  print("Body:$messageBody");
  print("Payload:${message.data}");
}
