import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  File? imageFile;
  final imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            width: size.width,
            height: 250,
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              color: Colors.blueGrey,
              strokeWidth: 1,
              dashPattern: const [5, 5],
              child: SizedBox.expand(
                child: FittedBox(
                  child: imageFile != null
                      ? Image.file(File(imageFile!.path), fit: BoxFit.cover)
                      : const Icon(
                          Icons.image_outlined,
                          color: Colors.blueGrey,
                        ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 40, 40, 20),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blueGrey,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  showPictureDialog();
                },
                child: SizedBox(
                  width: size.width,
                  height: 50,
                  child: const Center(
                    child: Text(
                      'Pick Image',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blueGrey,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  setState(() {
                    imageFile = null;
                  });
                },
                child: SizedBox(
                  width: size.width,
                  height: 50,
                  child: const Center(
                    child: Text(
                      'Clear Image',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showPictureDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Action'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                getFromCamera();
                Navigator.of(context).pop();
              },
              child: const Text('Open Camera'),
            ),
            SimpleDialogOption(
              onPressed: () {
                getFromGallery();
                Navigator.of(context).pop();
              },
              child: const Text('Open Gallery'),
            ),
          ],
        );
      },
    );
  }

  Future<void> cropImage() async {
    if (imageFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile!.path,
        // aspectRatioPresets: [
        //   CropAspectRatioPreset.square,
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
        setState(() {
          imageFile = File(croppedFile.path);
        });
      }
    }
  }

  // get from gallery
  Future<void> getFromGallery() async {
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      await cropImage();
    }
  }

  // get from camera
  Future<void> getFromCamera() async {
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}
