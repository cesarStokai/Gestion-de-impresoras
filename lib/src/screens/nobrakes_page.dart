import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import '../base/database.dart';
import '../providers/database_provider.dart';
import '../daos/nobrakes_dao.dart';

class NoBrakesPage extends ConsumerStatefulWidget {
  const NoBrakesPage({super.key});

  @override
  ConsumerState<NoBrakesPage> createState() => _NoBrakesPageState();
}

class _NoBrakesPageState extends ConsumerState<NoBrakesPage> {
  NoBrake? selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () => setState(() => selected = null),
              child: Row(
                children: [
                  const Icon(Icons.battery_charging_full),
                  const SizedBox(width: 8),
                  const Text('No-brakes (UPS)', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            if (selected != null) ...[
              const Icon(Icons.chevron_right),
              Text('${selected!.marca} ${selected!.modelo}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ]
          ],
        ),
      ),
      body: selected == null ? _buildList(context) : _buildHistorial(context, selected!),
      floatingActionButton: selected == null
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _showForm(context, ref, null),
            )
          : FloatingActionButton(
              child: const Icon(Icons.add),
              tooltip: 'Agregar evento',
              onPressed: () => _showAddEvento(context, ref, selected!),
            ),
    );
  }

  Widget _buildList(BuildContext context) {
    final noBrakesAsync = ref.watch(noBrakesListProvider);
    return noBrakesAsync.when(
      data: (list) => ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final n = list[i];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.battery_charging_full, color: Colors.green, size: 32),
              title: Text('${n.marca} ${n.modelo}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Serie: ${n.serie}'),
                  Text('Ubicación: ${n.ubicacion}'),
                  Text('Usuario: ${n.usuarioAsignado}'),
                  Text('Estado: ${n.estado}'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Eliminar',
                onPressed: () => _confirmDelete(context, ref, n.id),
              ),
              onTap: () => setState(() => selected = n),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildHistorial(BuildContext context, NoBrake noBrake) {
    final eventosAsync = ref.watch(noBrakeEventosListProvider(noBrake.id));
    return eventosAsync.when(
      data: (list) => list.isEmpty
          ? const Center(child: Text('Sin eventos registrados'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, i) {
                final e = list[i];
                return ListTile(
                  leading: Icon(_iconForTipo(e.tipoEvento), color: Colors.blue),
                  title: Text(_labelForTipo(e.tipoEvento)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha: ${e.fecha.toLocal().toString().split(' ')[0]}'),
                      if (e.descripcion.isNotEmpty)
                        Text('Descripción: ${e.descripcion}'),
                      if (e.usuario != null && e.usuario!.isNotEmpty)
                        Text('Usuario: ${e.usuario}'),
                    ],
                  ),
                );
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Eliminar este No-brake?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(noBrakesDaoProvider).deleteById(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No-brake eliminado')),
              );
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Future<void> _showForm(BuildContext context, WidgetRef ref, NoBrake? n) async {
    // ...igual que antes...
    final isNew = n == null;
    final marcaC = TextEditingController(text: n?.marca);
    final modeloC = TextEditingController(text: n?.modelo);
    final serieC = TextEditingController(text: n?.serie);
    final ubicacionC = TextEditingController(text: n?.ubicacion);
    final usuarioC = TextEditingController(text: n?.usuarioAsignado);
    final obsC = TextEditingController(text: n?.observaciones);
    String estado = n?.estado ?? 'activo';
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isNew ? 'Nuevo No-brake' : 'Editar No-brake'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: marcaC,
                decoration: const InputDecoration(labelText: 'Marca *'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: modeloC,
                decoration: const InputDecoration(labelText: 'Modelo *'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: serieC,
                decoration: const InputDecoration(labelText: 'Serie *'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ubicacionC,
                decoration: const InputDecoration(labelText: 'Ubicación *'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: usuarioC,
                decoration: const InputDecoration(labelText: 'Usuario asignado *'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: estado,
                items: const [
                  DropdownMenuItem(value: 'activo', child: Text('Activo')),
                  DropdownMenuItem(value: 'en_reparacion', child: Text('En reparación')),
                  DropdownMenuItem(value: 'baja', child: Text('Baja')),
                ],
                onChanged: (v) => estado = v ?? 'activo',
                decoration: const InputDecoration(labelText: 'Estado'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: obsC,
                decoration: const InputDecoration(labelText: 'Observaciones'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (marcaC.text.isEmpty || modeloC.text.isEmpty || serieC.text.isEmpty || ubicacionC.text.isEmpty || usuarioC.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Completa todos los campos obligatorios')));
                return;
              }
              final dao = ref.read(noBrakesDaoProvider);
              final companion = NoBrakesCompanion(
                id: isNew ? const Value.absent() : Value(n!.id),
                marca: Value(marcaC.text),
                modelo: Value(modeloC.text),
                serie: Value(serieC.text),
                ubicacion: Value(ubicacionC.text),
                usuarioAsignado: Value(usuarioC.text),
                estado: Value(estado),
                observaciones: Value(obsC.text.isEmpty ? null : obsC.text),
              );
              if (isNew) {
                await dao.insertOne(companion);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No-brake registrado')));
              } else {
                final updated = n!.copyWith(
                  marca: marcaC.text,
                  modelo: modeloC.text,
                  serie: serieC.text,
                  ubicacion: ubicacionC.text,
                  usuarioAsignado: usuarioC.text,
                  estado: estado,
                  observaciones: Value(obsC.text.isEmpty ? null : obsC.text),
                );
                await dao.updateOne(updated);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No-brake actualizado')));
              }
              Navigator.pop(context);
            },
            child: Text(isNew ? 'Registrar' : 'Guardar'),
          ),
        ],
      ),
    );
  }

  void _showAddEvento(BuildContext context, WidgetRef ref, NoBrake noBrake) {
    final tipoEvento = ValueNotifier<String>('reporte');
    final fecha = ValueNotifier<DateTime>(DateTime.now());
    final descripcionC = TextEditingController();
    final usuarioC = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Nuevo evento'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: tipoEvento.value,
                items: const [
                  DropdownMenuItem(value: 'reporte', child: Text('Reporte')),
                  DropdownMenuItem(value: 'diagnostico', child: Text('Diagnóstico')),
                  DropdownMenuItem(value: 'reparacion', child: Text('Reparación')),
                  DropdownMenuItem(value: 'baja', child: Text('Baja')),
                  DropdownMenuItem(value: 'reasignacion', child: Text('Reasignación')),
                ],
                onChanged: (v) => tipoEvento.value = v ?? 'reporte',
                decoration: const InputDecoration(labelText: 'Tipo de evento'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descripcionC,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: usuarioC,
                decoration: const InputDecoration(labelText: 'Usuario (opcional)'),
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder<DateTime>(
                valueListenable: fecha,
                builder: (_, value, __) => Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 8),
                    Text('Fecha: ${value.toLocal().toString().split(' ')[0]}'),
                    const Spacer(),
                    TextButton(
                      child: const Text('Cambiar'),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: value,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) fecha.value = picked;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final dao = ref.read(noBrakeEventosDaoProvider);
              await dao.insertOne(NoBrakeEventosCompanion(
                noBrakeId: Value(noBrake.id),
                fecha: Value(fecha.value),
                tipoEvento: Value(tipoEvento.value),
                descripcion: Value(descripcionC.text),
                usuario: Value(usuarioC.text.isEmpty ? null : usuarioC.text),
              ));
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  IconData _iconForTipo(String tipo) {
    switch (tipo) {
      case 'diagnostico':
        return Icons.search;
      case 'reparacion':
        return Icons.build;
      case 'baja':
        return Icons.delete_forever;
      case 'reasignacion':
        return Icons.swap_horiz;
      default:
        return Icons.info;
    }
  }

  String _labelForTipo(String tipo) {
    switch (tipo) {
      case 'diagnostico':
        return 'Diagnóstico';
      case 'reparacion':
        return 'Reparación';
      case 'baja':
        return 'Baja';
      case 'reasignacion':
        return 'Reasignación';
      default:
        return 'Reporte';
    }
  }
}

final noBrakeEventosDaoProvider = Provider<NoBrakeEventosDao>((ref) {
  final db = ref.read(databaseProvider);
  return NoBrakeEventosDao(db);
});

final noBrakeEventosListProvider = StreamProvider.family.autoDispose<List<NoBrakeEvento>, int>((ref, noBrakeId) {
  final dao = ref.watch(noBrakeEventosDaoProvider);
  return dao.watchByNoBrake(noBrakeId);
});

  void _confirmDelete(BuildContext context, WidgetRef ref, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Eliminar este No-brake?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(noBrakesDaoProvider).deleteById(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No-brake eliminado')),
              );
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Future<void> _showForm(BuildContext context, WidgetRef ref, NoBrake? n) async {
    final isNew = n == null;
    final marcaC = TextEditingController(text: n?.marca);
    final modeloC = TextEditingController(text: n?.modelo);
    final serieC = TextEditingController(text: n?.serie);
    final ubicacionC = TextEditingController(text: n?.ubicacion);
    final usuarioC = TextEditingController(text: n?.usuarioAsignado);
    final obsC = TextEditingController(text: n?.observaciones);
    String estado = n?.estado ?? 'activo';
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isNew ? 'Nuevo No-brake' : 'Editar No-brake'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: marcaC,
                decoration: const InputDecoration(labelText: 'Marca *'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: modeloC,
                decoration: const InputDecoration(labelText: 'Modelo *'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: serieC,
                decoration: const InputDecoration(labelText: 'Serie *'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ubicacionC,
                decoration: const InputDecoration(labelText: 'Ubicación *'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: usuarioC,
                decoration: const InputDecoration(labelText: 'Usuario asignado *'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: estado,
                items: const [
                  DropdownMenuItem(value: 'activo', child: Text('Activo')),
                  DropdownMenuItem(value: 'en_reparacion', child: Text('En reparación')),
                  DropdownMenuItem(value: 'baja', child: Text('Baja')),
                ],
                onChanged: (v) => estado = v ?? 'activo',
                decoration: const InputDecoration(labelText: 'Estado'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: obsC,
                decoration: const InputDecoration(labelText: 'Observaciones'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (marcaC.text.isEmpty || modeloC.text.isEmpty || serieC.text.isEmpty || ubicacionC.text.isEmpty || usuarioC.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Completa todos los campos obligatorios')));
                return;
              }
              final dao = ref.read(noBrakesDaoProvider);
              final companion = NoBrakesCompanion(
                id: isNew ? const Value.absent() : Value(n!.id),
                marca: Value(marcaC.text),
                modelo: Value(modeloC.text),
                serie: Value(serieC.text),
                ubicacion: Value(ubicacionC.text),
                usuarioAsignado: Value(usuarioC.text),
                estado: Value(estado),
                observaciones: Value(obsC.text.isEmpty ? null : obsC.text),
              );
              if (isNew) {
                await dao.insertOne(companion);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No-brake registrado')));
              } else {
                // Para actualizar, crea un modelo NoBrake actualizado
                final updated = n!.copyWith(
                  marca: marcaC.text,
                  modelo: modeloC.text,
                  serie: serieC.text,
                  ubicacion: ubicacionC.text,
                  usuarioAsignado: usuarioC.text,
                  estado: estado,
                  observaciones: Value(obsC.text.isEmpty ? null : obsC.text),
                );
                await dao.updateOne(updated);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No-brake actualizado')));
              }
              Navigator.pop(context);
            },
            child: Text(isNew ? 'Registrar' : 'Guardar'),
          ),
        ],
      ),
    );
  }


// Riverpod provider para la lista de No-brakes
final noBrakesDaoProvider = Provider<NoBrakesDao>((ref) {
  final db = ref.read(databaseProvider);
  return NoBrakesDao(db);
});

final noBrakesListProvider = StreamProvider.autoDispose((ref) {
  final dao = ref.watch(noBrakesDaoProvider);
  return dao.watchAll();
});
