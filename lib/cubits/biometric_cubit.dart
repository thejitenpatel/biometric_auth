import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import '../services/biometric_service.dart';
import '../storage/local_storage_manager.dart';
import 'biometric_state.dart';

class BiometricCubit extends Cubit<BiometricState> {
  // bool isEnabled = false;

  final BiometricService biometricService = BiometricService(
      auth: LocalAuthentication(), storageManager: LocalStorageManager());

  BiometricCubit() : super(BiometricInitialState());

  void enableBiometric() async {
    try {
      await biometricService.setBiometricStatus(isEnabled: true);
      emit(BiometricStatusState(
          true)); // Update the state to indicate biometrics is enabled
    } catch (e) {
      emit(BiometricErrorState("$e"));
    }
  }

  void disableBiometric() async {
    try {
      await biometricService.setBiometricStatus(isEnabled: false);
      emit(BiometricStatusState(
          false)); // Update the state to indicate biometrics is disabled
    } catch (e) {
      emit(BiometricErrorState("$e"));
    }
  }

  Future<void> checkBiometricsAvailability() async {
    try {
      final checkBiometrics = await biometricService.checkBiometrics();
      if (checkBiometrics) {
        await authenticateUser();
      } else {
        emit(BiometricErrorState("ERROR WHILE AUTHENTICATING"));
      }
    } catch (e) {
      emit(BiometricErrorState("$e"));
    }
  }

  Future<void> authenticateUser() async {
    try {
      await biometricService.authenticate();
      // isEnabled = true;
      // emit(BiometricStatusState(isEnabled));
      emit(BiometricAuthenticatedState());
    } catch (e) {
      emit(BiometricErrorState("$e"));
    }
  }

  void checkBiometricSupportOnDevice() async {
    try {
      if (await biometricService.isDeviceSupported()) {
        await checkBiometricsAvailability();
      }
    } catch (e) {
      emit(BiometricErrorState("$e"));
    }
  }

  void checkBiometricSupport() async {
    try {
      final isSupported = await biometricService.isDeviceSupported();
      emit(BiometricSupportedState(isSupported));
      emit(BiometricStatusState(isSupported));
    } catch (e) {
      emit(BiometricErrorState("Error checking biometric support"));
    }
  }

  void loadBiometricStatus() async {
    try {
      final isEnabled = await biometricService.getBiometricStatus();
      emit(BiometricStatusState(isEnabled));
    } catch (e) {
      emit(BiometricErrorState("Error loading biometric support"));
    }
  }

  // void toggleBiometric(bool newValue) async {
  //   try {
  //     await biometricService.authenticate();
  //     emit(BiometricAuthenticatedState());
  //   } catch (e) {
  //     emit(BiometricErrorState("Error authenticating with biometrics"));
  //   }
  // }
}
