class Coordenada {
  Coordenada({required double latitud, required double longitud})
    : assert(
        latitud >= -90 && latitud <= 90,
        'La latitud debe estar entre -90 y 90.',
      ),
      assert(
        longitud >= -180 && longitud <= 180,
        'La longitud debe estar entre -180 y 180.',
      ),
      _latitud = latitud,
      _longitud = longitud;

  final double _latitud;
  final double _longitud;

  double get latitud => _latitud;

  double get longitud => _longitud;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Coordenada &&
            other._latitud == _latitud &&
            other._longitud == _longitud;
  }

  @override
  int get hashCode => Object.hash(_latitud, _longitud);

  @override
  String toString() => 'Coordenada($latitud, $longitud)';
}
