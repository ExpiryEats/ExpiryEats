import 'package:postgres/postgres.dart';

class DatabaseManager {
  String host = 'localhost';
  String database = '';
  String username = '';
  String password = '';

  void connect() async {
    final conn = await Connection.open(Endpoint(
      host: host,
      database: database,
      username: username,
      password: password,
    ));
  }
}