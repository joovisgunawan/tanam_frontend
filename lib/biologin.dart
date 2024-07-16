// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tanam/models/usermodel.dart';
import 'package:tanam/tokenmanager.dart';
import 'package:tanam/screens/mainscreen.dart';
import 'dart:convert';
import 'dart:async';



class BioLogin extends StatefulWidget {
  const BioLogin({super.key});

  @override
  State<BioLogin> createState() => _BioLoginState();
}

class _BioLoginState extends State<BioLogin> {
  final LocalAuthentication auth = LocalAuthentication();
  bool? _canCheckBiometrics;
  bool? _canScanFace;
  bool? _canScanFinger;

  List<BiometricType>? _availableBiometrics;

  Future<void> _checkBiometricsCapability() async {
    try {
      _canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      _canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> _getAvailableBiometrics() async {
    print('Trying to get available bilogin');
    try {
      _availableBiometrics = await auth.getAvailableBiometrics();
      if (_availableBiometrics!.contains(BiometricType.face)) {
        _canScanFace = true;
      }
      if (_availableBiometrics!.contains(BiometricType.fingerprint)) {
        _canScanFinger = true;
      }
    } on PlatformException catch (e) {
      _availableBiometrics = <BiometricType>[];
      print(e);
    }
    print("_canScanFace $_canScanFace");
    print("_canScanFinger $_canScanFinger");
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> _authenticateWithFinger() async {
    bool authenticated = false;
    print('Trying to scan with biologin');

    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to login to Tanam',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
        // authMessages: authenticated,
      );
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) {
      return;
    }
    if (authenticated) {
      print("authenticated $authenticated");
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String email = preferences.getString('email') ?? '';
      String password = preferences.getString('password') ?? '';
      bool rememberMe = (preferences.getBool('rememberMe') ?? false);
      if(!rememberMe){
        return;
      }
      UserModel user;

      try {
        final response = await http.post(
          Uri.parse("https://api.tanam.software:8488/login"),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'x-api-key': 'tanam_api_key',
          },
          body: {
            "user_email": email,
            "user_password": password,
          },
        ).timeout(
          const Duration(seconds: 3),
        );

        if (response.statusCode != 200) {
          // Handle request failure
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login failed. Please try again."),
            ),
          );
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

        final data = jsonDecode(response.body);

        if (data['status'] != 'success login') {
          // Handle unsuccessful login
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login failed. Please try again."),
            ),
          );
          return;
        }

        // Handle token storage
        if (data.containsKey('access_token')) {
          await TokenManager.setAccessToken(data['access_token']);
        }
        if (data.containsKey('refresh_token')) {
          await TokenManager.setRefreshToken(data['refresh_token']);
        }

        user = UserModel.fromJson(data['data']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (content) => MainScreen(
              user: user,
              index: 0,
            ),
          ),
        );
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
    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    _checkBiometricsCapability();
    _getAvailableBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'BioLogin',
          ),
        ),
        body: Column(
          children: [
            TextButton(
              onPressed: () {
                print("_canCheckBiometrics $_canCheckBiometrics");
                print("_availableBiometrics $_availableBiometrics");
                _authenticateWithFinger();
              },
              child: const Text('Finger Print Login'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Face Login'),
            ),
          ],
        ),
      ),
    );
  }
}
