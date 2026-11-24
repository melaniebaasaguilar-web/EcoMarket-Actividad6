enum TipoMovimientoInventario { entrada, salida, ajuste }

class MovimientoInventario {
  MovimientoInventario({
    required this.id,
    required this.productoId,
    required this.tipo,
    required int cantidad,
    required this.motivo,
    DateTime? fecha,
  }) : assert(id.trim().isNotEmpty, 'El id no puede estar vacío.'),
       assert(
         productoId.trim().isNotEmpty,
         'El id del producto no puede estar vacío.',
       ),
       assert(cantidad > 0, 'La cantidad debe ser mayor que cero.'),
       assert(motivo.trim().isNotEmpty, 'El motivo no puede estar vacío.'),
       _cantidad = cantidad,
       _fecha = fecha ?? DateTime.now();

  final String id;
  final String productoId;
  final TipoMovimientoInventario tipo;
  final String motivo;
  final int _cantidad;
  final DateTime _fecha;

  int get cantidad => _cantidad;

  DateTime get fecha => _fecha;

  bool get esEntrada => tipo == TipoMovimientoInventario.entrada;

  bool get esSalida => tipo == TipoMovimientoInventario.salida;

  bool get esAjuste => tipo == TipoMovimientoInventario.ajuste;

  int get variacionStock {
    switch (tipo) {
      case TipoMovimientoInventario.entrada:
        return _cantidad;
      case TipoMovimientoInventario.salida:
        return -_cantidad;
      case TipoMovimientoInventario.ajuste:
        return _cantidad;
    }
  }
}
