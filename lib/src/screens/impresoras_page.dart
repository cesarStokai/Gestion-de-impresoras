// lib/src/impresoras_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/impresora.dart';
import '../providers/excel_provider.dart';

class ImpresorasPage extends ConsumerWidget {
  const ImpresorasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final impresoras = ref.watch(impresorasListProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 1) Botón arriba
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Agregar Impresora'),
            onPressed: () => _showForm(context, ref),
          ),

          const SizedBox(height: 8),

          // 2) Lista ocupa lo que queda
          Expanded(
            child: ListView.builder(
              itemCount: impresoras.length,
              itemBuilder: (ctx, i) {
                final imp = impresoras[i];
                return ListTile(
                  title: Text('${imp.marca} ${imp.modelo}'),
                  subtitle: Text('Serie: ${imp.serie} — Área: ${imp.area}'),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(context, ref, imp: imp),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => ref.read(impresorasListProvider.notifier)
                                         .remove(imp.id!),
                    ),
                  ]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showForm(BuildContext context, WidgetRef ref, {Impresora? imp}) {
    final isNew   = imp == null;
    final marcaC  = TextEditingController(text: imp?.marca);
    final modeloC = TextEditingController(text: imp?.modelo);
    final serieC  = TextEditingController(text: imp?.serie);
    final areaC   = TextEditingController(text: imp?.area);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isNew ? 'Nueva Impresora' : 'Editar Impresora'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: marcaC,  decoration: const InputDecoration(labelText: 'Marca')),
            TextField(controller: modeloC, decoration: const InputDecoration(labelText: 'Modelo')),
            TextField(controller: serieC,  decoration: const InputDecoration(labelText: 'Serie')),
            TextField(controller: areaC,   decoration: const InputDecoration(labelText: 'Área')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final nueva = Impresora(
                id: imp?.id,
                marca:  marcaC.text,
                modelo: modeloC.text,
                serie:  serieC.text,
                area:   areaC.text,
              );
              final notifier = ref.read(impresorasListProvider.notifier);
              if (isNew) notifier.add(nueva);
              else       notifier.update(nueva);
              Navigator.pop(context);
            },
            child: Text(isNew ? 'Crear' : 'Guardar'),
          ),
        ],
      ),
    );
  }
}
