class PerfilVendedor {
  PerfilVendedor({
    required this.vendedorId,
    required this.nombreNegocio,
    this.descripcion = '',
    double reputacion = 0,
    int ventasCompletadas = 0,
    int publicacionesActivas = 0,
    this.verificado = false,
    DateTime? fechaAlta,
  }) : assert(
         vendedorId.trim().isNotEmpty,
         'El id del vendedor no puede estar vacío.',
       ),
       assert(
         nombreNegocio.trim().isNotEmpty,
         'El nombre del negocio no puede estar vacío.',
       ),
       assert(
         reputacion >= 0 && reputacion <= 5,
         'La reputación debe estar entre 0 y 5.',
       ),
       assert(
         ventasCompletadas >= 0,
         'Las ventas completadas no pueden ser negativas.',
       ),
       assert(
         publicacionesActivas >= 0,
         'Las publicaciones activas no pueden ser negativas.',
       ),
       _reputacion = reputacion,
       _ventasCompletadas = ventasCompletadas,
       _publicacionesActivas = publicacionesActivas,
       _fechaAlta = fechaAlta ?? DateTime.now();

  final String vendedorId;
  final String nombreNegocio;
  final String descripcion;
  final bool verificado;
  final double _reputacion;
  final int _ventasCompletadas;
  final int _publicacionesActivas;
  final DateTime _fechaAlta;

  double get reputacion => _reputacion;

  int get ventasCompletadas => _ventasCompletadas;

  int get publicacionesActivas => _publicacionesActivas;

  DateTime get fechaAlta => _fechaAlta;

  bool get esConfiable =>
      verificado && _reputacion >= 4.5 && _ventasCompletadas >= 10;

  String get nivelReputacion {
    if (_ventasCompletadas == 0) {
      return 'Nuevo';
    }
    if (_reputacion >= 4.5) {
      return 'Excelente';
    }
    if (_reputacion >= 3.5) {
      return 'Bueno';
    }
    return 'En observación';
  }

  PerfilVendedor copyWith({
    String? nombreNegocio,
    String? descripcion,
    double? reputacion,
    int? ventasCompletadas,
    int? publicacionesActivas,
    bool? verificado,
  }) {
    return PerfilVendedor(
      vendedorId: vendedorId,
      nombreNegocio: nombreNegocio ?? this.nombreNegocio,
      descripcion: descripcion ?? this.descripcion,
      reputacion: reputacion ?? _reputacion,
      ventasCompletadas: ventasCompletadas ?? _ventasCompletadas,
      publicacionesActivas: publicacionesActivas ?? _publicacionesActivas,
      verificado: verificado ?? this.verificado,
      fechaAlta: _fechaAlta,
    );
  }
}
