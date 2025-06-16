import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInputProfile extends StatefulWidget {
  const ImageInputProfile({
    super.key,
  });

  @override
  State<ImageInputProfile> createState() {
    return _ImageInputProfile();
  }
}

class _ImageInputProfile extends State<ImageInputProfile> {
  File? _selectedImage;

  void _takePitcure() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = GestureDetector(
      onTap: _takePitcure,
      child: const Icon(
        Icons.camera_alt,
        size: 30,
        color: Colors.grey,
      ),
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePitcure,
        child: ClipOval(
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
            width: 100,
            height: 100,
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey[200],
      child: content,
    );
  }
}
