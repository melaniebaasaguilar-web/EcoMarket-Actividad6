import 'package:ecomarket/domain/entities/producto.dart';
import 'package:ecomarket/domain/repositories/producto_repository.dart';
import 'package:ecomarket/presentation/controllers/catalogo_controller.dart';
import 'package:flutter_test/flutter_test.dart';

class RepositorioFalso implements ProductoRepository {
  @override
  Future<List<Producto>> obtenerTodos() async {
    return [
      Producto(
        id: 'a',
        nombre: 'Manzana',
        descripcion: 'Manzana fresca',
        categoria: 'Frutas',
        precio: 25.0,
        stock: 10,
      ),
      Producto(
        id: 'b',
        nombre: 'Naranja',
        descripcion: 'Naranja fresca',
        categoria: 'Frutas',
        precio: 15.0,
        stock: 10,
      ),
    ];
  }
}

void main() {
  group('Suite de Calidad - Logica de Negocio', () {
    test('Estado inicial: el carrito inicia vacio', () {
      // 1. ARRANGE
      final controller = CatalogoController(repository: RepositorioFalso());
      addTearDown(controller.dispose);

      // 2. ACT
      final articulos = controller.cantidadTotalArticulos;
      final monto = controller.totalCarrito;

      // 3. ASSERT
      expect(articulos, 0);
      expect(monto, 0.0);
      expect(controller.carritoVacio, isTrue);
    });

    test('Calcula correctamente el total de dos productos', () async {
      // 1. ARRANGE
      final controller = CatalogoController(repository: RepositorioFalso());
      addTearDown(controller.dispose);

      await controller.cargarCatalogo();

      // 2. ACT
      controller.agregarAlCarrito('a');
      controller.agregarAlCarrito('b');

      // 3. ASSERT
      expect(controller.cantidadTotalArticulos, 2);
      expect(controller.totalCarrito, 40.0);
    });

    test('Rechaza confirmar una compra con carrito vacio', () {
      // 1. ARRANGE
      final controller = CatalogoController(repository: RepositorioFalso());
      addTearDown(controller.dispose);

      // 2. ACT
      final operacion = controller.confirmarCompra;

      // 3. ASSERT
      expect(operacion, throwsStateError);
      expect(controller.cantidadTotalArticulos, 0);
      expect(controller.totalCarrito, 0.0);
      expect(controller.carritoVacio, isTrue);
    });
  });
}
