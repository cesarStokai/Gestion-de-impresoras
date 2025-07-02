import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../base/database.dart';
import '../daos/impresoras_dao.dart';
import '../daos/toneres_dao.dart';
import '../daos/requisiciones_dao.dart';
import '../daos/mantenimientos_dao.dart';
import '../daos/documentos_dao.dart';
import '../daos/contadores_dao.dart';

/// Base de datos
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// DAO providers
final impresorasDaoProvider = Provider<ImpresorasDao>(
  (ref) => ImpresorasDao(ref.watch(databaseProvider)),
);
final toneresDaoProvider = Provider<ToneresDao>(
  (ref) => ToneresDao(ref.watch(databaseProvider)),
);
final requisicionesDaoProvider = Provider<RequisicionesDao>(
  (ref) => RequisicionesDao(ref.watch(databaseProvider)),
);
final mantenimientosDaoProvider = Provider<MantenimientosDao>(
  (ref) => MantenimientosDao(ref.watch(databaseProvider)),
);
final documentosDaoProvider = Provider<DocumentosDao>(
  (ref) => DocumentosDao(ref.watch(databaseProvider)),
);

final impresorasListStreamProvider =
    StreamProvider.autoDispose<List<Impresora>>(
  (ref) => ref.watch(impresorasDaoProvider).watchAll(),
);

final contadoresDaoProvider = Provider<ContadoresDao>(
  (ref) => ContadoresDao(ref.watch(databaseProvider)),
);

final toneresListStreamProvider = StreamProvider.autoDispose<List<Tonere>>(
  (ref) => ref.watch(toneresDaoProvider).watchAll(),
);

final requisicionesListStreamProvider =
    StreamProvider.autoDispose<List<Requisicione>>(
  (ref) => ref.watch(requisicionesDaoProvider).watchAll(),
);

final mantenimientosListStreamProvider =
    StreamProvider.autoDispose<List<Mantenimiento>>(
  (ref) => ref.watch(mantenimientosDaoProvider).watchAll(),
);





final documentosProvider = StreamProvider<List<Documento>>((ref) {
  final dao = ref.watch(documentosDaoProvider);
  return dao.watchAll();
});