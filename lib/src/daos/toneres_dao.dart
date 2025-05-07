import 'package:drift/drift.dart';
import '../base/database.dart';

part 'toneres_dao.g.dart';

@DriftAccessor(tables: [Toneres])
class ToneresDao extends DatabaseAccessor<AppDatabase>
    with _$ToneresDaoMixin {
  ToneresDao(AppDatabase db) : super(db);

  Stream<List<Tonere>> watchAll() =>
    select(toneres).watch();

  Future<int> insertOne(ToneresCompanion entry) =>
    into(toneres).insert(entry);

  Future<bool> updateOne(Insertable<Tonere> data) =>
    update(toneres).replace(data);

  Future<int> deleteById(int id) =>
    (delete(toneres)..where((t) => t.id.equals(id))).go();
}
