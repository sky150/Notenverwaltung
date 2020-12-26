import 'package:server/server.dart';

class Semester extends ManagedObject<_Semester> implements _Semester {}

class _Semester {
  @primaryKey
  int id;

  @Column(unique: false)
  String name;

  @Column(unique: false)
  double durchschnitt;

  @Column(unique: false)
  String jahr;

  @Column(nullable: true)
  String notiz;
}
