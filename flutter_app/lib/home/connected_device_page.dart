import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../connected_device_controller.dart';

class ConnectedDevicePage extends ConsumerWidget {
  const ConnectedDevicePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceState = ref.watch(connectedDeviceControllerProvider)!;
    final deviceNotifier = ref.read(connectedDeviceControllerProvider.notifier);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //we show the name of the device
          Text('Connected to: ${deviceState.advName}'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              //discover the services
              final services = await deviceState.discoverServices();
              //find the service
              final service = services.firstWhere(
                  (e) => e.uuid.str == "12345678-1234-1234-1234-1234567890ab");
              //find the characteristic
              final characteristic = service.characteristics.firstWhere(
                  (e) => e.uuid.str == "abcdefab-1234-5678-1234-abcdefabcdef");
              //write to the characteristic
              characteristic.write(utf8.encode("1"));
            },
            child: Text('Turn on led'),
          ),
          ElevatedButton(
            onPressed: () async {
              // here we are doing the same thing as above.
              // It's not the most efficient way to repeat this code,
              // but it keeps things simple and easy to follow
              final services = await deviceState.discoverServices();
              final service = services.firstWhere(
                  (e) => e.uuid.str == "12345678-1234-1234-1234-1234567890ab");
              final characteristic = service.characteristics.firstWhere(
                  (e) => e.uuid.str == "abcdefab-1234-5678-1234-abcdefabcdef");
              characteristic.write(utf8.encode("0"));
            },
            child: Text('Turn off led'),
          ),
          const SizedBox(
            height: 30,
          ),
          //we show the disconnect button and trigger the onDisconnect function when it is pressed
          ElevatedButton(
            onPressed: () async {
              await deviceNotifier.disconnect();
            },
            child: Text('Disconnect'),
          ),
        ],
      ),
    );
  }
}
