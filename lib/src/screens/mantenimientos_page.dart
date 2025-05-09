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
        data: (list) => ListView.separated(
          itemCount: list.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, i) {
            final m = list[i];
            return ListTile(
              title: FutureBuilder<Impresora?>(
                future: ref.read(impresorasDaoProvider).getImpresoraById(m.impresoraId),
                builder: (_, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final impresora = snapshot.data!;
                    return Text('${impresora.marca} ${impresora.modelo}');
                  }
                  return Text('Impresora ID: ${m.impresoraId}');
                },
              ),
              subtitle: Text('${m.fecha.toLocal().toShortIsoDate()}\n${m.detalle}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(m.id),
              ),
              onTap: () => _showForm(m),
            );
          },
        ),
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
          title: Text(isNew ? 'Nuevo mantenimiento' : 'Editar mantenimiento'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int?>(
                  value: origen,
                  decoration: const InputDecoration(labelText: 'Impresora *'),
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
                                child: Text('${p.marca} ${p.modelo} (${p.serie})'),
                              )),
                        ],
                  onChanged: (v) => setState(() => origen = v),
                  validator: (value) => value == null ? 'Seleccione una impresora' : null,
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(labelText: 'Fecha'),
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
                const SizedBox(height: 12),
                TextField(
                  controller: detalleC,
                  decoration: const InputDecoration(labelText: 'Detalle *'),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                Row(children: [
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
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int?>(
                    value: reemplazoId,
                    decoration: const InputDecoration(labelText: 'Nueva impresora'),
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
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: origen != null && detalleC.text.isNotEmpty
                  ? () {
                      final dao = ref.read(mantenimientosDaoProvider);
                      final companion = MantenimientosCompanion(
                        id: isNew ? const Value.absent() : Value(m.id),
                        impresoraId: Value(origen!),
                        fecha: Value(fecha),
                        detalle: Value(detalleC.text),
                        reemplazoImpresora: Value(reemplazo),
                        nuevaImpresoraId: reemplazo && reemplazoId != null
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
              child: Text(isNew ? 'Crear' : 'Guardar'),
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