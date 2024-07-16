class OnBoarding {
  final String title;
  final String image;
  final String color;
  OnBoarding({
    required this.title,
    required this.image,
    required this.color,
  });
}

List onBoardingContent = [
  OnBoarding(
    title: 'Hi Petani, welcome to Tanam',
    image: 'assets/images/onboard1.png',
    color: 'black',
  ),
  OnBoarding(
    title: 'Automate your work',
    image: 'assets/images/onboard2.png',
    color: 'blue',
  ),
  OnBoarding(
    title: 'Make agriculture taste technology',
    image: 'assets/images/onboard3.png',
    color: 'yellow',
  ),
];
