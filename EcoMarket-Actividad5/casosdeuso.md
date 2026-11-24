Casos de uso de compra/venta

- Registro de comprador
El usuario crea una cuenta con email y contraseña. Recibe un correo de verificación y accede a su perfil para gestionar direcciones y métodos de pago.

- Inicio de sesión
El usuario ingresa con email y contraseña. El sistema valida credenciales y lo redirige a su panel según su rol (comprador o vendedor).

- Buscar artículos
El comprador escribe una palabra clave en la barra de búsqueda. El sistema muestra resultados filtrados por categoría, precio y valoración.

- Filtrar y ordenar resultados
El comprador aplica filtros (categoría, rango de precio, disponibilidad) y ordena por relevancia, precio o novedad para acotar la lista de productos.

- Ver detalle de producto
El comprador abre la ficha de un artículo. Consulta descripción, imágenes, precio, stock, valoraciones y opciones de envío.

- Ver perfil de vendedor
El comprador accede a la página del vendedor. Consulta su reputación, historial de ventas y catálogo completo de productos publicados.

- Añadir al carrito
El comprador selecciona cantidad y variante de un producto y lo añade al carrito. El sistema actualiza el subtotal en tiempo real.

- Gestionar carrito
El comprador revisa los artículos del carrito, modifica cantidades o elimina productos antes de proceder al pago.

- Checkout y pago
El comprador confirma la dirección de envío, elige método de pago y finaliza la compra. El sistema genera la orden y envía la confirmación por email.

- Seguimiento de pedido
El comprador consulta el estado de su pedido (pendiente, enviado, entregado) y accede al número de seguimiento del envío.

- Subir artículo de venta
El vendedor completa el formulario con título, descripción, precio, stock, categoría e imágenes. El producto queda en estado "pendiente de revisión" hasta su aprobación.

- Editar o pausar publicación
El vendedor modifica datos de un producto publicado o lo pausa temporalmente para ocultarlo del catálogo sin eliminarlo.

- Gestionar inventario
El vendedor actualiza el stock de sus productos. El sistema oculta automáticamente los artículos sin existencias.

- Gestionar pedidos recibidos
El vendedor revisa los pedidos entrantes, confirma la preparación, marca el envío y actualiza el estado para el comprador.

- Ver reportes de ventas
El administrador accede a un panel con métricas de ventas, productos más vendidos y actividad de vendedores para tomar decisiones operativas.

- Compra con "sello satelital" en la ficha del producto
El consumidor navega el catálogo de frutas o cereales. Antes de comprar, ve un sello que indica "Origen verificado por satélite". Al pulsarlo, se despliega un mapa con la ubicación de la finca y una nota que confirma que la parcela no ha sufrido deforestación reciente (cruzando coordenadas con imágenes históricas). El modelo de referencia es la app china "今朝好物", que usa teledetección satelital precisamente para reconstruir la confianza en productos agrícolas .

- Venta del productor con carga de coordenadas
Un pequeño productor se registra como vendedor. Para publicar sus frutas o cereales, el sistema le exige delimitar el polígono de su finca en un mapa. Esta geolocalización es la que luego alimenta el monitoreo satelital. Sin este paso, el producto no obtiene el sello de trazabilidad y no puede venderse como "ecológico verificado".

- Suscripción recurrente con monitoreo continuo
El cliente se suscribe a una caja mensual de cereales o frutas de temporada. La app le envía actualizaciones breves: "Tu producto viene de la parcela X. El satélite confirma que el cultivo mantuvo buena salud vegetal este mes". Convierte el monitoreo en un beneficio de fidelización, no solo en un requisito de venta.

Casos de uso de trazabilidad y monitoreo

- Alertas tempranas de riesgo para el comprador
El sistema monitorea las parcelas de los productores registrados. Si el satélite detecta una anomalía (pérdida brusca de cobertura vegetal, posible tala o incendio en la zona), se genera una alerta. El comprador que tenga productos en camino desde esa finca recibe una notificación y puede pausar la compra o solicitar verificación adicional antes de recibir el pedido.

- Predicción de cosecha para planificar compras
Usando índices de vegetación satelital (como el GCVI, que correlaciona con el rendimiento en cebada ecológica) , la app estima la producción futura de un productor. El comprador mayorista puede planificar sus pedidos con antelación, y el productor puede ajustar su oferta en el catálogo antes de la cosecha. El monitoreo deja de ser retrospectivo y se vuelve predictivo.

- Panel de auditoría para el administrador de la plataforma
El equipo de la app tiene un panel interno donde ve todas las parcelas registradas, el estado de salud vegetal de cada cultivo (según índices satelitales) y las alertas de deforestación pendientes de revisar. Cuando un producto recibe una queja de "no parece ecológico", el administrador consulta el historial satelital de esa parcela y decide si mantiene o retira el sello de verificación al vendedor.