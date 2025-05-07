import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../base/database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Providers para cada DAO
final impresorasDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).impresorasDao;
});
final toneresDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).toneresDao;
});
final requisicionesDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).requisicionesDao;
});
final mantenimientosDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).mantenimientosDao;
});


final impresorasListStreamProvider =
    StreamProvider.autoDispose<List<Impresora>>((ref) {
  final dao = ref.watch(impresorasDaoProvider);
  return dao.watchAll();
});

final toneresListStreamProvider =
    StreamProvider.autoDispose<List<Tonere>>((ref) {
  final dao = ref.watch(toneresDaoProvider);
  return dao.watchAll();
});

final mantenimientosListStreamProvider =
    StreamProvider.autoDispose<List<Mantenimiento>>((ref) {
  final dao = ref.watch(mantenimientosDaoProvider);
  return dao.watchAll();
});

