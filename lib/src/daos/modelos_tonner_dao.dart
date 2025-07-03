import 'package:drift/drift.dart';
import '../base/database.dart';

part 'modelos_tonner_dao.g.dart';

@DriftAccessor(tables: [ModelosTonner, ModeloTonnerCompatible, Toneres, Impresoras])
class ModelosTonnerDao extends DatabaseAccessor<AppDatabase> with _$ModelosTonnerDaoMixin {
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
}
