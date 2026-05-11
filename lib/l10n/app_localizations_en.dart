// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Reciclando';

  @override
  String get appSlogan => 'Share, recycle, transform';

  @override
  String get appFooter => 'Make the world a greener place';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerSubtitle => 'Join the Reciclando community';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Password';

  @override
  String get nameHint => 'Username';

  @override
  String get confirmPasswordHint => 'Confirm password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get registerButton => 'Create Account';

  @override
  String get registeringButton => 'Registering...';

  @override
  String get loginError => 'Login failed';

  @override
  String get registerError => 'Registration failed';

  @override
  String get welcomeMessage => 'Welcome to Reciclando!';

  @override
  String get noInternet => 'No internet connection';

  @override
  String get serverError => 'Critical server error';

  @override
  String get requiredField => 'This field is required';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get enterName => 'Enter your name';

  @override
  String get enterNewPassword => 'Enter a password';

  @override
  String get confirmYourPassword => 'Confirm your password';

  @override
  String get minPasswordLength => 'Minimum 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get back => 'Back';

  @override
  String get homeTitle => 'Reciclando';

  @override
  String get loadingMap => 'Loading map...';

  @override
  String get waitingLocation => 'Waiting for location...';

  @override
  String get newMarkerButton => 'New marker';

  @override
  String get filterAll => 'All';

  @override
  String get menuProfile => 'Profile';

  @override
  String get menuPublications => 'Publications';

  @override
  String get menuNotifications => 'Notifications';

  @override
  String get menuViewAsList => 'View as List';

  @override
  String get menuChangeTheme => 'Change theme';

  @override
  String get menuLogout => 'Sign out';

  @override
  String get locationRequiredTitle => 'Location Required';

  @override
  String get locationRequiredBody =>
      'To find recycling points near you and create new markers, we need access to your location.\n\nPlease enable GPS or grant the necessary permissions.';

  @override
  String get locationLater => 'Later';

  @override
  String get locationGoToSettings => 'Go to Settings';

  @override
  String collectedSuccess(String ownerName) {
    return 'You picked up the item. $ownerName has been notified.';
  }

  @override
  String get collectError => 'Error picking up the item';

  @override
  String get createMarkerTitle => 'New Marker';

  @override
  String get createMarkerTypeQuestion => 'What do you want to recycle?';

  @override
  String get createMarkerDescription => 'Description';

  @override
  String get createMarkerDescriptionHint => 'Briefly describe the item...';

  @override
  String get createMarkerDescriptionRequired => 'Please add a description';

  @override
  String get createMarkerPhoto => 'Item photo';

  @override
  String get createMarkerPhotoRequired => 'Please add a photo of the item';

  @override
  String get createMarkerTapToAdd => 'Tap to add photo';

  @override
  String get createMarkerCameraOrGallery => 'Camera or Gallery';

  @override
  String createMarkerLocation(String lat, String lng) {
    return 'Location: $lat, $lng';
  }

  @override
  String createMarkerUploading(int percent) {
    return 'Uploading... $percent%';
  }

  @override
  String get createMarkerSave => 'Save Marker';

  @override
  String get createMarkerSaving => 'Uploading...';

  @override
  String get createMarkerSuccess => 'Marker created successfully! 🎉';

  @override
  String get createMarkerError =>
      'Error creating the marker. Please try again.';

  @override
  String get cameraError => 'Error accessing camera/gallery';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsMarkAllRead => 'Mark all read';

  @override
  String get notificationsEmpty => 'No notifications yet';

  @override
  String get notificationsEmptyHint =>
      'When someone picks up your items,\nwe\'ll notify you here.';

  @override
  String get profileTitle => 'My Profile';

  @override
  String get profileName => 'Name';

  @override
  String get profileEmail => 'Email Address';

  @override
  String get profileEmailNote =>
      '* Email address cannot be changed for security reasons.';

  @override
  String get profileSave => 'Save Changes';

  @override
  String get profileNameEmpty => 'Name cannot be empty';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profileChangePassword => 'Change Password';

  @override
  String get profileDeleteAccount => 'Delete Account';

  @override
  String get profileCurrentPassword => 'Current Password';

  @override
  String get profileNewPassword => 'New Password';

  @override
  String get profileChangePasswordTitle => 'Change Password';

  @override
  String get profileChangeButton => 'Change';

  @override
  String get profileDeleteTitle => 'Delete Account';

  @override
  String get profileDeleteBody =>
      'Are you sure you want to delete your account? This action cannot be undone and will delete all your markers.';

  @override
  String get markerListTitle => 'Items List';

  @override
  String get markerListError => 'Error loading the items list.';

  @override
  String get markerListEmpty => 'No items registered yet.';

  @override
  String get myPublicationsTitle => 'My Publications';

  @override
  String get myPublicationsEmpty =>
      'You haven\'t created any publications yet.';

  @override
  String get myPublicationsDeleteTitle => 'Delete publication';

  @override
  String get myPublicationsDeleteBody =>
      'Are you sure you want to permanently delete this publication?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get deleteSuccess => 'Publication deleted successfully';

  @override
  String get deleteError => 'Error deleting the publication';

  @override
  String get categoryClothing => 'Clothing';

  @override
  String get categoryGlass => 'Glass';

  @override
  String get categoryPaper => 'Paper';

  @override
  String get categoryToys => 'Toys';

  @override
  String get categoryElectronics => 'Electronics';

  @override
  String get categoryFurniture => 'Furniture';

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryOther => 'Other';

  @override
  String get detailDescription => 'Description';

  @override
  String get detailNoDescription => 'No description';

  @override
  String get detailPublishedBy => 'Published by';

  @override
  String get detailEmail => 'Email';

  @override
  String get detailDate => 'Date';

  @override
  String get detailCoordinates => 'Coordinates';

  @override
  String get detailCalculatingDistance => 'Calculating distance...';

  @override
  String get detailCollect => 'Pick up item';

  @override
  String get detailTooFar => 'Too far to pick up';

  @override
  String get bottomSheetViewDetails => 'View details';

  @override
  String get bottomSheetCollect => 'Pick up';

  @override
  String get bottomSheetTooFar => 'Too far';
}
