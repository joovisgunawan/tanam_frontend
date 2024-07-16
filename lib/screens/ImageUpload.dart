// ignore_for_file: file_names, library_private_types_in_public_api, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:permission_handler/permission_handler.dart';


class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;

  final picker = ImagePicker();

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

  // Future getImage() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

    Future<void> selectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1200,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      print(_image!.path);
      // cropImage();
    } else {
      print('No image selected.');
    }
  }


  Future<void> uploadImage(File imageFile) async {
    final url = Uri.parse('https://api.tanam.software:8488/upload');

    // Find the MIME type of the file
    final mimeTypeData = lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8])?.split('/');

    // Prepare the multipart request
    final imageUploadRequest = http.MultipartRequest('POST', url);

    // Attach the file in the request
    final file = await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
      contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
    );

    imageUploadRequest.files.add(file);

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('File uploaded successfully.');
      } else {
        print('File upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('File upload error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? const Text('No image selected.')
                : Image.file(_image!),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectFromCamera,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_image != null) {
                  uploadImage(_image!);
                }
              },
              child: const Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
