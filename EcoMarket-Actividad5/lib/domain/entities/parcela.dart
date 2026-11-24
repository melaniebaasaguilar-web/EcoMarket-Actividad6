import 'coordenada.dart';

class Parcela {
  Parcela({
    required this.id,
    required this.vendedorId,
    required this.nombreFinca,
    required List<Coordenada> poligono,
    this.verificada = false,
    DateTime? fechaRegistro,
  }) : assert(id.trim().isNotEmpty, 'El id no puede estar vacío.'),
       assert(
         vendedorId.trim().isNotEmpty,
         'El id del vendedor no puede estar vacío.',
       ),
       assert(
         nombreFinca.trim().isNotEmpty,
         'El nombre de la finca no puede estar vacío.',
       ),
       assert(
         poligono.length >= 3,
         'El polígono debe tener al menos tres coordenadas.',
       ),
       _poligono = List<Coordenada>.unmodifiable(poligono),
       _fechaRegistro = fechaRegistro ?? DateTime.now();

  final String id;
  final String vendedorId;
  final String nombreFinca;
  final bool verificada;
  final List<Coordenada> _poligono;
  final DateTime _fechaRegistro;

  List<Coordenada> get poligono => _poligono;

  DateTime get fechaRegistro => _fechaRegistro;

  int get cantidadVertices => _poligono.length;

  bool get tieneSelloSatelital => verificada;

  double get latitudCentro {
    final suma = _poligono.fold<double>(
      0,
      (total, coordenada) => total + coordenada.latitud,
    );
    return suma / _poligono.length;
  }

  double get longitudCentro {
    final suma = _poligono.fold<double>(
      0,
      (total, coordenada) => total + coordenada.longitud,
    );
    return suma / _poligono.length;
  }

  Parcela copyWith({
    String? nombreFinca,
    List<Coordenada>? poligono,
    bool? verificada,
  }) {
    return Parcela(
      id: id,
      vendedorId: vendedorId,
      nombreFinca: nombreFinca ?? this.nombreFinca,
      poligono: poligono ?? _poligono,
      verificada: verificada ?? this.verificada,
      fechaRegistro: _fechaRegistro,
    );
  }
}
