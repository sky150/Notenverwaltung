import 'package:notenverwaltung/models/classes/user.dart';
import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';

class UserBloc {
  final _repository = Repository();
  final _userGetter = PublishSubject<User>();

  Observable<User> get getUser => _userGetter.stream;

  registerUser(String username, String firstname, String lastname,
      String password, String email) async {
    User user = await _repository.registerUser(
        username, firstname, lastname, password, email);
    _userGetter.sink.add(user);
  }

  dispose() {
    _userGetter.close();
  }
}

final bloc = UserBloc();
