import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iot_project/connection_state_notifier.dart';
import 'package:iot_project/home/connected_device_page.dart';
import 'package:iot_project/home/scanning_page.dart';

import '../connected_device_controller.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    final connectedDevice = ref.watch(connectedDeviceControllerProvider);
    final connectionState = ref.watch(connectionStateNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('IoT project'),
      ),
      //if the device is connected we show the connected device page
      body: connectedDevice != null
          //if the device is not connected yet we show a loading indicator
          ? connectionState == BluetoothConnectionState.connected
              ? ConnectedDevicePage()
              : Center(
                  child: CircularProgressIndicator(),
                )
          : ScanningPage(),
    );
  }
}
