import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class WineCriteriaBarChartData {
  String criteriaLabel;
  double intensity;

  WineCriteriaBarChartData({
    this.criteriaLabel,
    this.intensity,
  });
}

class WineCriteriaBarChart extends StatelessWidget {
  WineCriteriaBarChart({this.children});

  final List<WineCriteriaBarChartData> children;

  final double size = 17;

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
        SizedBox(width: 17),
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
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
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
        SizedBox(width: 17),
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
