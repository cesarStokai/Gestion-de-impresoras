import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../base/database.dart';
import '../providers/database_provider.dart';

class ToneresPage extends ConsumerStatefulWidget {
  const ToneresPage({Key? key}) : super(key: key);
  @override
  ConsumerState<ToneresPage> createState() => _ToneresPageState();
}

class _ToneresPageState extends ConsumerState<ToneresPage> {
  static const _tonerStates = ['almacenado', 'instalado', 'en_pedido'];

  @override
  Widget build(BuildContext context) {
    final tonerAsync = ref.watch(toneresListStreamProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Tóneres')),
      body: tonerAsync.when(
        data: (list) => ListView.separated(
          itemCount: list.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, i) {
            final t = list[i];
            return ListTile(
              title: Text('${t.color} (${t.estado})'),
              subtitle: Text('Impresora ID: ${t.impresoraId}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => ref.read(toneresDaoProvider).deleteById(t.id!),
              ),
              onTap: () => _showForm(t),
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


void _showForm([Tonere? t]) {
  final isNew = t == null;
  final colorC = TextEditingController(text: t?.color);
  final fechaEstC = TextEditingController(
    text: t?.fechaEstimEntrega?.toIso8601String() ?? '',
  );
  int? impresoraId = t?.impresoraId;
  String estado = t?.estado ?? _tonerStates.first;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(isNew ? 'Nuevo tóner' : 'Editar tóner'),
      content: Consumer(builder: (ctx, ref, _) {
        // 1) Miramos el AsyncValue de la lista de impresoras
        final printersAsync = ref.watch(impresorasListStreamProvider);

        return printersAsync.when(
          loading: () => const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text('Error al cargar impresoras: $e'),
          data: (printers) {
            // 2) Una vez tenemos la lista, construimos el formulario
            final selectedPrinter = printers
                .firstWhereOrNull((p) => p.id == impresoraId);

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  value: impresoraId,
                  decoration: const InputDecoration(labelText: 'Impresora *'),
                  items: printers.map((p) {
                    return DropdownMenuItem(
                      value: p.id,
                      child: Text('${p.marca} ${p.modelo}'),
                    );
                  }).toList(),
                  onChanged: (v) {
                    setState(() => impresoraId = v);
                  },
                ),
                if (selectedPrinter != null) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Modelo: ${selectedPrinter.modelo}',
                      style:
                          const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Área: ${selectedPrinter.area}',
                      style:
                          const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                TextField(
                  controller: colorC,
                  decoration: const InputDecoration(labelText: 'Color *'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: estado,
                  decoration: const InputDecoration(labelText: 'Estado'),
                  items: _tonerStates
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => estado = v!),
                ),
                const SizedBox(height: 12),
                
              ],
            );
          },
        );
      }),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: impresoraId != null && colorC.text.isNotEmpty
              ? () {
                  final dao = ref.read(toneresDaoProvider);
                  final companion = ToneresCompanion(
                    id: isNew ? const Value.absent() : Value(t!.id!),
                    impresoraId: Value(impresoraId!),
                    color: Value(colorC.text),
                    estado: Value(estado),
                    fechaEstimEntrega: fechaEstC.text.isEmpty
                        ? const Value.absent()
                        : Value(DateTime.parse(fechaEstC.text)),
                  );
                  if (isNew) {
                    dao.insertOne(companion);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tóner creado')),
                    );
                  } else {
                    dao.updateOne(companion);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tóner actualizado')),
                    );
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

extension on List<Impresora> {
  firstWhereOrNull(bool Function(dynamic p) param0) {}
}
