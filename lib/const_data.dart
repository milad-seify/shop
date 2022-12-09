import 'package:flutter/material.dart';

const RoundedRectangleBorder shapeCard = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(20.0),
    topRight: Radius.circular(20.0),
  ),
  side: BorderSide(
    color: Colors.blueGrey,
    strokeAlign: StrokeAlign.outside,
  ),
);

RoundedRectangleBorder borderCartScreen = RoundedRectangleBorder(
  side: const BorderSide(
    color: Colors.orange,
    width: 2.0,
    strokeAlign: StrokeAlign.outside,
  ),
  borderRadius: BorderRadius.circular(20.0),
);
