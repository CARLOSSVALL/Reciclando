import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Reciclando'**
  String get appTitle;

  /// No description provided for @appSlogan.
  ///
  /// In es, this message translates to:
  /// **'Comparte, recicla, transforma'**
  String get appSlogan;

  /// No description provided for @appFooter.
  ///
  /// In es, this message translates to:
  /// **'Haz del mundo un lugar más verde'**
  String get appFooter;

  /// No description provided for @loginTitle.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get loginTitle;

  /// No description provided for @registerTitle.
  ///
  /// In es, this message translates to:
  /// **'Crear Cuenta'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Únete a la comunidad Reciclando'**
  String get registerSubtitle;

  /// No description provided for @emailHint.
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get passwordHint;

  /// No description provided for @nameHint.
  ///
  /// In es, this message translates to:
  /// **'Nombre de usuario'**
  String get nameHint;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In es, this message translates to:
  /// **'Confirmar contraseña'**
  String get confirmPasswordHint;

  /// No description provided for @loginButton.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In es, this message translates to:
  /// **'Crear Cuenta'**
  String get registerButton;

  /// No description provided for @registeringButton.
  ///
  /// In es, this message translates to:
  /// **'Registrando...'**
  String get registeringButton;

  /// No description provided for @loginError.
  ///
  /// In es, this message translates to:
  /// **'Error al iniciar sesión'**
  String get loginError;

  /// No description provided for @registerError.
  ///
  /// In es, this message translates to:
  /// **'Error al registrar'**
  String get registerError;

  /// No description provided for @welcomeMessage.
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenido a Reciclando!'**
  String get welcomeMessage;

  /// No description provided for @noInternet.
  ///
  /// In es, this message translates to:
  /// **'No hay conexión a internet'**
  String get noInternet;

  /// No description provided for @serverError.
  ///
  /// In es, this message translates to:
  /// **'Error crítico al conectar con el servidor'**
  String get serverError;

  /// No description provided for @requiredField.
  ///
  /// In es, this message translates to:
  /// **'Este campo es obligatorio'**
  String get requiredField;

  /// No description provided for @enterEmail.
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu contraseña'**
  String get enterPassword;

  /// No description provided for @enterName.
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu nombre'**
  String get enterName;

  /// No description provided for @enterNewPassword.
  ///
  /// In es, this message translates to:
  /// **'Ingresa una contraseña'**
  String get enterNewPassword;

  /// No description provided for @confirmYourPassword.
  ///
  /// In es, this message translates to:
  /// **'Confirma tu contraseña'**
  String get confirmYourPassword;

  /// No description provided for @minPasswordLength.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 6 caracteres'**
  String get minPasswordLength;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get passwordsDoNotMatch;

  /// No description provided for @back.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get back;

  /// No description provided for @homeTitle.
  ///
  /// In es, this message translates to:
  /// **'Reciclando'**
  String get homeTitle;

  /// No description provided for @loadingMap.
  ///
  /// In es, this message translates to:
  /// **'Cargando mapa...'**
  String get loadingMap;

  /// No description provided for @waitingLocation.
  ///
  /// In es, this message translates to:
  /// **'Esperando ubicación...'**
  String get waitingLocation;

  /// No description provided for @newMarkerButton.
  ///
  /// In es, this message translates to:
  /// **'Nuevo marcador'**
  String get newMarkerButton;

  /// No description provided for @filterAll.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get filterAll;

  /// No description provided for @menuProfile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get menuProfile;

  /// No description provided for @menuPublications.
  ///
  /// In es, this message translates to:
  /// **'Publicaciones'**
  String get menuPublications;

  /// No description provided for @menuNotifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get menuNotifications;

  /// No description provided for @menuViewAsList.
  ///
  /// In es, this message translates to:
  /// **'Ver como Lista'**
  String get menuViewAsList;

  /// No description provided for @menuChangeTheme.
  ///
  /// In es, this message translates to:
  /// **'Cambiar tema'**
  String get menuChangeTheme;

  /// No description provided for @menuLogout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get menuLogout;

  /// No description provided for @locationRequiredTitle.
  ///
  /// In es, this message translates to:
  /// **'Se requiere Ubicación'**
  String get locationRequiredTitle;

  /// No description provided for @locationRequiredBody.
  ///
  /// In es, this message translates to:
  /// **'Para encontrar puntos de reciclaje cerca de ti y poder crear nuevos marcadores, necesitamos acceso a tu ubicación.\n\nPor favor, enciende el GPS o concede los permisos necesarios.'**
  String get locationRequiredBody;

  /// No description provided for @locationLater.
  ///
  /// In es, this message translates to:
  /// **'En otro momento'**
  String get locationLater;

  /// No description provided for @locationGoToSettings.
  ///
  /// In es, this message translates to:
  /// **'Ir a Ajustes'**
  String get locationGoToSettings;

  /// No description provided for @collectedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Has recogido el producto. Se ha notificado a {ownerName}.'**
  String collectedSuccess(String ownerName);

  /// No description provided for @collectError.
  ///
  /// In es, this message translates to:
  /// **'Error al recoger el objeto'**
  String get collectError;

  /// No description provided for @createMarkerTitle.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Marcador'**
  String get createMarkerTitle;

  /// No description provided for @createMarkerTypeQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Qué quieres reciclar?'**
  String get createMarkerTypeQuestion;

  /// No description provided for @createMarkerDescription.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get createMarkerDescription;

  /// No description provided for @createMarkerDescriptionHint.
  ///
  /// In es, this message translates to:
  /// **'Describe brevemente el objeto...'**
  String get createMarkerDescriptionHint;

  /// No description provided for @createMarkerDescriptionRequired.
  ///
  /// In es, this message translates to:
  /// **'Por favor, añade una descripción'**
  String get createMarkerDescriptionRequired;

  /// No description provided for @createMarkerPhoto.
  ///
  /// In es, this message translates to:
  /// **'Foto del objeto'**
  String get createMarkerPhoto;

  /// No description provided for @createMarkerPhotoRequired.
  ///
  /// In es, this message translates to:
  /// **'Por favor, añade una foto del objeto'**
  String get createMarkerPhotoRequired;

  /// No description provided for @createMarkerTapToAdd.
  ///
  /// In es, this message translates to:
  /// **'Toca para añadir foto'**
  String get createMarkerTapToAdd;

  /// No description provided for @createMarkerCameraOrGallery.
  ///
  /// In es, this message translates to:
  /// **'Cámara o Galería'**
  String get createMarkerCameraOrGallery;

  /// No description provided for @createMarkerLocation.
  ///
  /// In es, this message translates to:
  /// **'Ubicación: {lat}, {lng}'**
  String createMarkerLocation(String lat, String lng);

  /// No description provided for @createMarkerUploading.
  ///
  /// In es, this message translates to:
  /// **'Subiendo... {percent}%'**
  String createMarkerUploading(int percent);

  /// No description provided for @createMarkerSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar Marcador'**
  String get createMarkerSave;

  /// No description provided for @createMarkerSaving.
  ///
  /// In es, this message translates to:
  /// **'Subiendo...'**
  String get createMarkerSaving;

  /// No description provided for @createMarkerSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Marcador creado con éxito! 🎉'**
  String get createMarkerSuccess;

  /// No description provided for @createMarkerError.
  ///
  /// In es, this message translates to:
  /// **'Error al crear el marcador. Inténtalo de nuevo.'**
  String get createMarkerError;

  /// No description provided for @cameraError.
  ///
  /// In es, this message translates to:
  /// **'Error al acceder a la cámara/galería'**
  String get cameraError;

  /// No description provided for @camera.
  ///
  /// In es, this message translates to:
  /// **'Cámara'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In es, this message translates to:
  /// **'Galería'**
  String get gallery;

  /// No description provided for @changePhoto.
  ///
  /// In es, this message translates to:
  /// **'Cambiar foto'**
  String get changePhoto;

  /// No description provided for @notificationsTitle.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notificationsTitle;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In es, this message translates to:
  /// **'Leer todo'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsEmpty.
  ///
  /// In es, this message translates to:
  /// **'No tienes notificaciones'**
  String get notificationsEmpty;

  /// No description provided for @notificationsEmptyHint.
  ///
  /// In es, this message translates to:
  /// **'Cuando alguien recoja tus objetos,\nte avisaremos aquí.'**
  String get notificationsEmptyHint;

  /// No description provided for @profileTitle.
  ///
  /// In es, this message translates to:
  /// **'Mi Perfil'**
  String get profileTitle;

  /// No description provided for @profileName.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get profileName;

  /// No description provided for @profileEmail.
  ///
  /// In es, this message translates to:
  /// **'Correo Electrónico'**
  String get profileEmail;

  /// No description provided for @profileEmailNote.
  ///
  /// In es, this message translates to:
  /// **'* El correo electrónico no se puede modificar por razones de seguridad.'**
  String get profileEmailNote;

  /// No description provided for @profileSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar Cambios'**
  String get profileSave;

  /// No description provided for @profileNameEmpty.
  ///
  /// In es, this message translates to:
  /// **'El nombre no puede estar vacío'**
  String get profileNameEmpty;

  /// No description provided for @profilePhone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get profilePhone;

  /// No description provided for @profileChangePassword.
  ///
  /// In es, this message translates to:
  /// **'Cambiar Contraseña'**
  String get profileChangePassword;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Cuenta'**
  String get profileDeleteAccount;

  /// No description provided for @profileCurrentPassword.
  ///
  /// In es, this message translates to:
  /// **'Contraseña Actual'**
  String get profileCurrentPassword;

  /// No description provided for @profileNewPassword.
  ///
  /// In es, this message translates to:
  /// **'Nueva Contraseña'**
  String get profileNewPassword;

  /// No description provided for @profileChangePasswordTitle.
  ///
  /// In es, this message translates to:
  /// **'Cambiar Contraseña'**
  String get profileChangePasswordTitle;

  /// No description provided for @profileChangeButton.
  ///
  /// In es, this message translates to:
  /// **'Cambiar'**
  String get profileChangeButton;

  /// No description provided for @profileDeleteTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Cuenta'**
  String get profileDeleteTitle;

  /// No description provided for @profileDeleteBody.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer y eliminará todos tus marcadores.'**
  String get profileDeleteBody;

  /// No description provided for @markerListTitle.
  ///
  /// In es, this message translates to:
  /// **'Lista de Objetos'**
  String get markerListTitle;

  /// No description provided for @markerListError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar la lista de objetos.'**
  String get markerListError;

  /// No description provided for @markerListEmpty.
  ///
  /// In es, this message translates to:
  /// **'No hay objetos registrados todavía.'**
  String get markerListEmpty;

  /// No description provided for @myPublicationsTitle.
  ///
  /// In es, this message translates to:
  /// **'Mis Publicaciones'**
  String get myPublicationsTitle;

  /// No description provided for @myPublicationsEmpty.
  ///
  /// In es, this message translates to:
  /// **'Aún no has creado publicaciones.'**
  String get myPublicationsEmpty;

  /// No description provided for @myPublicationsDeleteTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar publicación'**
  String get myPublicationsDeleteTitle;

  /// No description provided for @myPublicationsDeleteBody.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que deseas eliminar esta publicación permanentemente?'**
  String get myPublicationsDeleteBody;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @deleteSuccess.
  ///
  /// In es, this message translates to:
  /// **'Publicación eliminada correctamente'**
  String get deleteSuccess;

  /// No description provided for @deleteError.
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar la publicación'**
  String get deleteError;

  /// No description provided for @categoryClothing.
  ///
  /// In es, this message translates to:
  /// **'Ropa'**
  String get categoryClothing;

  /// No description provided for @categoryGlass.
  ///
  /// In es, this message translates to:
  /// **'Vidrio'**
  String get categoryGlass;

  /// No description provided for @categoryPaper.
  ///
  /// In es, this message translates to:
  /// **'Papel'**
  String get categoryPaper;

  /// No description provided for @categoryToys.
  ///
  /// In es, this message translates to:
  /// **'Juguetes'**
  String get categoryToys;

  /// No description provided for @categoryElectronics.
  ///
  /// In es, this message translates to:
  /// **'Electrónica'**
  String get categoryElectronics;

  /// No description provided for @categoryFurniture.
  ///
  /// In es, this message translates to:
  /// **'Muebles'**
  String get categoryFurniture;

  /// No description provided for @categoryFood.
  ///
  /// In es, this message translates to:
  /// **'Alimentos'**
  String get categoryFood;

  /// No description provided for @categoryOther.
  ///
  /// In es, this message translates to:
  /// **'Otros'**
  String get categoryOther;

  /// No description provided for @detailDescription.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get detailDescription;

  /// No description provided for @detailNoDescription.
  ///
  /// In es, this message translates to:
  /// **'Sin descripción'**
  String get detailNoDescription;

  /// No description provided for @detailPublishedBy.
  ///
  /// In es, this message translates to:
  /// **'Publicado por'**
  String get detailPublishedBy;

  /// No description provided for @detailEmail.
  ///
  /// In es, this message translates to:
  /// **'Correo'**
  String get detailEmail;

  /// No description provided for @detailDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get detailDate;

  /// No description provided for @detailCoordinates.
  ///
  /// In es, this message translates to:
  /// **'Coordenadas'**
  String get detailCoordinates;

  /// No description provided for @detailCalculatingDistance.
  ///
  /// In es, this message translates to:
  /// **'Calculando distancia...'**
  String get detailCalculatingDistance;

  /// No description provided for @detailCollect.
  ///
  /// In es, this message translates to:
  /// **'Recoger producto'**
  String get detailCollect;

  /// No description provided for @detailTooFar.
  ///
  /// In es, this message translates to:
  /// **'Demasiado lejos para recoger'**
  String get detailTooFar;

  /// No description provided for @bottomSheetViewDetails.
  ///
  /// In es, this message translates to:
  /// **'Ver detalles'**
  String get bottomSheetViewDetails;

  /// No description provided for @bottomSheetCollect.
  ///
  /// In es, this message translates to:
  /// **'Recoger'**
  String get bottomSheetCollect;

  /// No description provided for @bottomSheetTooFar.
  ///
  /// In es, this message translates to:
  /// **'Muy lejos'**
  String get bottomSheetTooFar;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
