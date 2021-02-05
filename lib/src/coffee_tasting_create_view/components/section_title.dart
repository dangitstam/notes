import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  SectionTitle({this.sectionNumber, this.title});

  final int sectionNumber;
  final String title;

  @override
  Widget build(BuildContext context) {
    var formattedSectionNumber = sectionNumber < 10 ? '0$sectionNumber.' : '$sectionNumber.';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(formattedSectionNumber, style: Theme.of(context).textTheme.subtitle2),
        SizedBox(width: 5),
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.overline.copyWith(fontSize: 20),
        ),
      ],
    );
  }
}

class SectionTitleDecoration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 2.0,
        width: 40,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
