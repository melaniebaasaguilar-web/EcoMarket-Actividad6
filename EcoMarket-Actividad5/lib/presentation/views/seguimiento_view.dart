import 'package:flutter/material.dart';

import '../../domain/entities/coordenada.dart';
import '../../domain/entities/posicion_entrega.dart';
import '../../domain/repositories/entrega_repository.dart';
import '../utils/formato.dart';

/// Seguimiento del pedido: un StreamBuilder escucha el GPS simulado.
class SeguimientoView extends StatefulWidget {
  const SeguimientoView({
    super.key,
    required this.entregaRepository,
    required this.comprobante,
    required this.destinatario,
    required this.direccion,
    required this.total,
    required this.origen,
    required this.destino,
  });

  final EntregaRepository entregaRepository;
  final String comprobante;
  final String destinatario;
  final String direccion;
  final double total;
  final Coordenada origen;
  final Coordenada destino;

  @override
  State<SeguimientoView> createState() => _SeguimientoViewState();
}

class _SeguimientoViewState extends State<SeguimientoView> {
  // Se crea una sola vez: evita reiniciar el GPS en cada redibujado.
  late final Stream<PosicionEntrega> _gps = widget.entregaRepository
      .rastrearEntrega(origen: widget.origen, destino: widget.destino);

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Seguimiento de entrega')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pago confirmado', style: tema.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('Comprobante: ${widget.comprobante}'),
                    Text('Total pagado: ${formatoMoneda(widget.total)}'),
                    Text('Destinatario: ${widget.destinatario}'),
                    Text('Dirección: ${widget.direccion}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            StreamBuilder<PosicionEntrega>(
              stream: _gps,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Se perdió la señal del GPS. Intenta más tarde.'),
                    ),
                  );
                }

                final posicion = snapshot.data;
                if (posicion == null) {
                  return const Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text('Conectando con el GPS…'),
                        ],
                      ),
                    ),
                  );
                }

                return _PanelGps(posicion: posicion);
              },
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () =>
                  Navigator.of(context).popUntil((ruta) => ruta.isFirst),
              child: const Text('Volver al catálogo'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelGps extends StatelessWidget {
  const _PanelGps({required this.posicion});

  final PosicionEntrega posicion;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              posicion.entregado
                  ? '¡Entregado!'
                  : 'Llegada en ${posicion.minutosRestantes} min',
              style: tema.textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(posicion.descripcion),
            const SizedBox(height: 16),
            SizedBox(
              height: 36,
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 600),
                alignment: Alignment(-1 + 2 * posicion.progreso, 0),
                child: Icon(
                  posicion.entregado ? Icons.home : Icons.local_shipping,
                  color: tema.colorScheme.primary,
                ),
              ),
            ),
            LinearProgressIndicator(
              value: posicion.progreso,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 12),
            Text(
              'GPS: ${posicion.ubicacion.latitud.toStringAsFixed(4)}, '
              '${posicion.ubicacion.longitud.toStringAsFixed(4)}',
              style: tema.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
