import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/home/home_screen.dart';
import 'package:notenverwaltung/authentication_service.dart';
import 'package:notenverwaltung/login_screen.dart';
import 'package:provider/provider.dart';
import 'global.dart';

//Update verbessern: wenn man zurück geht wird der neue durchschnitt nicht
//angezeigt. Bei fach und semester
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance)),
        StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notenverwaltung',
        theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          primaryColor: kPrimaryColor,
          textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final firebaseuser = context.watch<User>();

    if (firebaseuser != null) {
      return HomeScreen();
    }
    return LoginScreen();
    //throw HomeScreen();
  }
}
