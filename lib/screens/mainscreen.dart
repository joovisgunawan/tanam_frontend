// import 'package:awesome_notifications/awesome_notifications.dart';
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tanam/models/usermodel.dart';
// import 'package:tanam/screens/MyBannerAdWidget.dart';
// import 'package:tanam/screens/esp32cam.dart';
// import 'package:tanam/screens/esp32camscreen.dart';
import 'package:tanam/screens/homescreen.dart';
// import 'package:tanam/screens/loginscreen.dart';
import 'package:tanam/screens/mydevicescreen.dart';
import 'package:tanam/screens/notificationscreen.dart';
import 'package:tanam/screens/profile.dart';
import 'package:tanam/screens/shopscreen.dart';

class MainScreen extends StatefulWidget {
  final int index;
  final UserModel user;

  const MainScreen({
    super.key,
    required this.index,
    required this.user,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  AppOpenAd? _appOpenAd;

  late List tabchildren;
  int _currentIndex = 0;
  //method
  @override
  void initState() {
    super.initState();
    tabchildren = [
      HomeScreen(
        user: widget.user,
      ),
      ShopScreen(
        user: widget.user,
      ),
      const NotificationScreen(),

      ProfileScreen(user: widget.user),
      const MyDeviceScreen(),
    ];
    loadAd();
    //check the notification is allowed or not, check it when user acces the home screen, not the splash/login/signup/onboarding
    // AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    //   if (!isAllowed) {
    //     AwesomeNotifications().requestPermissionToSendNotifications();
    //   }
    // });
  }

  Future<void> loadAd() async {
    AppOpenAd.load(
      adUnitId: 'ca-app-pub-6311242713601440/2915991038',
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenAd!.show();
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
        },
      ),
    );
  }

  //widget is for UI
  @override
  Widget build(BuildContext context) {
    bool showFAB = MediaQuery.of(context).viewInsets.bottom != 0.0;

    return Scaffold(
      // resizeToAvoidBottomInset:false, // This line prevents resizing when the keyboard appears
      // extendBody: true,
      body: tabchildren[_currentIndex],
      //center btn
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: !showFAB,
        child: FloatingActionButton(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          onPressed: () {
            setState(() {
              _currentIndex = 4;
            });
          },
          backgroundColor: _currentIndex == 4 ? Colors.white : Colors.green,
          shape: CircleBorder(
            side: BorderSide(
              width: 3,
              color: _currentIndex == 4 ? Colors.green : Colors.white,
            ),
          ),
          child: Icon(
            Icons.add,
            color: _currentIndex == 4 ? Colors.green : Colors.white,
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.green,
        elevation: 0.0,
        child: SizedBox(
          height: 60,
          // color: Colors.amber,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //home
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home,
                        color: _currentIndex == 0 ? Colors.white : Colors.black,
                      ),
                      Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              _currentIndex == 0 ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //shop
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shop,
                        color: _currentIndex == 1 ? Colors.white : Colors.black,
                      ),
                      Text(
                        'Shop',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              _currentIndex == 1 ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 30,
              ),

              //Notification
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications,
                        color: _currentIndex == 2 ? Colors.white : Colors.black,
                      ),
                      Text(
                        'Notification',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              _currentIndex == 2 ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //profile
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _currentIndex = 3;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        color: _currentIndex == 3 ? Colors.white : Colors.black,
                      ),
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              _currentIndex == 3 ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
