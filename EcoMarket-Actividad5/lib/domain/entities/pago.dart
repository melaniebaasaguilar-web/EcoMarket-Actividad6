import 'metodo_pago.dart';

enum EstadoPago { pendiente, aprobado, rechazado, reembolsado }

class Pago {
  Pago({
    required this.id,
    required this.ordenId,
    required this.metodoPago,
    required double monto,
    this.estado = EstadoPago.pendiente,
    this.moneda = 'BOB',
    this.referencia,
    DateTime? fecha,
  }) : assert(id.trim().isNotEmpty, 'El id no puede estar vacío.'),
       assert(
         ordenId.trim().isNotEmpty,
         'El id de la orden no puede estar vacío.',
       ),
       assert(monto >= 0, 'El monto no puede ser negativo.'),
       assert(moneda.trim().isNotEmpty, 'La moneda no puede estar vacía.'),
       _monto = monto,
       _fecha = fecha ?? DateTime.now();

  final String id;
  final String ordenId;
  final MetodoPago metodoPago;
  final EstadoPago estado;
  final String moneda;
  final String? referencia;
  final double _monto;
  final DateTime _fecha;

  double get monto => _monto;

  DateTime get fecha => _fecha;

  bool get fueAprobado => estado == EstadoPago.aprobado;

  bool get permiteReintento => estado == EstadoPago.rechazado;

  bool get fueReembolsado => estado == EstadoPago.reembolsado;

  Pago copyWith({EstadoPago? estado, String? referencia}) {
    return Pago(
      id: id,
      ordenId: ordenId,
      metodoPago: metodoPago,
      monto: _monto,
      estado: estado ?? this.estado,
      moneda: moneda,
      referencia: referencia ?? this.referencia,
      fecha: _fecha,
    );
  }
}
