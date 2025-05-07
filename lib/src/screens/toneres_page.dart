// lib/src/toneres_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tonere.dart';
import '../providers/excel_provider.dart';

class ToneresPage extends ConsumerWidget {
  const ToneresPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toneres = ref.watch(toneresListProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Agregar Tóner'),
            onPressed: () => _showForm(context, ref),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: toneres.length,
              itemBuilder: (ctx, i) {
                final t = toneres[i];
                return ListTile(
                  title: Text('Tóner ${t.id} - Impresora ${t.impresoraId}'),
                  subtitle: Text('Color: ${t.color} • Estado: ${t.estado}'),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(context, ref, tonere: t),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => ref.read(toneresListProvider.notifier).remove(t.id!),
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

  void _showForm(BuildContext context, WidgetRef ref, {Tonere? tonere}) {
    final isNew = tonere == null;
    final impresoraC = TextEditingController(text: tonere?.impresoraId.toString());
    final colorC     = TextEditingController(text: tonere?.color);
    final estadoC    = TextEditingController(text: tonere?.estado);
    final fechaEstC  = TextEditingController(text: tonere?.fechaEstimEntrega?.toIso8601String() ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isNew ? 'Nuevo Tóner' : 'Editar Tóner'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: impresoraC,
              decoration: const InputDecoration(labelText: 'ID Impresora'),
              keyboardType: TextInputType.number,
            ),
            TextField(controller: colorC,  decoration: const InputDecoration(labelText: 'Color')),
            TextField(controller: estadoC, decoration: const InputDecoration(labelText: 'Estado')),
            TextField(
              controller: fechaEstC,
              decoration: const InputDecoration(labelText: 'Fecha Est. Entrega (ISO)'),
            ),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final nueva = Tonere(
                id: tonere?.id,
                impresoraId: int.tryParse(impresoraC.text) ?? 0,
                color: colorC.text,
                estado: estadoC.text,
                fechaEstimEntrega: DateTime.tryParse(fechaEstC.text),
              );
              final ctl = ref.read(toneresListProvider.notifier);
              if (isNew) ctl.add(nueva); else ctl.update(nueva);
              Navigator.pop(context);
            },
            child: Text(isNew ? 'Crear' : 'Guardar'),
          ),
        ],
      ),
    );
  }
}
