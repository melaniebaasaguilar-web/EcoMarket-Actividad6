import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/item_carrito.dart';
import '../../domain/repositories/entrega_repository.dart';
import '../controllers/catalogo_controller.dart';
import '../utils/formato.dart';
import 'seguimiento_view.dart';

/// Checkout: un único [Form] coordinado por una [GlobalKey<FormState>].
class CheckoutView extends StatefulWidget {
  const CheckoutView({
    super.key,
    required this.controller,
    required this.entregaRepository,
    required this.notificarCompra,
  });

  final CatalogoController controller;
  final EntregaRepository entregaRepository;
  final Future<void> Function(double) notificarCompra;

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  static final RegExp _regexNombre = RegExp(
    r"^[A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+(?:[ '\-][A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+)+$",
  );
  static final RegExp _regexCorreo = RegExp(
    r'^[\w.+\-]+@[A-Za-z0-9\-]+(\.[A-Za-z0-9\-]+)*\.[A-Za-z]{2,}$',
  );
  static final RegExp _regexTelefono = RegExp(r'^\d{8,10}$');
  static final RegExp _regexTarjeta = RegExp(r'^\d{16}$');
  static final RegExp _regexVencimiento = RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$');
  static final RegExp _regexCvv = RegExp(r'^\d{3,4}$');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _procesando = false;
  String _nombre = '';
  String _direccion = '';

