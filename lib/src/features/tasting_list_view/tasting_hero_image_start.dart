import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'tasting_hero_image_end.dart';

class TastingHeroImageStart extends StatelessWidget {
  final String tag;
  final String imageUrl; // TODO: Rename this to imageFileName.

  TastingHeroImageStart({this.tag, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    var image = CachedNetworkImage(
      imageUrl: imageUrl,

      // Wrapping in Center + SizedBox constrains the circle progress indicator.
      placeholder: (context, url) => Center(
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ),

      fadeInDuration: const Duration(),
      fadeOutDuration: const Duration(),
      fit: BoxFit.cover,
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return TastingHeroImageEnd(
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
  }
}
