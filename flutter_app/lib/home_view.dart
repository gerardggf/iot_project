import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iot_project/connected_device_page.dart';
import 'package:iot_project/scanning_page.dart';

final scannedResultsStreamProvider = StreamProvider<List<ScanResult>>(
  (ref) => FlutterBluePlus.scanResults,
);

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  ScanResult? selectedDevice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IoT project'),
      ),
      body: selectedDevice != null
          ? ConnectedDevicePage(
              connectedDevice: selectedDevice!.device,
              onDisconnect: () {
                selectedDevice!.device.disconnect();
                setState(() {
                  selectedDevice = null;
                });
              },
            )
          : ScanningPage(
              onSelectedDevice: (ScanResult result) {
                result.device.connect();
                setState(() {
                  selectedDevice = result;
                });
              },
            ),
    );
  }
}
