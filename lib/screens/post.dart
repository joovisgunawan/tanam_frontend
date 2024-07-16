// ignore_for_file: avoid_print

// import 'dart:convert';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// import '../phpconfig.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanam/config.dart';
import 'package:tanam/tokenmanager.dart';

class PostProductScreen extends StatefulWidget {
  // final UserTanam user;
  const PostProductScreen({super.key});

  @override
  State<PostProductScreen> createState() => _PostProductScreenState();
}

class _PostProductScreenState extends State<PostProductScreen> {
  File? _image;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    // Request camera and storage permissions
    var statusCamera = await Permission.camera.request();
    var statusStorage = await Permission.storage.request();

    if (statusCamera.isGranted && statusStorage.isGranted) {
      print('Permissions granted');
    } else {
      print('Permissions not granted');
    }
  }

  Future<void> showPictureDialog(BuildContext context) async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Action'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  _selectFromCamera();
                  Navigator.of(context).pop();
                },
                child: const Text('Open Camera'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  _selectFromGallery();
                  Navigator.of(context).pop();
                },
                child: const Text('Open Gallery'),
              ),
            ],
          );
        });
  }

  // final _formKey = GlobalKey<FormState>();
  final TextEditingController _productName = TextEditingController();
  final TextEditingController _productCategory = TextEditingController();
  final TextEditingController _productDescription = TextEditingController();
  final TextEditingController _productPrice = TextEditingController();
  final TextEditingController _productQuantity = TextEditingController();
  final TextEditingController _productState = TextEditingController();
  final TextEditingController _productLocality = TextEditingController();
  // final TextEditingController _prstateEditingController =
  //     TextEditingController();
  // final TextEditingController _prlocalEditingController =
  // TextEditingController();
  // late Position _currentPosition;
  List productCategory = [
    "Electronics",
    "Fashion and Clothing",
    "Home and Kitchen",
    "Sports and Fitness",
    "Health and Beauty",
    "Books and Media",
    "Toys and Games",
    "Automotive",
    "Baby and Kids",
    "Pet Supplies",
  ];
  String selectedCategory = "Electronics";

  String curaddress = "";
  String curstate = "";
  String prlat = "";
  String prlong = "";

  // @override
  // Widget build(BuildContext context) {
  //   Size size = MediaQuery.sizeOf(context);

  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('post'),
  //     ),
  //     body: Column(children: [
  //       // GestureDetector(
  //       //   onTap: () {
  //       //     showPictureDialog();
  //       //   },
  //       //   child: Container(
  //       //     height: 200,
  //       //     width: double.infinity,
  //       //     color: Colors.blueAccent,
  //       //     child: const Text('camera'),
  //       //   ),
  //       // ),
  //       Container(
  //         margin: const EdgeInsets.all(20),
  //         width: size.width,
  //         height: 250,
  //         child: DottedBorder(
  //             borderType: BorderType.RRect,
  //             radius: const Radius.circular(12),
  //             color: Colors.blueGrey,
  //             strokeWidth: 1,
  //             dashPattern: const [5, 5],
  //             child: SizedBox.expand(
  //               child: FittedBox(
  //                 child: _image != null
  //                     ? Image.file(File(_image!.path), fit: BoxFit.cover)
  //                     : const Icon(
  //                         Icons.image_outlined,
  //                         color: Colors.blueGrey,
  //                       ),
  //               ),
  //             )),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
  //         child: Material(
  //           elevation: 3,
  //           borderRadius: BorderRadius.circular(20),
  //           child: Container(
  //             width: size.width,
  //             height: 50,
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(20),
  //                 color: Colors.blueGrey),
  //             child: Material(
  //               borderRadius: BorderRadius.circular(20),
  //               color: Colors.transparent,
  //               child: InkWell(
  //                 splashColor: Colors.transparent,
  //                 highlightColor: Colors.transparent,
  //                 onTap: () {
  //                   showPictureDialog();
  //                 },
  //                 child: const Center(
  //                   child: Text(
  //                     'Pick Image',
  //                     style: TextStyle(
  //                         color: Colors.white, fontWeight: FontWeight.bold),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 40),
  //         child: Material(
  //           elevation: 3,
  //           borderRadius: BorderRadius.circular(20),
  //           child: Container(
  //             width: size.width,
  //             height: 50,
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(20),
  //                 color: Colors.blueGrey),
  //             child: Material(
  //               borderRadius: BorderRadius.circular(20),
  //               color: Colors.transparent,
  //               child: InkWell(
  //                 splashColor: Colors.transparent,
  //                 highlightColor: Colors.transparent,
  //                 onTap: () {
  //                   setState(() {
  //                     _image = null;
  //                   });
  //                 },
  //                 child: const Center(
  //                   child: Text(
  //                     'Clear Image',
  //                     style: TextStyle(
  //                         color: Colors.white, fontWeight: FontWeight.bold),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //       Expanded(
  //         child: Container(
  //           width: double.infinity,
  //           color: Colors.blueGrey,
  //           padding: const EdgeInsets.symmetric(horizontal: 16),
  //           child: Form(
  //             key: _formKey,
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 children: [
  //                   // name
  //                   Container(
  //                     color: Colors.white,
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const Text('Name'),
  //                         TextFormField(
  //                           controller: _productName,
  //                           // validator: (value) {},
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   // Category
  //                   Container(
  //                     color: Colors.white,
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const Text('Category'),
  //                         TextFormField(
  //                           controller: _productCategory,
  //                           // validator: (value) {},
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   // Description
  //                   Container(
  //                     color: Colors.white,
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const Text('Description'),
  //                         TextFormField(
  //                           maxLines: 5,
  //                           controller: _productDescription,
  //                           // validator: (value) {},
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   // price
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Flexible(
  //                         flex: 5,
  //                         child: Container(
  //                           color: Colors.white,
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               const Text('Price'),
  //                               TextFormField(
  //                                 controller: _productPrice,
  //                                 // validator: (value) {},
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         width: 10,
  //                       ),
  //                       Flexible(
  //                         flex: 5,
  //                         child: Container(
  //                           color: Colors.white,
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               const Text('Quantity'),
  //                               TextFormField(
  //                                 controller: _productQuantity,
  //                                 // validator: (value) {},
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Flexible(
  //                         flex: 5,
  //                         child: Container(
  //                           color: Colors.white,
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               const Text('State'),
  //                               TextFormField(
  //                                 controller: _productState,
  //                                 // validator: (value) {},
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         width: 10,
  //                       ),
  //                       Flexible(
  //                         flex: 5,
  //                         child: Container(
  //                           color: Colors.white,
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               const Text('Location'),
  //                               TextFormField(
  //                                 controller: _productLocality,
  //                                 // validator: (value) {},
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   TextButton(
  //                       onPressed: () {
  //                         addProduct();
  //                       },
  //                       child: const Text("Post"))
  //                   // TextFormField(
  //                   //   controller: _productName,
  //                   //   validator: (value) {},
  //                   // ),
  //                   // // quantity
  //                   // TextFormField(
  //                   //   controller: _productName,
  //                   //   validator: (value) {},
  //                   // ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       )
  //     ]),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                height: 250,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  color: Colors.blueGrey,
                  strokeWidth: 1,
                  dashPattern: const [5, 5],
                  child: InkWell(
                    onTap: () {
                      showPictureDialog(context);
                    },
                    child: Center(
                      child: _image != null
                          ? Image.file(_image!, fit: BoxFit.cover)
                          : const Icon(
                              Icons.image_outlined,
                              size: 50,
                              color: Colors.blueGrey,
                            ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                child: ElevatedButton(
                  onPressed: () {
                    showPictureDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Pick Image',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _image = null;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Clear Image',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              _buildFormField('Name', _productName),
              _buildFormField('Category', _productCategory),
              _buildFormField('Description', _productDescription, maxLines: 5),
              Row(
                children: [
                  Expanded(child: _buildFormField('Price', _productPrice)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _buildFormField('Quantity', _productQuantity)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildFormField('State', _productState)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _buildFormField('Location', _productLocality)),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: ElevatedButton(
                  // onPressed: addProduct,
                  onPressed: () {
                    // refresh();
                    // refreshAccessToken();
                    addProduct();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(String labelText, TextEditingController controller,
      {int? maxLines}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(labelText),
          TextFormField(
            controller: controller,
            maxLines: maxLines ?? 1,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
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

  Future<void> _selectFromGallery() async {
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
      // print('No image selected.');
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      // aspectRatioPresets: [
      //   CropAspectRatioPreset.square,
      //   // CropAspectRatioPreset.ratio3x2,
      //   // CropAspectRatioPreset.original,
      //   //CropAspectRatioPreset.ratio4x3,
      //   // CropAspectRatioPreset.ratio16x9
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
      _image = File(croppedFile.path);
      setState(() {});
    }
  }

  // void _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error('Location permissions are permanently denied.');
  //   }
  //   _currentPosition = await Geolocator.getCurrentPosition();

  //   _getAddress(_currentPosition);
  //   //return await Geolocator.getCurrentPosition();
  // }

  // _getAddress(Position position) async {
  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(position.latitude, position.longitude);
  //   if (placemarks.isEmpty) {
  //     _productLocality.text = "Changlun";
  //     _productState.text = "Kedah";
  //     prlat = "6.443455345";
  //     prlong = "100.05488449";
  //   } else {
  //     _productLocality.text = placemarks[0].locality.toString();
  //     _productState.text = placemarks[0].administrativeArea.toString();
  //     prlat = _currentPosition.latitude.toString();
  //     prlong = _currentPosition.longitude.toString();
  //   }
  //   setState(() {});
  // }

  Future<void> refresh() async {
    String refreshToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Impvb3Zpc2dAZ21haWwuY29tIiwiZXhwIjoxNzIwNDY2MDQ1LCJpYXQiOjE3MTk4NjEyNDV9.jvYXwtOIWdHyCSKhWpeAF9e1MJOzk_fM1uFohkPvr4M";
    String cookie = 'refresh_token=$refreshToken';
    final response = await http.post(
      Uri.parse("${Config.baseUrl}/refresh"),

      // Prepare headers with API key

      headers: {
        'Authorization': 'Bearer $refreshToken',
        'x-api-key': Config.apiKey,
        'Cookie': cookie,
      },
      // body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("object");
    }
    print(response);
    print(response.headers);
    print(response.body);
    print(response.statusCode);
  }

  void addProduct() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String accessToken = preferences.getString('access_token') ?? '';
    String refreshToken = preferences.getString('refresh_token') ?? '';
    String url = '${Config.baseUrl}/insertproduct';
    String apiKey = Config.apiKey;
    String accessCookie = 'access_token=$accessToken';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    if (_image != null) {
      var stream = http.ByteStream(_image!.openRead());
      var length = await _image!.length();
      var multipartFile = http.MultipartFile(
        'product_image',
        stream,
        length,
        filename: basename(_image!.path),
      );
      request.files.add(multipartFile);
    } else {
      print('No image selected');
      return;
    }

    print("object");
    print(accessToken);
    print(refreshToken);
    request.headers['X-API-Key'] = apiKey;
    request.headers['Cookie'] = accessCookie;
    request.fields['product_name'] = _productName.text;
    request.fields['product_category'] = _productCategory.text;
    request.fields['product_description'] = _productDescription.text;
    request.fields['product_price'] = _productPrice.text;
    request.fields['product_quantity'] = _productQuantity.text;
    request.fields['product_state'] = _productState.text;
    request.fields['product_location'] = _productLocality.text;
    request.fields['seller_id'] = "1";

    var response = await request.send();
    print(response);
    print(response.statusCode);
    print(apiKey);
    if (response.statusCode == 401) {
      await refreshAccessToken();
      String newAccessToken = preferences.getString('access_token') ?? '';
      String newAccessCookie = 'access_token=$newAccessToken';
      request.headers['Cookie'] = newAccessCookie;
      var response = await request.send();
      print(response);
      print(response.statusCode);
      print(apiKey);
      if (response.statusCode == 200) {
        print('Uploaded successfully');
      } else {
        print('Please relogin');
      }
    }
    if (response.statusCode == 200) {
      print('Uploaded successfully');
      return;
    } else {
      print('Upload failed');
    }
  }

  Future<void> refreshAccessToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String refreshToken = preferences.getString('refresh_token') ?? '';
    print('refreshToken');
    print(refreshToken);
    String cookie = 'refresh_token=$refreshToken';

    final response = await http.post(
      Uri.parse("${Config.baseUrl}/refresh"),
      headers: {
        'Authorization': 'Bearer $refreshToken',
        'x-api-key': Config.apiKey,
        'Cookie': cookie,
      },
      // body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("object");
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
      } else {
        print('Failed to fetch token');
      }
    }
    print(response);
    print(response.headers);
    print(response.body);
    print(response.statusCode);
  }
}
