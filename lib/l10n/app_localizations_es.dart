// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Reciclando';

  @override
  String get appSlogan => 'Comparte, recicla, transforma';

  @override
  String get appFooter => 'Haz del mundo un lugar más verde';

  @override
  String get loginTitle => 'Iniciar Sesión';

  @override
  String get registerTitle => 'Crear Cuenta';

  @override
  String get registerSubtitle => 'Únete a la comunidad Reciclando';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Contraseña';

  @override
  String get nameHint => 'Nombre de usuario';

  @override
  String get confirmPasswordHint => 'Confirmar contraseña';

  @override
  String get loginButton => 'Iniciar Sesión';

  @override
  String get registerButton => 'Crear Cuenta';

  @override
  String get registeringButton => 'Registrando...';

  @override
  String get loginError => 'Error al iniciar sesión';

  @override
  String get registerError => 'Error al registrar';

  @override
  String get welcomeMessage => '¡Bienvenido a Reciclando!';

  @override
  String get noInternet => 'No hay conexión a internet';

  @override
  String get serverError => 'Error crítico al conectar con el servidor';

  @override
  String get requiredField => 'Este campo es obligatorio';

  @override
  String get enterEmail => 'Ingresa tu email';

  @override
  String get enterPassword => 'Ingresa tu contraseña';

  @override
  String get enterName => 'Ingresa tu nombre';

  @override
  String get enterNewPassword => 'Ingresa una contraseña';

  @override
  String get confirmYourPassword => 'Confirma tu contraseña';

  @override
  String get minPasswordLength => 'Mínimo 6 caracteres';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get back => 'Volver';

  @override
  String get homeTitle => 'Reciclando';

  @override
  String get loadingMap => 'Cargando mapa...';

  @override
  String get waitingLocation => 'Esperando ubicación...';

  @override
  String get newMarkerButton => 'Nuevo marcador';

  @override
  String get filterAll => 'Todos';

  @override
  String get menuProfile => 'Perfil';

  @override
  String get menuPublications => 'Publicaciones';

  @override
  String get menuNotifications => 'Notificaciones';

  @override
  String get menuViewAsList => 'Ver como Lista';

  @override
  String get menuChangeTheme => 'Cambiar tema';

  @override
  String get menuLogout => 'Cerrar sesión';

  @override
  String get locationRequiredTitle => 'Se requiere Ubicación';

  @override
  String get locationRequiredBody =>
      'Para encontrar puntos de reciclaje cerca de ti y poder crear nuevos marcadores, necesitamos acceso a tu ubicación.\n\nPor favor, enciende el GPS o concede los permisos necesarios.';

  @override
  String get locationLater => 'En otro momento';

  @override
  String get locationGoToSettings => 'Ir a Ajustes';

  @override
  String collectedSuccess(String ownerName) {
    return 'Has recogido el producto. Se ha notificado a $ownerName.';
  }

  @override
  String get collectError => 'Error al recoger el objeto';

  @override
  String get createMarkerTitle => 'Nuevo Marcador';

  @override
  String get createMarkerTypeQuestion => '¿Qué quieres reciclar?';

  @override
  String get createMarkerDescription => 'Descripción';

  @override
  String get createMarkerDescriptionHint => 'Describe brevemente el objeto...';

  @override
  String get createMarkerDescriptionRequired =>
      'Por favor, añade una descripción';

  @override
  String get createMarkerPhoto => 'Foto del objeto';

  @override
  String get createMarkerPhotoRequired =>
      'Por favor, añade una foto del objeto';

  @override
  String get createMarkerTapToAdd => 'Toca para añadir foto';

  @override
  String get createMarkerCameraOrGallery => 'Cámara o Galería';

  @override
  String createMarkerLocation(String lat, String lng) {
    return 'Ubicación: $lat, $lng';
  }

  @override
  String createMarkerUploading(int percent) {
    return 'Subiendo... $percent%';
  }

  @override
  String get createMarkerSave => 'Guardar Marcador';

  @override
  String get createMarkerSaving => 'Subiendo...';

  @override
  String get createMarkerSuccess => '¡Marcador creado con éxito! 🎉';

  @override
  String get createMarkerError =>
      'Error al crear el marcador. Inténtalo de nuevo.';

  @override
  String get cameraError => 'Error al acceder a la cámara/galería';

  @override
  String get camera => 'Cámara';

  @override
  String get gallery => 'Galería';

  @override
  String get changePhoto => 'Cambiar foto';

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get notificationsMarkAllRead => 'Leer todo';

  @override
  String get notificationsEmpty => 'No tienes notificaciones';

  @override
  String get notificationsEmptyHint =>
      'Cuando alguien recoja tus objetos,\nte avisaremos aquí.';

  @override
  String get profileTitle => 'Mi Perfil';

  @override
  String get profileName => 'Nombre';

  @override
  String get profileEmail => 'Correo Electrónico';

  @override
  String get profileEmailNote =>
      '* El correo electrónico no se puede modificar por razones de seguridad.';

  @override
  String get profileSave => 'Guardar Cambios';

  @override
  String get profileNameEmpty => 'El nombre no puede estar vacío';

  @override
  String get profilePhone => 'Teléfono';

  @override
  String get profileChangePassword => 'Cambiar Contraseña';

  @override
  String get profileDeleteAccount => 'Eliminar Cuenta';

  @override
  String get profileCurrentPassword => 'Contraseña Actual';

  @override
  String get profileNewPassword => 'Nueva Contraseña';

  @override
  String get profileChangePasswordTitle => 'Cambiar Contraseña';

  @override
  String get profileChangeButton => 'Cambiar';

  @override
  String get profileDeleteTitle => 'Eliminar Cuenta';

  @override
  String get profileDeleteBody =>
      '¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer y eliminará todos tus marcadores.';

  @override
  String get markerListTitle => 'Lista de Objetos';

  @override
  String get markerListError => 'Error al cargar la lista de objetos.';

  @override
  String get markerListEmpty => 'No hay objetos registrados todavía.';

  @override
  String get myPublicationsTitle => 'Mis Publicaciones';

  @override
  String get myPublicationsEmpty => 'Aún no has creado publicaciones.';

  @override
  String get myPublicationsDeleteTitle => 'Eliminar publicación';

  @override
  String get myPublicationsDeleteBody =>
      '¿Estás seguro de que deseas eliminar esta publicación permanentemente?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteSuccess => 'Publicación eliminada correctamente';

  @override
  String get deleteError => 'Error al eliminar la publicación';

  @override
  String get categoryClothing => 'Ropa';

  @override
  String get categoryGlass => 'Vidrio';

  @override
  String get categoryPaper => 'Papel';

  @override
  String get categoryToys => 'Juguetes';

  @override
  String get categoryElectronics => 'Electrónica';

  @override
  String get categoryFurniture => 'Muebles';

  @override
  String get categoryFood => 'Alimentos';

  @override
  String get categoryOther => 'Otros';

  @override
  String get detailDescription => 'Descripción';

  @override
  String get detailNoDescription => 'Sin descripción';

  @override
  String get detailPublishedBy => 'Publicado por';

  @override
  String get detailEmail => 'Correo';

  @override
  String get detailDate => 'Fecha';

  @override
  String get detailCoordinates => 'Coordenadas';

  @override
  String get detailCalculatingDistance => 'Calculando distancia...';

  @override
  String get detailCollect => 'Recoger producto';

  @override
  String get detailTooFar => 'Demasiado lejos para recoger';

  @override
  String get bottomSheetViewDetails => 'Ver detalles';

  @override
  String get bottomSheetCollect => 'Recoger';

  @override
  String get bottomSheetTooFar => 'Muy lejos';
}
