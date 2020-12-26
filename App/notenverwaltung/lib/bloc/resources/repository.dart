import 'dart:async';
import 'package:notenverwaltung/bloc/resources/api.dart';
import 'package:notenverwaltung/models/classes/user.dart';

class Repository {
  final moviesApiProvider = ApiProvider();

  Future<User> registerUser(String username, String firstname, String lastname,
          String password, String email) =>
      moviesApiProvider.registerUser(
          username, firstname, lastname, password, email);
}
