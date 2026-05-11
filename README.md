# 🌿 Reciclando - Frontend (Flutter)

**Reciclando** es una innovadora aplicación multiplataforma (Android, iOS y Web) escrita en Flutter, cuyo objetivo fundamental es incentivar y facilitar el intercambio, reciclaje y reutilización de elementos cotidianos (muebles, electrónica, ropa, vidrio, etc). 

A través de un sistema inmersivo de cartografía (Google Maps) con geolocalización en tiempo real y soporte avanzado multimedia, cualquier usuario puede crear un punto o marca compartiendo lo que desea dar de acceso al mundo, y el ecosistema completo se actualiza e informa al resto de vecinos interesados.

## ⚙️ Entornos y Configuración (.env)

La arquitectura de endpoints que conecta Flutter al BackEnd Node.js MySQL se encuentra completamente abstraída usando el paquete `flutter_dotenv`.
Existen dos entornos configurados:
- `.env` (Producción)
- `.env.dev` (Desarrollo)

Ambos archivos constan de variables como `API_BASE_URL` o `LOG_LEVEL`. El entorno de compilación inyectará la constante correcta según estemos en Producción o Debug.

## 📚 Estructura y Arquitectura (Clean Code)
Nuestra aplicación cumple la premisa SOLID bajo un encapsulamiento jerárquico impecable:
*   `lib/pantallas/`: Almacena la visualización final renderizada mediante Widgets de Material Design.
*   `lib/servicios/`: Servicios asíncronos independientes, integradores de API y lógica abstracta (como Network Service).
*   `lib/componentes/`: Librería visual genérica para widgets reutilizables bajo principios DRY (Don't Repeat Yourself).
*   `lib/modelos/`: Data clases e inmutabilidad estricta.
*   `lib/nucleo/`: Core global (logging configurado usando el paquete `logger`, configuraciones, utilidades, y configuradores de entorno).
*   `lib/Implementaciones/`: Implementación de Features específicas (Auth) segmentadas en subcapas (Clean Architecture).

## 🌍 Internacionalización (i18n)
La app cuenta con **soporte multilingüe** mediante `flutter_localizations`. Toda la lógica de idioma se abstrae bajo archivos `.arb` estructurados (ej. `app_es.arb` y `app_en.arb`) permitiendo cubrir etiquetas, menús y traducciones al 100%.

## 🚀 Instrucciones de Instalación
Para poner en marcha en modo Developers:
1. Asegúrate de tener instalado el SDk de Flutter (`flutter sdk: ^3.4.0`).
2. Descarga este repositorio.
3. Clona el proyecto de backend asociado e inícialo (asegurándote de que `API_BASE_URL` en `.env.dev` apunte correctamente).
4. Configura y crea en la raíz del proyecto los archivos de entorno `.env` y `.env.dev`.
5. En la raíz de este proyecto ejecuta la obtención de dependencias y generación de internacionalización:
   ```bash
   flutter pub get
   flutter gen-l10n
   ```
6. Puedes correr el aplicativo en un emulador o navegador (Chrome):
   ```bash
   flutter run -d chrome
   ```

---

## 🔒 Auditoría de Seguridad & Privacy Graves
- **Secure Storage**: El JWT Token y manejo de estado sensible persistente se encuentra totalmente blindado a nivel binario mediante `flutter_secure_storage`.
- **Privacidad**: Nunca se envían las contraseñas ni datos sensibles de usuario sobre redes Log. Todo uso de Logs es estrictamente inyectado y filtrado.
- **Auditorías de Red**: Validaciones de Crash por Timeout y red caida gestionadas amigablemente en interfaces. Se previene la ejecución de consultas con comprobación proactiva (`connectivity_plus`).

> *Referencia: Documento de Validación PMDM adjunto en la raíz del repositorio (`VALIDACION_PMDM.md`) para más detalles.*
