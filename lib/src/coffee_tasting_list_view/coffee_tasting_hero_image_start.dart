import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'coffee_tasting_hero_image_end.dart';

class CoffeeTastingHeroImageStart extends StatelessWidget {
  final String tag;
  final String imagePath;

  CoffeeTastingHeroImageStart({this.tag, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getApplicationDocumentsDirectory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            var appDocDir = snapshot.data;
            var appDocDirPath = appDocDir.path;

            // TODO: Error handling for when image is not found.
            // TODO: New stub photo.
            var image = Image.asset('$appDocDirPath/$imagePath', fit: BoxFit.cover);
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return CoffeeTastingHeroImageEnd(
                        tag: tag,
                        thumbnail: image,
                      );
                    },
                  ),
                );
              },
              child: Hero(
                tag: tag,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: image,
                  ),
                ),
              ),
            );
          } else {
            return Image.asset('assets/images/coffee.jpg', fit: BoxFit.cover);
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
