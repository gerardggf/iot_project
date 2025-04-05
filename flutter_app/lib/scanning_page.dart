import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_view.dart';

class ScanningPage extends ConsumerStatefulWidget {
  const ScanningPage({
    super.key,
    required this.onSelectedDevice,
  });

  final void Function(ScanResult result) onSelectedDevice;

  @override
  ConsumerState<ScanningPage> createState() => _ScanningPageState();
}

class _ScanningPageState extends ConsumerState<ScanningPage> {
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    final scannedResultsStream = ref.watch(scannedResultsStreamProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: !isScanning
              ? const SizedBox(
                  width: double.infinity,
                )
              : scannedResultsStream.when(
                  data: (results) {
                    return ListView.builder(
                      itemCount: results.length + 1,
                      itemBuilder: (context, index) {
                        if (index == results.length) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (results[index].device.advName.isEmpty) {
                          return const SizedBox();
                        }

                        return ListTile(
                          leading: Icon(Icons.bluetooth),
                          onTap: () => widget.onSelectedDevice(
                            results[index],
                          ),
                          title: Text(results[index].device.advName),
                        );
                      },
                    );
                  },
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
