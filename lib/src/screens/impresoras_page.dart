
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/Impresora.dart';
import '../providers/excel_provider.dart';
import '../providers/database_provider.dart';


class ImpresorasPage extends ConsumerWidget {
  const ImpresorasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final impresorasAsync = ref.watch(impresorasListStreamProvider);


    return impresorasAsync.when(
      data: (lista) => ListView.builder(
        itemCount: lista.length,
        itemBuilder: (_, i) {
          final imp = lista[i];
          return ListTile(
            title: Text('${imp.marca} ${imp.modelo}'),
            subtitle: Text(imp.serie),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );

    
  }
  
}


