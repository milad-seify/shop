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

ButtonStyle authCardBTN = ButtonStyle(
  elevation: MaterialStateProperty.all(5.0),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(color: Colors.deepOrange, width: 2.0)),
  ),
  padding: MaterialStateProperty.all(
    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
  ),
  backgroundColor: MaterialStateProperty.all(
    Colors.black.withOpacity(0.7),
  ),
  textStyle: MaterialStateProperty.all(const TextStyle(
    color: Colors.white,
    //  backgroundColor: Colors.amber,
  )),
);

void errorDialogBox(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: ((ctx) => AlertDialog(
          title: const Text('ERROR'),
          content: Text(errorMessage),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.check),
            )
          ],
        )),
  );
}
