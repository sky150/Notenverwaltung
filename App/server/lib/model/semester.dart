import 'package:server/server.dart';

class Semester extends ManagedObject<_Semester> implements _Semester {}

class _Semester {
  @primaryKey
  int semester_id;

  @Column(unique: false)
  String semester_name;

  @Column(unique: false)
  double semester_durchschnitt;

  @Column(unique: false)
  String semester_jahr;

  @Column(nullable: true)
  String semester_notiz;
}
