import 'package:server/server.dart';

class Fach extends ManagedObject<_Fach> implements _Fach {}

class _Fach {
  @primaryKey
  int fach_id;

  @Column(unique: false)
  String fach_name;

  @Column(unique: false)
  String fach_gewichtung;

  @Column(unique: false)
  double fach_durchschnitt;

  @Column(unique: false)
  int semester_id;
}
