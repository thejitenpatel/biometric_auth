import 'package:biometric_auth/storage/local_storage_manager.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class BiometricService {
  final LocalAuthentication _authentication;
  final LocalStorageManager _storageManager;

  static const String biometricStatusKey = "isBiometricEnabled";

  BiometricService({
    required LocalAuthentication auth,
    required LocalStorageManager storageManager,
  })  : _authentication = auth,
        _storageManager = storageManager;

  Future<bool> isDeviceSupported() async {
    try {
      return await _authentication.isDeviceSupported();
    } on PlatformException catch (e) {
      _handleAuthError(e);
      return false;
    }
  }

  Future<bool> checkBiometrics() async {
    try {
      bool canCheckBiometrics = await _authentication.canCheckBiometrics;
      List<BiometricType> availableBiometrics =
          await _authentication.getAvailableBiometrics();
      return canCheckBiometrics && availableBiometrics.isNotEmpty;
    } on PlatformException catch (e) {
      _handleAuthError(e);
      return false;
    }
  }

  Future<bool> getBiometricStatus() async {
    return await _storageManager.getData(biometricStatusKey) ?? false;
  }

  Future<void> setBiometricStatus({required bool isEnabled}) async {
    await _storageManager.setData(biometricStatusKey, isEnabled);
  }

  Future<void> authenticate() async {
    try {
      final didAuthenticate = await _authentication.authenticate(
        localizedReason: "Please authenticate",
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );

      if (!await getBiometricStatus()) {
        setBiometricStatus(isEnabled: didAuthenticate);
      }
    } on PlatformException catch (e) {
      _handleAuthError(e);
    }
  }

  void _handleAuthError(PlatformException e) {
    String errorMessage = "Error Unknown";
    if (e.code == auth_error.notAvailable) {
      errorMessage = "Deivce is not supported";
    } else if (e.code == auth_error.notEnrolled) {
      errorMessage = "User has not enrolled any biometrics on the device";
    } else if (e.code == auth_error.lockedOut ||
        e.code == auth_error.permanentlyLockedOut) {
      errorMessage = "The device has been locaked because of too many attempts";
    }
    throw PlatformException(code: e.code, message: errorMessage);
  }
}
