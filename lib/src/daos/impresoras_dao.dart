import 'package:drift/drift.dart';
import 'package:drift/drift.dart' as drift;
import '../base/database.dart';
import '../daos/toneres_dao.dart';

part 'impresoras_dao.g.dart';

@DriftAccessor(tables: [Impresoras])
class ImpresorasDao extends DatabaseAccessor<AppDatabase>
    with _$ImpresorasDaoMixin {
  ImpresorasDao(super.db);

  Stream<List<Impresora>> watchAll() => select(impresoras).watch();

  Future<int> insertOne(ImpresorasCompanion entry) =>
      into(impresoras).insert(entry);

  Future<bool> updateOne(Insertable<Impresora> data) =>
      update(impresoras).replace(data);

  Future<int> deleteById(int id) =>
      (delete(impresoras)..where((t) => t.id.equals(id))).go();

  Future<Impresora?> getImpresoraById(int id) =>
      (select(impresoras)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Impresora>> getAllImpresoras() => select(impresoras).get();

  Future<List<Impresora>> getImpresorasActivas() =>
      (select(impresoras)..where((t) => t.estado.equals('activa'))).get();

  Future<Impresora?> getById(int id) =>
      (select(impresoras)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Impresora>> getAll() => select(impresoras).get();
  
}
