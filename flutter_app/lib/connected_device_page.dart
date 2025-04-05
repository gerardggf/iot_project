import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConnectedDevicePage extends StatelessWidget {
  const ConnectedDevicePage({
    super.key,
    required this.connectedDevice,
    required this.onDisconnect,
  });

  final VoidCallback onDisconnect;

  final BluetoothDevice connectedDevice;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Connected to: ${connectedDevice.advName}'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              final services = await connectedDevice.discoverServices();

              final service = services.firstWhere(
                  (e) => e.uuid.str == "12345678-1234-1234-1234-1234567890ab");
              final characteristic = service.characteristics.firstWhere(
                  (e) => e.uuid.str == "abcdefab-1234-5678-1234-abcdefabcdef");
              characteristic.write(utf8.encode("1"));
            },
            child: Text('Turn on led'),
          ),
          ElevatedButton(
            onPressed: () async {
              final services = await connectedDevice.discoverServices();

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
          ElevatedButton(
            onPressed: onDisconnect,
            child: Text('Disconnect'),
          ),
        ],
      ),
    );
  }
}
