enum TipoNotificacion {
  alertaSatelital,
  estadoPedido,
  actualizacionSuscripcion,
  promocion,
  sistema,
}

class Notificacion {
  Notificacion({
    required this.id,
    required this.usuarioId,
    required this.tipo,
    required this.titulo,
    required this.mensaje,
    this.leida = false,
    this.referenciaId,
    DateTime? fecha,
  }) : assert(id.trim().isNotEmpty, 'El id no puede estar vacío.'),
       assert(
         usuarioId.trim().isNotEmpty,
         'El id del usuario no puede estar vacío.',
       ),
       assert(titulo.trim().isNotEmpty, 'El título no puede estar vacío.'),
       assert(mensaje.trim().isNotEmpty, 'El mensaje no puede estar vacío.'),
       _fecha = fecha ?? DateTime.now();

  final String id;
  final String usuarioId;
  final TipoNotificacion tipo;
  final String titulo;
  final String mensaje;
  final bool leida;
  final String? referenciaId;
  final DateTime _fecha;

  DateTime get fecha => _fecha;

  bool get pendiente => !leida;

  Notificacion marcarComoLeida() {
    return Notificacion(
      id: id,
      usuarioId: usuarioId,
      tipo: tipo,
      titulo: titulo,
      mensaje: mensaje,
      leida: true,
      referenciaId: referenciaId,
      fecha: _fecha,
    );
  }
}
