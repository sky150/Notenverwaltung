import 'package:http/http.dart' show Client;
import 'dart:developer';
import 'dart:async';
import 'dart:convert';
import 'package:notenverwaltung/models/classes/user.dart';

class ApiProvider {
  Client client = Client();
  final _apiKey = 'your_api_key';

  Future<User> registerUser(String username, String firstname, String lastname,
      String password, String email) async {
    print(username +
        " " +
        firstname +
        " " +
        lastname +
        " " +
        password +
        " " +
        email);
    final response = await client.post("http://127.0.0.1:5000/api/register",
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "username": username,
          "firstname": firstname,
          "lastname": lastname,
          "password": password,
          "email": email
        }));
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return User.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
