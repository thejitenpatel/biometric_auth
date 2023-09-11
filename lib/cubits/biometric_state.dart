abstract class BiometricState {}

class BiometricInitialState extends BiometricState {}

class BiometricSupportedState extends BiometricState {
  final bool isSupported;
  BiometricSupportedState(this.isSupported);
}

class BiometricStatusState extends BiometricState {
  final bool isEnabled;
  BiometricStatusState(this.isEnabled);
}

class BiometricAuthenticatedState extends BiometricState {}

class BiometricErrorState extends BiometricState {
  final String error;
  BiometricErrorState(this.error);
}
