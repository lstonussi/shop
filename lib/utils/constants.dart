import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  final Map<String, String> env = DotEnv().env;
  static const BASE_API_URL = 'https://flutter-cod3r-b0224.firebaseio.com';

  static const BASE_API_SIGNIN_SIGNUP =
      'https://identitytoolkit.googleapis.com/v1/accounts:';
}
