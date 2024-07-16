// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tanam/config.dart';
// import 'package:tanam/models/usermodel.dart';
// import 'package:tanam/screens/mainscreen.dart';
import 'package:tanam/screens/registerscreen.dart';
import 'package:tanam/screens/loginscreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  bool _isResetting = false;

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
                              "Forgot",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 36,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Password",
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
                  const Padding(
                    padding: EdgeInsets.fromLTRB(32, 20, 32, 0),
                    child: Text(
                      "Enter your email, a reset password URL will be sent to your email",
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
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                            child: Column(
                              children: [
                                TextButton(
                                  onPressed:
                                      _isResetting ? null : forgotPassword,
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
                                  child: const Text('Submit'),
                                ),
                                const SizedBox(
                                  height: 8,
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
                                "Didn't receive an email?",
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Back to",
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (content) =>
                                          const LoginScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  ' Login',
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
            if (_isResetting)
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

  Future<void> forgotPassword() async {
    setState(() {
      _isResetting = true;
    });
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isResetting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Check your input"),
        ),
      );
      return;
    }

    String email = _email.text;

    try {
      final response = await http
          .post(
            Uri.parse("${Config.baseUrl}/forgotpassword"),
            headers: {
              'Content-Type': 'application/json',
              'x-api-key': Config.apiKey,
            },
            body: jsonEncode({
              "user_email": email,
            }),
          )
          .timeout(
            const Duration(seconds: 5),
          );

      setState(() {
        _isResetting = false;
      });
      print(response);
      print(response.headers);
      print(response.body);
      print(response.contentLength);
      print(response.statusCode);
      final data = jsonDecode(response.body);
      print("success decoding response");

      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Request failed. Please try again."),
          ),
        );
        return;
      }

      if (data['status'] != 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Request failed. Please try again."),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Reset password link sent. Check your email."),
        ),
      );
    } on TimeoutException catch (_) {
      setState(() {
        _isResetting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Request timed out. Please try again."),
        ),
      );
    } catch (e) {
      print(e);
      setState(() {
        _isResetting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred. Please try again."),
        ),
      );
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
