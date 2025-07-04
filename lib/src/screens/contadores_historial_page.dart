import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/database_provider.dart';

class ContadoresHistorialPage extends ConsumerStatefulWidget {
  const ContadoresHistorialPage({super.key});

  @override
  ConsumerState<ContadoresHistorialPage> createState() => _ContadoresHistorialPageState();
}

class _ContadoresHistorialPageState extends ConsumerState<ContadoresHistorialPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Map<String, dynamic>>> _eventMap = {};
  List<Map<String, dynamic>> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    _loadEventsForMonth(_focusedDay);
  }

  Future<void> _loadEventsForMonth(DateTime month) async {
    final contadoresDao = ref.read(contadoresDaoProvider);
    final mantenimientosDao = ref.read(mantenimientosDaoProvider);
    // Trae todos los registros del mes visible
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final registrosContadores = await contadoresDao.getContadoresPorRangoFechas(firstDay, lastDay);
    final registrosMantenimientos = await mantenimientosDao.getMantenimientosPorRangoFechas(firstDay, lastDay);
    // Marca tipo para distinguirlos
    for (final reg in registrosContadores) {
      reg['tipo'] = 'contador';
    }
    // Agrupa por día
    final map = <DateTime, List<Map<String, dynamic>>>{};
    for (final reg in [...registrosContadores, ...registrosMantenimientos]) {
      final fecha = reg['fechaRegistro'] ?? reg['fecha'];
      if (fecha is DateTime) {
        final key = DateTime(fecha.year, fecha.month, fecha.day);
        map.putIfAbsent(key, () => []).add(reg);
      }
    }
    setState(() {
      _eventMap = map;
      _selectedEvents = _eventMap[_selectedDay] ?? [];
    });
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return _eventMap[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Contadores'),
        backgroundColor: const Color.fromARGB(255, 255, 165, 30),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_month),
                    label: Text('${_focusedDay.year} - ${_focusedDay.month.toString().padLeft(2, '0')}'),
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _focusedDay,
                        firstDate: DateTime(2020, 1, 1),
                        lastDate: DateTime(now.year + 1, 12, 31),
                        helpText: 'Selecciona mes y año',
                        fieldLabelText: 'Mes/Año',
                        initialEntryMode: DatePickerEntryMode.calendar,
                        selectableDayPredicate: (date) => true,
                      );
                      if (picked != null) {
                        setState(() {
                          _focusedDay = DateTime(picked.year, picked.month, 1);
                          _selectedDay = null;
                        });
                        await _loadEventsForMonth(_focusedDay);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          TableCalendar(
            locale: 'es_ES',
            firstDay: DateTime(2020, 1, 1),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const { CalendarFormat.month: 'Mes' },
            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedEvents = _getEventsForDay(selectedDay);
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              _loadEventsForMonth(focusedDay);
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              markerDecoration: BoxDecoration(color: Colors.transparent), // No usar el default
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isEmpty) return null;
                // Determinar tipos de eventos
                final hasContador = events.any((e) => (e as Map<String, dynamic>?)?['tipo'] == 'contador');
                final hasMantenimiento = events.any((e) => (e as Map<String, dynamic>?)?['tipo'] == 'mantenimiento');
                // Mostrar puntos de colores
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (hasContador)
                      Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    if (hasMantenimiento)
                      Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _selectedEvents.isEmpty
                ? const Center(child: Text('No hay registros para este día.'))
                : ListView.separated(
                    itemCount: _selectedEvents.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, i) {
                      final item = _selectedEvents[i];
                      if (item['tipo'] == 'contador') {
                        return ListTile(
                          leading: const Icon(Icons.sticky_note_2, color: Colors.blue),
                          title: Text('${item['marca']} ${item['modelo']}'),
                          subtitle: Text('Área: ${item['area']} | Serie: ${item['serie']}'),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Contador: ${item['contador']}'),
                              if (item['observaciones'] != null && item['observaciones'].toString().isNotEmpty)
                                Text('Obs: ${item['observaciones']}'),
                            ],
                          ),
                        );
                      } else if (item['tipo'] == 'mantenimiento') {
                        return ListTile(
                          leading: const Icon(Icons.build, color: Colors.orange),
                          title: Text('Mantenimiento'),
                          subtitle: Text('${item['detalle']}\nImpresora: ${item['marca'] ?? ''} ${item['modelo'] ?? ''}'),
                          trailing: item['reemplazoImpresora'] == true || item['reemplazoImpresora'] == 1
                              ? const Icon(Icons.swap_horiz, color: Colors.red)
                              : null,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
