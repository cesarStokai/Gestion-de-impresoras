import 'package:drift/drift.dart';
import '../base/database.dart';

part 'requisiciones_dao.g.dart';

@DriftAccessor(tables: [Requisiciones])
class RequisicionesDao extends DatabaseAccessor<AppDatabase>
    with _$RequisicionesDaoMixin {
  RequisicionesDao(super.db);

  Stream<List<Requisicione>> watchAll() =>
    select(requisiciones).watch();

  Future<int> insertOne(RequisicionesCompanion entry) =>
    into(requisiciones).insert(entry);

  Future<bool> updateOne(Insertable<Requisicione> row) =>
    update(requisiciones).replace(row);

  Future<int> deleteById(int id) =>
    (delete(requisiciones)..where((t) => t.id.equals(id))).go();

      Future<Requisicione?> getById(int id) => 
      (select(requisiciones)..where((t) => t.id.equals(id))).getSingleOrNull();

      Future<List<Requisicione>> getAll() => select(requisiciones).get();

  
}
