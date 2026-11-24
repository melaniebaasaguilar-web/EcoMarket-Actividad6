import 'direccion_envio.dart';
import 'item_carrito.dart';
import 'metodo_pago.dart';

enum EstadoOrden {
  pendientePago,
  pagada,
  enPreparacion,
  enviada,
  entregada,
  cancelada,
}

class EventoSeguimiento {
  EventoSeguimiento({
    required this.id,
    required this.estado,
    required this.descripcion,
    this.ubicacion,
    DateTime? fecha,
  }) : assert(id.trim().isNotEmpty, 'El id no puede estar vacío.'),
       assert(
         descripcion.trim().isNotEmpty,
         'La descripción no puede estar vacía.',
       ),
       _fecha = fecha ?? DateTime.now();

  final String id;
  final EstadoOrden estado;
  final String descripcion;
  final String? ubicacion;
  final DateTime _fecha;

  DateTime get fecha => _fecha;
}

class Orden {
  Orden({
    required this.id,
    required this.compradorId,
    required this.vendedorId,
    required List<ItemCarrito> items,
    required this.direccionEnvio,
    required this.metodoPago,
    this.estado = EstadoOrden.pendientePago,
    this.costoEnvio = 0,
    this.numeroSeguimiento,
    DateTime? fechaCreacion,
    List<EventoSeguimiento> seguimiento = const <EventoSeguimiento>[],
  }) : assert(id.trim().isNotEmpty, 'El id no puede estar vacío.'),
       assert(
         compradorId.trim().isNotEmpty,
         'El id del comprador no puede estar vacío.',
       ),
       assert(
         vendedorId.trim().isNotEmpty,
         'El id del vendedor no puede estar vacío.',
       ),
       assert(items.isNotEmpty, 'La orden debe tener al menos un artículo.'),
       assert(costoEnvio >= 0, 'El costo de envío no puede ser negativo.'),
       _items = List<ItemCarrito>.unmodifiable(items),
       _fechaCreacion = fechaCreacion ?? DateTime.now(),
       _seguimiento = List<EventoSeguimiento>.unmodifiable(seguimiento);

  final String id;
  final String compradorId;
  final String vendedorId;
  final DireccionEnvio direccionEnvio;
  final MetodoPago metodoPago;
  final EstadoOrden estado;
  final double costoEnvio;
  final String? numeroSeguimiento;
  final List<ItemCarrito> _items;
  final DateTime _fechaCreacion;
  final List<EventoSeguimiento> _seguimiento;

  List<ItemCarrito> get items => _items;

  DateTime get fechaCreacion => _fechaCreacion;

  List<EventoSeguimiento> get seguimiento => _seguimiento;

  double get subtotal {
    return _items.fold(0, (total, item) => total + item.subtotal);
  }

  double get total => subtotal + costoEnvio;

  int get cantidadArticulos {
    return _items.fold(0, (total, item) => total + item.cantidad);
  }

  EventoSeguimiento? get ultimoEvento =>
      _seguimiento.isEmpty ? null : _seguimiento.last;

  bool get puedeCancelarse =>
      estado == EstadoOrden.pendientePago || estado == EstadoOrden.pagada;

  bool get estaEnCamino => estado == EstadoOrden.enviada;

  bool get fueEntregada => estado == EstadoOrden.entregada;

  Orden cambiarEstado(
    EstadoOrden nuevoEstado, {
    required String descripcion,
    String? ubicacion,
    String? numeroSeguimiento,
  }) {
    final evento = EventoSeguimiento(
      id: '$id-${_seguimiento.length + 1}',
      estado: nuevoEstado,
      descripcion: descripcion,
      ubicacion: ubicacion,
    );

    return Orden(
      id: id,
      compradorId: compradorId,
      vendedorId: vendedorId,
      items: _items,
      direccionEnvio: direccionEnvio,
      metodoPago: metodoPago,
      estado: nuevoEstado,
      costoEnvio: costoEnvio,
      numeroSeguimiento: numeroSeguimiento ?? this.numeroSeguimiento,
      fechaCreacion: _fechaCreacion,
      seguimiento: <EventoSeguimiento>[..._seguimiento, evento],
    );
  }
}
