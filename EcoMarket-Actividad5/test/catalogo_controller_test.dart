import 'package:ecomarket/data/datasources/servicio_asincrono_simulado.dart';
import 'package:ecomarket/domain/entities/coordenada.dart';
import 'package:ecomarket/domain/entities/producto.dart';
import 'package:ecomarket/domain/repositories/producto_repository.dart';
import 'package:ecomarket/presentation/controllers/catalogo_controller.dart';
import 'package:flutter_test/flutter_test.dart';

class _RepositorioFalso implements ProductoRepository {
  @override
  Future<List<Producto>> obtenerTodos() async {
    return <Producto>[
      Producto(
        id: 'a',
        nombre: 'Manzana',
        descripcion: 'Manzana fresca.',
        categoria: 'Frutas',
        precio: 10,
        stock: 5,
      ),
      Producto(
        id: 'b',
        nombre: 'Miel',
        descripcion: 'Miel pura.',
        categoria: 'Endulzantes',
        precio: 38,
        stock: 0,
        unidad: 'frasco',
      ),
    ];
  }
}

Future<CatalogoController> _crearControlador() async {
  final controller = CatalogoController(repository: _RepositorioFalso());
  await controller.cargarCatalogo();
  return controller;
}

void main() {
  group('CatalogoController', () {
    test('confirmarCompra resta el stock y vacía el carrito', () async {
      final controller = await _crearControlador();

      controller.agregarAlCarrito('a', cantidad: 3);
      expect(controller.totalCarrito, 30);

      final total = controller.confirmarCompra();

      expect(total, 30);
      expect(controller.buscarProductoPorId('a')!.stock, 2);
      expect(controller.carritoVacio, isTrue);
    });

    test('rechaza agregar más unidades que el stock', () async {
      final controller = await _crearControlador();

      expect(
        () => controller.agregarAlCarrito('a', cantidad: 6),
        throwsStateError,
      );
      expect(() => controller.agregarAlCarrito('b'), throwsStateError);
    });

    test('reabastecerInventario permite comprar lo que estaba agotado', () async {
      final controller = await _crearControlador();

      controller.reabastecerInventario(cantidad: 10);
      controller.agregarAlCarrito('b', cantidad: 4);

      expect(controller.buscarProductoPorId('b')!.stock, 10);
      expect(controller.cantidadEnCarrito('b'), 4);
    });

    test('notifica a los observadores al cambiar el carrito', () async {
      final controller = await _crearControlador();
      var avisos = 0;
      controller.addListener(() => avisos++);

      controller.agregarAlCarrito('a');

      expect(avisos, 1);
    });

    test('filtra por categoría', () async {
      final controller = await _crearControlador();

      controller.seleccionarCategoria('Frutas');

      expect(controller.productosVisibles.map((p) => p.id), <String>['a']);
    });
  });

  group('ServicioAsincronoSimulado', () {
    const servicio = ServicioAsincronoSimulado(
      latenciaRed: Duration.zero,
      intervaloGps: Duration.zero,
    );

    test('el GPS descuenta minutos hasta entregar el pedido', () async {
      final lecturas = await servicio
          .rastrearEntrega(
            origen: Coordenada(latitud: -16.5, longitud: -68.0),
            destino: Coordenada(latitud: -16.6, longitud: -68.1),
            minutosEstimados: 30,
          )
          .toList();

      expect(
        lecturas.map((lectura) => lectura.minutosRestantes),
        <int>[30, 25, 20, 15, 10, 5, 0],
      );
      expect(lecturas.first.progreso, 0);
      expect(lecturas.last.entregado, isTrue);
    });

    test('procesarPago devuelve comprobante y rechaza totales inválidos', () async {
      expect(await servicio.procesarPago(25), startsWith('PAGO-'));
      expect(servicio.procesarPago(0), throwsArgumentError);
    });
  });
}
