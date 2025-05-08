import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../base/database.dart';
import '../providers/database_provider.dart';

class MantenimientosPage extends ConsumerStatefulWidget {
  const MantenimientosPage({Key? key}) : super(key: key);
  @override
  ConsumerState<MantenimientosPage> createState() => _MantenimientosPageState();
}

class _MantenimientosPageState extends ConsumerState<MantenimientosPage> {
  @override
  Widget build(BuildContext context) {
    final mantAsync = ref.watch(mantenimientosListStreamProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Mantenimientos')),
      body: mantAsync.when(
        data: (list)=>ListView.separated(
          itemCount:list.length,
          separatorBuilder:(_,__)=>const Divider(),
          itemBuilder:(_,i){
            final m=list[i];
            return ListTile(
              title: Text('Impresora: ${m.impresoraId}'),
              subtitle: Text('${m.fecha.toLocal().toShortIsoDate()}\n${m.detalle}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: ()=> ref.read(mantenimientosDaoProvider).deleteById(m.id!),
              ),
            );
          },
        ),
        loading:()=>const Center(child:CircularProgressIndicator()),
        error:(e,_ )=>Center(child:Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.build),
        onPressed: ()=> _showForm(),
      ),
    );
  }

  void _showForm([Mantenimiento? m]) {
    final isNew = m==null;
    int? origen = m?.impresoraId;
    DateTime fecha = m?.fecha ?? DateTime.now();
    final detalleC = TextEditingController(text: m?.detalle);
    bool reemplazo = m?.reemplazoImpresora ?? false;
    int? reemplazoId = m?.nuevaImpresoraId;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isNew?'Nuevo mantenimiento':'Editar mantenimiento'),
        content: StatefulBuilder(builder:(ctx,set){
          final printers = ref.watch(impresorasListStreamProvider).value ?? [];
          return SingleChildScrollView(child: Column(mainAxisSize:MainAxisSize.min,children:[
            DropdownButtonFormField<int>(
              value: origen,
              decoration: const InputDecoration(labelText: 'Impresora *'),
              items: printers.map((p)=>DropdownMenuItem(
                value:p.id!, child:Text('${p.marca} ${p.modelo}')
              )).toList(),
              onChanged:(v)=> set(()=> origen=v),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Fecha'),
              controller: TextEditingController(text: fecha.toIso8601String().split('T').first),
              readOnly:true,
              onTap:() async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: fecha,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if(d!=null) set(()=> fecha=d);
              },
            ),
            TextField(controller: detalleC, decoration: const InputDecoration(labelText: 'Detalle *')),
            Row(children:[
              const Text('Reemplazo impresora'),
              Checkbox(value: reemplazo, onChanged:(b)=> set(()=> reemplazo=b!)),
            ]),
            if(reemplazo)
              DropdownButtonFormField<int>(
                value: reemplazoId,
                decoration: const InputDecoration(labelText: 'Nueva impresora'),
                items: printers.map((p)=>DropdownMenuItem(
                  value:p.id!, child:Text('${p.marca} ${p.modelo}')
                )).toList(),
                onChanged:(v)=> set(()=> reemplazoId=v),
              ),
          ]));
        }),
        actions:[
          TextButton(onPressed:()=>Navigator.pop(context), child:const Text('Cancelar')),
          ElevatedButton(
            onPressed: origen!=null && detalleC.text.isNotEmpty ? (){
              final dao = ref.read(mantenimientosDaoProvider);
              if(isNew){
                dao.insertOne(MantenimientosCompanion.insert(
                  impresoraId: Value(origen!),
                  fecha: Value(fecha),
                  detalle: Value(detalleC.text),
                  reemplazoImpresora: Value(reemplazo),
                  nuevaImpresoraId: reemplazo
                    ? Value(reemplazoId!)
                    : const Value.absent(),
                ));
              } else {
                dao.updateOne(Insertable<Mantenimiento>.fromData({
                  'id': m!.id!,
                  'impresora_id': origen,
                  'fecha': fecha,
                  'detalle': detalleC.text,
                  'reemplazo_impresora': reemplazo?1:0,
                  'nueva_impresora_id': reemplazo? reemplazoId:null,
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

extension _DateShort on DateTime {
  String toShortIsoDate() => toIso8601String().split('T').first;
}
