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
          const Text('Hojas impresas por impresora (mes a mes)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          _GraficaHojasPorMes(),
          const Divider(height: 40),
          const Text('Mantenimientos realizados por mes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          _GraficaMantenimientosPorMes(),
        ],
      ),
    );
  }
}

class _GraficaHojasPorMes extends ConsumerWidget {
  const _GraficaHojasPorMes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ref.read(contadoresDaoProvider).getContadoresPorRangoFechas(DateTime(2020, 1, 1), DateTime.now()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final registros = snapshot.data!;
        // Agrupar por mes y por impresora
        final Map<String, Map<String, num>> data = {};
        for (final reg in registros) {
          final fecha = reg['fechaRegistro'] as DateTime?;
          final impresora = '${reg['marca']} ${reg['modelo']}';
          if (fecha != null) {
            final mes = '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}';
            data.putIfAbsent(mes, () => {});
            data[mes]![impresora] = (data[mes]![impresora] ?? 0) + (reg['contador'] ?? 0);
          }
        }
        final meses = data.keys.toList()..sort();
        final impresoras = data.values.expand((m) => m.keys).toSet().toList();
        return SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              barGroups: List.generate(meses.length, (i) {
                final mes = meses[i];
                return BarChartGroupData(
                  x: i,
                  barRods: List.generate(impresoras.length, (j) {
                    final imp = impresoras[j];
                    return BarChartRodData(
                      toY: (data[mes]?[imp] ?? 0).toDouble(),
                      color: Colors.primaries[j % Colors.primaries.length],
                      width: 14,
                    );
                  }),
                );
              }),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      return idx >= 0 && idx < meses.length
                          ? Text(meses[idx], style: const TextStyle(fontSize: 12))
                          : const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: false),
            ),
          ),
        );
      },
    );
  }
}

class _GraficaMantenimientosPorMes extends ConsumerWidget {
  const _GraficaMantenimientosPorMes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ref.read(mantenimientosDaoProvider).getMantenimientosPorRangoFechas(DateTime(2020, 1, 1), DateTime.now()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final registros = snapshot.data!;
        // Agrupar por mes
        final Map<String, int> data = {};
        for (final reg in registros) {
          final fecha = reg['fecha'] as DateTime?;
          if (fecha != null) {
            final mes = '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}';
            data[mes] = (data[mes] ?? 0) + 1;
          }
        }
        final meses = data.keys.toList()..sort();
        return SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              barGroups: List.generate(meses.length, (i) {
                final mes = meses[i];
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: (data[mes] ?? 0).toDouble(),
                      color: Colors.orange,
                      width: 24,
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
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      return idx >= 0 && idx < meses.length
                          ? Text(meses[idx], style: const TextStyle(fontSize: 12))
                          : const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: false),
            ),
          ),
        );
      },
    );
  }
}
