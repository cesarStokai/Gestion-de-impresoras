import 'package:drift/drift.dart';
import '../base/database.dart';

part 'mantenimientos_dao.g.dart';

@DriftAccessor(tables: [Mantenimientos])
class MantenimientosDao extends DatabaseAccessor<AppDatabase>
    with _$MantenimientosDaoMixin {
  MantenimientosDao(AppDatabase db) : super(db);

  Stream<List<Mantenimiento>> watchAll() =>
    select(mantenimientos).watch();

  Future<int> insertOne(MantenimientosCompanion entry) =>
    into(mantenimientos).insert(entry);

  Future<bool> updateOne(Insertable<Mantenimiento> data) =>
    update(mantenimientos).replace(data);

  Future<int> deleteById(int id) =>
    (delete(mantenimientos)..where((t) => t.id.equals(id))).go();
}
