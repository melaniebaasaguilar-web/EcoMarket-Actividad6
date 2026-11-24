import 'direccion_envio.dart';
import 'metodo_pago.dart';
import 'usuario.dart';

class Comprador {
  Comprador({
    required this.usuario,
    List<DireccionEnvio> direcciones = const <DireccionEnvio>[],
    List<MetodoPago> metodosPago = const <MetodoPago>[],
  }) : assert(
         usuario.rol == RolUsuario.comprador,
         'El usuario debe tener el rol de comprador.',
       ),
       _direcciones = List<DireccionEnvio>.unmodifiable(direcciones),
       _metodosPago = List<MetodoPago>.unmodifiable(metodosPago);

  final Usuario usuario;
  final List<DireccionEnvio> _direcciones;
  final List<MetodoPago> _metodosPago;

  List<DireccionEnvio> get direcciones => _direcciones;

  List<MetodoPago> get metodosPago => _metodosPago;

  DireccionEnvio? get direccionPredeterminada {
    for (final direccion in _direcciones) {
      if (direccion.predeterminada) {
        return direccion;
      }
    }
    return _direcciones.isEmpty ? null : _direcciones.first;
  }

  MetodoPago? get metodoPagoPredeterminado {
    for (final metodo in _metodosPago) {
      if (metodo.predeterminado) {
        return metodo;
      }
    }
    return _metodosPago.isEmpty ? null : _metodosPago.first;
  }

  bool get tieneDireccion => _direcciones.isNotEmpty;

  bool get tieneMetodoPago => _metodosPago.isNotEmpty;

  bool get puedeComprar =>
      usuario.puedeIniciarSesion && tieneDireccion && tieneMetodoPago;

  Comprador copyWith({
    List<DireccionEnvio>? direcciones,
    List<MetodoPago>? metodosPago,
  }) {
    return Comprador(
      usuario: usuario,
      direcciones: direcciones ?? _direcciones,
      metodosPago: metodosPago ?? _metodosPago,
    );
  }
}
