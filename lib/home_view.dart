import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scannedResultsStreamProvider = StreamProvider<List<ScanResult>>(
  (ref) => FlutterBluePlus.scanResults,
);

final isScanningStreamProvider = StreamProvider<bool>(
  (ref) => FlutterBluePlus.isScanning,
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
    final scannedResultsStream = ref.watch(scannedResultsStreamProvider);
    final isScanningStream = ref.watch(isScanningStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('IoT project'),
      ),
      body: selectedDevice != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final services =
                          await selectedDevice!.device.discoverServices();

                      final service = services.firstWhere((e) =>
                          e.uuid.str == "12345678-1234-1234-1234-1234567890ab");
                      final characteristic = service.characteristics.firstWhere(
                          (e) =>
                              e.uuid.str ==
                              "abcdefab-1234-5678-1234-abcdefabcdef");
                      characteristic.write(utf8.encode("1"));
                    },
                    child: Text('Turn on led'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final services =
                          await selectedDevice!.device.discoverServices();

                      final service = services.firstWhere((e) =>
                          e.uuid.str == "12345678-1234-1234-1234-1234567890ab");
                      final characteristic = service.characteristics.firstWhere(
                          (e) =>
                              e.uuid.str ==
                              "abcdefab-1234-5678-1234-abcdefabcdef");
                      characteristic.write(utf8.encode("0"));
                    },
                    child: Text('Turn off led'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      selectedDevice!.device.disconnect();
                      setState(() {
                        selectedDevice = null;
                      });
                    },
                    child: Text('Disconnect'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: scannedResultsStream.when(
                    data: (results) => ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        if (results[index].device.advName.isEmpty) {
                          return const SizedBox();
                        }
                        return ListTile(
                          leading: Icon(Icons.bluetooth),
                          onTap: () {
                            results[index].device.connect();
                            setState(() {
                              selectedDevice = results[index];
                            });
                          },
                          title: Text(results[index].device.advName),
                        );
                      },
                    ),
                    error: (e, _) {
                      return Text('An error has occurred: $e');
                    },
                    loading: () {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: isScanningStream.maybeWhen(
                    data: (isScanning) {
                      if (isScanning) {
                        return ElevatedButton(
                          onPressed: () {
                            FlutterBluePlus.stopScan();
                          },
                          child: Text('Stop scanning'),
                        );
                      } else {
                        return ElevatedButton(
                          onPressed: () {
                            FlutterBluePlus.startScan(
                                timeout: Duration(seconds: 5));
                          },
                          child: Text('Start scanning'),
                        );
                      }
                    },
                    orElse: () {
                      return ElevatedButton(
                        onPressed: () {
                          FlutterBluePlus.startScan();
                        },
                        child: Text('Start scanning'),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
