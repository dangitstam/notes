import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes/src/styles/typography.dart';

class CriteriaLinearIndicator extends StatelessWidget {
  CriteriaLinearIndicator(this.value, this.label, this.color);

  final double value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    var scaledValue = value / 10;
    var formattedValue = value == 10.0 ? '$label: 10' : '$label: $value';
    var barHeight = 16.0;
    final textWidth = 80.0;

    return Padding(
      padding: EdgeInsets.only(top: 2, bottom: 2),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2.3),
            child: Container(
              height: barHeight,
              child: LinearProgressIndicator(
                backgroundColor: Color(0xfff1f1f1),
                value: scaledValue,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              var rightPadding = min(
                constraints.maxWidth * (1 - scaledValue),

                // Prevent pushing text overlaid on the progress indicator from going off the edge.
                constraints.maxWidth - textWidth,
              );

              return Padding(
                padding: EdgeInsets.only(right: rightPadding),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: barHeight,
                    width: textWidth,
                    padding: EdgeInsets.only(left: 4, right: 4),
                    child: Align(
                      // Aligns the text left when the bar is empty, aligns it to the the right when full.
                      alignment: Alignment.lerp(
                        Alignment.centerLeft,
                        Alignment.centerRight,
                        scaledValue,
                      ),
                      child: Text(
                        '$formattedValue',
                        style: caption.copyWith(color: Colors.white, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
