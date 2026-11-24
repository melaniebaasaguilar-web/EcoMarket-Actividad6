enum TipoAlertaSatelital {
  perdidaCoberturaVegetal,
  posibleTala,
  posibleIncendio,
  anomalia,
}

enum SeveridadAlerta { baja, media, alta, critica }

enum EstadoAlerta { pendiente, enRevision, resuelta, descartada }

class AlertaSatelital {
  AlertaSatelital({
    required this.id,
    required this.parcelaId,
    required this.tipo,
    required this.severidad,
    required this.descripcion,
    this.estado = EstadoAlerta.pendiente,
    this.requiereNotificarCompradores = true,
    DateTime? fechaDeteccion,
  }) : assert(id.trim().isNotEmpty, 'El id no puede estar vacío.'),
       assert(
         parcelaId.trim().isNotEmpty,
         'El id de la parcela no puede estar vacío.',
       ),
       assert(
         descripcion.trim().isNotEmpty,
         'La descripción no puede estar vacía.',
       ),
       _fechaDeteccion = fechaDeteccion ?? DateTime.now();

  final String id;
  final String parcelaId;
  final TipoAlertaSatelital tipo;
  final SeveridadAlerta severidad;
  final String descripcion;
  final EstadoAlerta estado;
  final bool requiereNotificarCompradores;
  final DateTime _fechaDeteccion;

  DateTime get fechaDeteccion => _fechaDeteccion;

  bool get estaPendiente => estado == EstadoAlerta.pendiente;

  bool get esCritica => severidad == SeveridadAlerta.critica;

  bool get debeNotificarCompradores {
    return requiereNotificarCompradores &&
        estaPendiente &&
        (severidad == SeveridadAlerta.alta || esCritica);
  }

  AlertaSatelital copyWith({EstadoAlerta? estado}) {
    return AlertaSatelital(
      id: id,
      parcelaId: parcelaId,
      tipo: tipo,
      severidad: severidad,
      descripcion: descripcion,
      estado: estado ?? this.estado,
      requiereNotificarCompradores: requiereNotificarCompradores,
      fechaDeteccion: _fechaDeteccion,
    );
  }
}
