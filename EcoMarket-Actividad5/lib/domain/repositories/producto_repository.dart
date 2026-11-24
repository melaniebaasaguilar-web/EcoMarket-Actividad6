import '../entities/producto.dart';

abstract interface class ProductoRepository {
  /// Obtiene el catálogo de forma asíncrona (simula una consulta de red).
  Future<List<Producto>> obtenerTodos();
}
