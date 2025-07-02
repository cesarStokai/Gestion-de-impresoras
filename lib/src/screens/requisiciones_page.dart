import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../base/database.dart';
import '../providers/database_provider.dart';
import 'package:collection/collection.dart';

class RequisicionesPage extends ConsumerStatefulWidget {
  const RequisicionesPage({super.key});

  @override
  ConsumerState<RequisicionesPage> createState() => _RequisicionesPageState();
}

class _RequisicionesPageState extends ConsumerState<RequisicionesPage> {
  static const _reqStates = ['pendiente', 'completada'];
  final List<String> _coloresToner = ['Cian', 'Magenta', 'Amarillo', 'Negro'];

  @override
  Widget build(BuildContext context) {
    final reqAsync = ref.watch(requisicionesListStreamProvider);
    final tonersAsync = ref.watch(toneresListStreamProvider);
    final printersAsync = ref.watch(impresorasListStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Requisiciones de Tóneres Color')),
      body: reqAsync.when(
        data: (requisiciones) {
          return tonersAsync.when(
            data: (toners) {
              return printersAsync.when(
                data: (printers) {
                  // Filtrar solo requisiciones de impresoras a color
                  final reqFiltradas = requisiciones.where((r) {
                    final toner = toners.firstWhereOrNull(
                      (t) => t.id == r.tonereId,
                    );
                    if (toner == null) return false;
                    final printer = printers.firstWhereOrNull(
                      (p) => p.id == toner.impresoraId,
                    );
                    if (printer == null) return false;
                    return printer.esAColor;
                  }).toList();

                  // Historial de completadas
                  final historial = reqFiltradas.where((r) => r.estado == 'completada').toList();
                  final activas = reqFiltradas.where((r) => r.estado != 'completada').toList();

                  if (reqFiltradas.isEmpty) {
                    return const Center(
                        child: Text('No hay requisiciones activas'));
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemCount: activas.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (_, i) {
                            final r = activas[i];
                            final toner = toners.firstWhereOrNull((t) => t.id == r.tonereId);
                            final printer = toner != null ? printers.firstWhereOrNull((p) => p.id == toner.impresoraId) : null;
                            final impresoraStr = printer != null ? '${printer.marca} ${printer.modelo}' : 'Desconocida';
                            final fechaPedidoStr = r.fechaPedido.toLocal().toShortIsoDate();
                            final fechaEntregaStr = r.fechaEstimEntrega.toLocal().toShortIsoDate();
                            return Card(
                              margin: const EdgeInsets.all(8),
                              child: ListTile(
                                leading: r.estado == 'completada'
                                    ? const Icon(Icons.check_circle, color: Colors.green)
                                    : const Icon(Icons.access_time, color: Colors.orange),
                                title: Text(
                                  toner?.color ?? '-',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: r.estado == 'completada' ? Colors.green : Colors.orange,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Impresora: $impresoraStr'),
                                    Text('Solicitado: $fechaPedidoStr'),
                                    Text('Estimado: $fechaEntregaStr'),
                                  ],
                                ),
                                trailing: DropdownButton<String>(
                                  value: r.estado,
                                  items: _reqStates.map((estado) {
                                    return DropdownMenuItem(
                                      value: estado,
                                      child: Text(estado),
                                    );
                                  }).toList(),
                                  onChanged: (nuevoEstado) {
                                    if (nuevoEstado != null && nuevoEstado != r.estado) {
                                      _cambiarEstadoRequisicion(r.id, nuevoEstado);
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (historial.isNotEmpty) ...[
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Historial de requisiciones completadas', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 180,
                          child: ListView.separated(
                            itemCount: historial.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (_, i) {
                              final r = historial[i];
                              final toner = toners.firstWhereOrNull((t) => t.id == r.tonereId);
                              final printer = toner != null ? printers.firstWhereOrNull((p) => p.id == toner.impresoraId) : null;
                              final impresoraStr = printer != null ? '${printer.marca} ${printer.modelo}' : 'Desconocida';
                              final fechaPedidoStr = r.fechaPedido.toLocal().toShortIsoDate();
                              final fechaEntregaStr = r.fechaEstimEntrega.toLocal().toShortIsoDate();
                              return ListTile(
                                leading: const Icon(Icons.check_circle, color: Colors.green),
                                title: Text(toner?.color ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Impresora: $impresoraStr'),
                                    Text('Solicitado: $fechaPedidoStr'),
                                    Text('Entregado: $fechaEntregaStr'),
                                  ],
                                ),
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
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(),
      ),
    );
  }

  void _confirmarEliminacion(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de eliminar esta requisición?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(requisicionesDaoProvider).deleteById(id);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Requisición eliminada')),
                );
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showForm([Requisicione? r]) async {
    final isNew = r == null;
    final fechaP = TextEditingController(
      text: isNew
          ? DateTime.now().toShortIsoDate()
          : r.fechaPedido.toShortIsoDate(),
    );
    final fechaE = TextEditingController(
      text: r?.fechaEstimEntrega != null
          ? r!.fechaEstimEntrega.toShortIsoDate()
          : '',
    );
    String estado = r?.estado ?? _reqStates.first;
    int? impresoraId;
    final selectedColors = <String>[];

    // Cargar datos existentes si estamos editando
    if (!isNew) {
      final toner = await ref.read(toneresDaoProvider).getById(r.tonereId);
      if (toner != null) {
        impresoraId = toner.impresoraId;
        selectedColors.add(toner.color);
      }
    }

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isNew ? 'Nueva requisición' : 'Editar requisición'),
        content: Form(
          key: formKey,
          child: StatefulBuilder(
            builder: (context, setState) {
              final printersAsync = ref.watch(impresorasListStreamProvider);

              return printersAsync.when(
                data: (printers) {
                  final colorPrinters =
                      printers.where((p) => p.esAColor).toList();

                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<int>(
                          value: impresoraId,
                          decoration: const InputDecoration(
                            labelText: 'Impresora a color *',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null ? 'Seleccione una impresora' : null,
                          items: colorPrinters
                              .map((p) => DropdownMenuItem(
                                    value: p.id,
                                    child: Text('${p.marca} ${p.modelo}'),
                                  ))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => impresoraId = value),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Seleccione los colores a solicitar:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ..._coloresToner.map((color) => CheckboxListTile(
                              title: Text(color),
                              value: selectedColors.contains(color),
                              onChanged: impresoraId != null
                                  ? (value) => setState(() {
                                        if (value == true) {
                                          selectedColors.add(color);
                                        } else {
                                          selectedColors.remove(color);
                                        }
                                      })
                                  : null,
                            )),
                        if (selectedColors.isEmpty)
                          const Text(
                            'Seleccione al menos un color',
                            style: TextStyle(color: Colors.red),
                          ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: fechaP,
                          decoration: const InputDecoration(
                            labelText: 'Fecha solicitud *',
                            suffixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Ingrese una fecha'
                              : null,
                          readOnly: true,
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.parse(fechaP.text),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              setState(
                                  () => fechaP.text = date.toShortIsoDate());
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: fechaE,
                          decoration: const InputDecoration(
                            labelText: 'Fecha estimada entrega',
                            suffixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                          onTap: () async {
                            final initialDate = fechaE.text.isEmpty
                                ? DateTime.now().add(const Duration(days: 7))
                                : DateTime.parse(fechaE.text);
                            final date = await showDatePicker(
                              context: context,
                              initialDate: initialDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              setState(
                                  () => fechaE.text = date.toShortIsoDate());
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: estado,
                          decoration: const InputDecoration(
                            labelText: 'Estado *',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Seleccione un estado'
                              : null,
                          items: _reqStates
                              .map((state) => DropdownMenuItem(
                                    value: state,
                                    child: Text(state),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => estado = value!),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                if (selectedColors.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Seleccione al menos un color')),
                  );
                  return;
                }

                if (fechaE.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('La fecha estimada de entrega es obligatoria')),
                  );
                  return;
                }

                final dao = ref.read(requisicionesDaoProvider);
                final tonersDao = ref.read(toneresDaoProvider);

                try {
                  for (final color in selectedColors) {
                    // Buscar toner existente
                    final toners = await tonersDao.getAll();
                    var toner = toners.firstWhereOrNull(
                      (t) => t.impresoraId == impresoraId && t.color == color,
                    );

                    // Crear nuevo toner si no existe
                    if (toner == null) {
                      final newTonerId = await tonersDao.insertOne(
                        ToneresCompanion(
                          impresoraId: Value(impresoraId!),
                          color: Value(color),
                          estado: const Value('en_pedido'),
                        ),
                      );
                      toner = await tonersDao.getById(newTonerId);
                    }

                    if (toner == null) {
                      throw Exception('No se pudo crear/obtener el toner');
                    }

                    // Crear/actualizar requisición
                    final companion = RequisicionesCompanion(
                      id: isNew ? const Value.absent() : Value(r.id),
                      tonereId: Value(toner.id),
                      fechaPedido: Value(DateTime.parse(fechaP.text)),
                      fechaEstimEntrega: Value(DateTime.parse(fechaE.text)),
                      estado: Value(estado),
                    );

                    if (isNew) {
                      await dao.insertOne(companion);
                    } else {
                      await dao.updateOne(companion);
                    }
                  }

                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isNew
                            ? 'Requisición creada'
                            : 'Requisición actualizada'),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              }
            },
            child: Text(isNew ? 'Crear' : 'Guardar'),
          ),
        ],
      ),
    );
  }

  void _cambiarEstadoRequisicion(int id, String nuevoEstado) async {
    try {
      final dao = ref.read(requisicionesDaoProvider);
      final tonersDao = ref.read(toneresDaoProvider);

      // Obtener la requisición existente
      final requisicion = await dao.getById(id);
      if (requisicion == null) {
        throw Exception('Requisición no encontrada');
      }

      // Actualizar el estado de la requisición
      await dao.updateOne(
        RequisicionesCompanion(
          id: Value(id),
          tonereId: Value(requisicion.tonereId),
          fechaPedido: Value(requisicion.fechaPedido),
          fechaEstimEntrega: Value(requisicion.fechaEstimEntrega),
          estado: Value(nuevoEstado),
          proveedor: Value(requisicion.proveedor),
        ),
      );

      // Si se marca como completada, actualizar el tóner asociado
      if (nuevoEstado == 'completada') {
        final toner = await tonersDao.getById(requisicion.tonereId);
        if (toner != null) {
          await tonersDao.updateOne(
            ToneresCompanion(
              id: Value(toner.id),
              impresoraId: Value(toner.impresoraId), // Asegurar que se incluya impresoraId
              color: Value(toner.color), // Asegurar que se incluya color
              estado: Value('almacenado'),
              fechaInstalacion: toner.fechaInstalacion != null ? Value(toner.fechaInstalacion!) : const Value.absent(),
              fechaEstimEntrega: toner.fechaEstimEntrega != null ? Value(toner.fechaEstimEntrega!) : const Value.absent(),
              fechaEntregaReal: toner.fechaEntregaReal != null ? Value(toner.fechaEntregaReal!) : const Value.absent(),
            ),
          );
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Estado actualizado a $nuevoEstado')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar estado: $e')),
        );
      }
    }
  }
}




extension on DateTime {
  String toShortIsoDate() {
    return '${year}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }
}
