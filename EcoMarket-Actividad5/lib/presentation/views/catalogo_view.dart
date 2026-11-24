import 'package:flutter/material.dart';

import '../../domain/entities/producto.dart';
import '../../domain/repositories/entrega_repository.dart';
import '../controllers/catalogo_controller.dart';
import '../widgets/producto_card.dart';
import 'checkout_view.dart';

/// Vista principal: carga el catálogo con un FutureBuilder y, una vez listo,
/// lo pinta con un CustomScrollView reactivo al [CatalogoController].
class CatalogoView extends StatefulWidget {
  const CatalogoView({
    super.key,
    required this.controller,
    required this.entregaRepository,
    required this.notificarCompra,
  });

  final CatalogoController controller;
  final EntregaRepository entregaRepository;
  final Future<void> Function(double) notificarCompra;

  @override
  State<CatalogoView> createState() => _CatalogoViewState();
}

class _CatalogoViewState extends State<CatalogoView> {
  late Future<void> _carga;

  @override
  void initState() {
    super.initState();
    _carga = widget.controller.cargarCatalogo();
  }

  void _reintentar() {
    setState(() {
      _carga = widget.controller.cargarCatalogo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _carga,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: const Text('EcoMarket')),
            body: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando catálogo…'),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('EcoMarket')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off_outlined, size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      'No se pudo cargar el catálogo.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _reintentar,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return _CatalogoContenido(
          controller: widget.controller,
          entregaRepository: widget.entregaRepository,
          notificarCompra: widget.notificarCompra,
        );
      },
    );
  }
}

class _CatalogoContenido extends StatelessWidget {
  const _CatalogoContenido({
    required this.controller,
    required this.entregaRepository,
    required this.notificarCompra,
  });

  final CatalogoController controller;
  final EntregaRepository entregaRepository;
  final Future<void> Function(double) notificarCompra;

  void _mostrarAviso(
    BuildContext context,
    String mensaje, {
    bool conReabastecer = false,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mensaje),
          action: conReabastecer
              ? SnackBarAction(
                  label: 'Rellenar Stock',
                  onPressed: () => controller.reabastecerInventario(),
                )
              : null,
        ),
      );
  }

  void _agregar(BuildContext context, Producto producto) {
    try {
      controller.agregarAlCarrito(producto.id);
      _mostrarAviso(context, '${producto.nombre} añadido al carrito.');
    } on StateError catch (error) {
      _mostrarAviso(context, error.message, conReabastecer: true);
    }
  }

  void _verOrigen(BuildContext context, Producto producto) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.satellite_alt),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Origen verificado por satélite',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Producto: ${producto.nombre}'),
                if (producto.finca.isNotEmpty) Text('Finca: ${producto.finca}'),
                Text(
                  'Coordenadas: ${producto.latitud?.toStringAsFixed(2)}, '
                  '${producto.longitud?.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sin alertas de deforestación reciente en la parcela '
                  '(dato simulado).',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final esquema = Theme.of(context).colorScheme;
        final productos = controller.productosVisibles;
        final enCarrito = controller.cantidadTotalArticulos;

        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              controller.reabastecerInventario();
              _mostrarAviso(context, 'Inventario reabastecido (+10 por producto).');
            },
            icon: const Icon(Icons.inventory_2_outlined),
            label: const Text('Rellenar Stock'),
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 150,
                backgroundColor: esquema.primary,
                foregroundColor: esquema.onPrimary,
                title: const Text('EcoMarket'),
                actions: [
                  IconButton(
                    tooltip: 'Ir al checkout',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => CheckoutView(
                            controller: controller,
                            entregaRepository: entregaRepository,
                            notificarCompra: notificarCompra,
                          ),
                        ),
                      );
                    },
                    icon: Badge(
                      label: Text('$enCarrito'),
                      isLabelVisible: enCarrito > 0,
                      child: const Icon(Icons.shopping_cart_outlined),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Alimentos frescos con origen verificado por satélite',
                        style: TextStyle(
                          color: esquema.onPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('Todas'),
                        selected: controller.categoriaSeleccionada == null,
                        onSelected: (_) => controller.seleccionarCategoria(null),
                      ),
                      for (final categoria in controller.categorias)
                        ChoiceChip(
                          label: Text(categoria),
                          selected: controller.categoriaSeleccionada == categoria,
                          onSelected: (_) =>
                              controller.seleccionarCategoria(categoria),
                        ),
                    ],
                  ),
                ),
              ),
              if (productos.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('No hay productos en esta categoría.')),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 96),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.65,
                    ),
                    delegate: SliverChildBuilderDelegate((context, indice) {
                      final producto = productos[indice];
                      return ProductoCard(
                        producto: producto,
                        cantidadEnCarrito: controller.cantidadEnCarrito(
                          producto.id,
                        ),
                        onAgregar: () => _agregar(context, producto),
                        onVerOrigen: () => _verOrigen(context, producto),
                      );
                    }, childCount: productos.length),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
