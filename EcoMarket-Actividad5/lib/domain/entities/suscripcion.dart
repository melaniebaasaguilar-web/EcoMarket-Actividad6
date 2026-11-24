import 'item_carrito.dart';

enum FrecuenciaSuscripcion { semanal, quincenal, mensual }

enum EstadoSuscripcion { activa, pausada, cancelada }

class Suscripcion {
  Suscripcion({
    required this.id,
    required this.compradorId,
    required this.nombrePlan,
    required List<ItemCarrito> items,
    required this.proximaEntrega,
    this.frecuencia = FrecuenciaSuscripcion.mensual,
    this.estado = EstadoSuscripcion.activa,
    DateTime? fechaInicio,
  }) : assert(id.trim().isNotEmpty, 'El id no puede estar vacío.'),
       assert(
         compradorId.trim().isNotEmpty,
         'El id del comprador no puede estar vacío.',
       ),
       assert(
         nombrePlan.trim().isNotEmpty,
         'El nombre del plan no puede estar vacío.',
       ),
       assert(
         items.isNotEmpty,
         'La suscripción debe tener al menos un artículo.',
       ),
       _items = List<ItemCarrito>.unmodifiable(items),
       _fechaInicio = fechaInicio ?? DateTime.now();

  final String id;
  final String compradorId;
  final String nombrePlan;
  final DateTime proximaEntrega;
  final FrecuenciaSuscripcion frecuencia;
  final EstadoSuscripcion estado;
  final List<ItemCarrito> _items;
  final DateTime _fechaInicio;

  List<ItemCarrito> get items => _items;

  DateTime get fechaInicio => _fechaInicio;

  double get totalPorEntrega {
    return _items.fold(0, (total, item) => total + item.subtotal);
  }

  bool get activa => estado == EstadoSuscripcion.activa;

  bool get pausada => estado == EstadoSuscripcion.pausada;

  bool get cancelada => estado == EstadoSuscripcion.cancelada;

  int get diasParaProximaEntrega =>
      proximaEntrega.difference(DateTime.now()).inDays;

  Suscripcion copyWith({
    String? nombrePlan,
    List<ItemCarrito>? items,
    DateTime? proximaEntrega,
    FrecuenciaSuscripcion? frecuencia,
    EstadoSuscripcion? estado,
  }) {
    return Suscripcion(
      id: id,
      compradorId: compradorId,
      nombrePlan: nombrePlan ?? this.nombrePlan,
      items: items ?? _items,
      proximaEntrega: proximaEntrega ?? this.proximaEntrega,
      frecuencia: frecuencia ?? this.frecuencia,
      estado: estado ?? this.estado,
      fechaInicio: _fechaInicio,
    );
  }
}
