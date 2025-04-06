import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../connected_device_controller.dart';

final scannedDevicesStreamProvider =
    StreamProvider.autoDispose<List<ScanResult>>(
  (ref) {
    return FlutterBluePlus.scanResults;
  },
);

class ScanningPage extends ConsumerStatefulWidget {
  const ScanningPage({
    super.key,
  });

  @override
  ConsumerState<ScanningPage> createState() => _ScanningPageState();
}

class _ScanningPageState extends ConsumerState<ScanningPage> {
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    final deviceNotifier = ref.read(connectedDeviceControllerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: ref.watch(scannedDevicesStreamProvider).when(
                data: (scannedDevices) {
                  return ListView.builder(
                    itemCount: scannedDevices.length,
                    itemBuilder: (context, index) {
                      final result = scannedDevices[index].device;
                      if (result.advName.isEmpty) {
                        return const SizedBox();
                      }
                      ////we trigger the onSelectedDevice function when a device is selected
                      return ListTile(
                        leading: Icon(Icons.bluetooth),
                        onTap: () async {
                          deviceNotifier.connect(result);
                        },
                        title: Text(result.advName),
                        trailing: Text(
                          "${scannedDevices[index].rssi} dBm",
                        ),
                      );
                    },
                  );
                },
                error: (e, _) => Text(e.toString()),
                loading: () => const SizedBox(
                  width: double.infinity,
                ),
              ),
        ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: isScanning
              ? ElevatedButton(
                  onPressed: () {
                    FlutterBluePlus.stopScan();
                    setState(() {
                      isScanning = false;
                    });
                  },
                  child: Text('Stop scanning'),
                )
              : ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isScanning = true;
                    });

                    final timeout = 5;
                    await FlutterBluePlus.startScan(
                        timeout: Duration(seconds: timeout));

                    //the variable "isScanning" is updated if the timeout expires
                    await Future.delayed(Duration(seconds: timeout), () {
                      if (!context.mounted) return;
                      setState(() {
                        isScanning = false;
                      });
                    });
                  },
                  child: Text('Start scanning'),
                ),
        ),
      ],
    );
  }
}
