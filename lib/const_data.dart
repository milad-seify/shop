import 'package:flutter/material.dart';

const RoundedRectangleBorder shapeCard = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(20.0),
    topRight: Radius.circular(20.0),
  ),
  side: BorderSide(
    width: 2,
    color: Colors.blueGrey,
    strokeAlign: StrokeAlign.outside,
  ),
);

RoundedRectangleBorder borderCartScreen = RoundedRectangleBorder(
  side: const BorderSide(
    color: Colors.deepOrange,
    width: 2.0,
    strokeAlign: StrokeAlign.outside,
  ),
  borderRadius: BorderRadius.circular(20.0),
);

RoundedRectangleBorder snackBarShape = RoundedRectangleBorder(
  side: BorderSide(
    color: Colors.teal.shade900,
    width: 3.0,
    strokeAlign: StrokeAlign.inside,
  ),
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(30.0),
    topRight: Radius.circular(30.0),
  ),
);
