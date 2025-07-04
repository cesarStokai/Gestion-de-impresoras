import 'package:control_impresoras/src/base/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../providers/database_provider.dart';
import '../utils/error_handler.dart';
import 'package:drift/drift.dart' show Value;

class ContadoresPage extends ConsumerStatefulWidget {
  const ContadoresPage({super.key});

  @override
  ConsumerState<ContadoresPage> createState() => _ContadoresPageState();
}

class _ContadoresPageState extends ConsumerState<ContadoresPage> {
  late DateTime _selectedMonth;
  final Map<int, TextEditingController> _controllers = {};
  String _searchText = '';
  int? _hoveredIndex; // Para sombreado en web
  int? _selectedIndex; // Para sombreado al tap en móvil

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
    initializeDateFormatting('es');
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  String get mesString => DateFormat('yyyy-MM').format(_selectedMonth);

  Future<void> _guardarContadores(List impresoras) async {
    final contadoresDao = ref.read(contadoresDaoProvider);
    bool huboError = false;
    for (final imp in impresoras) {
      final text = _controllers[imp.id]?.text ?? '';
      if (text.isEmpty) continue;
      final valor = int.tryParse(text);
      if (valor == null) {
        ErrorHandler.showError(context, 'Valor inválido para ${imp.marca} ${imp.modelo}');
        huboError = true;
        continue;
      }
      try {
        final existente = await contadoresDao.getByImpresoraYMes(imp.id, mesString);
        if (existente == null) {
          await contadoresDao.insertContador(ContadoresCompanion(
            impresoraId: Value(imp.id),
            mes: Value(mesString),
            contador: Value(valor),
          ));
        } else {
          await contadoresDao.updateContador(
            existente.copyWith(contador: valor),
          );
        }
      } catch (e) {
        ErrorHandler.showError(context, 'Error al guardar contador de ${imp.marca} ${imp.modelo}: $e');
        huboError = true;
      }
    }
    if (!huboError) {
      ErrorHandler.showSuccess(context, 'Contadores guardados correctamente');
    }
  }

  @override
  Widget build(BuildContext context) {
    final impresorasAsync = ref.watch(impresorasDaoProvider).getAllImpresoras().asStream();
    final contadoresDao = ref.read(contadoresDaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contadores mensuales'),
        backgroundColor: const Color.fromARGB(255, 255, 165, 30),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Mes:', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedMonth,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      locale: const Locale('es'),
                      helpText: 'Selecciona el mes',
                      fieldLabelText: 'Mes',
                      fieldHintText: 'Mes/Año',
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedMonth = DateTime(picked.year, picked.month);
                      });
                    }
                  },
                  child: Text(DateFormat('MMMM yyyy', 'es').format(_selectedMonth)),
                ),
                const Spacer(),
                SizedBox(
                  width: 260,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar impresora, modelo, área...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchText.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => _searchController.clear(),
                            )
                          : null,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: FutureBuilder<List>(
                future: Future.wait([
                  impresorasAsync.first,
                  contadoresDao.getByMes(mesString),
                ]),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final impresoras = snapshot.data![0] as List;
                  final contadores = snapshot.data![1] as List;
                  final contadoresMap = {for (var c in contadores) c.impresoraId: c};
                  if (impresoras.isEmpty) {
                    return const Center(child: Text('No hay impresoras registradas.'));
                  }

                  // Filtrado según el texto de búsqueda
                  final filteredImpresoras = _searchText.isEmpty
                      ? impresoras
                      : impresoras.where((imp) {
                          final text = (_searchText).toLowerCase();
                          return imp.marca.toLowerCase().contains(text) ||
                              imp.modelo.toLowerCase().contains(text) ||
                              imp.area.toLowerCase().contains(text) ||
                              imp.serie.toLowerCase().contains(text);
                        }).toList();

                  if (filteredImpresoras.isEmpty) {
                    return const Center(child: Text('No se encontraron coincidencias.'));
                  }

                  return ListView.separated(
                    itemCount: filteredImpresoras.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final imp = filteredImpresoras[i];
                      final contadorExistente = contadoresMap[imp.id];
                      final controller = _controllers.putIfAbsent(imp.id, () => TextEditingController());
                      if (contadorExistente != null) {
                        controller.text = contadorExistente.contador.toString();
                      } else if (!controller.text.endsWith('')) {
                        controller.text = '';
                      }

                      final bool isHovered = _hoveredIndex == i;
                      final bool isSelected = _selectedIndex == i;

                      Color? bgColor;
                      if (isHovered || isSelected) {
                        bgColor = Colors.orange.withOpacity(0.13); // Color suave
                      }

                      Widget tile = ListTile(
                        tileColor: bgColor,
                        title: Text('${imp.marca} ${imp.modelo}'),
                        subtitle: Text('Área: ${imp.area} | Serie: ${imp.serie}' + (contadorExistente != null ? '  |  Ya registrado' : '')),
                        trailing: SizedBox(
                          width: 120,
                          child: TextField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            enabled: contadorExistente == null,
                            decoration: InputDecoration(
                              labelText: 'Contador',
                              border: const OutlineInputBorder(),
                              suffixIcon: contadorExistente != null ? const Icon(Icons.lock, size: 18) : null,
                            ),
                          ),
                        ),
                        onTap: () => setState(() => _selectedIndex = i),
                      );

                      // Sombreado al pasar el mouse (solo web)
                      tile = MouseRegion(
                        onEnter: (_) => setState(() => _hoveredIndex = i),
                        onExit: (_) => setState(() => _hoveredIndex = null),
                        child: tile,
                      );

                      return tile;
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Guardar contadores'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () async {
                final impresoras = await ref.read(impresorasDaoProvider).getAllImpresoras();
                await _guardarContadores(impresoras);
              },
            ),
          ],
        ),
      ),
    );
  }
}
