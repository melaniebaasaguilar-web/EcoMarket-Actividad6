class ResumenProductoVendido {
  ResumenProductoVendido({
    required this.productoId,
    required this.nombre,
    required this.unidadesVendidas,
    required this.ingresos,
  }) : assert(
         productoId.trim().isNotEmpty,
         'El id del producto no puede estar vacío.',
       ),
       assert(nombre.trim().isNotEmpty, 'El nombre no puede estar vacío.'),
       assert(
         unidadesVendidas >= 0,
         'Las unidades vendidas no pueden ser negativas.',
       ),
       assert(ingresos >= 0, 'Los ingresos no pueden ser negativos.');

  final String productoId;
  final String nombre;
  final int unidadesVendidas;
  final double ingresos;

  double get precioPromedio =>
      unidadesVendidas == 0 ? 0 : ingresos / unidadesVendidas;
}

class ReporteVentas {
  ReporteVentas({
    required this.fechaInicio,
    required this.fechaFin,
    required List<ResumenProductoVendido> productosMasVendidos,
    required this.totalOrdenes,
    required this.ingresosTotales,
    required this.vendedoresActivos,
    required this.productosPublicados,
  }) : assert(
         !fechaFin.isBefore(fechaInicio),
         'La fecha final no puede ser anterior a la inicial.',
       ),
       assert(totalOrdenes >= 0, 'El total de órdenes no puede ser negativo.'),
       assert(
         ingresosTotales >= 0,
         'Los ingresos totales no pueden ser negativos.',
       ),
       assert(
         vendedoresActivos >= 0,
         'Los vendedores activos no pueden ser negativos.',
       ),
       assert(
         productosPublicados >= 0,
         'Los productos publicados no pueden ser negativos.',
       ),
       _productosMasVendidos = List<ResumenProductoVendido>.unmodifiable(
         productosMasVendidos,
       );

  final DateTime fechaInicio;
  final DateTime fechaFin;
  final int totalOrdenes;
  final double ingresosTotales;
  final int vendedoresActivos;
  final int productosPublicados;
  final List<ResumenProductoVendido> _productosMasVendidos;

  List<ResumenProductoVendido> get productosMasVendidos =>
      _productosMasVendidos;

  double get ticketPromedio =>
      totalOrdenes == 0 ? 0 : ingresosTotales / totalOrdenes;

  ResumenProductoVendido? get productoEstrella {
    if (_productosMasVendidos.isEmpty) {
      return null;
    }

    var mejor = _productosMasVendidos.first;
    for (final producto in _productosMasVendidos.skip(1)) {
      if (producto.unidadesVendidas > mejor.unidadesVendidas) {
        mejor = producto;
      }
    }
    return mejor;
  }
}
