import 'package:aqueduct/aqueduct.dart';
import 'package:server/model/note.dart';
import 'package:server/server.dart';

class NotenController extends ResourceController {
  NotenController(this.context);

  final ManagedContext context;
  //final _noten = [
  //  {'id': 1, 'note': '4.6', 'gewichtung': '1'},
  //  {'id': 2, 'note': '5.3', 'gewichtung': '2'},
  //  {'id': 3, 'note': '3.7', 'gewichtung': '1'},
  //];
  @Operation.post()
  Future<Response> createNote(@Bind.body() Note inputNote) async {
    final query = Query<Note>(context)..values = inputNote;

    final insertedNote = await query.insert();

    return Response.ok(insertedNote);
  }

  @Operation.delete('id')
  Future<Response> deleteNoteByID(@Bind.path('id') int id) async {
    final noteQuery = Query<Note>(context)..where((n) => n.id).equalTo(id);
    final note = await noteQuery.delete();
    if (note == null) {
      return Response.notFound();
    }
    return Response.ok(note);
  }

  @Operation.put('id')
  Future<Response> updateNoteById(
      @Bind.path('id') int id, @Bind.body() Note inputNote) async {
    final noteQuery = Query<Note>(context)
      ..where((n) => n.id).equalTo(id)
      ..values = inputNote;
    final note = await noteQuery.updateOne();
    if (note == null) {
      return Response.notFound();
    }
    return Response.ok(note);
  }

  @Operation.get()
  Future<Response> getAllNoten() async {
    final noteQuery = Query<Note>(context);
    final noten = await noteQuery.fetch();
    return Response.ok(noten);
  }

  @Operation.get('id')
  Future<Response> getNoteByID(@Bind.path('id') int id) async {
    final noteQuery = Query<Note>(context)..where((n) => n.id).equalTo(id);
    final note = await noteQuery.fetchOne();
    if (note == null) {
      return Response.notFound();
    }
    return Response.ok(note);
  }
}
