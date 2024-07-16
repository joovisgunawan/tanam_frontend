import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get mongoUrl => dotenv.env['MONGO_URI'] ?? '';
  static String get mongoDbName => dotenv.env['MONGO_DB_NAME'] ?? '';
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['TANAM_API_KEY'] ?? '';
}
