import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'connected_device_controller.dart';

/// A provider that provides the current connection state of the device
final connectionStateNotifierProvider =
    StateNotifierProvider<ConnectionStateNotifier, BluetoothConnectionState?>(
        (ref) {
  final device = ref.watch(connectedDeviceControllerProvider);
  return ConnectionStateNotifier(device);
});

class ConnectionStateNotifier extends StateNotifier<BluetoothConnectionState?> {
  ConnectionStateNotifier(this.device) : super(null) {
    _listen();
  }

  final BluetoothDevice? device;

  void _listen() {
    if (device == null) {
      state = null;
      return;
    }

    device!.connectionState.listen((newState) {
      state = newState;
    });
  }
}
