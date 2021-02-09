import 'package:server/server.dart';

class Note extends ManagedObject<_Noten> implements _Noten {}

class _Noten {
  @primaryKey
  int note_id;

  @Column(unique: false)
  double note;

  @Column(unique: false)
  String note_gewichtung;

  @Column(unique: false)
  String note_datum;

  @Column(unique: false)
  String note_name;

  @Column(unique: false)
  int fach_id;
}
