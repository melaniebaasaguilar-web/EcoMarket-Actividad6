# EcoMarket

Un minisistema móvil de catálogo ecológico y monitoreo satelital en tiempo real, aplicando de forma estricta los estándares industriales de Clean Architecture, programación asíncrona, control de nulabilidad y el patrón de diseño Observer.

Práctica de laboratorio — Flutter · Material 3.

## Estructura (Clean Architecture)

```
lib/
├── domain/            # Reglas de negocio. No importa Flutter ni data.
│   ├── entities/      # Entidades inmutables con assert (Producto, Carrito, Coordenada, PosicionEntrega…)
│   └── repositories/  # Contratos: ProductoRepository, EntregaRepository
├── data/              # Implementaciones de los contratos.
│   ├── datasources/   # Catálogo local en RAM + ServicioAsincronoSimulado (Futures de 1 s, Stream GPS de 3 s)
│   └── repositories/  # ProductoRepositoryImpl, EntregaRepositoryImpl
├── presentation/      # Píxeles. Solo habla con el dominio.
│   ├── controllers/   # CatalogoController (ChangeNotifier: stock, carrito, filtro)
│   ├── views/         # CatalogoView, CheckoutView, SeguimientoView
│   ├── widgets/       # ProductoCard
│   └── utils/
└── main.dart          # Raíz de composición (único lugar que une data con domain)
```

## Reparto por rol y día

| Rol | Responsable de | Archivos principales | Día |
| --- | --- | --- | --- |
| 1 — Arquitectura y Datos | Capas, entidades con `assert`, ChangeNotifier | `lib/domain/**`, `lib/data/datasources/producto_local_datasource.dart`, `lib/presentation/controllers/catalogo_controller.dart`, `.gitignore` | 1 y 3 |
| 2 — UI Responsiva | `Scaffold`, `Wrap`, `CustomScrollView`, `SliverAppBar(pinned)`, `SliverGrid` (0.65) | `lib/presentation/views/catalogo_view.dart`, `lib/presentation/widgets/producto_card.dart` | 1 y 2 |
| 3 — Captura y Validación | `Form`, `GlobalKey<FormState>`, `TextFormField` + regex | `lib/presentation/views/checkout_view.dart` | 2 |
| 4 — Sincronización Asíncrona | `Future` (1 s), `Stream` GPS (3 s), `FutureBuilder`, `StreamBuilder` | `lib/data/datasources/servicio_asincrono_simulado.dart`, `lib/data/repositories/entrega_repository_impl.dart`, `lib/domain/repositories/entrega_repository.dart`, `lib/domain/entities/posicion_entrega.dart`, `lib/presentation/views/seguimiento_view.dart` | 3 |
| Todo el equipo | Integración | `lib/main.dart`, `CatalogoController`, FAB "Rellenar Stock" | 3 |

## Flujo de la app

1. **Catálogo**: un `FutureBuilder` espera 1 s (carga simulada) con estados de carga y error. Las imágenes usan `loadingBuilder` y `errorBuilder`.
2. **Añadir al carrito**: si no hay stock suficiente aparece un `SnackBar` con la acción **Rellenar Stock**.
3. **Checkout**: la `GlobalKey<FormState>` valida todos los campos a la vez (errores en rojo). Al pagar se espera 1 s, se resta el stock real en RAM y se vacía el carrito.
4. **Seguimiento**: un `StreamBuilder` recibe una lectura del GPS cada 3 s y descuenta los minutos restantes.
5. **FAB "Rellenar Stock"**: `reabastecerInventario()` + `notifyListeners()`; el `ListenableBuilder` refresca la pantalla de forma atómica.

## Ejecutar

```bash
flutter pub get
flutter run
flutter test
```

> Las imágenes del catálogo son marcadores de posición (`picsum.photos`); sustitúyelas por URLs reales en `producto_local_datasource.dart`.
