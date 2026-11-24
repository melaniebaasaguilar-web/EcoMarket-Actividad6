# ecomarket

El mercado internacional de desarrollo móvil exige que las aplicaciones sean elásticas, escalables y eficientes ante las restricciones físicas de hardware (memoria RAM y batería). Empresas líderes como Uber o Mercado Libre aíslan por completo su interfaz gráfica de sus reglas operativas para garantizar la estabilidad del sistema. 

El objetivo de esta práctica es construir "EcoMarket App", un minisistema móvil de catálogo ecológico y monitoreo satelital en tiempo real, aplicando de forma estricta los estándares industriales de Clean Architecture, programación asíncrona, control de nulabilidad y el patrón de diseño Observer.
Los productos ecológicos que vendería son principalmente alimentos frescos y productos agrícolas de origen verificable,


ORGANIZACIÓN Y ROLES DEL EQUIPO (4 INTEGRANTES)
El proyecto se desarrollará en células de ingeniería de 4 personas. Cada integrante asumirá una responsabilidad técnica específica en el código fuente. Queda prohibido mezclar el código de las capas.

* ROL 1: Líder de Arquitectura y Datos (Domain/Data Specialist)
Responsable de estructurar los paquetes físicos del software, implementar las entidades inmutables, aserciones de desarrollo (assert), getters/setters computados y la lógica central de persistencia temporal en RAM del ChangeNotifier.

Acciones de desarrollo:
    - Inicializa las carpetas estructurales lib/data/, lib/domain/ y lib/presentation/.
    - Escribe la entidad "Producto" en el dominio, blindando el constructor contra valores negativos utilizando la lista de inicialización y aserciones.

Resultado esperado:
    Proyecto estructurado de forma rigurosa en capas (data, domain, presentation). Lógica y píxeles completamente aislados.

* ROL 2: Diseñador de UI Responsiva (Sliver & Grid Specialist)
Responsable de maquetar la vista principal unificada utilizando CustomScrollView, SliverAppBar colapsable, SliverGrid eficientes bajo demanda y el widget elástico Wrap para inmunizar la pantalla contra desbordamientos geométricos (Overflows).

Acciones de desarrollo:
    - Levanta el andamiaje básico de la pantalla con Scaffold y coloca las etiquetas de categorías superiores empleando el widget Wrap.
    - Diseña el CustomScrollView, la cabecera interactiva SliverAppBar (pinned: true) y la rejilla simétrica SliverGrid con un childAspectRatio matemático de 0.65.

Resultado esperado
    Uso estricto de viewports distribuidos con Slivers y layouts elásticos responsivos (Wrap). Totalmente adaptado a cualquier hardware.

* ROL 3: Especialista en Captura y Validación (UX/Form Specialist)
Responsable de construir la vista de checkout utilizando el widget Form, campos TextFormField blindados con expresiones regulares de validación (validator) y la sincronización transversal mediante el uso de GlobalKey<FormState>.

Acciones de desarrollo
    - Implementa el formulario de checkout (CheckoutView), vinculando la GlobalKey de alta jerarquía para validar los datos e invocar avisos visuales automáticos en rojo.

Resultado esperado:
    -Formulario coordinado por GlobalKey con validaciones en cascada automatizadas y control inmutable de botones en Material 3.

* ROL 4: Ingeniero de Sincronización Asíncrona (Backend/Async Specialist)
Responsable de escribir las mangueras de datos asíncronos simulados empleando promesas Futures (para simular retardos de red) y flujos continuos Streams (para el GPS), integrándolos limpiamente a través de FutureBuilder y StreamBuilder.

Acciones de desarrollo:
    - Escribe el servicio asíncrono con Futures retardados de 1 segundo y Streams de traslado GPS con pausas realistas de 3 segundos por ciclo.

Resultado esperado:
    Integración impecable de Futures/Streams usando Builders dedicados. Interfaz libre al 100% de congelamiento táctil.

* Todo el equipo une las piezas en el CatalogoController. Al confirmar el pago en la pantalla de Checkout, el controlador debe restar las unidades compradas del stock real de las entidades en la RAM y vaciar el carrito reactivamente.

* Se añade un FloatingActionButton para reabastecer el inventario bajo demanda mediante el método notifyListeners() y el widget ListenableBuilder.

