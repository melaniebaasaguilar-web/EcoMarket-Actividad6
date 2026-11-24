enum RolUsuario { comprador, vendedor, administrador }

bool _correoValido(String correo) {
  return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(correo);
}

class Usuario {
  Usuario({
    required this.id,
    required this.nombre,
    required String correo,
    required this.rol,
    this.correoVerificado = false,
    this.activo = true,
    DateTime? fechaRegistro,
  }) : assert(id.trim().isNotEmpty, 'El id no puede estar vacío.'),
       assert(nombre.trim().isNotEmpty, 'El nombre no puede estar vacío.'),
       assert(_correoValido(correo), 'El correo no tiene un formato válido.'),
       _correo = correo,
       _fechaRegistro = fechaRegistro ?? DateTime.now();

  final String id;
  final String nombre;
  final RolUsuario rol;
  final bool correoVerificado;
  final bool activo;
  final String _correo;
  final DateTime _fechaRegistro;

  String get correo => _correo;

  DateTime get fechaRegistro => _fechaRegistro;

  bool get puedeIniciarSesion => activo && correoVerificado;

  bool get esComprador => rol == RolUsuario.comprador;

  bool get esVendedor => rol == RolUsuario.vendedor;

  bool get esAdministrador => rol == RolUsuario.administrador;

  Usuario copyWith({
    String? nombre,
    String? correo,
    RolUsuario? rol,
    bool? correoVerificado,
    bool? activo,
  }) {
    return Usuario(
      id: id,
      nombre: nombre ?? this.nombre,
      correo: correo ?? _correo,
      rol: rol ?? this.rol,
      correoVerificado: correoVerificado ?? this.correoVerificado,
      activo: activo ?? this.activo,
      fechaRegistro: _fechaRegistro,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Usuario &&
            other.id == id &&
            other.nombre == nombre &&
            other._correo == _correo &&
            other.rol == rol &&
            other.correoVerificado == correoVerificado &&
            other.activo == activo &&
            other._fechaRegistro == _fechaRegistro;
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    _correo,
    rol,
    correoVerificado,
    activo,
    _fechaRegistro,
  );

  @override
  String toString() {
    return 'Usuario(id: $id, nombre: $nombre, rol: $rol)';
  }
}
