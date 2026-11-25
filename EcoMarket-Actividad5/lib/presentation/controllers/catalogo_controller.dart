import 'package:flutter/foundation.dart';

import '../../domain/entities/coordenada.dart';
import '../../domain/entities/item_carrito.dart';
import '../../domain/entities/producto.dart';
import '../../domain/repositories/producto_repository.dart';

class CatalogoController extends ChangeNotifier {
  CatalogoController({required this._repository});

  static final Coordenada _origenPredeterminado = Coordenada(
    latitud: -16.52,
    longitud: -68.05,
  );
  static final Coordenada _destinoPredeterminado = Coordenada(
    latitud: -16.50,
    longitud: -68.15,
  );

  final ProductoRepository _repository;
  final Map<String, int> _cantidadesCarrito = <String, int>{};
  List<Producto> _productos = <Producto>[];
  String? _categoriaSeleccionada;

  /// Carga el catálogo (Future con latencia simulada) y avisa a los
  /// observadores. Se invoca desde un FutureBuilder.
  Future<void> cargarCatalogo() async {
    final cargados = await _repository.obtenerTodos();
    _productos = List<Producto>.of(cargados);
    notifyListeners();
  }

  List<Producto> get productos => List<Producto>.unmodifiable(_productos);

  String? get categoriaSeleccionada => _categoriaSeleccionada;

  List<String> get categorias {
    final unicas = <String>{for (final producto in _productos) producto.categoria};
    return List<String>.unmodifiable(unicas.toList()..sort());
  }

  List<Producto> get productosVisibles {
    final categoria = _categoriaSeleccionada;
    if (categoria == null) {
      return productos;
    }
    return List<Producto>.unmodifiable(
      _productos.where((producto) => producto.categoria == categoria),
    );
  }

  void seleccionarCategoria(String? categoria) {
    if (_categoriaSeleccionada == categoria) {
      return;
    }
    _categoriaSeleccionada = categoria;
    notifyListeners();
  }

  Coordenada get origenEnvio {
    for (final item in carrito) {
      final latitud = item.producto.latitud;
      final longitud = item.producto.longitud;
      if (latitud != null && longitud != null) {
        return Coordenada(latitud: latitud, longitud: longitud);
      }
    }
    return _origenPredeterminado;
  }

  Coordenada get destinoEnvio => _destinoPredeterminado;

  List<Producto> get productosDisponibles => List<Producto>.unmodifiable(
    _productos.where((producto) => producto.disponible),
  );

  List<ItemCarrito> get carrito =>
      List<ItemCarrito>.unmodifiable(_generarItemsCarrito());

  bool get carritoVacio => _cantidadesCarrito.isEmpty;

  int get cantidadProductosEnCarrito => _cantidadesCarrito.length;

  int get cantidadTotalArticulos {
    return _cantidadesCarrito.values.fold(
      0,
      (total, cantidad) => total + cantidad,
    );
  }

  double get subtotalCarrito {
    return carrito.fold(0, (total, item) => total + item.subtotal);
  }

  double get totalCarrito => subtotalCarrito;

  Iterable<ItemCarrito> _generarItemsCarrito() sync* {
    for (final entrada in _cantidadesCarrito.entries) {
      final producto = buscarProductoPorId(entrada.key);
      if (producto != null) {
        yield ItemCarrito(producto: producto, cantidad: entrada.value);
      }
    }
  }

  Producto? buscarProductoPorId(String productoId) {
    for (final producto in _productos) {
      if (producto.id == productoId) {
        return producto;
      }
    }
    return null;
  }

  int cantidadEnCarrito(String productoId) {
    return _cantidadesCarrito[productoId] ?? 0;
  }

  void agregarAlCarrito(String productoId, {int cantidad = 1}) {
    if (cantidad <= 0) {
      throw ArgumentError.value(
        cantidad,
        'cantidad',
        'La cantidad debe ser mayor que cero.',
      );
    }

    final producto = buscarProductoPorId(productoId);
    if (producto == null) {
      throw StateError('No existe un producto con id $productoId.');
    }
    if (producto.agotado) {
      throw StateError('El producto ${producto.nombre} está agotado.');
    }

    final nuevaCantidad = cantidadEnCarrito(productoId) + cantidad;
    if (nuevaCantidad > producto.stock) {
      throw StateError(
        'Stock insuficiente para ${producto.nombre}. '
        'Disponible: ${producto.stock}.',
      );
    }

    _cantidadesCarrito[productoId] = nuevaCantidad;
    notifyListeners();
  }

  void actualizarCantidadCarrito(String productoId, int cantidad) {
    if (cantidad < 0) {
      throw ArgumentError.value(
        cantidad,
        'cantidad',
        'La cantidad no puede ser negativa.',
      );
    }

    final producto = buscarProductoPorId(productoId);
    if (producto == null) {
      throw StateError('No existe un producto con id $productoId.');
    }

    if (cantidad == 0) {
      eliminarDelCarrito(productoId);
      return;
    }

    if (cantidad > producto.stock) {
      throw StateError(
        'Stock insuficiente para ${producto.nombre}. '
        'Disponible: ${producto.stock}.',
      );
    }

    if (cantidadEnCarrito(productoId) == cantidad) {
      return;
    }

    _cantidadesCarrito[productoId] = cantidad;
    notifyListeners();
  }

  void eliminarDelCarrito(String productoId) {
    if (_cantidadesCarrito.remove(productoId) != null) {
      notifyListeners();
    }
  }

  void vaciarCarrito() {
    if (_cantidadesCarrito.isEmpty) {
      return;
    }
    _cantidadesCarrito.clear();
    notifyListeners();
  }

  /// Lanza [StateError] si el carrito está vacío o excede el stock real.
  void validarDisponibilidad() {
    if (carritoVacio) {
      throw StateError(
        'No se puede confirmar una compra con el carrito vacío.',
      );
    }

    for (final item in carrito) {
      if (item.excedeStock) {
        throw StateError(
          'Stock insuficiente para ${item.producto.nombre}. '
          'Disponible: ${item.producto.stock}.',
        );
      }
    }
  }

  double confirmarCompra() {
    validarDisponibilidad();

    final items = carrito;
    final total = totalCarrito;
    final stockActualizado = <String, int>{
      for (final item in items)
        item.producto.id: item.producto.stock - item.cantidad,
    };

    _productos = _productos
        .map((producto) {
          final nuevoStock = stockActualizado[producto.id];
          return nuevoStock == null
              ? producto
              : producto.copyWith(stock: nuevoStock);
        })
        .toList(growable: false);

    _cantidadesCarrito.clear();
    notifyListeners();
    return total;
  }

  void reabastecerInventario({int cantidad = 10, String? productoId}) {
    if (cantidad <= 0) {
      throw ArgumentError.value(
        cantidad,
        'cantidad',
        'La cantidad debe ser mayor que cero.',
      );
    }

    if (productoId != null && buscarProductoPorId(productoId) == null) {
      throw StateError('No existe un producto con id $productoId.');
    }

    _productos = _productos
        .map((producto) {
          if (productoId == null || producto.id == productoId) {
            return producto.copyWith(stock: producto.stock + cantidad);
          }
          return producto;
        })
        .toList(growable: false);

    notifyListeners();
  }
}
