// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  String topBarTitle;
  Widget? primaryAction;
  Widget? secondartAction;
  double? fontSize;

  late double height;
  late double width;

  TopBar(
    this.topBarTitle, {
    super.key,
    this.primaryAction,
    this.secondartAction,
    this.fontSize = 35,
  });

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: height * 0.11,
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (secondartAction != null) secondartAction!,
          Text(
            topBarTitle,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (primaryAction != null) primaryAction!,
          
        ],
      ),
    );
  }
}
