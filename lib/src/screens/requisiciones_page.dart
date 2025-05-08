import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../base/database.dart';
import '../providers/database_provider.dart';

class RequisicionesPage extends ConsumerStatefulWidget {
  const RequisicionesPage({Key? key}) : super(key: key);
  @override
  ConsumerState<RequisicionesPage> createState() => _RequisicionesPageState();
}

class _RequisicionesPageState extends ConsumerState<RequisicionesPage> {
  static const _reqStates = ['pendiente', 'completada'];

  @override
  Widget build(BuildContext context) {
    final reqAsync = ref.watch(requisicionesListStreamProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Requisiciones')),
      body: reqAsync.when(
        data: (list) => ListView.separated(
          itemCount: list.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, i) {
            final r = list[i];
            return ListTile(
              title: Text('Tóner ID: ${r.tonereId}'),
              subtitle: Text(
                  'Pedido: ${r.fechaPedido.toLocal().toShortIsoDate()}\nEstado: ${r.estado}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () =>
                    ref.read(requisicionesDaoProvider).deleteById(r.id!),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_shopping_cart),
        onPressed: () => _showForm(),
      ),
    );
  }

  void _showForm([Requisicione? r]) {
    final isNew = r == null;
    final fechaP = TextEditingController(
        text: r?.fechaPedido.toIso8601String() ??
            DateTime.now().toIso8601String());
    final fechaE = TextEditingController(
        text: r?.fechaEstimEntrega.toIso8601String() ?? '');
    String estado = r?.estado ?? _reqStates.first;
    int? tonerId = r?.tonereId;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isNew ? 'Nueva requisición' : 'Editar requisición'),
        content: StatefulBuilder(builder: (ctx, set) {
          final toners = ref.watch(toneresListStreamProvider).value ?? [];
          return Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButtonFormField<int>(
              value: tonerId,
              decoration: const InputDecoration(labelText: 'Tóner *'),
              items: toners
                  .map((t) => DropdownMenuItem(
                      value: t.id!,
                      child: Text('${t.color} (${t.impresoraId})')))
                  .toList(),
              onChanged: (v) => set(() => tonerId = v),
            ),
            TextField(
              controller: fechaP,
              decoration: const InputDecoration(labelText: 'Fecha pedido'),
              readOnly: true,
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: DateTime.parse(fechaP.text),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (d != null) set(() => fechaP.text = d.toIso8601String());
              },
            ),
            TextField(
              controller: fechaE,
              decoration: const InputDecoration(labelText: 'Fecha estimada'),
              readOnly: true,
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: fechaE.text.isEmpty
                      ? DateTime.now()
                      : DateTime.parse(fechaE.text),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (d != null) set(() => fechaE.text = d.toIso8601String());
              },
            ),
            DropdownButtonFormField<String>(
              value: estado,
              decoration: const InputDecoration(labelText: 'Estado'),
              items: _reqStates
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => set(() => estado = v!),
            ),
          ]);
        }),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: tonerId != null
                ? () {
                    final dao = ref.read(requisicionesDaoProvider);
                    final companion = RequisicionesCompanion(
                      id: isNew ? const Value.absent() : Value(r!.id!),
                      tonereId: Value(tonerId!),
                      fechaPedido: Value(DateTime.parse(fechaP.text)),
                      fechaEstimEntrega: Value(DateTime.parse(fechaE.text)),
                      estado: Value(estado),
                      
                    );
                    if (isNew) {
                      dao.insertOne(companion);
                    } else {
                      dao.updateOne(companion);
                    }
                    Navigator.pop(context);
                  }
                : null,
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
