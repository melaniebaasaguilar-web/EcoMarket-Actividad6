import '../../domain/entities/coordenada.dart';
import '../../domain/entities/posicion_entrega.dart';

/// Backend simulado: Futures con retardo de red (1 s) y un Stream de GPS
/// que emite una lectura cada 3 s.
class ServicioAsincronoSimulado {
  const ServicioAsincronoSimulado({
    this.latenciaRed = const Duration(seconds: 1),
    this.intervaloGps = const Duration(seconds: 3),
  });

  final Duration latenciaRed;
  final Duration intervaloGps;

  /// Ejecuta [consulta] después de esperar la latencia de red simulada.
  Future<T> conLatencia<T>(T Function() consulta) async {
    await Future<void>.delayed(latenciaRed);
    return consulta();
  }

  Future<String> procesarPago(double total) {
    return conLatencia(() {
      if (total <= 0) {
        throw ArgumentError.value(
          total,
          'total',
          'El total a pagar debe ser mayor que cero.',
        );
      }
      return 'PAGO-${DateTime.now().millisecondsSinceEpoch}';
    });
  }

  /// Emite la posición inicial de inmediato y luego una nueva lectura cada
  /// [intervaloGps], descontando [minutosPorCiclo] hasta llegar a cero.
  Stream<PosicionEntrega> rastrearEntrega({
    required Coordenada origen,
    required Coordenada destino,
    int minutosEstimados = 30,
    int minutosPorCiclo = 5,
  }) async* {
    assert(minutosEstimados > 0, 'Los minutos estimados deben ser positivos.');
    assert(minutosPorCiclo > 0, 'Los minutos por ciclo deben ser positivos.');

    var restantes = minutosEstimados;
    while (true) {
      final avance = (minutosEstimados - restantes) / minutosEstimados;
      yield PosicionEntrega(
        ubicacion: Coordenada(
          latitud: origen.latitud + (destino.latitud - origen.latitud) * avance,
          longitud:
              origen.longitud + (destino.longitud - origen.longitud) * avance,
        ),
        minutosRestantes: restantes,
        progreso: avance,
        descripcion: _describir(restantes, avance),
      );

      if (restantes == 0) {
        return;
      }

      await Future<void>.delayed(intervaloGps);
      restantes = restantes - minutosPorCiclo < 0
          ? 0
          : restantes - minutosPorCiclo;
    }
  }

  static String _describir(int restantes, double avance) {
    if (restantes == 0) {
      return 'Pedido entregado. ¡Gracias por comprar ecológico!';
    }
    if (avance < 0.34) {
      return 'El repartidor salió de la finca.';
    }
    if (avance < 0.67) {
      return 'En ruta hacia tu dirección.';
    }
    return 'Última milla: ya casi llegamos.';
  }
}
