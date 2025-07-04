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

  /// Historial paginado de contadores, solo meses anteriores al actual
  Future<List<Map<String, dynamic>>> getHistorialPaginado(int page, int pageSize) async {
    final now = DateTime.now();
    final mesActual = "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}";
    final query = select(contadores).join([
      innerJoin(impresoras, impresoras.id.equalsExp(contadores.impresoraId)),
    ])
      ..where(contadores.mes.isSmallerThanValue(mesActual))
      ..orderBy([
        OrderingTerm(expression: contadores.mes, mode: OrderingMode.desc),
        OrderingTerm(expression: contadores.impresoraId),
      ])
      ..limit(pageSize, offset: page * pageSize);

    final rows = await query.get();
    return rows.map((row) {
      final cont = row.readTable(contadores);
      final imp = row.readTable(impresoras);
      return {
        'id': cont.id,
        'impresoraId': cont.impresoraId,
        'mes': cont.mes,
        'contador': cont.contador,
        'marca': imp.marca,
        'modelo': imp.modelo,
        'area': imp.area,
        'serie': imp.serie,
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getContadoresPorMeses() async {
  final query = select(contadores).join([
    innerJoin(impresoras, impresoras.id.equalsExp(contadores.impresoraId)),
  ]);
  final rows = await query.get();
  return rows.map((row) {
    final cont = row.readTable(contadores);
    final imp = row.readTable(impresoras);
    return {
      'id': cont.id,
      'impresoraId': cont.impresoraId,
      'mes': cont.mes, // Ej: "2024-06"
      'contador': cont.contador,
      'marca': imp.marca,
      'modelo': imp.modelo,
      'area': imp.area,
      'serie': imp.serie,
      'observaciones': cont.observaciones,
    };
  }).toList();
}


  /// Obtiene todos los registros de contadores (con datos de impresora) en un rango de fechas
  Future<List<Map<String, dynamic>>> getContadoresPorRangoFechas(DateTime desde, DateTime hasta) async {
    final query = select(contadores).join([
      innerJoin(impresoras, impresoras.id.equalsExp(contadores.impresoraId)),
    ])
      ..where(contadores.fechaRegistro.isBiggerOrEqualValue(desde))
      ..where(contadores.fechaRegistro.isSmallerOrEqualValue(hasta));

    final rows = await query.get();
    return rows.map((row) {
      final cont = row.readTable(contadores);
      final imp = row.readTable(impresoras);
      return {
        'id': cont.id,
        'impresoraId': cont.impresoraId,
        'fechaRegistro': cont.fechaRegistro,
        'contador': cont.contador,
        'marca': imp.marca,
        'modelo': imp.modelo,
        'area': imp.area,
        'serie': imp.serie,
        'observaciones': cont.observaciones,
      };
    }).toList();
  }
}
