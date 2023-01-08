import 'dart:convert';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

const String apiKey = '';

class Auth with ChangeNotifier {
  String _token = 'null';
  late DateTime _expiryDate;
  late String _userId;
  late Timer _authTimer;
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
    if (_userId != 'null') {
      return _userId;
    }
    return 'null';
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
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      //_autoLogout();

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();

      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String()
      });

      await prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }

    // print(json.decode(response.body));
    // print(json.decode(response.statusCode.toString()));
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
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

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'] ?? 'null';
    _userId = extractedUserData['userId'] ?? 'null';
    _expiryDate = expiryDate;
    notifyListeners();

    _autoLogout();

    return true;
  }

  Future<void> logout() async {
    _token = 'null';
    _userId = 'null';
    _expiryDate = DateTime.now();
    //  if (_authTimer != null) {

    _authTimer.cancel();
    _authTimer = Timer(const Duration(seconds: 0), () {});
    // }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    print('heeyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy');

    print(prefs.getString('userData'));
    await prefs.remove('userData');
    print(prefs.getString('userData'));

    await prefs.clear();
    print(prefs.getString('userData'));

    await prefs.reload();
    print(prefs.getString('userData'));
  }

  void _autoLogout() {
    //    if (_authTimer != null) {
    _authTimer.cancel();
    //   }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
