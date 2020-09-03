import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String _token, _userId;
  DateTime _expiryDate;
  Timer _timer;

  Future sign(String email, String password, String method) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$method?key=AIzaSyBP90kTmoF_plI7J93mAafC75o_0AslPNU';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final responseBody = json.decode(response.body);
      if (responseBody['error'] != null) {
        throw HttpException(responseBody['error']['message']);
      }
      _token = responseBody['idToken'];
      _userId = responseBody['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseBody['expiresIn'])));
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      prefs.setString('token', _token);
      prefs.setString('userId', _userId);
      prefs.setString('email', email);
      prefs.setString('password', password);
      prefs.setString('expiryDate', _expiryDate.toString());

      notifyListeners();
      _autoLogout();
    } catch (error) {
      throw error;
    }
  }

  Future autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs != null &&
        prefs.getString('token') != null &&
        prefs.getString('userId') != null &&
        prefs.getString('expiryDate') != null) {
      sign(prefs.getString('email'), prefs.getString('password'), 'signInWithPassword');
    }
    return;
  }

  String get token {
    if (_token != null && _expiryDate != null && _expiryDate.isAfter(DateTime.now())) return _token;
    return null;
  }

  bool get authorized {
    return token != null;
  }

  Future signUp(String email, String password) async {
    return sign(email, password, 'signUp');
  }

  Future signIn(String email, String password) async {
    return sign(email, password, 'signInWithPassword');
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    notifyListeners();
  }

  void _autoLogout() {
    if (_timer != null) {
      _timer.cancel();
    }
    final remainingSeconds = _expiryDate.difference(DateTime.now()).inSeconds;
    _timer = Timer(Duration(seconds: remainingSeconds), logout);
  }

  get userId => _userId;

  DateTime get expiryDate => _expiryDate;
}
