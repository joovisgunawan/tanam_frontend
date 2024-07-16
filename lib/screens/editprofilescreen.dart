// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tanam/config.dart';
import 'package:tanam/models/usermodel.dart';
import 'package:tanam/screens/mainscreen.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<EditProfileScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _password = TextEditingController();
  // final TextEditingController _password2 = TextEditingController();
  bool isHidden = false;
  bool isHidden2 = false;
  final _formKey = GlobalKey<FormState>();
  File? _image;

  @override
  void initState() {
    super.initState();
    isHidden = true;
    isHidden2 = true;
    // getUser();
    _name.text = widget.user.name.toString();
    _email.text = widget.user.email.toString();
    _gender.text = widget.user.gender.toString();
    _phone.text = widget.user.phone.toString();
    _address.text = widget.user.address.toString();
    _password.text = widget.user.password.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                _selectFromCamera();
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                // child: Image.network(
                //   widget.user.id == "na"
                //       ? "${PhpConfig().SERVER}/barterit/photo/na.png"
                //       : "${PhpConfig().SERVER}/barterit/photo/${widget.user.photo}.png",
                //   width: 100,
                //   height: 100,
                // ),
                child: const Image(
                  image: AssetImage("assets/images/logo.png"),
                  width: 150,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'User Information',
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.indigo,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Name'),
                          TextFormField(
                            controller: _name,
                            validator: (value) =>
                                value!.isEmpty || (value.length < 5)
                                    ? "Name must be longer than 5"
                                    : null,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: 'Name',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Email'),
                          TextFormField(
                            controller: _email,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              hintText: 'Email',
                            ),
                            validator: (value) => value!.isEmpty ||
                                    !value.contains("@") ||
                                    !value.contains(".")
                                ? "Enter a valid email"
                                : null,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 5,
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Gender'),
                                TextFormField(
                                  controller: _gender,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.person),
                                    hintText: 'Gender',
                                  ),
                                  // validator: (value) => value!.isEmpty ||
                                  //         !value.contains("@") ||
                                  //         !value.contains(".")
                                  //     ? "Enter a valid email"
                                  //     : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          flex: 5,
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Phone'),
                                TextFormField(
                                  controller: _phone,
                                  validator: (value) =>
                                      value!.isEmpty || (value.length < 5)
                                          ? "Phone must be longer than 5"
                                          : null,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.phone),
                                    hintText: 'Phone Number',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Address'),
                          TextFormField(
                            controller: _address,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.location_on),
                              hintText: 'Address',
                            ),
                            // validator: (value) => value!.isEmpty ||
                            //         !value.contains("@") ||
                            //         !value.contains(".")
                            //     ? "Enter a valid email"
                            //     : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Password'),
                          TextFormField(
                            obscureText: isHidden,
                            controller: _password,
                            // validator: (value) => value!.isEmpty || (value.length < 8)
                            //     ? "Password must be at least 8 characters"
                            //     : null,
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
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        update();
                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.indigo,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),

            // Text(
            //   'Address',
            //   style: TextStyle(
            //       fontSize: 24,
            //       color: Colors.indigo,
            //       fontWeight: FontWeight.w500),
            // ),

            // Image.network(
            //   _image==null
            //       ? 'https://picsum.photos/150/150'
            //       :  _image!.path ,
            //   // width: double.infinity,
            // ),
            // Card(
            //   child: Container(
            //       decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: _image == null
            //           ? const AssetImage("assets/images/onboard0.png")
            //           : FileImage(_image!) as ImageProvider,
            //       fit: BoxFit.contain,
            //     ),
            //   )),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            //   child: Form(
            //     key: _formKey,
            //     child: Column(
            //       children: [
            //         TextFormField(
            //           controller: _name,
            //           validator: (value) => value!.isEmpty || (value.length < 5)
            //               ? "Name must be longer than 5"
            //               : null,
            //           decoration: const InputDecoration(
            //             prefixIcon: Icon(Icons.person),
            //             hintText: 'Name',
            //           ),
            //         ),
            //         const SizedBox(
            //           height: 10,
            //         ),
            //         TextFormField(
            //           controller: _email,
            //           decoration: const InputDecoration(
            //             prefixIcon: Icon(Icons.email),
            //             hintText: 'Email',
            //           ),
            //           validator: (value) => value!.isEmpty ||
            //                   !value.contains("@") ||
            //                   !value.contains(".")
            //               ? "Enter a valid email"
            //               : null,
            //         ),
            //         const SizedBox(
            //           height: 10,
            //         ),
            //         TextFormField(
            //           controller: _phone,
            //           validator: (value) => value!.isEmpty || (value.length < 5)
            //               ? "Name must be longer than 5"
            //               : null,
            //           decoration: const InputDecoration(
            //             prefixIcon: Icon(Icons.person),
            //             hintText: 'Phone Number',
            //           ),
            //         ),
            //         const SizedBox(
            //           height: 10,
            //         ),
            //         TextFormField(
            //           obscureText: isHidden,
            //           controller: _password,
            //           validator: (value) => value!.isEmpty || (value.length < 8)
            //               ? "Password must be at least 8 characters"
            //               : null,
            //           decoration: InputDecoration(
            //             prefixIcon: const Icon(Icons.key),
            //             hintText: 'Password',
            //             suffixIcon: IconButton(
            //               onPressed: () {
            //                 setState(() {
            //                   isHidden = !isHidden;
            //                 });
            //               },
            //               icon: Icon(isHidden
            //                   ? Icons.visibility_off
            //                   : Icons.visibility),
            //             ),
            //           ),
            //         ),
            //         const SizedBox(
            //           height: 10,
            //         ),
            //         TextFormField(
            //           obscureText: isHidden2,
            //           controller: _password2,
            //           validator: (value) => value!.isEmpty || (value.length < 8)
            //               ? "Password must be at least 8 characters"
            //               : null,
            //           decoration: InputDecoration(
            //             prefixIcon: const Icon(Icons.key),
            //             hintText: 'Reconfirm Password',
            //             suffixIcon: IconButton(
            //               onPressed: () {
            //                 setState(() {
            //                   isHidden2 = !isHidden2;
            //                 });
            //               },
            //               icon: Icon(isHidden2
            //                   ? Icons.visibility_off
            //                   : Icons.visibility),
            //             ),
            //           ),
            //         ),
            //         const SizedBox(
            //           height: 30,
            //         ),
            //         TextButton(
            //           onPressed: () {
            //             update();
            //             setState(() {});
            //           },
            //           style: TextButton.styleFrom(
            //             foregroundColor: Colors.white,
            //             backgroundColor: Colors.indigo,
            //             minimumSize: const Size.fromHeight(50),
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(8),
            //             ),
            //           ),
            //           child: const Text('Save'),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void update() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    // if (_password.text != _password2.text) {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(const SnackBar(content: Text("Password must be same")));
    //   return;
    // }

    String name = _name.text;
    String password = _password.text;
    String gender = _gender.text;
    String address = _address.text;
    String phone = _phone.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());

    http.post(
      // Uri.parse("${PhpConfig().SERVER}/barterit/php/editprofile.php"),
      Uri.parse("${Config.baseUrl}/login"),
      body: {
        "id": widget.user.id.toString(),
        "name": name,
        "password": password,
        "gender": gender,
        "phone": phone,
        "address": address,
        "photo": base64Image,
      },
    ).then((response) {
      print(response.body);
      print(password);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          print(jsondata['data']['name']);
          UserModel user1 = UserModel.fromJson(jsondata['data']);
          widget.user.name = jsondata['data']['name'];
          widget.user.gender = jsondata['data']['gender'];
          widget.user.phone = jsondata['data']['phone'];
          widget.user.address = jsondata['data']['address'];
          widget.user.password = jsondata['data']['password'];
          widget.user.photo = jsondata['data']['photo'];
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Success")));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (content) => MainScreen(
                      user: user1,
                      index: 3,
                    )),
          );
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Failed")));
        Navigator.pop(context);
      }
    });
    setState(() {});
  }

  Future<void> _selectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1200,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      print(_image!.path);
      cropImage();
    } else {
      print('No image selected.');
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      // aspectRatioPresets: [
      //   CropAspectRatioPreset.square,
      // CropAspectRatioPreset.ratio3x2,
      // CropAspectRatioPreset.original,
      //CropAspectRatioPreset.ratio4x3,
      // CropAspectRatioPreset.ratio16x9
      // ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      int? sizeInBytes = _image?.lengthSync();
      double sizeInMb = sizeInBytes! / (1024 * 1024);
      print(sizeInMb);
      print(_image!.path);
      setState(() {});
    }
  }

  void getUser() {
    http.post(
      // Uri.parse("${PhpConfig().SERVER}/barterit/php/getuser.php"),
      Uri.parse("${Config.baseUrl}/login"),
      body: {
        "id": widget.user.id,
      },
    ).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body); //decode==parse
        if (jsondata['status'] == 'success') {
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Login Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Login Failed")));
      }
    }).timeout(
      const Duration(seconds: 3),
      onTimeout: () {},
    );
  }
}
