// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tanam/screens/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _password2 = TextEditingController();
  bool isHidden = true;
  bool isHidden2 = true;
  bool _isRegistering = false;
  final _formKey = GlobalKey<FormState>();
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
                              "Create",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 36,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Account",
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
                            height: 10,
                          ),
                          TextFormField(
                            obscureText: isHidden,
                            controller: _password2,
                            validator: (value) =>
                                value!.isEmpty || (value.length < 8)
                                    ? "Password must be at least 8 characters"
                                    : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.key),
                              hintText: 'Re-enter password',
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
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                            child: Column(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    register();
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
                                  child: const Text('Register'),
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
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.green,
                                    backgroundColor: Colors.white,
                                    minimumSize: const Size.fromHeight(50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    side: const BorderSide(
                                      color: Colors.green,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Image(
                                      //   image: AssetImage(
                                      //       "assets/images/googlelogo.png"),
                                      //   width: 25,
                                      // ),
                                      Text(' Google'),
                                    ],
                                  ),
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
                                'Already have an account?',
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (content) => const LoginScreen(),
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
            if (_isRegistering)
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

  Future<void> register() async {
    setState(() {
      _isRegistering = true;
    });

    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isRegistering = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    if (_password.text != _password2.text) {
      setState(() {
        _isRegistering = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords must be the same")));
      return;
    }

    String email = _email.text;
    int atIndex = email.indexOf('@');
    String name = email.substring(0, atIndex);
    String password = _password.text;

    try {
      final response = await http.post(
        Uri.parse("https://api.tanam.software:8488/api/tanam/register"),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'x-api-key': 'tanam_api_key',
        },
        body: {
          "user_name": name,
          "user_email": email,
          "user_password": password,
        },
      ).timeout(
        const Duration(seconds: 7),
      );
      setState(() {
        _isRegistering = false;
      });
      print(response.body);
      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        String loginError = data['data'].toString();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // content: Text("Request failed. Please try again."),
            content: Text(
              "Login failed. $loginError",
            ),
          ),
        );
        return;
      }

      if (data['status'] != 'success') {
        String loginError = data['data'].toString();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // content: Text("Register failed. Please try again."),
            content: Text(
              "Login failed. $loginError",
            ),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Register Success"),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
      return;
    } on TimeoutException catch (_) {
      setState(() {
        _isRegistering = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Request timed out. Please try again."),
        ),
      );
    } catch (e) {
      setState(() {
        _isRegistering = false;
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
