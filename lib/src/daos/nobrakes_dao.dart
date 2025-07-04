import 'package:drift/drift.dart';
import '../base/database.dart';

part 'nobrakes_dao.g.dart';

@DriftAccessor(tables: [NoBrakes])
class NoBrakesDao extends DatabaseAccessor<AppDatabase> with _$NoBrakesDaoMixin {
  NoBrakesDao(AppDatabase db) : super(db);

  Future<List<NoBrake>> getAll() => select(noBrakes).get();
  Stream<List<NoBrake>> watchAll() => select(noBrakes).watch();
  Future<int> insertOne(NoBrakesCompanion entry) => into(noBrakes).insert(entry);
  Future updateOne(NoBrake entry) => update(noBrakes).replace(entry);
  Future deleteById(int id) => (delete(noBrakes)..where((tbl) => tbl.id.equals(id))).go();
  Future<NoBrake?> getById(int id) => (select(noBrakes)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
}

@DriftAccessor(tables: [NoBrakeEventos])
class NoBrakeEventosDao extends DatabaseAccessor<AppDatabase> with _$NoBrakeEventosDaoMixin {
  NoBrakeEventosDao(AppDatabase db) : super(db);

  Future<List<NoBrakeEvento>> getByNoBrake(int noBrakeId) => (select(noBrakeEventos)..where((e) => e.noBrakeId.equals(noBrakeId))).get();
  Stream<List<NoBrakeEvento>> watchByNoBrake(int noBrakeId) => (select(noBrakeEventos)..where((e) => e.noBrakeId.equals(noBrakeId))).watch();
  Future<int> insertOne(NoBrakeEventosCompanion entry) => into(noBrakeEventos).insert(entry);
  Future updateOne(NoBrakeEvento entry) => update(noBrakeEventos).replace(entry);
  Future deleteById(int id) => (delete(noBrakeEventos)..where((tbl) => tbl.id.equals(id))).go();
}
