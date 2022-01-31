import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show basename;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;

/// Creates a widget that on tap, allows a user to select an image.
///
/// The image can be set via selection from the photo gallery or taken with the device's camera.
/// This widget accepts an [onImageSelected] that is called when an image is selected, and is passed the image as an
/// instance of [File].
class ImageCapture extends StatefulWidget {
  @required
  final Function(File) onImageSelected; // TODO: This should take a list of files.
  ImageCapture({this.onImageSelected});

  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _image;

  List<File> _images = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        imageCaptureSelectMethodModal(context, (image) {
          // Update this widget's displayed image.
          setState(() {
            _image = File(image.path);
            _images.add(File(image.path));
          });

          // Pass selected image's file path to onImageSelected.
          widget.onImageSelected(image);
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: _images.map(
              (element) {
                return Container(
                  height: 50,
                  width: 50,
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3.0),
                      child: Image.file(element, fit: BoxFit.cover),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.photo_camera_back_outlined,
                color: Colors.black,
                size: 40,
              ),
              const SizedBox(width: 10),
              Text('Tap to add images',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
            ],
          ),
        ],
      ),
    );
  }
}

/// Returns a modal allowing the user to set an image for the tasting.
///
/// The image can be set via selection from the photo gallery or taken with the device's camera.
/// When an image is selected, [onImageSelected] is called with the path for the image file.
Future<void> imageCaptureSelectMethodModal(
  BuildContext context,
  Function(File) onImageSelected,
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
  Function(File) onImageSelected,
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

  onImageSelected(savedFile);
}
