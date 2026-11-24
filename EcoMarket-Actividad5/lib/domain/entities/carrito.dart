import 'item_carrito.dart';
import 'producto.dart';

bool _idsUnicos(List<ItemCarrito> items) {
  final ids = <String>{};
  for (final item in items) {
    if (!ids.add(item.producto.id)) {
      return false;
    }
  }
  return true;
}

class Carrito {
  Carrito({List<ItemCarrito> items = const <ItemCarrito>[]})
    : assert(
        _idsUnicos(items),
        'El carrito no puede contener productos duplicados.',
      ),
      _items = List<ItemCarrito>.unmodifiable(items);

  final List<ItemCarrito> _items;

  List<ItemCarrito> get items => _items;

  bool get vacio => _items.isEmpty;

  int get cantidadProductos => _items.length;

  int get cantidadTotal {
    return _items.fold(0, (total, item) => total + item.cantidad);
  }

  double get subtotal {
    return _items.fold(0, (total, item) => total + item.subtotal);
  }

  bool get tieneExcedentesDeStock {
    return _items.any((item) => item.excedeStock);
  }

  int cantidadDe(String productoId) {
    final item = _buscarItem(productoId);
    return item?.cantidad ?? 0;
  }

  ItemCarrito? _buscarItem(String productoId) {
    for (final item in _items) {
      if (item.producto.id == productoId) {
        return item;
      }
    }
    return null;
  }

  Carrito agregar(Producto producto, {int cantidad = 1}) {
    if (cantidad <= 0) {
      throw ArgumentError.value(
        cantidad,
        'cantidad',
        'La cantidad debe ser mayor que cero.',
      );
    }
    if (producto.agotado) {
      throw StateError('El producto ${producto.nombre} está agotado.');
    }

    final nuevaCantidad = cantidadDe(producto.id) + cantidad;
    if (nuevaCantidad > producto.stock) {
      throw StateError(
        'Stock insuficiente para ${producto.nombre}. '
        'Disponible: ${producto.stock}.',
      );
    }

    return _conItem(ItemCarrito(producto: producto, cantidad: nuevaCantidad));
  }

  Carrito actualizarCantidad(String productoId, int cantidad) {
    if (cantidad < 0) {
      throw ArgumentError.value(
        cantidad,
        'cantidad',
        'La cantidad no puede ser negativa.',
      );
    }

    final item = _buscarItem(productoId);
    if (item == null) {
      throw StateError('El producto no está en el carrito.');
    }

    if (cantidad == 0) {
      return eliminar(productoId);
    }

    if (cantidad > item.producto.stock) {
      throw StateError(
        'Stock insuficiente para ${item.producto.nombre}. '
        'Disponible: ${item.producto.stock}.',
      );
    }

    return _conItem(item.copyWith(cantidad: cantidad));
  }

  Carrito eliminar(String productoId) {
    if (_buscarItem(productoId) == null) {
      return this;
    }

    return Carrito(
      items: _items
          .where((item) => item.producto.id != productoId)
          .toList(growable: false),
    );
  }

  Carrito vaciar() => Carrito();

  Carrito _conItem(ItemCarrito item) {
    final actualizados = <ItemCarrito>[];
    var reemplazado = false;

    for (final actual in _items) {
      if (actual.producto.id == item.producto.id) {
        actualizados.add(item);
        reemplazado = true;
      } else {
        actualizados.add(actual);
      }
    }

    if (!reemplazado) {
      actualizados.add(item);
    }

    return Carrito(items: actualizados);
  }
}
