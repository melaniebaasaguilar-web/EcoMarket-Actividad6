import '../entities/coordenada.dart';
import '../entities/posicion_entrega.dart';

abstract interface class EntregaRepository {
  /// Procesa el cobro (Future con retardo de red simulado).
  /// Devuelve el comprobante de pago.
  Future<String> procesarPago(double total);

  /// Flujo continuo del GPS del repartidor hasta que el pedido se entrega.
  Stream<PosicionEntrega> rastrearEntrega({
    required Coordenada origen,
    required Coordenada destino,
    int minutosEstimados = 30,
  });
}
