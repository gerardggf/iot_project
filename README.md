# ESP32 + Flutter BLE LED Control

This project connects an ESP32 with a Flutter app using Bluetooth Low Energy (BLE) to control an LED. The ESP32 runs a BLE server and exposes a writable characteristic. The Flutter app connects and sends `1` or `0` to turn the LED on or off.

---

## Hardware

ESP32 GPIO2 (D2) ---> 220Ω resistor ---> LED anode (+)

ESP32 GND ------------------------> LED cathode (-)

- Use a 220Ω resistor to avoid damaging the LED.
- Anode (+) = long leg -> GPIO2 via the resistor  
- Cathode (-) = short leg -> directly to GND

---

## Uploading the Arduino Firmware

1. Open the file `iot_project.ino` in Arduino IDE
2. Go to "Tools" -> "Board" and select your board (in my case "ESP32-WROOM-DA module")
3. Go to "Tools" -> "Ports" and select the correct serial port ("/dev/cu.usbserial-xxxx...")
4. Go to "Tools" -> "Upload Speed" and set it to 115200
5. Click "Upload" (arrow icon)
6. Open the "Serial Monitor" (also at 115200 baud) to see connection and command logs

When a BLE device connects or disconnects, or you send a "0" or "1", you will see a message on the Serial monitor.

---

## Running the Flutter App

1. Navigate to the Flutter app directory in VS Code:

```bash
cd flutter_app
```

2. Get the dependencies:
```bash
flutter pub get
```

3. Connect a physical Android device or start an emulator.


4. Run the app in debug mode:
```bash
flutter run
```

## Contact

For any questions, you can contact me at: gerard.ggf@gmail.com