import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CriteriaCaption extends StatelessWidget {
  CriteriaCaption(this.criteria);

  final String criteria;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Container(
        height: 40,
        child: Center(
          child: Text(
            '$criteria',
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ),
    );
  }
}
