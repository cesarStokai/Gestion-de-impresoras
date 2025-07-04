import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/database_provider.dart';

class EstadisticasPage extends ConsumerWidget {
  const EstadisticasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas y Gráficas'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Resumen y comparativas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          const SizedBox(height: 24),
          // TOP IMPRESORAS
          Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 32),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Top impresoras por hojas impresas',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 20),
                  _ResumenYGraficaPorImpresora(),
                ],
              ),
            ),
          ),
          // PROMEDIO POR IMPRESORA
          Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 32),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _GraficaPromedioPorImpresora(),
            ),
          ),
          // 12 GRAFICAS (1 POR MES)
          const SizedBox(height: 10),
          const _GraficasMesPorMes(),
        ],
      ),
    );
  }
}

// ---------- GRAFICA TOP IMPRESORAS ----------
class _ResumenYGraficaPorImpresora extends ConsumerWidget {
  const _ResumenYGraficaPorImpresora();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ref.read(contadoresDaoProvider)
          .getContadoresPorRangoFechas(DateTime(2020, 1, 1), DateTime.now()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final registros = snapshot.data!;
        final Map<String, num> hojasPorImpresora = {};
        for (final reg in registros) {
          final impresora = '${reg['marca']} ${reg['modelo']}';
          hojasPorImpresora[impresora] = (hojasPorImpresora[impresora] ?? 0) + (reg['contador'] ?? 0);
        }
        final impresorasOrdenadas = hojasPorImpresora.keys.toList()
          ..sort((a, b) => hojasPorImpresora[b]!.compareTo(hojasPorImpresora[a]!));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TABLA
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 36,
                columns: const [
                  DataColumn(label: Text('Impresora', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Total hojas', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: impresorasOrdenadas.map((imp) {
                  return DataRow(
                    cells: [
                      DataCell(Text(imp)),
                      DataCell(Text('${hojasPorImpresora[imp] ?? 0}')),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 30),
            // GRAFICA HORIZONTAL
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: 60.0 * impresorasOrdenadas.length.clamp(4, 8),
                width: (impresorasOrdenadas.length * 240).clamp(500, 1600).toDouble(),
                child: BarChart(
                  BarChartData(
                    barGroups: List.generate(impresorasOrdenadas.length, (i) {
                      final imp = impresorasOrdenadas[i];
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: (hojasPorImpresora[imp] ?? 0).toDouble(),
                            color: Colors.purpleAccent,
                            width: 40,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ],
                      );
                    }),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 100,
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            return idx >= 0 && idx < impresorasOrdenadas.length
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: RotatedBox(
                                      quarterTurns: 1,
                                      child: Text(
                                        impresorasOrdenadas[idx],
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                    barTouchData: BarTouchData(enabled: true),
                    alignment: BarChartAlignment.spaceAround,
                    maxY: hojasPorImpresora.values.fold<num>(0, (a, b) => a > b ? a : b) * 1.2,
                    groupsSpace: 20,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---------- GRAFICA PROMEDIO POR IMPRESORA ----------
class _GraficaPromedioPorImpresora extends ConsumerWidget {
  const _GraficaPromedioPorImpresora();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ref.read(contadoresDaoProvider)
          .getContadoresPorRangoFechas(DateTime(now.year, 1, 1), DateTime(now.year, 12, 31)),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final registros = snapshot.data!;
        final Map<String, List<num>> hojasPorImpresora = {};
        for (final reg in registros) {
          final fecha = reg['fechaRegistro'] as DateTime?;
          if (fecha == null || fecha.year != now.year) continue;
          final impresora = '${reg['marca']} ${reg['modelo']}';
          hojasPorImpresora.putIfAbsent(impresora, () => List.filled(12, 0));
          hojasPorImpresora[impresora]![fecha.month - 1] += (reg['contador'] ?? 0);
        }
        final impresoras = hojasPorImpresora.keys.toList();
        final promedios = impresoras.map((imp) {
          final sum = hojasPorImpresora[imp]!.reduce((a, b) => a + b);
          return sum / 12.0;
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Promedio mensual de hojas por impresora (año actual)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 18),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: 60.0 * impresoras.length.clamp(4, 8),
                width: (impresoras.length * 240).clamp(500, 1600).toDouble(),
                child: BarChart(
                  BarChartData(
                    barGroups: List.generate(impresoras.length, (i) {
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: promedios[i],
                            color: Colors.blueAccent,
                            width: 40,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ],
                      );
                    }),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 100,
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            return idx >= 0 && idx < impresoras.length
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: RotatedBox(
                                      quarterTurns: 1,
                                      child: Text(
                                        impresoras[idx],
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                    barTouchData: BarTouchData(enabled: true),
                    alignment: BarChartAlignment.spaceAround,
                    maxY: promedios.fold<num>(0, (a, b) => a > b ? a : b) * 1.2,
                    groupsSpace: 20,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---------- 12 GRAFICAS (MES POR MES) ----------
class _GraficasMesPorMes extends ConsumerWidget {
  const _GraficasMesPorMes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ref.read(contadoresDaoProvider)
          .getContadoresPorRangoFechas(DateTime(now.year, 1, 1), DateTime(now.year, 12, 31)),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final registros = snapshot.data!;
        final Map<int, Map<String, num>> dataPorMes = {};
        for (int m = 1; m <= 12; m++) {
          dataPorMes[m] = {};
        }
        for (final reg in registros) {
          final fecha = reg['fechaRegistro'] as DateTime?;
          if (fecha == null) continue;
          if (fecha.year != now.year) continue;
          final mes = fecha.month;
          final impresora = '${reg['marca']} ${reg['modelo']}';
          dataPorMes[mes]![impresora] = (dataPorMes[mes]![impresora] ?? 0) + (reg['contador'] ?? 0);
        }
        final impresoras = dataPorMes.values.expand((m) => m.keys).toSet().toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(12, (i) {
            final mes = i + 1;
            final nombreMes = [
              'ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO',
              'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE'
            ][i];
            final datosMes = dataPorMes[mes]!;
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 28),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Consumo en $nombreMes ${now.year}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        height: 60.0 * impresoras.length.clamp(4, 8),
                        width: (impresoras.length * 240).clamp(500, 1600).toDouble(),
                        child: BarChart(
                          BarChartData(
                            barGroups: List.generate(impresoras.length, (j) {
                              final imp = impresoras[j];
                              return BarChartGroupData(
                                x: j,
                                barRods: [
                                  BarChartRodData(
                                    toY: (datosMes[imp] ?? 0).toDouble(),
                                    color: Colors.primaries[j % Colors.primaries.length],
                                    width: 40,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ],
                              );
                            }),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 100,
                                  getTitlesWidget: (value, meta) {
                                    final idx = value.toInt();
                                    return idx >= 0 && idx < impresoras.length
                                        ? Padding(
                                            padding: const EdgeInsets.only(top: 6),
                                            child: RotatedBox(
                                              quarterTurns: 1,
                                              child: Text(
                                                impresoras[idx],
                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink();
                                  },
                                ),
                              ),
                            ),
                            gridData: FlGridData(show: true),
                            borderData: FlBorderData(show: false),
                            alignment: BarChartAlignment.spaceAround,
                            maxY: datosMes.values.fold<num>(0, (a, b) => a > b ? a : b) * 1.2,
                            groupsSpace: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
