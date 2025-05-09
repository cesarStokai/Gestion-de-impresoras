import 'package:drift/drift.dart';
import '../base/database.dart';

part 'toneres_dao.g.dart';

@DriftAccessor(tables: [Toneres])
class ToneresDao extends DatabaseAccessor<AppDatabase> with _$ToneresDaoMixin {
  ToneresDao(super.db);  // Corregido el parámetro db con super

  // Método CORRECTO para contar tóneres por estado
  Future<Map<String, int>> countTonersByState() async {
    // Consulta personalizada para contar por estado
    final query = customSelect(
      'SELECT estado, COUNT(id) as count FROM toneres GROUP BY estado',
      readsFrom: {toneres},
    );

    final results = await query.get();

    // Procesamos los resultados
    final countMap = <String, int>{};
    for (final row in results) {
      final estado = row.read<String>('estado');
      final count = row.read<int>('count');
      countMap[estado] = count;
    }

    return countMap;
  }

  // Métodos básicos del DAO
  Stream<List<Tonere>> watchAll() => select(toneres).watch();

  Future<int> insertOne(ToneresCompanion entry) => into(toneres).insert(entry);

  Future<bool> updateOne(Insertable<Tonere> data) => update(toneres).replace(data);

  Future<int> deleteById(int id) => 
    (delete(toneres)..where((t) => t.id.equals(id))).go();

      Future<Tonere?> getById(int id) => 
      (select(toneres)..where((t) => t.id.equals(id))).getSingleOrNull();
  
  Future<List<Tonere>> getAll() => select(toneres).get();

}