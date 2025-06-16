import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({
    required this.onPickImage,
    super.key,
  });
  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() {
    return _ImageInput();
  }
}

class _ImageInput extends State<ImageInput> {
  File? _selectedImage;

  void _takePitcure() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedImage == null) return;

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    widget.onPickImage(_selectedImage!);
    print("Image path: ${_selectedImage?.path}");
    print("Image exists: ${_selectedImage?.existsSync()}");
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 2, 160, 120),
      ),
      onPressed: _takePitcure,
      icon: const Icon(Icons.camera, color: Colors.white),
      label: const Text('take picture', style: TextStyle(color: Colors.white)),
    );
    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePitcure,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        border:
            Border.all(width: 1, color: const Color.fromARGB(255, 2, 160, 120)),
      ),
      height: 200,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
