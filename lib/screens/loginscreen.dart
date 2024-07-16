// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanam/config.dart';
import 'package:tanam/models/usermodel.dart';
import 'package:tanam/screens/forgotpassword.dart';
import 'package:tanam/screens/mainscreen.dart';
import 'package:tanam/screens/registerscreen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:tanam/tokenmanager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();
  List<BiometricType>? _availableBiometrics;
  // ignore: unused_field
  bool? _canCheckBiometrics;
  bool? _canScanFace;
  bool? _canScanFinger;
  bool isHidden = true;
  bool isChecked = false;
  bool _isLogin = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricsCapability();
    _getAvailableBiometrics();
    loadPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7FFF7),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  ClipPath(
                    clipper: MyClipper(),
                    child: Container(
                      width: double.infinity,
                      color: Colors.green,
                      height: 250,
                      child: const Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 36,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Back",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _email,
                            validator: (value) => value!.isEmpty ||
                                    !value.contains("@") ||
                                    !value.contains(".")
                                ? "Enter a valid email"
                                : null,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              hintText: 'Email',
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            obscureText: isHidden,
                            controller: _password,
                            validator: (value) =>
                                value!.isEmpty || (value.length < 8)
                                    ? "Password must be at least 8 characters"
                                    : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.key),
                              hintText: 'Password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isHidden = !isHidden;
                                  });
                                },
                                icon: Icon(isHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      isChecked = value!;
                                      rememberMe(value);
                                      setState(() {});
                                    },
                                  ),
                                  const Text('Remember me'),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                            child: Column(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    login();
                                    // apiClient.login(email, password, context);
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xffF7FFF7),
                                    backgroundColor: Colors.green,
                                    minimumSize: const Size.fromHeight(50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    side: const BorderSide(
                                      color: Colors.green,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: const Text('Login'),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        thickness: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Text('or sign in with'),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        thickness: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.green,
                                        backgroundColor: Colors.white,
                                        fixedSize: const Size.fromHeight(50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        side: const BorderSide(
                                          color: Colors.green,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      child: const Image(
                                        image: AssetImage(
                                            "assets/images/googlelogo.png"),
                                        width: 25,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _authenticate();
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.green,
                                        backgroundColor: Colors.white,
                                        fixedSize: const Size.fromHeight(50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        side: const BorderSide(
                                          color: Colors.green,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      child: const Icon(Icons.fingerprint),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Dont have an account?',
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (content) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  ' Register Now',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_isLogin)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void rememberMe(bool isChecked) async {
    FocusScope.of(context).requestFocus(FocusNode());
    String email = _email.text;
    String password = _password.text;
    //shared preference will store data in key, whatever object we created, it can access any other key stored to shared preference
    SharedPreferences preference = await SharedPreferences.getInstance();
    print("Remember me checkbox is checked: $isChecked");
    if (!isChecked) {
      //if remember me is not checked, so remove the corresponsing data stored in shared preference
      await preference.setString('user_email', '');
      await preference.setString('user_password', '');
      await preference.setBool('rememberMe', false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preference Removed"),
        ),
      );
      setState(() {});
      return; //if retrun, it will not continue to execute next line of code
    }
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill data first"),
        ),
      );
      return;
    }
    await preference.setString('email', email);
    await preference.setString('password', password);
    await preference.setBool("rememberMe", true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Preference Stored"),
      ),
    );
  }

  Future<void> loadPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String email = preferences.getString('email') ?? '';
    String password = preferences.getString('password') ?? '';
    isChecked = preferences.getBool('rememberMe') ?? false;
    if (isChecked) {
      _email.text = email;
      _password.text = password;
      setState(() {});
      // login();
    }
  }

  Future<void> login() async {
    setState(() {
      _isLogin = true;
    });
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isLogin = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Check your input"),
        ),
      );
      return;
    }

    String email = _email.text;
    String password = _password.text;

    try {
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
        const Duration(seconds: 5),
      );
      setState(() {
        _isLogin = false;
      });

      print(response);
      print(response.headers);
      print(response.body);
      print(response.contentLength);
      print(response.statusCode);
      final data = jsonDecode(response.body);
      print("success decoding response");
      if (response.headers['content-encoding'] == 'gzip') {
        print("Response is gzip compressed");
      } else {
        print("Response is not gzip compressed");
      }

      if (response.statusCode != 200) {
        String loginError = data['data'].toString();
        print(loginError);
        // Handle unsuccessful login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Login failed. $loginError",
            ),
          ),
        );
        return;
      }

      if (data['status'] != 'success') {
        String loginError = data['data'].toString();
        print(loginError);
        // Handle unsuccessful login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Login failed. $loginError",
            ),
          ),
        );
        return;
      }
      //this is like geetting the json key
      final setCookie = response.headers['set-cookie'];
      if (setCookie != null) {
        final cookies = setCookie.split(',');
        for (var cookie in cookies) {
          if (cookie.trim().startsWith('access_token=')) {
            final accessToken = cookie.split(';')[0].split('=')[1];
            // Save the access token to shared preferences
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            await preferences.setString('access_token', accessToken);
            print('Access token saved: $accessToken');
            break;
          }
        }
        for (var cookie in cookies) {
          if (cookie.trim().startsWith('refresh_token=')) {
            final refreshToken = cookie.split(';')[0].split('=')[1];
            // Save the access token to shared preferences
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            await preferences.setString('refresh_token', refreshToken);
            print('Refresh token saved: $refreshToken');
            break;
          }
        }
      } else {
        print('Failed to fetch token');
      }

      // final setCookie = response.headers['set-cookie'];
      // if (setCookie != null) {
      //   final cookies = setCookie.split(',');
      //   for (var cookie in cookies) {
      //     if (cookie.trim().startsWith('access_token=')) {
      //       final accessToken = cookie.split(';')[0].split('=')[1];
      //       // Save the access token to shared preferences
      //       final prefs = await SharedPreferences.getInstance();
      //       await prefs.setString('access_token', accessToken);
      //       print('Access token saved: $accessToken');
      //       break;
      //     }
      //   }
      //   for (var cookie in cookies) {
      //     if (cookie.trim().startsWith('refresh_token=')) {
      //       final refreshToken = cookie.split(';')[0].split('=')[1];
      //       // Save the access token to shared preferences
      //       final prefs = await SharedPreferences.getInstance();
      //       await prefs.setString('_token', refreshToken);
      //       print('Refresh token saved: $refreshToken');
      //       break;
      //     }
      //   }
      // } else {
      //   print('Failed to fetch token');
      // }

      // if (data.containsKey('access_token')) {
      //   print('accessToken is here');
      //   await TokenManager.setAccessToken(data['access_token']);
      // }
      // if (data.containsKey('refresh_token')) {
      //   await TokenManager.setRefreshToken(data['refresh_token']);
      // }

      // final accessToken = await TokenManager.getAccessToken();
      // final refreshToken = await TokenManager.getRefreshToken();
      // print('accessToken');
      // print(accessToken);
      // print(refreshToken);

      UserModel user = UserModel.fromJson(data['data']);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text("Login Success"),
      //   ),
      // );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            user: user,
            index: 0,
          ),
        ),
      );
      return;
    } on TimeoutException catch (_) {
      setState(() {
        _isLogin = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Request timed out. Please try again."),
        ),
      );
    } catch (e) {
      setState(() {
        _isLogin = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred. Please try again."),
        ),
      );
      print(e);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> _checkBiometricsCapability() async {
    try {
      bool isBiometricSupported = await auth.isDeviceSupported();
      print(isBiometricSupported);
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
    print('Trying to get available biologin');
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
    print(_availableBiometrics);
    print("_canScanFace $_canScanFace");
    print("_canScanFinger $_canScanFinger");
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> _authenticate() async {
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
      // ignore: empty_catches
    } on PlatformException {}
    if (!mounted) {
      return;
    }
    if (authenticated) {
      print("authenticated $authenticated");
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // ignore: unused_local_variable
      String email = preferences.getString('email') ?? '';
      bool rememberMe = preferences.getBool('rememberMe') ?? false;
      if (!rememberMe) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login failed. No data saved to the finger print"),
          ),
        );
        return;
      }
      setState(() {
        _isLogin = true;
        login();
      });
    }
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    final path = Path();

    path.lineTo(0, height);
    path.quadraticBezierTo(width / 4, height - 40, width / 2, height - 20);
    path.quadraticBezierTo(3 / 4 * width, height, width, height - 30);
    path.lineTo(width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
