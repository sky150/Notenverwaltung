import 'package:aqueduct/aqueduct.dart';
import 'package:server/model/semester.dart';
import 'package:server/server.dart';

class SemesterController extends ResourceController {
  SemesterController(this.context);

  final ManagedContext context;

  @Operation.post()
  Future<Response> createSemester(@Bind.body() Semester inputSemester) async {
    final query = Query<Semester>(context)..values = inputSemester;

    final insertedSemester = await query.insert();

    return Response.ok(insertedSemester);
  }

  @Operation.delete('id')
  Future<Response> deleteSemesterByID(@Bind.path('id') int id) async {
    final semesterQuery = Query<Semester>(context)
      ..where((s) => s.semester_id).equalTo(id);
    final semester = await semesterQuery.delete();
    if (semester == null) {
      return Response.notFound();
    }
    return Response.ok(semester);
  }

  @Operation.put('id')
  Future<Response> updateSemesterById(
      @Bind.path('id') int id, @Bind.body() Semester inputSemester) async {
    final semesterQuery = Query<Semester>(context)
      ..where((s) => s.semester_id).equalTo(id)
      ..values = inputSemester;
    final semester = await semesterQuery.updateOne();
    if (semester == null) {
      return Response.notFound();
    }
    return Response.ok(semester);
  }

  @Operation.get()
  Future<Response> getAllSemester() async {
    final semesterQuery = Query<Semester>(context);
    final semester = await semesterQuery.fetch();
    return Response.ok(semester);
  }

  @Operation.get('id')
  Future<Response> getSemesterByID(@Bind.path('id') int id) async {
    final semesterQuery = Query<Semester>(context)
      ..where((s) => s.semester_id).equalTo(id);
    final semester = await semesterQuery.fetchOne();
    if (semester == null) {
      return Response.notFound();
    }
    return Response.ok(semester);
  }
}
