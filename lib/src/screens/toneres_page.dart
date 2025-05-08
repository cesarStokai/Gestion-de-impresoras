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
  static const _tonerStates = ['almacenado','instalado','en_pedido'];

  @override
  Widget build(BuildContext context) {
    final tonerAsync = ref.watch(toneresListStreamProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Tóneres')),
      body: tonerAsync.when(
        data: (list) => ListView.separated(
          itemCount: list.length,
          separatorBuilder: (_,__) => const Divider(),
          itemBuilder: (_, i) {
            final t = list[i];
            return ListTile(
              title: Text('${t.color} (${t.estado})'),
              subtitle: Text('Impresora ID: ${t.impresoraId}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: ()=> ref.read(toneresDaoProvider).deleteById(t.id!),
              ),
              onTap: ()=> _showForm(t),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e,_) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: ()=> _showForm(),
      ),
    );
  }

  void _showForm([Tonere? t]) {
    final isNew = t==null;
    final colorC = TextEditingController(text: t?.color);
    final fechaEstC = TextEditingController(text: t?.fechaEstimEntrega?.toIso8601String()??'');
    int? impresoraId = t?.impresoraId;
    String estado = t?.estado ?? _tonerStates.first;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isNew?'Nuevo tóner':'Editar tóner'),
        content: StatefulBuilder(builder:(ctx,set) {
          final printers = ref.watch(impresorasListStreamProvider).value ?? [];
          return Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButtonFormField<int>(
              value: impresoraId,
              decoration: const InputDecoration(labelText: 'Impresora *'),
              items: printers.map((p)=>DropdownMenuItem(
                value: p.id!, child: Text('${p.marca} ${p.modelo}')
              )).toList(),
              onChanged: (v)=> set(()=> impresoraId=v),
            ),
            TextField(controller: colorC, decoration: const InputDecoration(labelText: 'Color *')),
            DropdownButtonFormField<String>(
              value: estado,
              decoration: const InputDecoration(labelText: 'Estado'),
              items: _tonerStates.map((s)=>DropdownMenuItem(value:s,child:Text(s))).toList(),
              onChanged:(v)=> set(()=> estado=v!),
            ),
            TextField(
              controller: fechaEstC,
              decoration: const InputDecoration(labelText: 'Fecha estimada'),
              readOnly: true,
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: DateTime.tryParse(fechaEstC.text) ?? DateTime.now(),
                  firstDate: DateTime(2000), lastDate: DateTime(2100),
                );
                if (d!=null) set(()=> fechaEstC.text=d.toIso8601String());
              },
            ),
          ]);
        }),
        actions: [
          TextButton(onPressed: ()=> Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: impresoraId!=null && colorC.text.isNotEmpty ? () {
              final dao = ref.read(toneresDaoProvider);
              if (isNew) {
                dao.insertOne(ToneresCompanion.insert(
                  impresoraId: Value(impresoraId!),
                  color: Value(colorC.text),
                  estado: Value(estado),
                  fechaEstimEntrega: fechaEstC.text.isEmpty
                    ? const Value.absent()
                    : Value(DateTime.parse(fechaEstC.text)),
                ));
              } else {
                dao.updateOne(Insertable<Tonere>.fromData({
                  'id': t!.id!,
                  'impresora_id': impresoraId,
                  'color': colorC.text,
                  'estado': estado,
                  'fecha_estim_entrega': fechaEstC.text.isEmpty?null: DateTime.parse(fechaEstC.text),
                }, db: ref.read(databaseProvider)));
              }
              Navigator.pop(context);
            } : null,
            child: Text(isNew?'Crear':'Guardar'),
          ),
        ],
      ),
    );
  }
}
