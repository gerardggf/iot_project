#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <BLE2902.h>

//define the ESP32 GPIO pin used to control the LED
#define LED_PIN 2

//define custom UUIDs for the BLE service and characteristic
#define SERVICE_UUID        "12345678-1234-1234-1234-1234567890ab"
#define CHARACTERISTIC_UUID "abcdefab-1234-5678-1234-abcdefabcdef"

//pointer to the characterstic
BLECharacteristic *pCharacteristic;

//callback class that handles write operations on the BLE characteristic
class CharCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *characteristic) override {
    //read the value written by the BLE client
    String value = String(characteristic->getValue().c_str());

    //control the LED based on the received value
    if (value.length() > 0 && value[0] == '1') {
      digitalWrite(LED_PIN, HIGH);
      Serial.println("LED ON");
    } else if (value.length() > 0 && value[0] == '0') {
      digitalWrite(LED_PIN, LOW);
      Serial.println("LED OFF");
    }

  }
};

//callback class that handles device connection and disconnection events
class ServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) override {
    Serial.println("Device connected");
  }

  void onDisconnect(BLEServer* pServer) override {
    Serial.println("Device disconnected");
  }
};

void setup() {
  //start serial communication
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);

  //initialize the BLE device and create a server
  BLEDevice::init("IOT project");
  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new ServerCallbacks());

  //create a BLE service with the custom UUID
  BLEService *pService = pServer->createService(SERVICE_UUID);

  //create a writable BLE characteristic with the custom UUID
  pCharacteristic = pService->createCharacteristic(
    CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_WRITE
  );

  //set the callback for when the characteristic is written
  pCharacteristic->setCallbacks(new CharCallbacks());
  pService->start();

  //start advertising the BLE service
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->start();
}


void loop() {
  // Nothing needed here, because everything is driven using events
}
