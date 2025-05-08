import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../base/database.dart';
import '../providers/database_provider.dart';

class ImpresorasPage extends ConsumerStatefulWidget {
  const ImpresorasPage({Key? key}) : super(key: key);
  @override
  ConsumerState<ImpresorasPage> createState() => _ImpresorasPageState();
}

class _ImpresorasPageState extends ConsumerState<ImpresorasPage> {
  static const _printerStates = [
    'activa',
    'pendiente_baja',
    'baja',
    'mantenimiento'
  ];

  @override
  Widget build(BuildContext context) {
    final impAsync = ref.watch(impresorasListStreamProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Impresoras')),
      body: impAsync.when(
        data: (list) => ListView.separated(
          itemCount: list.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, i) {
            final imp = list[i];
            return ListTile(
              title: Text('${imp.marca} • ${imp.modelo}'),
              subtitle: Text('Área: ${imp.area}\nEstado: ${imp.estado} \nNumero de serie:${imp.serie}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(imp.id),
              ),
              onTap: () => _showForm(imp),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(),
      ),
    );
  }

  void _confirmDelete(int? id) {
    final toners = ref.read(toneresListStreamProvider).value ?? [];
    final asociados = toners.where((t) => t.impresoraId == id).length;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(asociados > 0
            ? 'Esta impresora tiene $asociados tóner(es) asociados. ¿Seguro?'
            : '¿Seguro que quieres eliminarla?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              ref.read(impresorasDaoProvider).deleteById(id!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Impresora eliminada')));
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showForm([Impresora? imp]) {
  final isNew = imp == null;
  final marcaC  = TextEditingController(text: imp?.marca);
  final modeloC = TextEditingController(text: imp?.modelo);
  final serieC  = TextEditingController(text: imp?.serie);
  final areaC   = TextEditingController(text: imp?.area);
  String estado = imp?.estado ?? _printerStates.first;

  showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (ctx, setState) {
        // Cada vez que llames a setState dentro de este builder
        // se volverá a ejecutar todo el contenido, incluido el botón.
        final ok = marcaC.text.isNotEmpty &&
                   modeloC.text.isNotEmpty &&
                   serieC.text.isNotEmpty &&
                   areaC.text.isNotEmpty;

        return AlertDialog(
          title: Text(isNew ? 'Nueva impresora' : 'Editar impresora'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: marcaC,
                decoration: const InputDecoration(labelText: 'Marca *'),
                onChanged: (_) => setState(() {}),
              ),
              TextField(
                controller: modeloC,
                decoration: const InputDecoration(labelText: 'Modelo *'),
                onChanged: (_) => setState(() {}),
              ),
              TextField(
                controller: serieC,
                decoration: const InputDecoration(labelText: 'Serie *'),
                onChanged: (_) => setState(() {}),
              ),
              TextField(
                controller: areaC,
                decoration: const InputDecoration(labelText: 'Área *'),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: estado,
                decoration: const InputDecoration(labelText: 'Estado'),
                items: _printerStates
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() {
                  estado = v!;
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: ok
                  ? () {
                      final dao = ref.read(impresorasDaoProvider);
                      final companion = ImpresorasCompanion(
                        id: isNew
                            ? const Value.absent()
                            : Value(imp!.id!),
                        marca: Value(marcaC.text),
                        modelo: Value(modeloC.text),
                        serie: Value(serieC.text),
                        area: Value(areaC.text),
                        estado: Value(estado),
                      );
                      if (isNew) {
                        dao.insertOne(companion);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Impresora creada'))
                        );
                      } else {
                        dao.updateOne(companion);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Impresora actualizada'))
                        );
                      }
                      Navigator.pop(context);
                    }
                  : null,
              child: Text(isNew ? 'Crear' : 'Guardar'),
            ),
          ],
        );
      },
    ),
  );
}

}



