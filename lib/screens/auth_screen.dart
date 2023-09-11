import 'package:biometric_auth/cubits/biometric_cubit.dart';
import 'package:biometric_auth/cubits/biometric_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen>
    with WidgetsBindingObserver {
  bool isBiometricEnabled = false;
  final BiometricCubit biometricCubit = BiometricCubit();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("RESUMED");
      biometricCubit.checkBiometricSupportOnDevice();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("build");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Biometric Authentication"),
      ),
      body: BlocListener<BiometricCubit, BiometricState>(
        listener: (context, state) {
          // if (state is BiometricStatusState) {
          //   setState(() {
          //     isBiometricEnabled = state.isEnabled;
          //   });
          // } else if (state is BiometricAuthenticatedState) {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const MyHomePage(title: 'Authenticated',),
            //   ),
            // );
          // }
        },
        child: Center(
          child: ElevatedButton(
            onPressed: isBiometricEnabled
                ? () {
                    context.read<BiometricCubit>().disableBiometric();
                    // setState(() {});
                  }
                : () {
                    context
                        .read<BiometricCubit>()
                        .checkBiometricSupportOnDevice();
                    // setState(() {});
                  },
            child: Text(
              isBiometricEnabled ? "Disable Biometric" : "Enable Biometric",
            ),
          ),
        ),
      ),
    );
  }
}
