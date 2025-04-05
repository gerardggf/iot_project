import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'scanned_devices_notifier.dart';

class ScanningPage extends ConsumerStatefulWidget {
  const ScanningPage({
    super.key,
    required this.onSelectedDevice,
  });

  /// this function is called when a device is selected
  final void Function(ScanResult result) onSelectedDevice;

  @override
  ConsumerState<ScanningPage> createState() => _ScanningPageState();
}

class _ScanningPageState extends ConsumerState<ScanningPage> {
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    final scannedDevices = ref.watch(scannedDevicesProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: scannedDevices.length,
            itemBuilder: (context, index) {
              if (scannedDevices[index].device.advName.isEmpty) {
                return const SizedBox();
              }
              ////we trigger the onSelectedDevice function when a device is selected
              return ListTile(
                leading: Icon(Icons.bluetooth),
                onTap: () => widget.onSelectedDevice(
                  scannedDevices[index],
                ),
                title: Text(scannedDevices[index].device.advName),
              );
            },
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
                    //we clear the list of devices
                    ref.read(scannedDevicesProvider.notifier).clear();
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
