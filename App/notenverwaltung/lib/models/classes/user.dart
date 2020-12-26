class User {
  String firstname;
  String lastname;
  String username;
  String email;
  String password;
  String api_key;
  String id;

  User(this.firstname, this.lastname, this.email, this.username, this.password,
      this.api_key, this.id);

  User.fromJson(Map<String, dynamic> parsedJson) {
    User user = new User(
        parsedJson['firstname'],
        parsedJson['lastname'],
        parsedJson['email'],
        parsedJson['username'],
        parsedJson['password'],
        parsedJson['api_key'],
        parsedJson['id']);
  }
}
