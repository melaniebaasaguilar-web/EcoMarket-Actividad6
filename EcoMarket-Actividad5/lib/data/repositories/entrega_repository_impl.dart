import '../../domain/entities/coordenada.dart';
import '../../domain/entities/posicion_entrega.dart';
import '../../domain/repositories/entrega_repository.dart';
import '../datasources/servicio_asincrono_simulado.dart';

class EntregaRepositoryImpl implements EntregaRepository {
  EntregaRepositoryImpl(this._servicio);

  final ServicioAsincronoSimulado _servicio;

  @override
  Future<String> procesarPago(double total) => _servicio.procesarPago(total);

  @override
  Stream<PosicionEntrega> rastrearEntrega({
    required Coordenada origen,
    required Coordenada destino,
    int minutosEstimados = 30,
  }) {
    return _servicio.rastrearEntrega(
      origen: origen,
      destino: destino,
      minutosEstimados: minutosEstimados,
    );
  }
}
