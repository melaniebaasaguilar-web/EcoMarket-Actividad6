import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecomarket/domain/entities/producto.dart';
import 'package:ecomarket/domain/repositories/producto_repository.dart';
import 'package:ecomarket/domain/repositories/entrega_repository.dart';
import 'package:ecomarket/presentation/controllers/catalogo_controller.dart';
import 'package:ecomarket/presentation/views/catalogo_view.dart';

class RepositorioProductoFalso implements ProductoRepository {
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
    ];
  }
}

class RepositorioEntregaFalso implements EntregaRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

Widget crearAplicacion(CatalogoController controller) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CatalogoView(
      controller: controller,
      entregaRepository: RepositorioEntregaFalso(),
      notificarCompra: (double total) async {},
    ),
  );
}

void main() {
  group('Suite de Calidad - Interfaz Grafica', () {
    testWidgets('Renderiza el titulo y el carrito en cero', (
      WidgetTester tester,
    ) async {
      // 1. ARRANGE
      final controller = CatalogoController(
        repository: RepositorioProductoFalso(),
      );
      addTearDown(controller.dispose);

      // 2. ACT
      await tester.pumpWidget(crearAplicacion(controller));

      await tester.pumpAndSettle();

      // 3. ASSERT
      expect(find.text('EcoMarket Pro'), findsOneWidget);

      expect(find.byType(Badge), findsOneWidget);

      expect(
        find.descendant(of: find.byType(Badge), matching: find.text('0')),
        findsOneWidget,
      );

      expect(find.text('Manzana'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('Actualiza el contador del carrito al agregar un producto', (
      WidgetTester tester,
    ) async {
      // 1. ARRANGE
      final controller = CatalogoController(
        repository: RepositorioProductoFalso(),
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(crearAplicacion(controller));

      await tester.pumpAndSettle();

      final botonAgregar = find.widgetWithIcon(
        FilledButton,
        Icons.add_shopping_cart,
      );

      await tester.ensureVisible(botonAgregar);
      await tester.pumpAndSettle();

      // 2. ACT
      await tester.tap(botonAgregar);
      await tester.pump();

      // 3. ASSERT
      expect(
        find.descendant(of: find.byType(Badge), matching: find.text('1')),
        findsOneWidget,
      );

      expect(controller.cantidadTotalArticulos, 1);
      expect(controller.totalCarrito, 25.0);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  });
}
