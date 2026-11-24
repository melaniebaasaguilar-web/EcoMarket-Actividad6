class Producto {
  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required double precio,
    required int stock,
    this.unidad = 'kg',
    this.finca = '',
    this.latitud,
    this.longitud,
    this.origenVerificadoSatelite = false,
    this.imagenUrl,
  }) : assert(id.trim().isNotEmpty, 'El id no puede estar vacío.'),
       assert(nombre.trim().isNotEmpty, 'El nombre no puede estar vacío.'),
       assert(
         descripcion.trim().isNotEmpty,
         'La descripción no puede estar vacía.',
       ),
       assert(
         categoria.trim().isNotEmpty,
         'La categoría no puede estar vacía.',
       ),
       assert(precio >= 0, 'El precio no puede ser negativo.'),
       assert(stock >= 0, 'El stock no puede ser negativo.'),
       assert(unidad.trim().isNotEmpty, 'La unidad no puede estar vacía.'),
       assert(
         latitud == null || (latitud >= -90 && latitud <= 90),
         'La latitud debe estar entre -90 y 90.',
       ),
       assert(
         longitud == null || (longitud >= -180 && longitud <= 180),
         'La longitud debe estar entre -180 y 180.',
       ),
       assert(
         !origenVerificadoSatelite || (latitud != null && longitud != null),
         'Un producto verificado por satélite requiere coordenadas.',
       ),
       _precio = precio,
       _stock = stock;

  final String id;
  final String nombre;
  final String descripcion;
  final String categoria;
  final String unidad;
  final String finca;
  final double? latitud;
  final double? longitud;
  final bool origenVerificadoSatelite;
  final String? imagenUrl;
  final double _precio;
  final int _stock;

  double get precio => _precio;

  int get stock => _stock;

  bool get disponible => _stock > 0;

  bool get agotado => !disponible;

  bool get tieneSelloSatelital =>
      origenVerificadoSatelite && latitud != null && longitud != null;

  double get valorInventario => _precio * _stock;

  Producto copyWith({
    String? nombre,
    String? descripcion,
    String? categoria,
    double? precio,
    int? stock,
    String? unidad,
    String? finca,
    double? latitud,
    double? longitud,
    bool? origenVerificadoSatelite,
    String? imagenUrl,
  }) {
    return Producto(
      id: id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      categoria: categoria ?? this.categoria,
      precio: precio ?? _precio,
      stock: stock ?? _stock,
      unidad: unidad ?? this.unidad,
      finca: finca ?? this.finca,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      origenVerificadoSatelite:
          origenVerificadoSatelite ?? this.origenVerificadoSatelite,
      imagenUrl: imagenUrl ?? this.imagenUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Producto &&
            other.id == id &&
            other.nombre == nombre &&
            other.descripcion == descripcion &&
            other.categoria == categoria &&
            other.unidad == unidad &&
            other.finca == finca &&
            other.latitud == latitud &&
            other.longitud == longitud &&
            other.origenVerificadoSatelite == origenVerificadoSatelite &&
            other.imagenUrl == imagenUrl &&
            other._precio == _precio &&
            other._stock == _stock;
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    descripcion,
    categoria,
    unidad,
    finca,
    latitud,
    longitud,
    origenVerificadoSatelite,
    imagenUrl,
    _precio,
    _stock,
  );

  @override
  String toString() {
    return 'Producto(id: $id, nombre: $nombre, precio: $_precio, stock: $_stock)';
  }
}