  String? _validarNombre(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) return 'Ingresa tu nombre completo.';
    if (!_regexNombre.hasMatch(texto)) {
      return 'Escribe nombre y apellido (solo letras).';
    }
    return null;
  }

  String? _validarCorreo(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) return 'Ingresa tu correo electrónico.';
    if (!_regexCorreo.hasMatch(texto)) return 'Correo no válido.';
    return null;
  }

  String? _validarTelefono(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) return 'Ingresa tu teléfono.';
    if (!_regexTelefono.hasMatch(texto)) return 'Debe tener de 8 a 10 dígitos.';
    return null;
  }

  String? _validarDireccion(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) return 'Ingresa la dirección de entrega.';
    if (texto.length < 8) return 'La dirección es demasiado corta.';
    return null;
  }

  String? _validarTarjeta(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) return 'Ingresa el número de tarjeta.';
    if (!_regexTarjeta.hasMatch(texto)) return 'Debe tener 16 dígitos.';
    return null;
  }

  String? _validarVencimiento(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) return 'Ingresa el vencimiento.';
    if (!_regexVencimiento.hasMatch(texto)) return 'Usa el formato MM/AA.';
    return null;
  }

  String? _validarCvv(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) return 'Ingresa el CVV.';
    if (!_regexCvv.hasMatch(texto)) return 'Debe tener 3 o 4 dígitos.';
    return null;
  }

  void _aviso(String mensaje, {bool conReabastecer = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mensaje),
          action: conReabastecer
              ? SnackBarAction(
                  label: 'Rellenar Stock',
                  onPressed: () => widget.controller.reabastecerInventario(),
                )
              : null,
        ),
      );
  }

  void _cambiarCantidad(ItemCarrito item, int delta) {
    try {
      widget.controller.actualizarCantidadCarrito(
        item.producto.id,
        item.cantidad + delta,
      );
    } on StateError catch (error) {
      _aviso(error.message, conReabastecer: true);
    }
  }

  Future<void> _pagar() async {
    final formulario = _formKey.currentState;
    if (formulario == null || !formulario.validate()) {
      _aviso('Revisa los campos marcados en rojo.');
      return;
    }
    formulario.save();

    final controller = widget.controller;
    try {
      controller.validarDisponibilidad();
    } on StateError catch (error) {
      _aviso(error.message, conReabastecer: true);
      return;
    }

    setState(() => _procesando = true);
    try {
      final comprobante = await widget.entregaRepository.procesarPago(
        controller.totalCarrito,
      );
      if (!mounted) return;

      final origen = controller.origenEnvio;
      final destino = controller.destinoEnvio;
      final total = controller.confirmarCompra();

      // La compra ya fue confirmada. Un fallo de la notificación no debe
      // marcar el pago como fallido ni permitir cobrar de nuevo.
      try {
        await widget.notificarCompra(total);
      } catch (error) {
        debugPrint('EcoMarket: no se pudo mostrar la notificación: $error');
      }
      if (!mounted) return;

      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => SeguimientoView(
            entregaRepository: widget.entregaRepository,
            comprobante: comprobante,
            destinatario: _nombre,
            direccion: _direccion,
            total: total,
            origen: origen,
            destino: destino,
          ),
        ),
      );
    } on StateError catch (error) {
      if (!mounted) return;
      setState(() => _procesando = false);
      _aviso(error.message, conReabastecer: true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _procesando = false);
      _aviso('No se pudo procesar el pago. Intenta de nuevo.');
    }
  }

  Widget _campo({
    required String etiqueta,
    required IconData icono,
    required FormFieldValidator<String> validator,
    FormFieldSetter<String>? onSaved,
    TextInputType? teclado,
    List<TextInputFormatter>? formatos,
    String? pista,
    bool ultimo = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        enabled: !_procesando,
        keyboardType: teclado,
        inputFormatters: formatos,
        textInputAction: ultimo ? TextInputAction.done : TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: etiqueta,
          hintText: pista,
          prefixIcon: Icon(icono),
          border: const OutlineInputBorder(),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  Widget _resumen(BuildContext context) {
    final tema = Theme.of(context);
    final controller = widget.controller;

    if (controller.carritoVacio) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: Text('Tu carrito está vacío.')),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Resumen del pedido', style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        for (final item in controller.carrito)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.producto.nombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${formatoMoneda(item.producto.precio)} × '
                        '${item.cantidad} = ${formatoMoneda(item.subtotal)}',
                        style: tema.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Quitar una unidad',
                  onPressed: _procesando ? null : () => _cambiarCantidad(item, -1),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('${item.cantidad}'),
                IconButton(
                  tooltip: 'Añadir una unidad',
                  onPressed: _procesando ? null : () => _cambiarCantidad(item, 1),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total a pagar', style: tema.textTheme.titleMedium),
            Text(
              formatoMoneda(controller.totalCarrito),
              style: tema.textTheme.titleMedium?.copyWith(
                color: tema.colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final vacio = widget.controller.carritoVacio;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _resumen(context),
                if (!vacio) ...[
                  const SizedBox(height: 24),
                  Text('Datos de entrega', style: tema.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _campo(
                          etiqueta: 'Nombre completo',
                          icono: Icons.person_outline,
                          validator: _validarNombre,
                          onSaved: (valor) => _nombre = valor?.trim() ?? '',
                          teclado: TextInputType.name,
                        ),
                        _campo(
                          etiqueta: 'Correo electrónico',
                          icono: Icons.email_outlined,
                          validator: _validarCorreo,
                          teclado: TextInputType.emailAddress,
                        ),
                        _campo(
                          etiqueta: 'Teléfono',
                          icono: Icons.phone_outlined,
                          validator: _validarTelefono,
                          teclado: TextInputType.phone,
                          formatos: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ),
                        _campo(
                          etiqueta: 'Dirección de entrega',
                          icono: Icons.home_outlined,
                          validator: _validarDireccion,
                          onSaved: (valor) => _direccion = valor?.trim() ?? '',
                          teclado: TextInputType.streetAddress,
                        ),
                        const SizedBox(height: 12),
                        Text('Pago con tarjeta', style: tema.textTheme.titleMedium),
                        const SizedBox(height: 12),
                        _campo(
                          etiqueta: 'Número de tarjeta',
                          icono: Icons.credit_card,
                          validator: _validarTarjeta,
                          teclado: TextInputType.number,
                          formatos: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(16),
                          ],
                        ),
                        _campo(
                          etiqueta: 'Vencimiento',
                          pista: 'MM/AA',
                          icono: Icons.date_range_outlined,
                          validator: _validarVencimiento,
                          teclado: TextInputType.datetime,
                          formatos: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                            LengthLimitingTextInputFormatter(5),
                          ],
                        ),
                        _campo(
                          etiqueta: 'CVV',
                          icono: Icons.lock_outline,
                          validator: _validarCvv,
                          teclado: TextInputType.number,
                          ultimo: true,
                          formatos: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: _procesando ? null : _pagar,
                    icon: _procesando
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.lock_outline),
                    label: Text(
                      _procesando
                          ? 'Procesando pago…'
                          : 'Pagar ${formatoMoneda(widget.controller.totalCarrito)}',
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
