import 'package:aqueduct/aqueduct.dart';
import 'package:server/model/fach.dart';
import 'package:server/server.dart';

class FachController extends ResourceController {
  FachController(this.context);

  final ManagedContext context;

  @Operation.post()
  Future<Response> createFach(@Bind.body() Fach inputFach) async {
    final query = Query<Fach>(context)..values = inputFach;

    final insertedFach = await query.insert();

    return Response.ok(insertedFach);
  }

  @Operation.delete('id')
  Future<Response> deleteFachByID(@Bind.path('id') int id) async {
    final fachQuery = Query<Fach>(context)..where((s) => s.fach_id).equalTo(id);
    final fach = await fachQuery.delete();
    if (fach == null) {
      return Response.notFound();
    }
    return Response.ok(fach);
  }

  @Operation.put('id')
  Future<Response> updateFachById(
      @Bind.path('id') int id, @Bind.body() Fach inputFach) async {
    final fachQuery = Query<Fach>(context)
      ..where((s) => s.fach_id).equalTo(id)
      ..values = inputFach;
    final fach = await fachQuery.updateOne();
    if (fach == null) {
      return Response.notFound();
    }
    return Response.ok(fach);
  }

  @Operation.get()
  Future<Response> getAllFach() async {
    final fachQuery = Query<Fach>(context);
    final fach = await fachQuery.fetch();
    return Response.ok(fach);
  }

  @Operation.get('id')
  Future<Response> getFachByID(@Bind.path('id') int id) async {
    final fachQuery = Query<Fach>(context)..where((s) => s.fach_id).equalTo(id);
    final fach = await fachQuery.fetchOne();
    if (fach == null) {
      return Response.notFound();
    }
    return Response.ok(fach);
  }

  @Operation.get('semester_id')
  Future<Response> getSemesterByFach(@Bind.path('semester_id') int id) async {
    final fachQuery = Query<Fach>(context)
      ..where((s) => s.semester_id).equalTo(id);
    final fach = await fachQuery.fetch();
    if (fach == null) {
      return Response.notFound();
    }
    return Response.ok(fach);
  }
}
