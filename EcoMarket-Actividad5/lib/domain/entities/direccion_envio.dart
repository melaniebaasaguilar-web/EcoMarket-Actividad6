class DireccionEnvio {
  DireccionEnvio({
    required this.id,
    required this.alias,
    required this.destinatario,
    required this.calle,
    required this.ciudad,
    required this.pais,
    this.codigoPostal = '',
    this.referencia = '',
    this.predeterminada = false,
  }) : assert(id.trim().isNotEmpty, 'El id no puede estar vacío.'),
       assert(alias.trim().isNotEmpty, 'El alias no puede estar vacío.'),
       assert(
         destinatario.trim().isNotEmpty,
         'El destinatario no puede estar vacío.',
       ),
       assert(calle.trim().isNotEmpty, 'La calle no puede estar vacía.'),
       assert(ciudad.trim().isNotEmpty, 'La ciudad no puede estar vacía.'),
       assert(pais.trim().isNotEmpty, 'El país no puede estar vacío.');

  final String id;
  final String alias;
  final String destinatario;
  final String calle;
  final String ciudad;
  final String pais;
  final String codigoPostal;
  final String referencia;
  final bool predeterminada;

  String get direccionCompleta {
    final partes = <String>[calle, ciudad];
    if (codigoPostal.trim().isNotEmpty) {
      partes.add(codigoPostal);
    }
    partes.add(pais);
    return partes.join(', ');
  }

  DireccionEnvio copyWith({
    String? alias,
    String? destinatario,
    String? calle,
    String? ciudad,
    String? pais,
    String? codigoPostal,
    String? referencia,
    bool? predeterminada,
  }) {
    return DireccionEnvio(
      id: id,
      alias: alias ?? this.alias,
      destinatario: destinatario ?? this.destinatario,
      calle: calle ?? this.calle,
      ciudad: ciudad ?? this.ciudad,
      pais: pais ?? this.pais,
      codigoPostal: codigoPostal ?? this.codigoPostal,
      referencia: referencia ?? this.referencia,
      predeterminada: predeterminada ?? this.predeterminada,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DireccionEnvio &&
            other.id == id &&
            other.alias == alias &&
            other.destinatario == destinatario &&
            other.calle == calle &&
            other.ciudad == ciudad &&
            other.pais == pais &&
            other.codigoPostal == codigoPostal &&
            other.referencia == referencia &&
            other.predeterminada == predeterminada;
  }

  @override
  int get hashCode => Object.hash(
    id,
    alias,
    destinatario,
    calle,
    ciudad,
    pais,
    codigoPostal,
    referencia,
    predeterminada,
  );
}
