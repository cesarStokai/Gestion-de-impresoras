import 'package:drift/drift.dart';
import '../base/database.dart';

part 'contadores_dao.g.dart';

@DriftAccessor(tables: [Contadores, Impresoras])
class ContadoresDao extends DatabaseAccessor<AppDatabase> with _$ContadoresDaoMixin {
  ContadoresDao(AppDatabase db) : super(db);

  

  Future<List<Contadore>> getAll() => select(contadores).get();

  Stream<List<Contadore>> watchAll() => select(contadores).watch();

  Future<int> insertContador(ContadoresCompanion entry) => into(contadores).insert(entry);

  Future updateContador(Contadore entry) => update(contadores).replace(entry);

  Future deleteContador(int id) => (delete(contadores)..where((tbl) => tbl.id.equals(id))).go();

  // Obtener contadores por impresora y mes
  Future<Contadore?> getByImpresoraYMes(int impresoraId, String mes) {
    return (select(contadores)
      ..where((tbl) => tbl.impresoraId.equals(impresoraId) & tbl.mes.equals(mes)))
      .getSingleOrNull();
  }

  // Obtener todos los contadores de una impresora
  Future<List<Contadore>> getByImpresora(int impresoraId) {
    return (select(contadores)..where((tbl) => tbl.impresoraId.equals(impresoraId))).get();
  }

//Puedes crear el provider para este DAO si lo necesitas  



  // Obtener contadores por mes
  Future<List<Contadore>> getByMes(String mes) {
    return (select(contadores)..where((tbl) => tbl.mes.equals(mes))).get();
  }
}
