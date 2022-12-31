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

InputDecoration textFormFieldEdit = const InputDecoration(
    //  labelText: 'Title',
    errorStyle: TextStyle(letterSpacing: 3),
    hintText: 'Enter Name of Your Product',
    // border: OutlineInputBorder(
    //   borderRadius: BorderRadius.all(Radius.circular(15)),
    // ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.teal),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(width: 3, color: Color.fromARGB(255, 100, 168, 201)),
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ));
