import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'fach.dart';
import 'note.dart';
import 'semester.dart';

final databaseReference = FirebaseDatabase.instance.reference();
final firestoreInstance = FirebaseFirestore.instance;

//Get Notenschnitt

//Semester
Future<List<Semester>> getAllSemester() async {
  //DataSnapshot dataSnapshot = await databaseReference.child('semester/').once();
  List<Semester> semesterList = [];
  /*if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      Semester semester = createSemester(value);
      semester.setId(databaseReference.child('semester/' + key));
      semesterList.add(semester);
    });
  }*/
  firestoreInstance.collection("semester/").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      //print("1. database = result.data(): " + result.data().toString());
      Semester semester = createSemester(result.data());
      print(databaseReference.child('semester/' + result.id).toString());
      semester.setId(databaseReference.child('semester/' + result.id));
      semesterList.add(semester);
    });
  });
  if (semesterList.isEmpty) {
    return [];
  } else {
    return semesterList;
  }
}

DatabaseReference saveSemester(Semester semester) {
  /*var id = databaseReference.child('semester/').push();
  id.set(semester.toJson());
  return id;*/
  print(firestoreInstance.toString());
  print(databaseReference.toString());
  firestoreInstance
      .collection('semester/')
      .add(semester.toJson())
      .then((value) => {print(value.id)});
}

void updateS(Semester semester, String id) {
  print(semester.toJson());
  //print(semester.id.key);
  firestoreInstance
      .collection('semester/')
      .doc(id)
      .update(semester.toJson())
      .then((value) => print("success!"));
  //id.update(semester.toJson());
}

/*Future deleteSemester(context) async {
  var uuid = await Provider.of(context).auth.getCurrentUID;
}*/

void deleteSemester(String id) {
  print(id);
  firestoreInstance
      .collection('semester/')
      .doc(id)
      .delete()
      .then((value) => print("success!"));

  //id.remove();
}

//Fach
DatabaseReference saveFach(Fach fach, String semesterId) {
  print(firestoreInstance.toString());
  print(databaseReference.toString());
  firestoreInstance
      .collection('semester/' + semesterId + '/fach/')
      .add(fach.toJson())
      .then((value) => {print(value.id)});
  /*var id =
      databaseReference.child('semester/' + semesterId.key + '/fach/').push();
  id.set(fach.toJson());
  return id;*/
}

void updateFach(Fach fach, String id, String semesterId) {
  firestoreInstance
      .collection("semester/" + semesterId + "/fach/")
      .doc(id)
      .update(fach.toJson())
      .then((value) => print("success!"));
}

void deleteFach(String semesterId, String fachId) {
  /*List<String> path = id.path.split(id.key);
  print(path[0]);*/

  firestoreInstance
      .collection("semester/" + semesterId + "/fach/")
      .doc(fachId)
      .delete()
      .then((value) => print("success!"));
}

Future<List<Fach>> getAllFach(String id) async {
  /*DataSnapshot dataSnapshot =
      await databaseReference.child('semester/' + id + '/fach/').once();*/
  List<Fach> fachList = [];
  /*if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      Fach fach = createFach(value);
      fach.setId(
          databaseReference.child('semester/' + id.key + '/fach/' + key));
      fachList.add(fach);
    });
  }*/
  //getFachschnitt(fachList, id);
  final firestoreInstance = FirebaseFirestore.instance;
  String coll = "semester/" + id + "/fach/";
  firestoreInstance.collection(coll).get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      Fach fach = createFach(result.data());
      print(result.data());
      fach.setId(
          databaseReference.child('semester/' + id + '/fach/' + result.id));
      fachList.add(fach);
    });
  });
  //getFachschnitt(fachList, id);
  return fachList;
}

void updateFachschnitt(double schnitt, String semesterId) {
  //List<String> path = semesterId.split("/");
  firestoreInstance.collection("semester/").doc(semesterId).update(
      {'semester_durchschnitt': schnitt}).then((value) => print("success!"));

  //semesterId.update({'semester_durchschnitt': schnitt});
  //print("updated semester_durchschnitt");
}

double getFachschnitt(List list, String semesterId) {
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
DatabaseReference saveNote(Note note, String fachId) {
  /*var id = databaseReference.child(fachId.path + '/note/').push();
  print("fach path " + fachId.path);
  /*databaseReference.parent();*/
  id.set(note.toJson());
  return id;*/
  String id;
  print("Neue Fach id = " + fachId);
  firestoreInstance
      .collection(fachId + '/note/')
      .add(note.toJson())
      .then((value) => print("success!"));
  //print("Neue Note id = " + id);
  //print("Neue Fach id = " + fachId);
  /*DatabaseReference newFachId = FirebaseDatabase.instance.reference().child(id);
  print("Neue Rückgabewert = " + newFachId.key);
  return newFachId;*/
}

void updateNote(Note note, String id, String fachId) {
  /*print(id.path);
  print(id.path.split(id.key));
  List<String> path = id.path.split(id.key);
  print(path[0]);*/
  firestoreInstance
      .collection(fachId + "/note/")
      .doc(id)
      .update(note.toJson())
      .then((value) => print("success!"));

  //id.update(note.toJson());
}

void deleteNote(String path, String id) {
  firestoreInstance
      .collection(path + "/note/")
      .doc(id)
      .delete()
      .then((value) => print("success!"));
}

Future<List<Note>> getAllNote(DatabaseReference id) async {
  /*print("GETALL: " + id.path + '/note/');
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
  }*/
  List<Note> noteList = [];
  firestoreInstance.collection(id.path + '/note/').get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      Note note = createNote(result.data());
      print(result.data());
      note.setId(databaseReference.child(id.path + '/note/' + result.id));
      noteList.add(note);
    });
  });

  getNotenschnitt(noteList, id.path);
  return noteList;
}

void updateNotenschnitt(double schnitt, String fachId) {
  List<String> path = fachId.split("/");
  print(path[0] + path[1] + path[2]);
  print("splitt");
  print(path[3]);
  firestoreInstance
      .collection(path[0] + "/" + path[1] + "/" + path[2])
      .doc(path[3])
      .update({'fach_durchschnitt': schnitt}).then(
          (value) => print("success!"));
}

double getNotenschnitt(List list, String fachId) {
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
  print(fachId);
  updateNotenschnitt(schnitt, fachId);

  return schnitt;
}
