import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/requisicion.dart';
import '../providers/excel_provider.dart';

class RequisicionesPage extends ConsumerWidget {
  const RequisicionesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reqs = ref.watch(requisicionesListProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Nueva Requisición'),
          onPressed: () => _showForm(context, ref),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: reqs.length,
            itemBuilder: (ctx, i) {
              final r = reqs[i];
              return ListTile(
                title: Text('Req ${r.id} - Tóner ${r.tonereId}'),
                subtitle: Text('Pedido: ${r.fechaPedido.toLocal().toShortIsoDate()} • Estado: ${r.estado}'),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showForm(context, ref, requisicion: r),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => ref.read(requisicionesListProvider.notifier).remove(r.id!),
                  ),
                ]),
              );
            },
          ),
        ),
      ]),
    );
  }

  void _showForm(BuildContext context, WidgetRef ref, {Requisicion? requisicion}) {
    final isNew = requisicion == null;
    final tonerC   = TextEditingController(text: requisicion?.tonereId.toString());
    final fechaP   = TextEditingController(text: requisicion?.fechaPedido.toIso8601String() ?? DateTime.now().toIso8601String());
    final fechaE   = TextEditingController(text: requisicion?.fechaEstimEntrega.toIso8601String() ?? '');
    final estadoC  = TextEditingController(text: requisicion?.estado);
    final provC    = TextEditingController(text: requisicion?.proveedor ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isNew ? 'Nueva Requisición' : 'Editar Requisición'),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: tonerC,  decoration: const InputDecoration(labelText: 'ID Tóner'), keyboardType: TextInputType.number),
          TextField(controller: fechaP,  decoration: const InputDecoration(labelText: 'Fecha Pedido (ISO)')),
          TextField(controller: fechaE,  decoration: const InputDecoration(labelText: 'Fecha Est. Entrega (ISO)')),
          TextField(controller: estadoC, decoration: const InputDecoration(labelText: 'Estado')),
          TextField(controller: provC,   decoration: const InputDecoration(labelText: 'Proveedor')),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final nueva = Requisicion(
                id: requisicion?.id,
                tonereId: int.tryParse(tonerC.text) ?? 0,
                fechaPedido: DateTime.parse(fechaP.text),
                fechaEstimEntrega: DateTime.parse(fechaE.text),
                estado: estadoC.text,
                proveedor: provC.text,
              );
              final ctl = ref.read(requisicionesListProvider.notifier);
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
