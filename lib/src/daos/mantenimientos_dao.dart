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

        Future<Mantenimiento?> getById(int id) => 
      (select(mantenimientos)..where((t) => t.id.equals(id))).getSingleOrNull();

      Future<List<Mantenimiento>> getAll() => select(mantenimientos).get();

  /// Obtiene todos los mantenimientos (con datos de impresora) en un rango de fechas
  Future<List<Map<String, dynamic>>> getMantenimientosPorRangoFechas(DateTime desde, DateTime hasta) async {
    final query = select(mantenimientos).join([
      leftOuterJoin(impresoras, impresoras.id.equalsExp(mantenimientos.impresoraId)),
    ])
      ..where(mantenimientos.fecha.isBiggerOrEqualValue(desde))
      ..where(mantenimientos.fecha.isSmallerOrEqualValue(hasta));

    final rows = await query.get();
    return rows.map((row) {
      final mant = row.readTable(mantenimientos);
      final imp = row.readTableOrNull(impresoras);
      return {
        'id': mant.id,
        'impresoraId': mant.impresoraId,
        'fecha': mant.fecha,
        'detalle': mant.detalle,
        'reemplazoImpresora': mant.reemplazoImpresora,
        'nuevaImpresoraId': mant.nuevaImpresoraId,
        'marca': imp?.marca,
        'modelo': imp?.modelo,
        'area': imp?.area,
        'serie': imp?.serie,
        'tipo': 'mantenimiento',
      };
    }).toList();
  }

}