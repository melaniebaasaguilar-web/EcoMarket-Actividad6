enum TipoMetodoPago { tarjeta, transferencia, contraentrega, billeteraDigital }

class MetodoPago {
  MetodoPago({
    required this.id,
    required this.tipo,
    required String etiqueta,
    this.ultimosDigitos,
    this.predeterminado = false,
  }) : assert(id.trim().isNotEmpty, 'El id no puede estar vacío.'),
       assert(etiqueta.trim().isNotEmpty, 'La etiqueta no puede estar vacía.'),
       assert(
         ultimosDigitos == null || RegExp(r'^\d{4}$').hasMatch(ultimosDigitos),
         'Los últimos dígitos deben ser exactamente cuatro números.',
       ),
       assert(
         tipo != TipoMetodoPago.tarjeta || ultimosDigitos != null,
         'Una tarjeta debe registrar sus últimos cuatro dígitos.',
       ),
       _etiqueta = etiqueta;

  final String id;
  final TipoMetodoPago tipo;
  final String? ultimosDigitos;
  final bool predeterminado;
  final String _etiqueta;

  String get etiqueta => _etiqueta;

  String get descripcion {
    if (ultimosDigitos == null) {
      return _etiqueta;
    }
    return '$_etiqueta •••• $ultimosDigitos';
  }

  bool get requiereConfirmacion => tipo != TipoMetodoPago.contraentrega;

  MetodoPago copyWith({
    TipoMetodoPago? tipo,
    String? etiqueta,
    String? ultimosDigitos,
    bool? predeterminado,
  }) {
    return MetodoPago(
      id: id,
      tipo: tipo ?? this.tipo,
      etiqueta: etiqueta ?? _etiqueta,
      ultimosDigitos: ultimosDigitos ?? this.ultimosDigitos,
      predeterminado: predeterminado ?? this.predeterminado,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MetodoPago &&
            other.id == id &&
            other.tipo == tipo &&
            other._etiqueta == _etiqueta &&
            other.ultimosDigitos == ultimosDigitos &&
            other.predeterminado == predeterminado;
  }

  @override
  int get hashCode =>
      Object.hash(id, tipo, _etiqueta, ultimosDigitos, predeterminado);
}
