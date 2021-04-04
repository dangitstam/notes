import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CriteriaBarChartData {
  String criteriaLabel;
  double intensity;

  CriteriaBarChartData({
    this.criteriaLabel,
    this.intensity,
  });
}

class CriteriaBarChart extends StatelessWidget {
  CriteriaBarChart({this.children});

  final List<CriteriaBarChartData> children;

  final double size = 20;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children
              .map(
                (e) => Container(
                  height: size,
                  child: Center(
                    child: Text(
                      '${e.criteriaLabel}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children.map(
            (e) {
              var value = e.intensity;
              return RatingBar(
                allowHalfRating: false,
                initialRating: value,
                direction: Axis.horizontal,
                ignoreGestures: true,
                itemCount: 6,
                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                itemSize: size,
                ratingWidget: RatingWidget(
                  full: ImageIcon(
                    AssetImage('assets/images/np_x.png'),
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  half: ImageIcon(
                    AssetImage('assets/images/np_x.png'),
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  empty: Icon(
                    CupertinoIcons.minus,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                onRatingUpdate: (rating) {},
              );
            },
          ).toList(),
        ),
        SizedBox(width: 20),
        Column(
          children: children
              .map(
                (e) => Container(
                  alignment: Alignment.center,
                  height: size,
                  child: Text(
                    '${e.intensity} / 6.0',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
