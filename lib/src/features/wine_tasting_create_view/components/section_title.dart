import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  SectionTitle({this.sectionNumber, this.title});

  final int sectionNumber;
  final String title;

  @override
  Widget build(BuildContext context) {
    var formattedSectionNumber = sectionNumber.toString().padLeft(2, '0');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${formattedSectionNumber}.',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        SizedBox(width: 5),
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.overline.copyWith(fontSize: 20),
        ),
      ],
    );
  }
}
