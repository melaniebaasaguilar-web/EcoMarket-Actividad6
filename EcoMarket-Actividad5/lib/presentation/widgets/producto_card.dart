import 'package:flutter/material.dart';

import '../../domain/entities/producto.dart';
import '../utils/formato.dart';

class ProductoCard extends StatelessWidget {
  const ProductoCard({
    super.key,
    required this.producto,
    required this.cantidadEnCarrito,
    required this.onAgregar,
    required this.onVerOrigen,
  });

  final Producto producto;
  final int cantidadEnCarrito;
  final VoidCallback onAgregar;
  final VoidCallback onVerOrigen;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                _ImagenProducto(url: producto.imagenUrl),
                if (producto.agotado)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Chip(
                      label: const Text('Agotado'),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: tema.colorScheme.errorContainer,
                      labelStyle: TextStyle(
                        color: tema.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                if (producto.tieneSelloSatelital)
                  Positioned(
                    left: 8,
                    right: 8,
                    bottom: 8,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _SelloSatelital(onTap: onVerOrigen),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tema.textTheme.titleSmall,
                ),
                Text(
                  producto.categoria,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tema.textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '${formatoMoneda(producto.precio)} / ${producto.unidad}',
                      style: tema.textTheme.labelLarge?.copyWith(
                        color: tema.colorScheme.primary,
                      ),
                    ),
                    Text(
                      producto.agotado
                          ? 'Sin stock'
                          : 'Stock: ${producto.stock}',
                      style: tema.textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonalIcon(
                    onPressed: onAgregar,
                    icon: const Icon(Icons.add_shopping_cart, size: 18),
                    label: Text(
                      cantidadEnCarrito > 0
                          ? 'Añadir ($cantidadEnCarrito)'
                          : 'Añadir',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagenProducto extends StatelessWidget {
  const _ImagenProducto({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final direccion = url;
    if (direccion == null) {
      return const _ImagenNoDisponible();
    }

    return Image.network(
      direccion,
      fit: BoxFit.cover,
      loadingBuilder: (context, hijo, progreso) {
        if (progreso == null) {
          return hijo;
        }
        final total = progreso.expectedTotalBytes;
        return Center(
          child: CircularProgressIndicator(
            value: total == null ? null : progreso.cumulativeBytesLoaded / total,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) =>
          const _ImagenNoDisponible(),
    );
  }
}

class _ImagenNoDisponible extends StatelessWidget {
  const _ImagenNoDisponible();

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return ColoredBox(
      color: esquema.surfaceContainerHighest,
      child: Center(
        child: Icon(Icons.eco_outlined, size: 40, color: esquema.outline),
      ),
    );
  }
}

class _SelloSatelital extends StatelessWidget {
  const _SelloSatelital({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Material(
      color: esquema.primaryContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.satellite_alt,
                size: 14,
                color: esquema.onPrimaryContainer,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  'Verificado por satélite',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: esquema.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
