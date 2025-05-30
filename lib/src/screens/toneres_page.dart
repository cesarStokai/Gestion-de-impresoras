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
  static const _stateColors = {
    'almacenado': Colors.green,
    'instalado': Colors.blue,
    'en_pedido': Colors.orange,
  };
  static const _colorColors = {
    'Negro': Colors.black,
    'Cian': Colors.cyan,
    'Magenta': Colors.purple,
    'Amarillo': Colors.yellow,
  };

  String? _filterEstado;
  String? _filterColor;

  @override
  Widget build(BuildContext context) {
    final tonerAsync = ref.watch(toneresListStreamProvider);
    final printersAsync = ref.watch(impresorasListStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Tóneres'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _showFilterDialog,
            tooltip: 'Filtrar tóneres',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(9.0),
        child: tonerAsync.when(
          data: (toners) => printersAsync.when(
            data: (printers) {
              final enPedido = toners.where((t) => t.estado == 'en_pedido').length;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildTonerCounter(Icons.local_shipping, 'En pedido', enPedido, Colors.orange),
                      ],
                    ),
                  ),
                  Expanded(child: _buildTonerList(
                    toners.where((t) {
                      final matchEstado = _filterEstado == null || t.estado == _filterEstado;
                      final matchColor = _filterColor == null || t.color == _filterColor;
                      return matchEstado && matchColor;
                    }).toList(),
                    printers,
                  )),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Tóner'),
        onPressed: () => _showForm(),
      ),
    );
  }

  Widget _buildTonerCounter(IconData icon, String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$count', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
              Text(label, style: TextStyle(fontSize: 12, color: color)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTonerList(List<Tonere> toners, List<Impresora> printers) {
    if (toners.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.tonality, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay tóneres registrados',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              'Presiona el botón + para agregar uno',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => ref.refresh(toneresListStreamProvider),
      child: ListView.separated(
        itemCount: toners.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) => _buildTonerTile(toners[i], printers),
      ),
    );
  }

  Widget _buildTonerTile(Tonere t, List<Impresora> printers) {
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

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _colorColors[t.color]?.withOpacity(0.2),
            border: Border.all(
              color: _colorColors[t.color] ?? Colors.grey,
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              t.color[0],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _colorColors[t.color] ?? Colors.grey,
              ),
            ),
          ),
        ),
        title: Text(
          '${t.color}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${printer.marca} ${printer.modelo}'),
            Text('Área: ${printer.area}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(t.estado),
              backgroundColor: _stateColors[t.estado]?.withOpacity(0.2),
              labelStyle: TextStyle(
                color: _stateColors[t.estado] ?? Colors.grey,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(t.id),
            ),
          ],
        ),
        onTap: () => _showForm(t),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
                const SnackBar(
                  content: Text('Tóner eliminado'),
                  behavior: SnackBarBehavior.floating,
                )
              );
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
            title: Text(isNew ? 'Nuevo Tóner' : 'Editar Tóner'),
            content: SingleChildScrollView(
              child: Consumer(
                builder: (ctx, ref, _) {
                  final printersAsync = ref.watch(impresorasListStreamProvider);

                  return printersAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('Error: $e'),
                    data: (printers) {
                      final selectedPrinter = printers.firstWhereOrNull((p) => p.id == impresoraId);
                      
                      // Solo HP y Lexmark pueden elegir color
                      final isHpOrLexmark = selectedPrinter != null &&
                        (selectedPrinter.marca.toLowerCase() == 'hp' || selectedPrinter.marca.toLowerCase() == 'lexmark');
                      if (!isHpOrLexmark) {
                        selectedColor = 'Negro';
                        colorC.text = 'Negro';
                      }

                      return ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 300),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButtonFormField<int>(
                              value: impresoraId,
                              decoration: const InputDecoration(
                                labelText: 'Impresora *',
                                border: OutlineInputBorder(),
                              ),
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
                                  final isHpOrLexmark = printer.marca.toLowerCase() == 'hp' || printer.marca.toLowerCase() == 'lexmark';
                                  if (!isHpOrLexmark) {
                                    selectedColor = 'Negro';
                                    colorC.text = 'Negro';
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            if (isHpOrLexmark)
                              DropdownButtonFormField<String>(
                                value: selectedColor,
                                decoration: const InputDecoration(
                                  labelText: 'Color *',
                                  border: OutlineInputBorder(),
                                ),
                                items: _tonerColors.map((color) {
                                  return DropdownMenuItem(
                                    value: color,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          margin: const EdgeInsets.only(right: 12),
                                          decoration: BoxDecoration(
                                            color: _colorColors[color]?.withOpacity(0.2),
                                            border: Border.all(
                                              color: _colorColors[color] ?? Colors.grey,
                                              width: 2,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Text(color),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (v) {
                                  setState(() {
                                    selectedColor = v;
                                    colorC.text = v ?? '';
                                  });
                                },
                              )
                            else ...[
                              TextField(
                                controller: colorC,
                                decoration: const InputDecoration(
                                  labelText: 'Color',
                                  border: OutlineInputBorder(),
                                ),
                                enabled: false,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.info_outline, color: Colors.grey, size: 18),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Solo HP y Lexmark pueden elegir color. Para Ricoh y otras marcas, el color siempre será Negro.',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: estado,
                              decoration: const InputDecoration(
                                labelText: 'Estado *',
                                border: OutlineInputBorder(),
                              ),
                              items: _tonerStates.map((state) {
                                return DropdownMenuItem(
                                  value: state,
                                  child: Chip(
                                    label: Text(state),
                                    backgroundColor: _stateColors[state]?.withOpacity(0.2),
                                    labelStyle: TextStyle(
                                      color: _stateColors[state] ?? Colors.grey,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (v) => setState(() => estado = v!),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: (impresoraId != null && colorC.text.isNotEmpty && estado.isNotEmpty)
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
                            SnackBar(
                              content: const Text('Tóner creado'),
                              behavior: SnackBarBehavior.floating,
                            )
                          );
                        } else {
                          await dao.updateOne(companion);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Tóner actualizado'),
                              behavior: SnackBarBehavior.floating,
                            )
                          );
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

  void _showFilterDialog() {
    String? selectedEstado = _filterEstado;
    String? selectedColor = _filterColor;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Filtrar Tóneres'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedEstado,
                    decoration: const InputDecoration(
                      labelText: 'Estado',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Todos los estados'),
                      ),
                      ..._tonerStates.map((state) {
                        return DropdownMenuItem(
                          value: state,
                          child: Chip(
                            label: Text(state),
                            backgroundColor: _stateColors[state]?.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: _stateColors[state] ?? Colors.grey,
                            ),
                          ),
                        );
                      }),
                    ],
                    onChanged: (value) => setStateDialog(() => selectedEstado = value),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedColor,
                    decoration: const InputDecoration(
                      labelText: 'Color',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Todos los colores'),
                      ),
                      ..._tonerColors.map((color) {
                        return DropdownMenuItem(
                          value: color,
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: _colorColors[color]?.withOpacity(0.2),
                                  border: Border.all(
                                    color: _colorColors[color] ?? Colors.grey,
                                    width: 2,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(color),
                            ],
                          ),
                        );
                      }),
                    ],
                    onChanged: (value) => setStateDialog(() => selectedColor = value),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    setStateDialog(() {
                      selectedEstado = null;
                      selectedColor = null;
                    });
                  },
                  child: const Text('Limpiar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Aquí usamos setState del widget principal
                    if (mounted) {
                      setState(() {
                        _filterEstado = selectedEstado;
                        _filterColor = selectedColor;
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Aplicar'),
                ),
              ],
            );
          },
        );
      },
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