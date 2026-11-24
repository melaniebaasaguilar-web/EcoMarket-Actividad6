enum DecisionAuditoria { mantenerSello, retirarSello, requiereRevision }

class AuditoriaParcela {
  AuditoriaParcela({
    required this.id,
    required this.parcelaId,
    required this.administradorId,
    required this.decision,
    required this.motivo,
    this.alertaId,
    DateTime? fecha,
  }) : assert(id.trim().isNotEmpty, 'El id no puede estar vacío.'),
       assert(
         parcelaId.trim().isNotEmpty,
         'El id de la parcela no puede estar vacío.',
       ),
       assert(
         administradorId.trim().isNotEmpty,
         'El id del administrador no puede estar vacío.',
       ),
       assert(motivo.trim().isNotEmpty, 'El motivo no puede estar vacío.'),
       _fecha = fecha ?? DateTime.now();

  final String id;
  final String parcelaId;
  final String administradorId;
  final DecisionAuditoria decision;
  final String motivo;
  final String? alertaId;
  final DateTime _fecha;

  DateTime get fecha => _fecha;

  bool get retiraSello => decision == DecisionAuditoria.retirarSello;

  bool get mantieneSello => decision == DecisionAuditoria.mantenerSello;

  bool get requiereRevision => decision == DecisionAuditoria.requiereRevision;
}
