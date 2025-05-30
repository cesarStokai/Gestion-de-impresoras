import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../base/database.dart';
import '../providers/database_provider.dart';

class MantenimientosPage extends ConsumerStatefulWidget {
  const MantenimientosPage({super.key});

  @override
  ConsumerState<MantenimientosPage> createState() => _MantenimientosPageState();
}

class _MantenimientosPageState extends ConsumerState<MantenimientosPage> {
  @override
  Widget build(BuildContext context) {
    final mantAsync = ref.watch(mantenimientosListStreamProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Mantenimientos')),
      body: mantAsync.when(
        data: (list) {
          // Filtrar mantenimientos con reemplazo
          final reemplazos = list.where((m) => m.reemplazoImpresora == true && m.nuevaImpresoraId != null).toList();
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final m = list[i];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        leading: const Icon(Icons.build, color: Colors.blueAccent, size: 32),
                        title: FutureBuilder<Impresora?>(
                          future: ref.read(impresorasDaoProvider).getImpresoraById(m.impresoraId),
                          builder: (_, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              final impresora = snapshot.data!;
                              return Text(
                                '${impresora.marca} ${impresora.modelo}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                              );
                            }
                            return Text('Impresora ID: ${m.impresoraId}', style: const TextStyle(fontWeight: FontWeight.bold));
                          },
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  m.fecha.toLocal().toShortIsoDate(),
                                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              m.detalle,
                              style: const TextStyle(fontSize: 15),
                            ),
                            if (m.reemplazoImpresora == true && m.nuevaImpresoraId != null) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.swap_horiz, color: Colors.orange, size: 18),
                                  const SizedBox(width: 4),
                                  FutureBuilder<Impresora?>(
                                    future: ref.read(impresorasDaoProvider).getImpresoraById(m.nuevaImpresoraId!),
                                    builder: (_, snap) {
                                      if (snap.hasData && snap.data != null) {
                                        final nueva = snap.data!;
                                        return Text(
                                          'Reemplazada por: ${nueva.marca} ${nueva.modelo}',
                                          style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w500),
                                        );
                                      }
                                      return const Text('Reemplazo registrado', style: TextStyle(color: Colors.orange));
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Eliminar mantenimiento',
                          onPressed: () => _confirmDelete(m.id),
                        ),
                        onTap: () => _showForm(m),
                      ),
                    );
                  },
                ),
              ),
              if (reemplazos.isNotEmpty) ...[
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Historial de reemplazos de impresoras', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 180,
                  child: ListView.separated(
                    itemCount: reemplazos.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, i) {
                      final m = reemplazos[i];
                      return FutureBuilder<List<Impresora?>> (
                        future: Future.wait([
                          ref.read(impresorasDaoProvider).getImpresoraById(m.impresoraId),
                          ref.read(impresorasDaoProvider).getImpresoraById(m.nuevaImpresoraId!),
                        ]),
                        builder: (_, snap) {
                          final vieja = snap.hasData && snap.data![0] != null ? snap.data![0]! : null;
                          final nueva = snap.hasData && snap.data![1] != null ? snap.data![1]! : null;
                          final area = nueva?.area ?? vieja?.area ?? '-';
                          return ListTile(
                            leading: const Icon(Icons.swap_horiz, color: Colors.orange),
                            title: Text(
                              'De: ${vieja != null ? '${vieja.marca} ${vieja.modelo} (${vieja.serie})' : 'Desconocida'}\nA: ${nueva != null ? '${nueva.marca} ${nueva.modelo} (${nueva.serie})' : 'Desconocida'}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Fecha: ${m.fecha.toLocal().toShortIsoDate()}'),
                                Text('Departamento: $area'),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.build),
        onPressed: () => _showForm(),
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de eliminar este mantenimiento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(mantenimientosDaoProvider).deleteById(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mantenimiento eliminado')),
              );
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Future<void> _showForm([Mantenimiento? m]) async {
    final isNew = m == null;
    int? origen = m?.impresoraId;
    DateTime fecha = m?.fecha ?? DateTime.now();
    final detalleC = TextEditingController(text: m?.detalle);
    bool reemplazo = m?.reemplazoImpresora ?? false;
    int? reemplazoId = m?.nuevaImpresoraId;
    
    // Cargar impresoras al iniciar
    final printers = await ref.read(impresorasDaoProvider).getAllImpresoras();

    // Verificar si el valor inicial existe
    if (origen != null && !printers.any((p) => p.id == origen)) {
      origen = null;
    }

    // Verificar si el valor de reemplazo existe
    if (reemplazoId != null && !printers.any((p) => p.id == reemplazoId)) {
      reemplazoId = null;
    }

    final fechaController = TextEditingController(
      text: fecha.toIso8601String().split('T').first,
    );

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (ctx, setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
          actionsPadding: const EdgeInsets.all(16),
          title: Text(
            isNew ? 'Nuevo Mantenimiento' : 'Editar Mantenimiento',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<int?>(
                  value: origen,
                  decoration: InputDecoration(
                    labelText: 'Impresora *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  items: printers.isEmpty
                      ? [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('No hay impresoras disponibles'),
                          )
                        ]
                      : [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Seleccione una impresora'),
                          ),
                          ...printers.map((p) => DropdownMenuItem(
                                value: p.id,
                                child: Text('${p.marca} ${p.modelo} ${p.area} (${p.serie})'),
                              )),
                        ],
                  onChanged: (v) => setState(() => origen = v),
                  validator: (value) => value == null ? 'Seleccione una impresora' : null,
                ),
                const SizedBox(height: 14),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Fecha',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.grey[100],
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  controller: fechaController,
                  readOnly: true,
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: fecha,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        fecha = pickedDate;
                        fechaController.text = fecha.toIso8601String().split('T').first;
                      });
                    }
                  },
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: detalleC,
                  decoration: InputDecoration(
                    labelText: 'Detalle *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.grey[100],
                    prefixIcon: const Icon(Icons.description),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 14),
                Row(children: [
                  const Icon(Icons.swap_horiz, color: Colors.orange),
                  const SizedBox(width: 6),
                  const Text('Reemplazo impresora'),
                  Checkbox(
                    value: reemplazo,
                    onChanged: (b) => setState(() {
                      reemplazo = b ?? false;
                      if (!reemplazo) {
                        reemplazoId = null;
                      }
                    }),
                  ),
                ]),
                if (reemplazo) ...[
                  const SizedBox(height: 10),
                  DropdownButtonFormField<int?>(
                    value: reemplazoId,
                    decoration: InputDecoration(
                      labelText: 'Nueva impresora',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    items: printers
                        .where((p) => p.id != origen)
                        .map((p) => DropdownMenuItem(
                              value: p.id,
                              child: Text('${p.marca} ${p.modelo} (${p.serie})'),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => reemplazoId = v),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: origen != null && detalleC.text.isNotEmpty && (!reemplazo || (reemplazo && reemplazoId != null))
                  ? () {
                      if (!reemplazo) {
                        reemplazoId = null;
                      }
                      final dao = ref.read(mantenimientosDaoProvider);
                      final companion = MantenimientosCompanion(
                        id: isNew ? const Value.absent() : Value(m.id),
                        impresoraId: Value(origen!),
                        fecha: Value(fecha),
                        detalle: Value(detalleC.text),
                        reemplazoImpresora: Value(reemplazo && reemplazoId != null),
                        nuevaImpresoraId: (reemplazo && reemplazoId != null)
                            ? Value(reemplazoId!)
                            : const Value.absent(),
                      );
                      if (isNew) {
                        dao.insertOne(companion);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Mantenimiento creado')),
                        );
                      } else {
                        dao.updateOne(companion);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Mantenimiento actualizado')),
                        );
                      }
                      Navigator.pop(context);
                    }
                  : null,
              child: Text(isNew ? 'Crear' : 'Guardar', style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      }),
    );
  }
}

extension _DateShort on DateTime {
  String toShortIsoDate() => toIso8601String().split('T').first;
}