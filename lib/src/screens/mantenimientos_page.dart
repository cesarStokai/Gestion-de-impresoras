import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mantenimiento.dart';
import '../providers/excel_provider.dart';

class MantenimientosPage extends ConsumerWidget {
  const MantenimientosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mans = ref.watch(mantenimientosListProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.build),
          label: const Text('Nuevo Mantenimiento'),
          onPressed: () => _showForm(context, ref),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: mans.length,
            itemBuilder: (ctx, i) {
              final m = mans[i];
              return ListTile(
                title: Text('Mant ${m.id} — Impresora ${m.impresoraId}'),
                subtitle: Text('Fecha: ${m.fecha.toLocal().toShortIsoDate()} — ${m.detalle}'),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showForm(context, ref, mant: m),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => ref.read(mantenimientosListProvider.notifier).remove(m.id!),
                  ),
                ]),
              );
            },
          ),
        ),
      ]),
    );
  }

  void _showForm(BuildContext context, WidgetRef ref, {Mantenimiento? mant}) {
    final isNew = mant == null;
    final impC        = TextEditingController(text: mant?.impresoraId.toString());
    final fechaC      = TextEditingController(text: mant?.fecha.toIso8601String() ?? DateTime.now().toIso8601String());
    final detalleC    = TextEditingController(text: mant?.detalle);
    final reemplazo   = ValueNotifier<bool>(mant?.reemplazoImpresora ?? false);
    final nuevaImpC   = TextEditingController(text: mant?.nuevaImpresoraId?.toString() ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isNew ? 'Nuevo Mantenimiento' : 'Editar Mantenimiento'),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: impC,      decoration: const InputDecoration(labelText: 'ID Impresora'), keyboardType: TextInputType.number),
          TextField(controller: fechaC,    decoration: const InputDecoration(labelText: 'Fecha (ISO)')),
          TextField(controller: detalleC,  decoration: const InputDecoration(labelText: 'Detalle')),
          Row(children: [
            const Text('Reemplazo impresora:'),
            ValueListenableBuilder<bool>(
              valueListenable: reemplazo,
              builder: (_, v, __) => Checkbox(
                value: v,
                onChanged: (b) => reemplazo.value = b ?? false,
              ),
            ),
          ]),
          TextField(controller: nuevaImpC, decoration: const InputDecoration(labelText: 'Nueva impresora ID')),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final nueva = Mantenimiento(
                id: mant?.id,
                impresoraId: int.tryParse(impC.text) ?? 0,
                fecha: DateTime.parse(fechaC.text),
                detalle: detalleC.text,
                reemplazoImpresora: reemplazo.value,
                nuevaImpresoraId: int.tryParse(nuevaImpC.text),
              );
              final ctl = ref.read(mantenimientosListProvider.notifier);
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

extension _DateHelpers on DateTime {
  String toShortIsoDate() => toIso8601String().split('T').first;
}
