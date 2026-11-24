enum FuenteSatelital { landsat, sentinel, modis, otra }

class VerificacionSatelital {
  VerificacionSatelital({
    required this.id,
    required this.parcelaId,
    required this.fecha,
    required this.deforestacionDetectada,
    required this.indiceVegetacion,
    this.fuente = FuenteSatelital.sentinel,
    this.selloOtorgado = false,
    this.observaciones = '',
  }) : assert(id.trim().isNotEmpty, 'El id no puede estar vacío.'),
       assert(
         parcelaId.trim().isNotEmpty,
         'El id de la parcela no puede estar vacío.',
       ),
       assert(
         indiceVegetacion >= -1 && indiceVegetacion <= 1,
         'El índice de vegetación debe estar entre -1 y 1.',
       ),
       assert(
         !deforestacionDetectada || !selloOtorgado,
         'No se puede otorgar el sello si se detectó deforestación.',
       );

  final String id;
  final String parcelaId;
  final DateTime fecha;
  final bool deforestacionDetectada;
  final double indiceVegetacion;
  final FuenteSatelital fuente;
  final bool selloOtorgado;
  final String observaciones;

  bool get selloValido =>
      selloOtorgado && !deforestacionDetectada && indiceVegetacion >= 0;

  bool get requiereRevision => deforestacionDetectada || indiceVegetacion < 0;

  String get estadoSello {
    return selloValido
        ? 'Origen verificado por satélite'
        : 'Origen no verificado';
  }
}
