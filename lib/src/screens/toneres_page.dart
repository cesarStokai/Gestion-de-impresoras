import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../base/database.dart';
import '../providers/database_provider.dart';

class ToneresPage extends ConsumerStatefulWidget {
  const ToneresPage({super.key});

  @override
  ConsumerState<ToneresPage> createState() => _ToneresPageState();
}

class _ToneresPageState extends ConsumerState<ToneresPage> {
  static const _tonerStates = ['almacenado', 'instalado', 'en_pedido'];
  static const _tonerColors = ['Negro', 'Cian', 'Magenta', 'Amarillo'];

  @override
  Widget build(BuildContext context) {
    final tonerAsync = ref.watch(toneresListStreamProvider);
    final printersAsync = ref.watch(impresorasListStreamProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Tóneres')),
      body: tonerAsync.when(
        data: (toners) => printersAsync.when(
          data: (printers) => ListView.separated(
            itemCount: toners.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (_, i) {
              final t = toners[i];
              final printer = printers.firstWhere(
                (p) => p.id == t.impresoraId,
                orElse: () => Impresora(
                  id: 0,
                  marca: 'Desconocida',
                  modelo: '',
                  serie: '',
                  area: '',
                  estado: '',
                  esAColor: false,
                ),
              );
              
              return ListTile(
                title: Text('${t.color} (${t.estado})'),
                subtitle: Text('Impresora: ${printer.marca} ${printer.modelo}\nÁrea: ${printer.area}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(t.id),
                ),
                onTap: () => _showForm(t),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
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

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Seguro que quieres eliminar este tóner?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(toneresDaoProvider).deleteById(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tóner eliminado')));
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showForm([Tonere? t]) {
    final isNew = t == null;
    final colorC = TextEditingController(text: t?.color);
    int? impresoraId = t?.impresoraId;
    String estado = t?.estado ?? _tonerStates.first;
    String? selectedColor = t?.color;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(isNew ? 'Nuevo tóner' : 'Editar tóner'),
            content: Consumer(
              builder: (ctx, ref, _) {
                final printersAsync = ref.watch(impresorasListStreamProvider);
                
                return printersAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error: $e'),
                  data: (printers) {
                    final selectedPrinter = printers.firstWhereOrNull((p) => p.id == impresoraId);
                    final isRicoh = selectedPrinter?.marca.toLowerCase() == 'ricoh';
                    
                    // Si es Ricoh, forzar color negro
                    if (isRicoh && isNew) {
                      selectedColor = 'Negro';
                      colorC.text = 'Negro';
                    }
                    
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
                            setState(() {
                              impresoraId = v;
                              final printer = printers.firstWhere((p) => p.id == v);
                              if (printer.marca.toLowerCase() == 'ricoh') {
                                selectedColor = 'Negro';
                                colorC.text = 'Negro';
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        if (selectedPrinter != null && 
                            selectedPrinter.marca.toLowerCase() != 'ricoh')
                          DropdownButtonFormField<String>(
                            value: selectedColor,
                            decoration: const InputDecoration(labelText: 'Color *'),
                            items: _tonerColors.map((color) {
                              return DropdownMenuItem(
                                value: color,
                                child: Text(color),
                              );
                            }).toList(),
                            onChanged: (v) {
                              setState(() {
                                selectedColor = v;
                                colorC.text = v ?? '';
                              });
                            },
                          )
                        else
                          TextField(
                            controller: colorC,
                            decoration: const InputDecoration(labelText: 'Color'),
                            enabled: false,
                          ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: estado,
                          decoration: const InputDecoration(labelText: 'Estado *'),
                          items: _tonerStates.map((state) {
                            return DropdownMenuItem(
                              value: state,
                              child: Text(state),
                            );
                          }).toList(),
                          onChanged: (v) => setState(() => estado = v!),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: impresoraId != null && colorC.text.isNotEmpty
                    ? () async {
                        final dao = ref.read(toneresDaoProvider);
                        final companion = ToneresCompanion(
                          id: isNew ? const drift.Value.absent() : drift.Value(t.id),
                          impresoraId: drift.Value(impresoraId!),
                          color: drift.Value(colorC.text),
                          estado: drift.Value(estado),
                        );
                        
                        if (isNew) {
                          await dao.insertOne(companion);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Tóner creado')));
                        } else {
                          await dao.updateOne(companion);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Tóner actualizado')));
                        }
                        Navigator.pop(context);
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