class ActualizacionMonitoreo {
  ActualizacionMonitoreo({
    required this.id,
    required this.suscripcionId,
    required this.parcelaId,
    required this.periodo,
    required this.mensaje,
    required double indiceVegetacion,
    DateTime? fecha,
  }) : assert(id.trim().isNotEmpty, 'El id no puede estar vacío.'),
       assert(
         suscripcionId.trim().isNotEmpty,
         'El id de la suscripción no puede estar vacío.',
       ),
       assert(
         parcelaId.trim().isNotEmpty,
         'El id de la parcela no puede estar vacío.',
       ),
       assert(periodo.trim().isNotEmpty, 'El periodo no puede estar vacío.'),
       assert(mensaje.trim().isNotEmpty, 'El mensaje no puede estar vacío.'),
       assert(
         indiceVegetacion >= -1 && indiceVegetacion <= 1,
         'El índice de vegetación debe estar entre -1 y 1.',
       ),
       _indiceVegetacion = indiceVegetacion,
       _fecha = fecha ?? DateTime.now();

  final String id;
  final String suscripcionId;
  final String parcelaId;
  final String periodo;
  final String mensaje;
  final double _indiceVegetacion;
  final DateTime _fecha;

  double get indiceVegetacion => _indiceVegetacion;

  DateTime get fecha => _fecha;

  bool get saludVegetalBuena => _indiceVegetacion >= 0.3;

  String get nivelSalud {
    if (_indiceVegetacion >= 0.5) {
      return 'Buena';
    }
    if (_indiceVegetacion >= 0.3) {
      return 'Estable';
    }
    return 'En riesgo';
  }
}
