import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConnectedDevicePage extends StatelessWidget {
  const ConnectedDevicePage({
    super.key,
    required this.connectedDevice,
    required this.onDisconnect,
  });

  ///this functionis called when the disconnect button is pressed
  ///
  ///this is the same as "void Function()"
  final VoidCallback onDisconnect;

  ///this is the device that is connected
  final BluetoothDevice connectedDevice;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //we show the name of the device
          Text('Connected to: ${connectedDevice.advName}'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              //discover the services
              final services = await connectedDevice.discoverServices();
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
          //we show the disconnect button and trigger the onDisconnect function when it is pressed
          ElevatedButton(
            onPressed: onDisconnect,
            child: Text('Disconnect'),
          ),
        ],
      ),
    );
  }
}
