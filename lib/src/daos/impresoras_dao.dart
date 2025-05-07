import 'package:drift/drift.dart';
import '../base/database.dart';

part 'impresoras_dao.g.dart';

@DriftAccessor(tables: [Impresoras])
class ImpresorasDao extends DatabaseAccessor<AppDatabase>
    with _$ImpresorasDaoMixin {
  ImpresorasDao(AppDatabase db) : super(db);

  Stream<List<Impresora>> watchAll() =>
    select(impresoras).watch();

  Future<int> insertOne(ImpresorasCompanion entry) =>
    into(impresoras).insert(entry);

  Future<bool> updateOne(Insertable<Impresora> data) =>
    update(impresoras).replace(data);

  Future<int> deleteById(int id) =>
    (delete(impresoras)..where((t) => t.id.equals(id))).go();
}
