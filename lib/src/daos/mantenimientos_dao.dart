import 'package:drift/drift.dart';
import '../base/database.dart';

part 'mantenimientos_dao.g.dart';

@DriftAccessor(tables: [Mantenimientos])
class MantenimientosDao extends DatabaseAccessor<AppDatabase>
    with _$MantenimientosDaoMixin {
  MantenimientosDao(super.db);

  // Métodos existentes
  Stream<List<Mantenimiento>> watchAll() => select(mantenimientos).watch();

  Future<int> insertOne(MantenimientosCompanion entry) => 
      into(mantenimientos).insert(entry);

  Future<bool> updateOne(Insertable<Mantenimiento> data) => 
      update(mantenimientos).replace(data);

  Future<int> deleteById(int id) => 
      (delete(mantenimientos)..where((t) => t.id.equals(id))).go();

  // Nuevos métodos necesarios
  Future<Mantenimiento?> getMantenimientoById(int id) =>
      (select(mantenimientos)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Mantenimiento>> getAllMantenimientos() =>
      select(mantenimientos).get();

  // Métodos para relación con impresoras (si los necesitas)
  Future<List<Mantenimiento>> getMantenimientosByImpresoraId(int impresoraId) =>
      (select(mantenimientos)..where((t) => t.impresoraId.equals(impresoraId))).get();
}