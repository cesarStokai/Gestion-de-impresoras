import 'package:drift/drift.dart';
import '../base/database.dart';

part 'requisiciones_dao.g.dart';

@DriftAccessor(tables: [Requisiciones])
class RequisicionesDao extends DatabaseAccessor<AppDatabase>
    with _$RequisicionesDaoMixin {
  RequisicionesDao(AppDatabase db) : super(db);



  Future<int> insertOne(RequisicionesCompanion entry) =>
    into(requisiciones).insert(entry);


  Future<int> deleteById(int id) =>
    (delete(requisiciones)..where((t) => t.id.equals(id))).go();
}
