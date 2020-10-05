import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/store.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/utils/constants.dart';

class Auth with ChangeNotifier {
  final Map<String, String> env = DotEnv().env;

  String _token;
  DateTime _expireDate;
  String _userId;
  Timer _logoutTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return isAuth ? _userId : null;
  }

  String get token {
    if (_token != null &&
        (_expireDate != null && _expireDate.isAfter(DateTime.now())))
      return _token;
    else
      return null;
  }

  Future<void> _authenticate(
      String email, String pass, String urlSegment) async {
    final String url =
        '${Constants.BASE_API_SIGNIN_SIGNUP}$urlSegment?key=${env['API_KEY']}';
    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': pass,
          'returnSecureToken': true,
        },
      ),
    );
    final responseBody = json.decode(response.body);
    if (responseBody['error'] != null) {
      throw AuthException(responseBody['error']['message']);
    } else {
      _token = responseBody['idToken'];
      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseBody['expiresIn']),
        ),
      );
      _userId = responseBody['localId'];

      Store.saveMap('userData', {
        'token': _token,
        'userId': _userId,
        'expireDate': _expireDate.toIso8601String(),
      });
      _autoLogout();
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) {
      return Future.value();
    }

    final userData = await Store.getMap('userData');

    if (userData == null) {
      return Future.value();
    }

    final expireDate = DateTime.parse(userData['expireDate']);
    if (expireDate.isBefore(DateTime.now())) {
      return Future.value();
    }
    _userId = userData['userId'];
    _token = userData['token'];
    _expireDate = expireDate;
    _autoLogout();
    notifyListeners();
    return Future.value();
  }

  Future<void> signIn(String email, String pass) async {
    return _authenticate(email, pass, 'signInWithPassword');
  }

  Future<void> signUp(String email, String pass) async {
    return _authenticate(email, pass, 'signUp');
  }

  void logout() {
    _token = null;
    _userId = null;
    _expireDate = null;
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
      _logoutTimer = null;
    }
    Store.remove('userData');
    notifyListeners();
  }

  void _autoLogout() {
    final timeLogout = _expireDate.difference(DateTime.now()).inSeconds;
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
    }
    _logoutTimer = Timer(Duration(seconds: timeLogout), logout);
  }
}
