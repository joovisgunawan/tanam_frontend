import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanam/models/onboardmodel.dart';
import 'package:tanam/models/usermodel.dart';
// import 'package:tanam/models/usermodel.dart';
import 'package:tanam/screens/mainscreen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    setSeen();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  currentIndex = value;
                  setState(() {});
                },
                itemCount: onBoardingContent.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          onBoardingContent[index].title,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 36,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Image.asset(
                          onBoardingContent[index].image,
                          // width: 250,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onBoardingContent.length,
                        (index) => dotIndicator(index),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextButton(
                      onPressed: () {
                        currentIndex != onBoardingContent.length - 1
                            ? _pageController.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              )
                            : Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    UserModel user = UserModel(
                                      id: "na",
                                      name: "na",
                                      email: "na",
                                      password: "na",
                                      gender: "na",
                                      phone: 0,
                                      address: "na",
                                    );
                                    return MainScreen(
                                      index: 0,
                                      user: user,
                                    );
                                  },
                                ),
                              );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        currentIndex != onBoardingContent.length - 1
                            ? 'Continue'
                            : 'Get Started',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future setSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnBoard', true);
  }

  Container dotIndicator(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: currentIndex == index ? 20 : 8,
      decoration: BoxDecoration(
        color: currentIndex == index ? Colors.green : Colors.grey,
        // shape: BoxShape.circle,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
