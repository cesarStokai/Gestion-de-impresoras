import 'package:drift/drift.dart' as drift;  // Alias para drift
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../base/database.dart';
import '../providers/database_provider.dart';

class ToneresPage extends ConsumerStatefulWidget {
  const ToneresPage({super.key});  // Corregido el parámetro key
  
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
              subtitle: Text('Impresora ID: ${t.impresoraId} '),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => ref.read(toneresDaoProvider).deleteById(t.id),
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

    // Estado de habilitación del botón "Guardar"
    bool isButtonEnabled = impresoraId != null && colorC.text.isNotEmpty;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(isNew ? 'Nuevo tóner' : 'Editar tóner'),
            content: Consumer(builder: (ctx, ref, _) {
              final printersAsync = ref.watch(impresorasListStreamProvider);

              return printersAsync.when(
                loading: () => const SizedBox(
                  height: 80,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text('Error al cargar impresoras: $e'),
                data: (printers) {
                  final selectedPrinter = printers.firstWhereOrNull((p) => p.id == impresoraId);

                  return Column(  // Ahora usa el Column de Flutter sin conflicto
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
                          setState(() {
                            impresoraId = v;
                            isButtonEnabled = impresoraId != null && colorC.text.isNotEmpty;
                          });
                          debugPrint("Nuevo impresoraId seleccionado: $impresoraId");
                        },
                      ),
                      if (selectedPrinter != null) ...[
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Modelo: ${selectedPrinter.modelo}',
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Área: ${selectedPrinter.area}',
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      TextField(
                        controller: colorC,
                        decoration: const InputDecoration(labelText: 'Color *'),
                        onChanged: (value) {
                          setState(() {
                            isButtonEnabled = value.isNotEmpty && impresoraId != null;
                          });
                        },
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
                onPressed: isButtonEnabled
                    ? () async {
                        debugPrint("Intentando guardar o actualizar el tóner...");
                        debugPrint("Fecha estimada: ${fechaEstC.text}");

                        final dao = ref.read(toneresDaoProvider);
                        final companion = ToneresCompanion(
                          id: isNew ? const drift.Value.absent() : drift.Value(t.id),
                          impresoraId: drift.Value(impresoraId!),
                          color: drift.Value(colorC.text),
                          estado: drift.Value(estado),
                          fechaEstimEntrega: fechaEstC.text.isEmpty
                              ? const drift.Value.absent()
                              : drift.Value(DateTime.parse(fechaEstC.text)),
                        );

                        debugPrint("Datos para insertar/actualizar: $companion");

                        try {
                          if (isNew) {
                            await dao.insertOne(companion);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Tóner creado')),
                              );
                            }
                          } else {
                            await dao.updateOne(companion);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Tóner actualizado')),
                              );
                            }
                          }
                          if (mounted) {
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          debugPrint("Error al guardar el tóner: $e");
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Error al guardar el tóner')),
                            );
                          }
                        }
                      }
                    : null,
                child: Text(isNew ? 'Crear' : 'Guardar'),
              ),
            ],
          );
        },
      ),
    );
  }
}

extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}