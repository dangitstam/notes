import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' show basename;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;

/// Returns a modal allowing the user to set an image for the tasting
///
/// The image can be set via selection from the photo gallery or taken with the device's camera.
/// When an image is selected, [onImageSelected] is called with the path for the image file.
Future<void> imageCaptureSelectMethodModal(
  BuildContext context,
  Function(String) onImageSelected,
) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Wrap(
          children: <Widget>[
            ListTile(
                leading: Icon(CupertinoIcons.photo_fill, color: Colors.black),
                title: Text('Photo Library', style: Theme.of(context).textTheme.bodyText2),
                onTap: () {
                  _getImage(ImageSource.gallery, onImageSelected);
                  Navigator.of(context).pop();
                }),
            ListTile(
              leading: Icon(CupertinoIcons.photo_camera, color: Colors.black),
              title: Text('Camera', style: Theme.of(context).textTheme.bodyText2),
              onTap: () {
                _getImage(ImageSource.camera, onImageSelected);
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    },
  );
}

Future _getImage(
  ImageSource source,
  Function(String) onImageSelected,
) async {
  ImagePicker picker = ImagePicker();

  final pickedFile = await picker.getImage(source: source);

  if (pickedFile == null) return;

  // Save the captured image to the app locally.
  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocDirPath = appDocDir.path;

  var tmpFile = File(pickedFile.path);

  var pickedFileBasename = basename(pickedFile.path);
  var savePath = '$appDocDirPath/$pickedFileBasename';
  var savedFile = await tmpFile.copy(savePath);

  onImageSelected(savedFile.path);
}
