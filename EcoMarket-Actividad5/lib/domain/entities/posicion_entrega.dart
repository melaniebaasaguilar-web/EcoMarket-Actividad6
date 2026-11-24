import 'coordenada.dart';

/// Lectura puntual del GPS de un pedido en camino.
class PosicionEntrega {
  PosicionEntrega({
    required this.ubicacion,
    required int minutosRestantes,
    required double progreso,
    required this.descripcion,
  }) : assert(
         minutosRestantes >= 0,
         'Los minutos restantes no pueden ser negativos.',
       ),
       assert(
         progreso >= 0 && progreso <= 1,
         'El progreso debe estar entre 0 y 1.',
       ),
       assert(descripcion.trim().isNotEmpty, 'La descripción no puede estar vacía.'),
       _minutosRestantes = minutosRestantes,
       _progreso = progreso;

  final Coordenada ubicacion;
  final String descripcion;
  final int _minutosRestantes;
  final double _progreso;

  int get minutosRestantes => _minutosRestantes;

  double get progreso => _progreso;

  bool get entregado => _minutosRestantes == 0;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PosicionEntrega &&
            other.ubicacion == ubicacion &&
            other.descripcion == descripcion &&
            other._minutosRestantes == _minutosRestantes &&
            other._progreso == _progreso;
  }

  @override
  int get hashCode =>
      Object.hash(ubicacion, descripcion, _minutosRestantes, _progreso);

  @override
  String toString() {
    return 'PosicionEntrega($ubicacion, minutos: $_minutosRestantes)';
  }
}
