import 'package:flutter/material.dart';

class SwiperTabs extends StatelessWidget {
  SwiperTabs({this.swiperTitles, this.isSelected, this.onTap});

  final List<String> swiperTitles;
  final List<bool> isSelected;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      children: List<Widget>.generate(
        swiperTitles.length,
        (int index) {
          return _SwiperTab(text: swiperTitles[index], position: index, isSelected: isSelected[index], onTap: onTap);
        },
      ),
    );
  }
}

class _SwiperTab extends StatelessWidget {
  _SwiperTab({this.text, this.position, this.isSelected, this.onTap});

  final String text;
  final int position;
  final bool isSelected;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(position);
      },
      child: Container(
        child: Text(
          text.toUpperCase(),
          style: Theme.of(context).textTheme.overline,
        ),
        padding: EdgeInsets.only(bottom: 10),
        decoration: isSelected
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 1.0,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
