// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanam/config.dart';
import 'package:tanam/models/usermodel.dart';
import 'package:tanam/screens/mainscreen.dart';
import 'package:tanam/screens/onboardingscreen.dart';
import 'package:http/http.dart' as http;
import 'package:tanam/tokenmanager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/images/logo.png"),
              width: 150,
            ),
          ],
        ),
      ),
    );
  }

  //check shared preference
  //if not remember user, so login using anonymous user
  //if remember user, so get the id and password, and try to login using it
  //if response=200, means the data arrive in the server, and server send status ok(200)
  //if status from response = success login, means user data is found
  //if user data is found, generate object from json

  void checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('password')) ?? '';
    bool seenOnBoard = prefs.getBool('seenOnBoard') ?? false;
    bool rememberMe = (prefs.getBool('rememberMe') ?? false);
    UserModel user;
    if (!seenOnBoard) {
      // If the user hasn't seen the onboarding screen, navigate to it
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (content) => const OnBoardingScreen(),
        ),
      );
      print("seenOnBoard is: $seenOnBoard");
      return;
    }

    if (seenOnBoard) {
      // If the user hasn't seen the onboarding screen, navigate to it
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (content) => const OnBoardingScreen(),
        ),
      );
      print("seenOnBoard is: $seenOnBoard");
      return;
    }

    if (!rememberMe) {
      print("login using anonymous user");
      // If the user opted not to be remembered, create a placeholder user and navigate to the main screen
      user = UserModel(
        id: "na",
        name: "na",
        email: "na",
        password: "na",
        gender: "na",
        phone: 0,
        address: "na",
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (content) => MainScreen(
            user: user,
            index: 0,
          ),
        ),
      );
      return;
    }

    // Proceed with the login process
    try {
      print("login using remembered user");
      final response = await http.post(
        Uri.parse("${Config.baseUrl}/login"),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'x-api-key': Config.apiKey,
          'Accept-Encoding': 'gzip',
        },
        body: {
          "user_email": email,
          "user_password": password,
        },
      ).timeout(
        const Duration(seconds: 3),
      );
      print(response);
      print(response.body);
      print(response.contentLength);
      print(response.statusCode);
      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        String loginError = data['data'].toString();
        print(loginError);
        user = UserModel(
          id: "na",
          name: "na",
          email: "na",
          password: "na",
          gender: "na",
          phone: 0,
          address: "na",
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (content) => MainScreen(
              index: 0,
              user: user,
            ),
          ),
        );
        return;
      }

      if (data['status'] != 'success') {
        String loginError = data['data'].toString();
        print(loginError);
        // Handle unsuccessful login
        user = UserModel(
          id: "na",
          name: "na",
          email: "na",
          password: "na",
          gender: "na",
          phone: 0,
          address: "na",
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (content) => MainScreen(
              index: 0,
              user: user,
            ),
          ),
        );
        return;
      }
      print("response status");
      print(data['status']);

      // Handle token storage
      if (data.containsKey('access_token')) {
        await TokenManager.setAccessToken(data['access_token']);
      }
      if (data.containsKey('refresh_token')) {
        await TokenManager.setRefreshToken(data['refresh_token']);
      }

      user = UserModel.fromJson(data['data']);
      print(user.name);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (content) => MainScreen(
            user: user,
            index: 0,
          ),
        ),
      );
      return;
    } on TimeoutException catch (_) {
      // Handle timeout exception
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Request timed out. Please try again."),
        ),
      );
    } catch (e) {
      // Handle other exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred. Please try again."),
        ),
      );
    }
  }

  // void check() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool seenOnBoard = prefs.getBool('seenOnBoard') ?? false;

  //   Timer(
  //     //timer need async library
  //     const Duration(milliseconds: 3000),
  //     () => Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) =>
  //             seenOnBoard ? const OnBoardingScreen() : const OnBoardingScreen(),
  //       ),
  //     ),
  //   );
  // }

  // void checkLogin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String email = (prefs.getString('email')) ?? '';
  //   String password = (prefs.getString('password')) ?? '';
  //   bool seenOnBoard = prefs.getBool('seenOnBoard') ?? false;
  //   bool rememberMe = (prefs.getBool('rememberMe') ?? false);
  //   UserModel user;
  //   if (!seenOnBoard) {
  //     Timer(
  //       const Duration(milliseconds: 3000),
  //       () => Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (content) => const OnBoardingScreen(),
  //         ),
  //       ),
  //     );
  //   }
  //   if (!rememberMe) {
  //     user = UserModel(
  //       id: "na",
  //       name: "na",
  //       email: "na",
  //       password: "na",
  //       gender: "na",
  //       phone: "na",
  //       address: "na",
  //     );
  //     Timer(
  //       const Duration(milliseconds: 3000),
  //       () {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (content) => MainScreen(
  //               user: user,
  //               index: 0,
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   }

  //   try {
  //     await http.post(
  //       Uri.parse("https://api.tanam.software:8488/login"),
  //       headers: {
  //         'Content-Type': 'application/x-www-form-urlencoded',
  //         'x-api-key': 'tanam_api_key',
  //       },
  //       body: {
  //         "user_email": email,
  //         "user_password": password,
  //       },
  //     ).then(
  //       (response) async {
  //         // ignore: avoid_print
  //         print(response.body);
  //         //the response is in string, make it to json again
  //         final data = jsonDecode(response.body);

  //         //we just accept status code 200, so other than that, reject, dont forget the return keyword
  //         if (response.statusCode != 200) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(
  //               content: Text("Request failed. Please try again."),
  //             ),
  //           );
  //           return;
  //         }

  //         //we just accept success login, other than that, reject, dont forget the return keyword
  //         if (data['status'] != 'success login') {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(
  //               content: Text("Login failed. Please try again."),
  //             ),
  //           );
  //           return;
  //         }
  //         //check if the response send cookies with key access_token
  //         if (data.containsKey('access_token')) {
  //           await TokenManager.setAccessToken(data['access_token']);
  //         }
  //         //check if the response send cookies with key refresh_token
  //         if (data.containsKey('refresh_token')) {
  //           await TokenManager.setRefreshToken(data['refresh_token']);
  //         }
  //         user = UserModel.fromJson(data['data']);
  //         Timer(
  //           const Duration(milliseconds: 3000),
  //           () {
  //             Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (content) => MainScreen(
  //                   user: user,
  //                   index: 0,
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     ).timeout(
  //       const Duration(seconds: 3),
  //       onTimeout: () {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text("Request timed out. Please try again."),
  //           ),
  //         );
  //         throw TimeoutException(
  //           'The connection has timed out, Please try again!',
  //         );
  //       },
  //     );
  //   } catch (e) {
  //     // print(e);
  //   }

  //   setState(() {});
  // }
}
