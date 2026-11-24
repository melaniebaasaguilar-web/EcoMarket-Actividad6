# Actividad 5 – EcoMarket (Android)

## Configuración

Se fijaron flutter_local_notifications 23.0.3 y workmanager 0.10.10 para mantener la sintaxis de sus APIs. Se requiere Flutter 3.47 o posterior compatible con Dart ^3.13.0 del proyecto, Android SDK Platform 37 y el JDK compatible con AGP 9.1.1 (Java 17 como mínimo). Se conserva Gradle 9.3.1. La plataforma objetivo es Android porque el ZIP original solo contiene ese host.

En PowerShell, desde la carpeta que contiene pubspec.yaml:

```powershell
flutter doctor -v
flutter pub get
flutter analyze
flutter test
flutter devices
flutter run
```

Si no está instalado Android SDK Platform 37, instálalo en Android Studio > SDK Manager > SDK Platforms. El archivo pubspec.lock original se conserva como base; flutter pub get lo actualizará con los nuevos paquetes. No se ejecutaron Flutter, Gradle ni pruebas en el entorno de edición, que no dispone de Flutter ni Android SDK.

## Demostración

1. Abre EcoMarket en Android y concede el permiso de notificaciones.
2. Añade cualquier producto disponible y abre el carrito. Usa datos ficticios, porque el pago es simulado, por ejemplo: Ana López, ana@example.com, 9991234567, Calle 20 número 100, tarjeta 4111111111111111, vencimiento 12/30, CVV 123.
3. Confirma el pago y verifica que la alerta «¡Compra realizada!» muestra el total real. Comprueba también la pantalla de seguimiento. Si el banner no aparece, revisa que el canal Confirmación de Pedidos tenga alertas emergentes habilitadas y que No molestar esté desactivado.
4. El registro de Workmanager es periódico (15 minutos), con red conectada. Android decide el momento real; no se garantiza una ejecución exacta cada 15 minutos. La tarea consulta el catálogo local con latencia simulada en un isolate separado: no afirma sincronizar con un servidor ni modificar el stock del isolate principal. El mensaje de diagnóstico se puede buscar con adb logcat.
5. Genera y localiza el APK:

```powershell
flutter build apk --release
explorer .\build\app\outputs\flutter-apk
```

El APK se generará solo si la compilación termina correctamente. Se conserva la firma debug del proyecto original para la práctica; no es una firma de distribución comercial.

## GitFlow

El ZIP no contiene .git. Para conservar el historial, usa tu clon original, con los cambios locales protegidos y la rama develop disponible. Crea la rama antes de aplicar el parche adjunto desde el chat:

```powershell
git status
git switch develop
git switch -c feature/notificaciones-release
git apply --check "C:\ruta\EcoMarket-Actividad5.patch"
git apply "C:\ruta\EcoMarket-Actividad5.patch"
flutter pub get
flutter analyze
flutter test
flutter build apk --release
git add .
git commit -m "feat: integrar notificaciones locales, workmanager y compilacion release"
git push -u origin feature/notificaciones-release
```

Si el parche no aplica, no lo fuerces: probablemente develop difiere del ZIP. Revisa los archivos modificados y adapta los cambios.

## Defensa oral

- `@pragma('vm:entry-point')`: conserva el punto de entrada de Workmanager durante la optimización AOT.
- Main Isolate: ejecuta la UI; Workmanager usa otro isolate sin compartir directamente la memoria del primero.
- AOT: compilación anticipada a código máquina, usada por el APK Release.
- `Importance.max` y `Priority.high`: configuran la importancia del canal y prioridad de la alerta. El sistema y la configuración del usuario determinan si aparece como Heads-up.
- La notificación se ejecuta tras un pago válido y la confirmación del stock. Si la notificación falla, no se revierte el pago ni se presenta un mensaje de fallo de cobro por ese motivo.
