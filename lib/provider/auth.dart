import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

const String apiKey = '';

class Auth with ChangeNotifier {
  String _token = 'null';
  late DateTime _expiryDate;
  late String _userId;

  bool get isAuth {
    return _token != 'null';
  }

  String get token {
    if (_token != 'null' &&
        _expiryDate.isAfter(DateTime.now()) &&
        _expiryDate != null) {
      return _token;
    }
    return 'null';
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _userId = responseData['localId'];
      notifyListeners();
    } catch (error) {
      rethrow;
    }

    // print(json.decode(response.body));
    // print(json.decode(response.statusCode.toString()));
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<dynamic> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');

    // final logInData = json.decode(response.body) as Map<String, dynamic>;
    // var isRegister;
    // logInData.forEach((key, value) {
    //   if (key == 'registered') {
    //     isRegister = value;
    //   }
    // });
    // return isRegister;
  }
}
