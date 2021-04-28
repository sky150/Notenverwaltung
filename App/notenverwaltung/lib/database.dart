import 'package:firebase_database/firebase_database.dart';
import 'fach.dart';
import 'note.dart';
import 'semester.dart';

final databaseReference = FirebaseDatabase.instance.reference();

//Get Notenschnitt

//Semester
DatabaseReference saveSemester(Semester semester) {
  var id = databaseReference.child('semester/').push();
  id.set(semester.toJson());
  return id;
}

void updateS(Semester semester, DatabaseReference id) {
  print(semester.toJson());
  print(semester.id.key);
  id.update(semester.toJson());
}

/*Future deleteSemester(context) async {
  var uuid = await Provider.of(context).auth.getCurrentUID;
}*/
Future<List<Semester>> getAllSemester() async {
  DataSnapshot dataSnapshot = await databaseReference.child('semester/').once();
  List<Semester> semesterList = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      Semester semester = createSemester(value);
      semester.setId(databaseReference.child('semester/' + key));
      semesterList.add(semester);
    });
  }
  return semesterList;
}

void deleteSemester(DatabaseReference id) {
  id.remove();
}

//Fach
DatabaseReference saveFach(Fach fach, DatabaseReference semesterId) {
  var id =
      databaseReference.child('semester/' + semesterId.key + '/fach/').push();
  id.set(fach.toJson());
  return id;
}

void updateFach(Fach fach, DatabaseReference id) {
  id.update(fach.toJson());
}

void deleteFach(DatabaseReference id) {
  var idFach = databaseReference.child('fach/' + id.key + '/note/').push();
  print("Fachid: " + idFach.key);
  idFach.remove();
  id.remove();
}

/*Future deleteSemester(context) async {
  var uuid = await Provider.of(context).auth.getCurrentUID;
}*/
Future<List<Fach>> getAllFach(DatabaseReference id) async {
  DataSnapshot dataSnapshot =
      await databaseReference.child('semester/' + id.key + '/fach/').once();
  List<Fach> fachList = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      Fach fach = createFach(value);
      fach.setId(
          databaseReference.child('semester/' + id.key + '/fach/' + key));
      fachList.add(fach);
    });
  }
  return fachList;
}

void updateFachschnitt(double schnitt, DatabaseReference semesterId) {
  semesterId.update({'semester_durchschnitt': schnitt});
  print("updated semester_durchschnitt");
}

double getFachschnitt(List list, DatabaseReference semesterId) {
  double schnitt;
  if (list.isEmpty) {
    return 0.0;
  }
  double summeN = 0;
  double summeG = 0;
  double summeNG = 0;

  for (int i = 0; i < list.length; i++) {
    if (list[i].durchschnitt != null && list[i].gewichtung != null) {
      summeG = summeG + list[i].gewichtung / 100;
      summeN = summeN + list[i].durchschnitt;
      summeNG = summeNG + (list[i].durchschnitt * (list[i].gewichtung / 100));
    }
  }
  // (note*gewichtung)/summeG
  schnitt = summeNG / summeG;
  if (schnitt.isNaN) {
    schnitt = 0.0;
  }

  print("der schnitt: " + schnitt.toString());
  updateFachschnitt(schnitt, semesterId);

  return schnitt;
}

//Note
DatabaseReference saveNote(Note note, DatabaseReference fachId) {
  var id = databaseReference.child(fachId.path + '/note/').push();
  print("fach path " + fachId.path);
  /*databaseReference.parent();*/
  id.set(note.toJson());
  return id;
}

void updateNote(Note note, DatabaseReference id) {
  id.update(note.toJson());
}

void deleteNote(DatabaseReference id) {
  id.remove();
}

/*Future deleteSemester(context) async {
  var uuid = await Provider.of(context).auth.getCurrentUID;
}*/
Future<List<Note>> getAllNote(DatabaseReference id) async {
  print("GETALL: " + id.path + '/note/');
  DataSnapshot dataSnapshot =
      await databaseReference.child(id.path + '/note/').once();
  List<Note> noteList = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      Note note = createNote(value);
      note.setId(databaseReference.child(id.path + '/note/' + key));
      print("GETALL: " + id.path + '/note/' + key);
      noteList.add(note);
    });
  }
  return noteList;
}

void updateNotenschnitt(double schnitt, DatabaseReference fachId) {
  fachId.update({'fach_durchschnitt': schnitt});
  print("updated fachdurchschnitt");
}

double getNotenschnitt(List list, DatabaseReference fachId) {
  double schnitt;
  if (list.isEmpty) {
    return 0.0;
  }
  double summeN = 0;
  double summeG = 0;
  double summeNG = 0;

  for (int i = 0; i < list.length; i++) {
    summeG = summeG + list[i].gewichtung / 100;
    summeN = summeN + list[i].note;
    summeNG = summeNG + (list[i].note * (list[i].gewichtung / 100));
  }
  // (note*gewichtung)/summeG
  schnitt = summeNG / summeG;
  if (schnitt.isNaN) {
    schnitt = 0.0;
  }

  print("der schnitt: " + schnitt.toString());
  updateNotenschnitt(schnitt, fachId);

  return schnitt;
}
