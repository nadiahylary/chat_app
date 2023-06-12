import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({Key? key, required this.onPickedImage}) : super(key: key);

  final void Function(File userImage) onPickedImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _imagePicker() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 150,
    );
    if(pickedImage == null){
      return;
    }
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickedImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
          foregroundImage: _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
          child: IconButton(
              onPressed: _imagePicker,
              icon: Icon(
                _pickedImageFile == null ? Icons.image : Icons.edit,
                color: Theme.of(context).colorScheme.secondary,
                size: 40,
              ),
          ),
        ),
        TextButton.icon(
            onPressed: _imagePicker,
            icon: Icon(
                _pickedImageFile == null ? Icons.image : Icons.edit,
                color: Theme.of(context).colorScheme.secondary,
              size: 18,
            ),
            label: Text(
              _pickedImageFile == null ? "Add Image" : "Edit",
              style: GoogleFonts.ubuntu(
                textStyle: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.secondary
                ),
              ),
            )
        ),
      ],
    );
  }
}
