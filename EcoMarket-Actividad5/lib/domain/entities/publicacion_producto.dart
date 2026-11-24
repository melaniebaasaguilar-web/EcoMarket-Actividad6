import 'producto.dart';

enum EstadoPublicacion { pendienteRevision, publicado, pausado, rechazado }

class PublicacionProducto {
  PublicacionProducto({
    required this.id,
    required this.producto,
    required this.vendedorId,
    this.parcelaId,
    this.estado = EstadoPublicacion.pendienteRevision,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) : assert(id.trim().isNotEmpty, 'El id no puede estar vacío.'),
       assert(
         vendedorId.trim().isNotEmpty,
         'El id del vendedor no puede estar vacío.',
       ),
       _fechaCreacion = fechaCreacion ?? DateTime.now(),
       _fechaActualizacion = fechaActualizacion ?? DateTime.now();

  final String id;
  final Producto producto;
  final String vendedorId;
  final String? parcelaId;
  final EstadoPublicacion estado;
  final DateTime _fechaCreacion;
  final DateTime _fechaActualizacion;

  DateTime get fechaCreacion => _fechaCreacion;

  DateTime get fechaActualizacion => _fechaActualizacion;

  bool get visibleEnCatalogo =>
      estado == EstadoPublicacion.publicado && producto.disponible;

  bool get requiereRevision => estado == EstadoPublicacion.pendienteRevision;

  bool get estaPausada => estado == EstadoPublicacion.pausado;

  bool get puedeObtenerSelloSatelital => parcelaId != null;

  PublicacionProducto publicar() {
    return copyWith(estado: EstadoPublicacion.publicado);
  }

  PublicacionProducto pausar() {
    return copyWith(estado: EstadoPublicacion.pausado);
  }

  PublicacionProducto rechazar() {
    return copyWith(estado: EstadoPublicacion.rechazado);
  }

  PublicacionProducto copyWith({
    Producto? producto,
    String? vendedorId,
    String? parcelaId,
    EstadoPublicacion? estado,
    DateTime? fechaActualizacion,
  }) {
    return PublicacionProducto(
      id: id,
      producto: producto ?? this.producto,
      vendedorId: vendedorId ?? this.vendedorId,
      parcelaId: parcelaId ?? this.parcelaId,
      estado: estado ?? this.estado,
      fechaCreacion: _fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? DateTime.now(),
    );
  }
}
