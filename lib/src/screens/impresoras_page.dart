import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../base/database.dart';
import '../providers/database_provider.dart';

class ImpresorasPage extends ConsumerWidget {
  const ImpresorasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final impresorasAsync = ref.watch(impresorasListStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Impresoras')),
      body: impresorasAsync.when(
        data: (impresoras) => ListView.builder(
          itemCount: impresoras.length,
          itemBuilder: (_, i) {
            final imp = impresoras[i];
            return ListTile(
              title: Text('Marca:${imp.marca} - Modelo:${imp.modelo}'),
              subtitle: Text('Area donde se encuentra: ${imp.area}\nEstado de la impresora:${imp.estado}\nNumero de serie: ${imp.serie} ' ),
              
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  ref.read(impresorasDaoProvider).deleteById(imp.id);
                },
              ),
              onTap: () {
                // aquí podrías abrir un diálogo para editar...
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddDialog(context, ref),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final marcaCtrl = TextEditingController();
    final modeloCtrl = TextEditingController();
    final serieCtrl = TextEditingController();
    final areaCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nueva impresora'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: marcaCtrl,
                decoration: const InputDecoration(labelText: 'Marca')),
            TextField(
                controller: modeloCtrl,
                decoration: const InputDecoration(labelText: 'Modelo')),
            TextField(
                controller: serieCtrl,
                decoration: const InputDecoration(labelText: 'Serie')),
            TextField(
                controller: areaCtrl,
                decoration: const InputDecoration(labelText: 'Área')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final entry = ImpresorasCompanion.insert(
                marca: marcaCtrl.text,
                modelo: modeloCtrl.text,
                serie: serieCtrl.text,
                area: areaCtrl.text,
                // estado: 'activa',  // si quieres sobreescribir el default
              );

              ref.read(impresorasDaoProvider).insertOne(entry);
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
