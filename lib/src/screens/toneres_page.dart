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

class _ToneresPageState extends ConsumerState<ToneresPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // _deleteOrphanToners(); // Removed unused method
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Tóneres'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Registro de Tóner'),
            Tab(text: 'Asignación de Tóner'),
          ],
        ),
        actions: [
          // if (_tabController.index == 1)
          //   IconButton(
          //     icon: const Icon(Icons.filter_alt),
          //     onPressed: _showFilterDialog,
          //     tooltip: 'Filtrar tóneres',
          //   ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 0: Registro de tóner
          _buildRegistroTab(),
          // Tab 1: Asignación de tóner
          _buildAsignacionTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: const Text('Nuevo Tóner'),
              onPressed: () => _showForm(),
            )
          : null,
    );
  }

  Widget _buildRegistroTab() {
    final tonerAsync = ref.watch(toneresListStreamProvider);
    final modelosTonnerAsync = ref.watch(modelosTonnerListProvider);
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Column(
        children: [
          // Ayuda visual para el nuevo flujo unificado
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: Colors.blueGrey, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ahora puedes gestionar la compatibilidad de modelos de impresora directamente al registrar o editar un tóner.',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: tonerAsync.when(
              data: (toners) {
                final almacenados = toners.where((t) => t.estado == 'almacenado').toList();
                return modelosTonnerAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                  data: (modelosTonner) {
                    if (almacenados.isEmpty) {
                      return const Center(
                        child: Text('No hay tóneres almacenados. Usa el botón + para registrar.'),
                      );
                    }
                    return ListView.separated(
                      itemCount: almacenados.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) => _buildTonerTileV2(almacenados[i], const [], modelosTonner),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

 

  Widget _buildAsignacionTab() {
    final tonerAsync = ref.watch(toneresListStreamProvider);
    final printersAsync = ref.watch(impresorasListStreamProvider);
    return Padding(
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
    return Consumer(
      builder: (context, ref, _) {
        final modelosTonnerAsync = ref.watch(modelosTonnerListProvider);
        return modelosTonnerAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (modelosTonner) {
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
                itemBuilder: (_, i) => _buildTonerTileV2(toners[i], printers, modelosTonner),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTonerTileV2(Tonere t, List<Impresora> printers, List modelosTonner) {
    final modelo = modelosTonner.where((m) => m.id == t.modeloTonnerId).isNotEmpty ? modelosTonner.firstWhere((m) => m.id == t.modeloTonnerId) : null;
    final printer = printers.where((p) => p.id == t.impresoraId).isNotEmpty ? printers.firstWhere((p) => p.id == t.impresoraId) : null;

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
              t.color.isNotEmpty ? t.color[0] : '?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _colorColors[t.color] ?? Colors.grey,
              ),
            ),
          ),
        ),
        title: Text(
          modelo != null ? modelo.nombre : 'Modelo desconocido',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Color: ${t.color}'),
            if (printer != null)
              Text('Instalado en: ${printer.marca} ${printer.modelo} (${printer.area})'),
            if (printer == null)
              const Text('En almacén'),
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
            if (t.estado == 'almacenado')
              IconButton(
                icon: const Icon(Icons.input, color: Colors.blue),
                tooltip: 'Instalar en impresora',
                onPressed: () => _showAsignarTonerDialog(t),
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

  void _showAsignarTonerDialog(Tonere t) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final impresorasAsync = ref.watch(impresorasListStreamProvider);
            final modelosTonnerAsync = ref.watch(modelosTonnerListProvider);
            final modelosTonnerDao = ref.read(modelosTonnerDaoProvider);
            return impresorasAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => AlertDialog(title: const Text('Error'), content: Text('Error: $e')),
              data: (impresoras) {
                return modelosTonnerAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => AlertDialog(title: const Text('Error'), content: Text('Error: $e')),
                  data: (modelosTonner) {
                    // final modeloToner = modelosTonner.firstWhereOrNull((m) => m.id == t.modeloTonnerId); // No se usa
                    // Obtener modelos de impresora compatibles para este modelo de tóner
                    return FutureBuilder<List<String>>(
                      future: modelosTonnerDao.getModelosImpresoraCompatiblesPorToner(t.modeloTonnerId!),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final modelosCompatibles = snapshot.data!;
                        // Filtrar impresoras activas y compatibles
                        final compatibles = impresoras.where((imp) =>
                          imp.estado == 'activa' && modelosCompatibles.contains(imp.modelo)
                        ).toList();
                        int? selectedImpresoraId;
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: const Text('Instalar tóner en impresora'),
                              content: compatibles.isEmpty
                                  ? const Text('No hay impresoras compatibles disponibles.')
                                  : DropdownButtonFormField<int>(
                                      decoration: const InputDecoration(labelText: 'Selecciona impresora'),
                                      value: selectedImpresoraId,
                                      items: compatibles.map((imp) => DropdownMenuItem(
                                            value: imp.id,
                                            child: Text('${imp.marca} ${imp.modelo} (${imp.area})'),
                                          )).toList(),
                                      onChanged: (impresoraId) async {
                                        setState(() {
                                          selectedImpresoraId = impresoraId;
                                        });
                                        if (impresoraId == null) return;
                                        final dao = ref.read(toneresDaoProvider);
                                        await dao.updateOne(
                                          t.copyWith(
                                            impresoraId: impresoraId,
                                            estado: 'instalado',
                                            fechaInstalacion: drift.Value(DateTime.now()),
                                          ),
                                        );
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Tóner instalado en impresora'),
                                            backgroundColor: Colors.blue,
                                          ),
                                        );
                                      },
                                    ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancelar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
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
    // ...existing code for _showForm (unified, optimized version)...
    // (The legacy/duplicated form code block has been removed)
    final isNew = t == null;
    int? modeloTonnerId = t?.modeloTonnerId;
    String estado = t?.estado ?? _tonerStates.first;
    bool esColor = false;
    List<String> coloresSeleccionados = [];
    String color = t?.color ?? '';
    int? impresoraIdSeleccionada = t?.impresoraId;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          final TextEditingController _nuevoModeloController = TextEditingController();
          bool creandoModelo = false;
          String? errorNuevoModelo;
          // impresoraIdSeleccionada ahora se inicializa arriba y se mantiene en el scope correcto
          return AlertDialog(
            title: Text(isNew ? 'Nuevo Tóner' : 'Editar Tóner'),
            content: SingleChildScrollView(
              child: Consumer(
                builder: (ctx, ref, _) {
                  final modelosTonnerAsync = ref.watch(modelosTonnerListProvider);
                  final impresorasAsync = ref.watch(impresorasListStreamProvider);
                  final modelosTonnerDao = ref.read(modelosTonnerDaoProvider);
                  return impresorasAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('Error: $e'),
                    data: (impresoras) {
                      final impresorasColor = impresoras.where((i) => i.esAColor).toList();
                      final impresorasMono = impresoras.where((i) => !i.esAColor).toList();
                      if (esColor) {
                        // Solo impresora a color y selección de cartuchos
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: esColor,
                                  onChanged: (v) {
                                    setState(() {
                                      esColor = v ?? false;
                                      coloresSeleccionados = [];
                                      color = '';
                                      impresoraIdSeleccionada = null;
                                    });
                                  },
                                ),
                                const Text('¿Impresora a color?'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text('Selecciona impresora a color:'),
                            DropdownButtonFormField<int>(
                              value: impresoraIdSeleccionada,
                              decoration: const InputDecoration(
                                labelText: 'Impresora a color',
                                border: OutlineInputBorder(),
                              ),
                              items: impresorasColor.map((i) => DropdownMenuItem(
                                value: i.id,
                                child: Text('${i.marca} ${i.modelo}'),
                              )).toList(),
                              onChanged: (v) => setState(() => impresoraIdSeleccionada = v),
                            ),
                            const SizedBox(height: 8),
                            const Text('Colores disponibles:'),
                            Wrap(
                              spacing: 8,
                              children: _tonerColors.map((c) => FilterChip(
                                label: Text(c),
                                selected: coloresSeleccionados.contains(c),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      coloresSeleccionados.add(c);
                                    } else {
                                      coloresSeleccionados.remove(c);
                                    }
                                  });
                                },
                              )).toList(),
                            ),
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
                        );
                      } else {
                        // Monocromática: modelo de tóner y compatibilidad
                        return modelosTonnerAsync.when(
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Text('Error: $e'),
                          data: (modelosTonner) {
                            final selectedModelo = modelosTonner.where((m) => m.id == modeloTonnerId).isNotEmpty ? modelosTonner.firstWhere((m) => m.id == modeloTonnerId) : null;
                            // Solo mostrar modelos de impresora monocromática para compatibilidad
                            final modelosImpresora = impresoras
                                .where((i) => !i.esAColor)
                                .map((i) => i.modelo)
                                .toSet()
                                .toList();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: esColor,
                                      onChanged: (v) {
                                        setState(() {
                                          esColor = v ?? false;
                                          coloresSeleccionados = [];
                                          color = '';
                                          impresoraIdSeleccionada = null;
                                        });
                                      },
                                    ),
                                    const Text('¿Impresora a color?'),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<int>(
                                        value: modeloTonnerId,
                                        decoration: const InputDecoration(
                                          labelText: 'Modelo de Tóner *',
                                          border: OutlineInputBorder(),
                                        ),
                                        items: modelosTonner.map((m) {
                                          return DropdownMenuItem(
                                            value: m.id,
                                            child: Text(m.nombre),
                                          );
                                        }).toList(),
                                        onChanged: (v) {
                                          setState(() {
                                            modeloTonnerId = v;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Tooltip(
                                      message: 'Registrar nuevo modelo de tóner',
                                      child: IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return StatefulBuilder(
                                                builder: (context, setStateDialog) {
                                                  return AlertDialog(
                                                    title: const Text('Nuevo modelo de tóner'),
                                                    content: TextField(
                                                      controller: _nuevoModeloController,
                                                      decoration: InputDecoration(
                                                        labelText: 'Nombre del modelo',
                                                        errorText: errorNuevoModelo,
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(context),
                                                        child: const Text('Cancelar'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: creandoModelo
                                                            ? null
                                                            : () async {
                                                                final nombre = _nuevoModeloController.text.trim();
                                                                if (nombre.isEmpty) {
                                                                  setStateDialog(() => errorNuevoModelo = 'El nombre es obligatorio');
                                                                  return;
                                                                }
                                                                setStateDialog(() => creandoModelo = true);
                                                                final id = await modelosTonnerDao.crearModeloTonner(nombre: nombre);
                                                                setState(() {
                                                                  modeloTonnerId = id;
                                                                });
                                                                Navigator.pop(context);
                                                              },
                                                        child: const Text('Guardar'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          );
                                          _nuevoModeloController.clear();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text('Selecciona impresora monocromática:'),
                                DropdownButtonFormField<int>(
                                  value: impresoraIdSeleccionada,
                                  decoration: const InputDecoration(
                                    labelText: 'Impresora monocromática',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: impresorasMono.map((i) => DropdownMenuItem(
                                    value: i.id,
                                    child: Text('${i.marca} ${i.modelo}'),
                                  )).toList(),
                                  onChanged: (v) => setState(() => impresoraIdSeleccionada = v),
                                ),
                                const SizedBox(height: 8),
                                const Text('Color: Negro'),
                                const SizedBox(height: 16),
                                // Compatibilidad UI y estado
                                FutureBuilder<List<String>>(
                                  future: modeloTonnerId != null
                                      ? modelosTonnerDao.getModelosImpresoraCompatiblesPorToner(modeloTonnerId!)
                                      : Future.value([]),
                                  builder: (context, snapshot) {
                                    final modelosCompatibles = snapshot.data ?? [];
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (modeloTonnerId != null) ...[
                                          const Text('Compatibilidad con modelos de impresora:', style: TextStyle(fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 6),
                                          Wrap(
                                            spacing: 6,
                                            runSpacing: 6,
                                            children: modelosImpresora.map((modelo) {
                                              final isCompatible = modelosCompatibles.contains(modelo);
                                              return FilterChip(
                                                label: Text(modelo),
                                                selected: isCompatible,
                                                onSelected: (_) async {
                                                  if (modeloTonnerId == null) return;
                                                  if (isCompatible) {
                                                    await modelosTonnerDao.eliminarCompatibilidad(
                                                      modeloImpresora: modelo,
                                                      modeloTonnerId: modeloTonnerId!,
                                                    );
                                                  } else {
                                                    await modelosTonnerDao.agregarCompatibilidad(
                                                      modeloImpresora: modelo,
                                                      modeloTonnerId: modeloTonnerId!,
                                                    );
                                                  }
                                                  setState(() {});
                                                },
                                                selectedColor: Colors.green.withOpacity(0.2),
                                                checkmarkColor: Colors.green,
                                              );
                                            }).toList(),
                                          ),
                                          if (modelosCompatibles.isEmpty)
                                            const Padding(
                                              padding: EdgeInsets.only(top: 8.0),
                                              child: Text('¡Agrega al menos una compatibilidad antes de guardar!', style: TextStyle(color: Colors.red)),
                                            ),
                                          const SizedBox(height: 16),
                                        ],
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
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
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
                  foregroundColor: Colors.white, // Asegura texto blanco
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  final dao = ref.read(toneresDaoProvider);
                  if (esColor) {
                    if (impresoraIdSeleccionada == null || coloresSeleccionados.isEmpty || estado.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Selecciona impresora y al menos un color.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    for (final c in coloresSeleccionados) {
                      await dao.insertOne(ToneresCompanion(
                        modeloTonnerId: const drift.Value.absent(),
                        color: drift.Value(c),
                        estado: drift.Value(estado),
                        impresoraId: drift.Value(impresoraIdSeleccionada!),
                      ));
                    }
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tóner(es) registrado(s) correctamente.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    if (modeloTonnerId == null || estado.isEmpty || impresoraIdSeleccionada == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Completa todos los campos obligatorios.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    // Buscar la impresora seleccionada (de cualquier tipo)
                    final impresorasAsync = ref.read(impresorasListStreamProvider);
                    List<Impresora> impresoras = impresorasAsync.maybeWhen(
                      data: (list) => list,
                      orElse: () => <Impresora>[],
                    );
                    Impresora? impresoraSeleccionada;
                    try {
                      impresoraSeleccionada = impresoras.firstWhere((i) => i.id == impresoraIdSeleccionada);
                    } catch (_) {
                      impresoraSeleccionada = null;
                    }
                    final esRicoh = impresoraSeleccionada != null && impresoraSeleccionada.marca.toLowerCase().contains('ricoh');
                    final modelosTonnerDao = ref.read(modelosTonnerDaoProvider);
                    final compatibles = await modelosTonnerDao.getModelosImpresoraCompatiblesPorToner(modeloTonnerId!);
                    if (compatibles.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Agrega al menos una compatibilidad antes de guardar.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    // Validar que la impresora seleccionada sea compatible
                    if (impresoraSeleccionada == null || !compatibles.contains(impresoraSeleccionada.modelo)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('La impresora seleccionada no es compatible con el modelo de tóner.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    await dao.insertOne(ToneresCompanion(
                      modeloTonnerId: drift.Value(modeloTonnerId!),
                      color: drift.Value('Negro'),
                      estado: drift.Value(estado),
                      impresoraId: drift.Value(impresoraIdSeleccionada!),
                    ));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(esRicoh ? 'Tóner Ricoh registrado correctamente.' : 'Tóner registrado correctamente.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      ),
    );




}
}