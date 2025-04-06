import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectedDeviceControllerProvider =
    StateNotifierProvider<DeviceController, BluetoothDevice?>(
  (ref) => DeviceController(),
);

class DeviceController extends StateNotifier<BluetoothDevice?> {
  DeviceController() : super(null);

  Future<void> connect(BluetoothDevice device) async {
    await device.connect();
    state = device;
  }

  Future<void> disconnect() async {
    await state?.disconnect();
    state = null;
  }
}
