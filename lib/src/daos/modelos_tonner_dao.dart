import 'package:drift/drift.dart';
import '../base/database.dart';

part 'modelos_tonner_dao.g.dart';

@DriftAccessor(tables: [ModelosTonner, ModeloTonnerCompatible, Toneres, Impresoras])
class ModelosTonnerDao extends DatabaseAccessor<AppDatabase> with _$ModelosTonnerDaoMixin {
  // Crear un nuevo modelo de tóner
  Future<int> crearModeloTonner({required String nombre}) {
    return into(modelosTonner).insert(ModelosTonnerCompanion(
      nombre: Value(nombre),
    ));
  }
  /// Elimina la compatibilidad entre un modelo de tóner y un modelo de impresora
  Future<int> eliminarCompatibilidad({required String modeloImpresora, required int modeloTonnerId}) {
    return (delete(modeloTonnerCompatible)
      ..where((tbl) => tbl.modeloImpresora.equals(modeloImpresora) & tbl.modeloTonnerId.equals(modeloTonnerId)))
      .go();
  }
  ModelosTonnerDao(AppDatabase db) : super(db);

  // Obtener todos los modelos de tóner
  Future<List<ModelosTonnerData>> getAllModelosTonner() => select(modelosTonner).get();

  // Obtener todos los modelos de tóner compatibles con un modelo de impresora
  Future<List<ModelosTonnerData>> getModelosTonnerCompatibles(String modeloImpresora) async {
    final query = select(modelosTonner).join([
      innerJoin(modeloTonnerCompatible, modeloTonnerCompatible.modeloTonnerId.equalsExp(modelosTonner.id)),
    ])..where(modeloTonnerCompatible.modeloImpresora.equals(modeloImpresora));
    final rows = await query.get();
    return rows.map((row) => row.readTable(modelosTonner)).toList();
  }

  // Obtener stock de tóneres disponibles para un modelo de impresora
  Future<List<Tonere>> getTonnersDisponiblesParaModeloImpresora(String modeloImpresora) async {
    final compatibles = await getModelosTonnerCompatibles(modeloImpresora);
    if (compatibles.isEmpty) return [];
    final idsCompatibles = compatibles.map((e) => e.id).toList();
    return (select(toneres)
      ..where((t) => t.modeloTonnerId.isIn(idsCompatibles) & t.estado.equals('almacenado'))).get();
  }

  // Relacionar un modelo de tóner con un modelo de impresora
  Future<int> agregarCompatibilidad({required String modeloImpresora, required int modeloTonnerId}) {
    return into(modeloTonnerCompatible).insert(ModeloTonnerCompatibleCompanion(
      modeloImpresora: Value(modeloImpresora),
      modeloTonnerId: Value(modeloTonnerId),
    ));
  }

  // Devuelve la lista de modelos de impresora compatibles para un modelo de tóner dado
  Future<List<String>> getModelosImpresoraCompatiblesPorToner(int modeloTonnerId) async {
    final query = select(modeloTonnerCompatible)
      ..where((tbl) => tbl.modeloTonnerId.equals(modeloTonnerId));
    final rows = await query.get();
    return rows.map((row) => row.modeloImpresora).toList();
  }
}
