import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  String _token, _userId;
  DateTime _expiryDate;

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
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  bool get authorized {
    if (_token != null && _userId != null && _expiryDate.isAfter(DateTime.now())) return true;
    return false;
  }

  Future signUp(String email, String password) async {
    return sign(email, password, 'accounts:signUp');
  }

  Future signIn(String email, String password) async {
    return sign(email, password, 'signInWithPassword');
  }
}
