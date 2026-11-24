import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Notificaciones locales de pedidos para Android.
class NotificacionesService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String canalId = 'canal_ecomarket_pedidos';
  static const String canalNombre = 'Confirmación de Pedidos';
  static const String canalDescripcion = 'Confirmaciones de compra de EcoMarket';

  static Future<void> inicializar() async {
    const ajustes = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _plugin.initialize(settings: ajustes);

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        canalId,
        canalNombre,
        description: canalDescripcion,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      ),
    );
    await android?.requestNotificationsPermission();
  }

  static Future<void> mostrarNotificacionCompra(double totalPagado) async {
    const detalles = NotificationDetails(
      android: AndroidNotificationDetails(
        canalId,
        canalNombre,
        channelDescription: canalDescripcion,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      ),
    );

    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch.remainder(2147483647),
      title: '¡Compra realizada!',
      body: 'Total pagado: \$${totalPagado.toStringAsFixed(2)}',
      notificationDetails: detalles,
    );
  }
}
