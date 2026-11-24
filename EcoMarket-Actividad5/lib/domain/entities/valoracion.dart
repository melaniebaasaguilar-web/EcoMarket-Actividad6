class Valoracion {
  Valoracion({
    required this.id,
    required this.productoId,
    required this.compradorId,
    required int puntuacion,
    required this.comentario,
    DateTime? fecha,
  }) : assert(id.trim().isNotEmpty, 'El id no puede estar vacío.'),
       assert(
         productoId.trim().isNotEmpty,
         'El id del producto no puede estar vacío.',
       ),
       assert(
         compradorId.trim().isNotEmpty,
         'El id del comprador no puede estar vacío.',
       ),
       assert(
         puntuacion >= 1 && puntuacion <= 5,
         'La puntuación debe estar entre 1 y 5.',
       ),
       assert(
         comentario.trim().isNotEmpty,
         'El comentario no puede estar vacío.',
       ),
       _puntuacion = puntuacion,
       _fecha = fecha ?? DateTime.now();

  final String id;
  final String productoId;
  final String compradorId;
  final String comentario;
  final int _puntuacion;
  final DateTime _fecha;

  int get puntuacion => _puntuacion;

  DateTime get fecha => _fecha;

  bool get esPositiva => _puntuacion >= 4;

  bool get esNegativa => _puntuacion <= 2;

  bool get esNeutra => _puntuacion == 3;
}
