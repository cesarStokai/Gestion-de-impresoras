// lib/src/daos/requisiciones_dao.dart

import 'package:drift/drift.dart';
import '../base/database.dart';

part 'requisiciones_dao.g.dart';

@DriftAccessor(tables: [Requisiciones])
class RequisicionesDao extends DatabaseAccessor<AppDatabase>
    with _$RequisicionesDaoMixin {
  RequisicionesDao(AppDatabase db) : super(db);

  // ─── R ───
  Stream<List<Requisicione>> watchAll() =>
    select(requisiciones).watch();

  // ─── C ───
  Future<int> insertOne(RequisicionesCompanion entry) =>
    into(requisiciones).insert(entry);

  // ─── U ───
  Future<bool> updateOne(Insertable<Requisicione> row) =>
    update(requisiciones).replace(row);

  // ─── D ───
  Future<int> deleteById(int id) =>
    (delete(requisiciones)..where((t) => t.id.equals(id))).go();
}
