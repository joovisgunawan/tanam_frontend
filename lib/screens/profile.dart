// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:tanam/models/usermodel.dart';
import 'package:tanam/screens/editprofilescreen.dart';
import 'package:tanam/screens/loginscreen.dart';
import 'package:tanam/screens/mainscreen.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          // child: Image.network(
                          //   widget.user.id == "na"
                          //       ? "${PhpConfig().SERVER}/barterit/photo/na.png"
                          //       : "${PhpConfig().SERVER}/barterit/photo/${widget.user.photo}.png",
                          //   width: 95,
                          //   height: 95,
                          // ),
                          child: const Image(
                            image: AssetImage("assets/images/logo.png"),
                            width: 70,
                            height: 100,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.user.name.toString(),
                              style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              widget.user.email.toString(),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            widget.user.id == "na"
                                ? Container(
                                    margin: const EdgeInsets.only(top: 6),
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 6, 16, 6),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Text(
                                      'Unregistered',
                                      style: TextStyle(color: Colors.white),
                                    ))
                                : Container(
                                    margin: const EdgeInsets.only(top: 6),
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 6, 16, 6),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Text(
                                      'Registered',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        widget.user.id == "na"
                            ? print('Login First')
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditProfileScreen(user: widget.user),
                                ),
                              );
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
                      child: const Text('Edit Profile'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    // tileColor: Colors.amber,
                    title: const Text('My order'),
                    leading: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.green,
                    ),
                    trailing: const Icon(Icons.navigate_next_outlined),
                    onTap: () {
                      widget.user.id == "na"
                          ? print('Login First')
                          : print('Login First');
                    },
                  ),
                  const Divider(
                    height: 5,
                    color: Colors.black12,
                    indent: 10,
                    endIndent: 10,
                  ),
                  ListTile(
                    title: const Text('Shipping Address'),
                    leading: const Icon(
                      Icons.location_on_outlined,
                      color: Colors.green,
                    ),
                    trailing: const Icon(Icons.navigate_next_outlined),
                    onTap: () {
                      widget.user.id == "na"
                          ? print('Login First')
                          : print('Login First');
                    },
                  ),
                  const Divider(
                    height: 5,
                    color: Colors.black12,
                    indent: 10,
                    endIndent: 10,
                  ),
                  ListTile(
                    title: const Text('Payment Method'),
                    leading: const Icon(
                      Icons.credit_card,
                      color: Colors.green,
                    ),
                    trailing: const Icon(Icons.navigate_next_outlined),
                    onTap: () {
                      widget.user.id == "na"
                          ? print('Login First')
                          : print('Login First');
                    },
                  ),
                  const Divider(
                    height: 5,
                    color: Colors.black12,
                    indent: 10,
                    endIndent: 10,
                  ),
                  ListTile(
                    title: const Text('Setting'),
                    leading: const Icon(
                      Icons.settings,
                      color: Colors.green,
                    ),
                    trailing: const Icon(
                      Icons.navigate_next_outlined,
                    ),
                    onTap: () {},
                  ),
                  const Divider(
                    height: 5,
                    color: Colors.black12,
                    indent: 10,
                    endIndent: 10,
                  ),
                  widget.user.id == "na"
                      ? ListTile(
                          title: const Text('Log In'),
                          leading: const Icon(
                            Icons.login,
                            color: Colors.green,
                          ),
                          trailing: const Icon(Icons.navigate_next_outlined),
                          onTap: () {
                            // widget.user.id = 'na';
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (content) => const LoginScreen(),
                              ),
                            );
                          },
                        )
                      : ListTile(
                          title: const Text('Log Out'),
                          leading: const Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                          trailing: const Icon(Icons.navigate_next_outlined),
                          onTap: () {
                            // widget.user.id = 'na';
                            UserModel user = UserModel(
                              id: "na",
                              name: "na",
                              email: "na",
                              phone: 0,
                              password: "na",
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
                          },
                        ),
                  const Divider(
                    height: 5,
                    color: Colors.black12,
                    indent: 10,
                    endIndent: 10,
                  ),
                ],
              ),
            ),

            // Image.network(
            //   // "${PhpConfig().SERVER}/barterit/photo/0.png",
            //   "${PhpConfig().SERVER}/barterit/photo/${widget.user.id}.png",
            //   // "https://picsum.photos/190/170",
            //   width: double.infinity,
            // ),
            // TextButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (content) => EditProfileScreen(
            //           user: widget.user,
            //         ),
            //       ),
            //     );
            //   },
            //   child: const Text('Edit Profile'),
            // ),
            // const Text('User Name'),
            // const Text('User Address'),
            // TextButton(
            //   onPressed: () {},
            //   child: const Text('Log Out'),
            // )
          ],
        ),
      ),
    );
  }
}
