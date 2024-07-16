// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart';
// import 'package:mime/mime.dart';
// import 'package:http_parser/http_parser.dart';

// class ImagePicker extends StatefulWidget {
//   const ImagePicker({super.key});

//   @override
//   State<ImagePicker> createState() => _ImagePickerState();
// }

// class _ImagePickerState extends State<ImagePicker> {
//   File? _image;

//   final picker = ImagePicker();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upload Image'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _image == null ? Text('No image selected.') : Image.file(_image!),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: getImage,
//               child: Text('Pick Image'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 if (_image != null) {
//                   uploadImage(_image!);
//                 }
//               },
//               child: Text('Upload Image'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future getImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   Future<void> uploadImage(File imageFile) async {
//     final url = Uri.parse('http://localhost:8080/upload');

//     // Find the MIME type of the file
//     final mimeTypeData =
//         lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8])?.split('/');

//     // Prepare the multipart request
//     final imageUploadRequest = http.MultipartRequest('POST', url);

//     // Attach the file in the request
//     final file = await http.MultipartFile.fromPath(
//       'image',
//       imageFile.path,
//       contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
//     );

//     imageUploadRequest.files.add(file);

//     try {
//       final streamedResponse = await imageUploadRequest.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         print('File uploaded successfully.');
//       } else {
//         print('File upload failed with status: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('File upload error: $e');
//     }
//   }
// }
