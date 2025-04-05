import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// We create a provider to listen and save the results and pass it to the scanning page,
/// until we press the button to scan the devices again
final scannedDevicesProvider =
    StateNotifierProvider<ScannedDevicesNotifier, List<ScanResult>>(
  (ref) => ScannedDevicesNotifier(),
);

class ScannedDevicesNotifier extends StateNotifier<List<ScanResult>> {
  ScannedDevicesNotifier() : super([]) {
    _listenToScan();
  }

  void _listenToScan() {
    FlutterBluePlus.scanResults.listen(
      (results) {
        for (final result in results) {
          //if the device is not in the list and its name is not empty , add it
          if (!state.any((r) => r.device.remoteId == result.device.remoteId) &&
              result.device.advName.isNotEmpty) {
            state = [...state, result];
          }
        }
      },
    );
  }

  //clear the devices list
  void clear() {
    state = [];
  }
}
