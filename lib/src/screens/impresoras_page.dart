import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../base/database.dart';
import '../providers/database_provider.dart';

class ImpresorasPage extends ConsumerStatefulWidget {
  const ImpresorasPage({super.key});

  @override
  ConsumerState<ImpresorasPage> createState() => _ImpresorasPageState();
}

class _ImpresorasPageState extends ConsumerState<ImpresorasPage> {
  static const _printerStates = ['activa', 'pendiente_baja', 'baja', 'mantenimiento'];
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final impAsync = ref.watch(impresorasListStreamProvider);
    final tonersAsync = ref.watch(toneresListStreamProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Impresoras'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: PrinterSearchDelegate(ref: ref),
            ),
          ),
        ],
      ),
      body: impAsync.when(
        data: (impresoras) => tonersAsync.when(
          data: (toners) {
            final activas = impresoras.where((i) => i.estado == 'activa').length;
            final fueraServicio = impresoras.where((i) => i.estado == 'baja' || i.estado == 'pendiente_baja').length;
            final enMantenimiento = impresoras.where((i) => i.estado == 'mantenimiento').length;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCounterBox(Icons.print, 'Activas', activas, Colors.green),
                      _buildCounterBox(Icons.block, 'Fuera de servicio', fueraServicio, Colors.red),
                      _buildCounterBox(Icons.build, 'Mantenimiento', enMantenimiento, Colors.blue),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar impresoras...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: impresoras.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final imp = impresoras[i];
                      final impToners = toners.where((t) => t.impresoraId == imp.id).toList();
                      
                      // Filtro de búsqueda
                      if (_searchController.text.isNotEmpty &&
                          !'${imp.marca} ${imp.modelo} ${imp.serie} ${imp.area}'
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase())) {
                        return const SizedBox.shrink();
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => _showForm(imp),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${imp.marca} ${imp.modelo}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    _buildStatusBadge(imp.estado),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Serie: ${imp.serie}',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  'Área: ${imp.area}',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                if (impToners.isEmpty)
                                  Row(
                                    children: [
                                      const Icon(Icons.warning, color: Colors.red),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Sin tóneres registrados',
                                        style: TextStyle(
                                          color: Colors.red[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                else if (imp.esAColor) 
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      _buildTonerIndicator('Cian', _hasToner(impToners, 'Cian')),
                                      _buildTonerIndicator('Magenta', _hasToner(impToners, 'Magenta')),
                                      _buildTonerIndicator('Negro', _hasToner(impToners, 'Negro')),
                                      _buildTonerIndicator('Amarillo', _hasToner(impToners, 'Amarillo')),
                                    ],
                                  )
                                else if (imp.marca.toLowerCase() == 'ricoh')
                                  _buildTonerIndicator('Negro', _hasToner(impToners, 'Negro')),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _confirmDelete(imp.id),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
        onPressed: () => _showForm(),
      ),
    );
  }

  Widget _buildCounterBox(IconData icon, String label, int count, Color color) {
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

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'activa':
        color = Colors.green;
        break;
      case 'pendiente_baja':
        color = Colors.orange;
        break;
      case 'baja':
        color = Colors.red;
        break;
      case 'mantenimiento':
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  bool _hasToner(List<Tonere> toners, String color) {
    // Solo cuenta los toners cuyo estado es 'almacenado'
    return toners.any((t) => t.color.toLowerCase() == color.toLowerCase() && t.estado == 'almacenado');
  }

  Widget _buildTonerIndicator(String color, bool disponible) {
    return Chip(
      backgroundColor: disponible ? Colors.green[50] : Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: disponible ? Colors.green : Colors.grey,
          width: 1,
        ),
      ),
      label: Text(
        color,
        style: TextStyle(
          color: disponible ? Colors.green[800] : Colors.grey[600],
          fontSize: 12,
        ),
      ),
      avatar: Icon(
        disponible ? Icons.check_circle : Icons.circle_outlined,
        color: disponible ? Colors.green : Colors.grey,
        size: 16,
      ),
    );
  }

  void _confirmDelete(int? id) {
    final toners = ref.read(toneresListStreamProvider).value ?? [];
    final asociados = toners.where((t) => t.impresoraId == id).length;
    
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(asociados > 0
            ? 'Esta impresora tiene $asociados tóner(es) asociados. ¿Seguro que deseas eliminarla?'
            : '¿Seguro que deseas eliminar esta impresora?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              ref.read(impresorasDaoProvider).deleteById(id!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Impresora eliminada'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showForm([Impresora? imp]) {
    final isNew = imp == null;
    final marcaC = TextEditingController(text: imp?.marca);
    final modeloC = TextEditingController(text: imp?.modelo);
    final serieC = TextEditingController(text: imp?.serie);
    final areaC = TextEditingController(text: imp?.area);
    String estado = imp?.estado ?? _printerStates.first;
    bool esAColor = imp?.esAColor ?? false;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setState) {
          final ok = isNew
              ? marcaC.text.isNotEmpty &&
                modeloC.text.isNotEmpty &&
                serieC.text.isNotEmpty &&
                areaC.text.isNotEmpty
              : true;

          return AlertDialog(
            titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            actionsPadding: const EdgeInsets.all(12),
            title: Text(
              isNew ? 'Nueva Impresora' : 'Editar Estado de Impresora',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: marcaC,
                    decoration: InputDecoration(
                      labelText: 'Marca *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    onChanged: (_) => setState(() {}),
                    enabled: isNew,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: modeloC,
                    decoration: InputDecoration(
                      labelText: 'Modelo *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    onChanged: (_) => setState(() {}),
                    enabled: isNew,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: serieC,
                    decoration: InputDecoration(
                      labelText: 'Número de Serie *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    onChanged: (_) => setState(() {}),
                    enabled: isNew,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: areaC,
                    decoration: InputDecoration(
                      labelText: 'Área/Departamento *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    onChanged: (_) => setState(() {}),
                    enabled: isNew,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: estado,
                    decoration: InputDecoration(
                      labelText: 'Estado',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    items: _printerStates
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s.replaceAll('_', ' ')),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => estado = v!),
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    title: const Text('Impresora a color (HP/Lexmark)'),
                    value: esAColor,
                    onChanged: isNew ? (value) => setState(() => esAColor = value ?? false) : null,
                    tileColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: ok ? () async {
                  final dao = ref.read(impresorasDaoProvider);
                  final companion = ImpresorasCompanion(
                    id: isNew ? const drift.Value.absent() : drift.Value(imp.id),
                    marca: drift.Value(marcaC.text),
                    modelo: drift.Value(modeloC.text),
                    serie: drift.Value(serieC.text),
                    area: drift.Value(areaC.text),
                    estado: drift.Value(estado),
                    esAColor: drift.Value(esAColor),
                  );

                  if (isNew) {
                    final id = await dao.insertOne(companion);
                    // Si es Ricoh, crear automáticamente tóner negro
                    if (marcaC.text.toLowerCase() == 'ricoh') {
                      await ref.read(toneresDaoProvider).insertOne(
                        ToneresCompanion(
                          impresoraId: drift.Value(id),
                          color: drift.Value('Negro'),
                          estado: drift.Value('almacenado'),
                        ),
                      );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Impresora creada exitosamente'),
                        backgroundColor: Colors.green[700],
                      ),
                    );
                  } else {
                    await dao.updateOne(companion);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Estado de impresora actualizado'),
                        backgroundColor: Colors.green[700],
                      ),
                    );
                  }
                  Navigator.pop(context);
                } : null,
                child: Text(isNew ? 'Crear' : 'Guardar', style: const TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PrinterSearchDelegate extends SearchDelegate {
  final WidgetRef ref;

  PrinterSearchDelegate({required this.ref});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final impAsync = ref.watch(impresorasListStreamProvider);
    final tonersAsync = ref.watch(toneresListStreamProvider);

    return impAsync.when(
      data: (impresoras) => tonersAsync.when(
        data: (toners) => ListView.builder(
          itemCount: impresoras.length,
          itemBuilder: (context, index) {
            final imp = impresoras[index];
            if (!'${imp.marca} ${imp.modelo} ${imp.serie} ${imp.area}'
                .toLowerCase()
                .contains(query.toLowerCase())) {
              return const SizedBox.shrink();
            }

            final impToners = toners.where((t) => t.impresoraId == imp.id).toList();
            
            return ListTile(
              title: Text('${imp.marca} ${imp.modelo}'),
              subtitle: Text('Serie: ${imp.serie} - Área: ${imp.area}'),
              trailing: Text(imp.estado.replaceAll('_', ' ')),
              onTap: () {
                close(context, null);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(title: Text('${imp.marca} ${imp.modelo}')),
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('Marca', imp.marca),
                          _buildDetailRow('Modelo', imp.modelo),
                          _buildDetailRow('Número de Serie', imp.serie),
                          _buildDetailRow('Área/Departamento', imp.area),
                          _buildDetailRow('Estado', imp.estado.replaceAll('_', ' ')),
                          const SizedBox(height: 16),
                          const Text(
                            'Tóneres:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (imp.esAColor) ...[
                            _buildTonerDetail('Cian', impToners, 'Cian'),
                            _buildTonerDetail('Magenta', impToners, 'Magenta'),
                            _buildTonerDetail('Amarillo', impToners, 'Amarillo'),
                            _buildTonerDetail('Negro', impToners, 'Negro'),
                          ] else if (imp.marca.toLowerCase() == 'ricoh')
                            _buildTonerDetail('Negro', impToners, 'Negro'),
                        ],
                      ),
                    ),
                  ),
                ));
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildTonerDetail(String label, List<Tonere> toners, String color) {
    final hasToner = toners.any((t) => t.color.toLowerCase() == color.toLowerCase());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            hasToner ? Icons.check_circle : Icons.circle_outlined,
            color: hasToner ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}