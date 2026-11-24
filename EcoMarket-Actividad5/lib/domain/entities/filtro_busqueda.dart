enum CriterioOrden { relevancia, precioAscendente, precioDescendente, novedad }

class FiltroBusqueda {
  FiltroBusqueda({
    this.termino = '',
    this.categoria,
    this.precioMinimo,
    this.precioMaximo,
    this.soloDisponibles = true,
    this.criterio = CriterioOrden.relevancia,
    this.puntuacionMinima,
  }) : assert(
         precioMinimo == null || precioMinimo >= 0,
         'El precio mínimo no puede ser negativo.',
       ),
       assert(
         precioMaximo == null || precioMaximo >= 0,
         'El precio máximo no puede ser negativo.',
       ),
       assert(
         precioMinimo == null ||
             precioMaximo == null ||
             precioMinimo <= precioMaximo,
         'El precio mínimo no puede superar al máximo.',
       ),
       assert(
         puntuacionMinima == null ||
             (puntuacionMinima >= 1 && puntuacionMinima <= 5),
         'La puntuación mínima debe estar entre 1 y 5.',
       );

  final String termino;
  final String? categoria;
  final double? precioMinimo;
  final double? precioMaximo;
  final bool soloDisponibles;
  final CriterioOrden criterio;
  final double? puntuacionMinima;

  bool get tieneFiltrosActivos {
    return termino.trim().isNotEmpty ||
        categoria != null ||
        precioMinimo != null ||
        precioMaximo != null ||
        !soloDisponibles ||
        puntuacionMinima != null;
  }

  FiltroBusqueda copyWith({
    String? termino,
    String? categoria,
    double? precioMinimo,
    double? precioMaximo,
    bool? soloDisponibles,
    CriterioOrden? criterio,
    double? puntuacionMinima,
  }) {
    return FiltroBusqueda(
      termino: termino ?? this.termino,
      categoria: categoria ?? this.categoria,
      precioMinimo: precioMinimo ?? this.precioMinimo,
      precioMaximo: precioMaximo ?? this.precioMaximo,
      soloDisponibles: soloDisponibles ?? this.soloDisponibles,
      criterio: criterio ?? this.criterio,
      puntuacionMinima: puntuacionMinima ?? this.puntuacionMinima,
    );
  }
}
