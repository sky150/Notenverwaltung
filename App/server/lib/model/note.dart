import 'package:server/server.dart';

class Note extends ManagedObject<_Noten> implements _Noten {}

class _Noten {
  @primaryKey
  int id;

  @Column(unique: false)
  String note;
}
