import 'producto.dart';

class ItemCarrito {
  ItemCarrito({required this.producto, required int cantidad})
    : assert(cantidad > 0, 'La cantidad debe ser mayor que cero.'),
      _cantidad = cantidad;

  final Producto producto;
  final int _cantidad;

  int get cantidad => _cantidad;

  double get subtotal => producto.precio * _cantidad;

  bool get excedeStock => _cantidad > producto.stock;

  ItemCarrito copyWith({Producto? producto, int? cantidad}) {
    return ItemCarrito(
      producto: producto ?? this.producto,
      cantidad: cantidad ?? _cantidad,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ItemCarrito &&
            other.producto == producto &&
            other._cantidad == _cantidad;
  }

  @override
  int get hashCode => Object.hash(producto, _cantidad);

  @override
  String toString() {
    return 'ItemCarrito(producto: ${producto.nombre}, cantidad: $_cantidad)';
  }
}
