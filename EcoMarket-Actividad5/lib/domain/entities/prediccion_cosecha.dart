class PrediccionCosecha {
  PrediccionCosecha({
    required this.id,
    required this.parcelaId,
    required this.productoId,
    required this.fechaEstimada,
    required double rendimientoEstimadoKg,
    required double indiceVegetacion,
    required double confianza,
    DateTime? fechaCalculo,
  }) : assert(id.trim().isNotEmpty, 'El id no puede estar vacío.'),
       assert(
         parcelaId.trim().isNotEmpty,
         'El id de la parcela no puede estar vacío.',
       ),
       assert(
         productoId.trim().isNotEmpty,
         'El id del producto no puede estar vacío.',
       ),
       assert(
         rendimientoEstimadoKg >= 0,
         'El rendimiento estimado no puede ser negativo.',
       ),
       assert(
         indiceVegetacion >= -1 && indiceVegetacion <= 1,
         'El índice de vegetación debe estar entre -1 y 1.',
       ),
       assert(
         confianza >= 0 && confianza <= 1,
         'La confianza debe estar entre 0 y 1.',
       ),
       _rendimientoEstimadoKg = rendimientoEstimadoKg,
       _indiceVegetacion = indiceVegetacion,
       _confianza = confianza,
       _fechaCalculo = fechaCalculo ?? DateTime.now();

  final String id;
  final String parcelaId;
  final String productoId;
  final DateTime fechaEstimada;
  final double _rendimientoEstimadoKg;
  final double _indiceVegetacion;
  final double _confianza;
  final DateTime _fechaCalculo;

  double get rendimientoEstimadoKg => _rendimientoEstimadoKg;

  double get indiceVegetacion => _indiceVegetacion;

  double get confianza => _confianza;

  DateTime get fechaCalculo => _fechaCalculo;

  bool get esConfiable => _confianza >= 0.7 && _indiceVegetacion > 0;

  int get diasRestantes => fechaEstimada.difference(DateTime.now()).inDays;

  String get nivelConfianza {
    if (_confianza >= 0.8) {
      return 'Alta';
    }
    if (_confianza >= 0.5) {
      return 'Media';
    }
    return 'Baja';
  }
}
