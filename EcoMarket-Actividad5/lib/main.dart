import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import 'data/datasources/producto_local_datasource.dart';
import 'data/datasources/servicio_asincrono_simulado.dart';
import 'data/repositories/entrega_repository_impl.dart';
import 'data/repositories/producto_repository_impl.dart';
import 'data/services/notificaciones_service.dart';
import 'domain/repositories/entrega_repository.dart';
import 'presentation/controllers/catalogo_controller.dart';
import 'presentation/views/catalogo_view.dart';

const tareaInventario = 'sincronizarInventario';

/// Punto de entrada del isolate de segundo plano, conservado en Release (AOT).
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task != tareaInventario) return false;
    try {
      // Simula una consulta de inventario, sin modificar el carrito en RAM.
      const servicio = ServicioAsincronoSimulado();
      final productos = await servicio.conLatencia(
        () => const ProductoLocalDataSource().obtenerProductos(),
      );
      debugPrint(
        'EcoMarket: sincronización simulada: ${productos.length} productos.',
      );
      return true;
    } catch (error) {
      debugPrint('EcoMarket: error de sincronización: $error');
      return false;
    }
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificacionesService.inicializar();
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    'ecomarket-inventario',
    tareaInventario,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );
  runApp(const EcoMarketApp());
}

/// Raíz de composición: aquí (y solo aquí) se conectan las implementaciones
/// de la capa data con las interfaces del dominio.
class EcoMarketApp extends StatefulWidget {
  const EcoMarketApp({super.key});

  @override
  State<EcoMarketApp> createState() => _EcoMarketAppState();
}

class _EcoMarketAppState extends State<EcoMarketApp> {
  late final CatalogoController _controller;
  late final EntregaRepository _entregaRepository;

  @override
  void initState() {
    super.initState();
    const servicio = ServicioAsincronoSimulado();
    _controller = CatalogoController(
      repository: ProductoRepositoryImpl(
        const ProductoLocalDataSource(),
        servicio,
      ),
    );
    _entregaRepository = EntregaRepositoryImpl(servicio);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoMarket Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
      ),
      home: CatalogoView(
        controller: _controller,
        entregaRepository: _entregaRepository,
        notificarCompra: NotificacionesService.mostrarNotificacionCompra,
      ),
    );
  }
}
