Bluetooth Classic:
- Orientado a transmisión continua
- Alto consumo energético
- Tiempo de conexión más lento
- Basado en perfiles como A2DP, HFP, SPP
- Usado en auriculares, altavoces, mandos, manos libres, etc.

Bluetooth Low Energy (BLE):
- Diseñado para conexiones rápidas y esporádicas
- Muy bajo consumo energético
- Ideal para dispositivos con batería pequeña o sensores
- Comunicación basada en una arquitectura llamada GATT
- Soporta "advertising": puede emitir información sin estar conectado

    Profile -> Servicio -> Característica -> Descriptor



Ejemplo: 

Profile:
 └─ Service: Heart Rate Service (UUID: 0x180D)
     └─ Characteristic: Heart Rate Measurement (UUID: 0x2A37)
         ├─ Valor: 72 (pulsaciones por minuto)
         ├─ Descriptor 0x2901: "Heart Rate"
         └─ Descriptor 0x2902: habilita notificaciones

 └─ Service: Battery Service (UUID: 0x180F)
     └─ Characteristic: Battery Level (UUID: 0x2A19)
         ├─ Valor: 91 (%)
         ├─ Descriptor 0x2901: "Battery Level"
         └─ Descriptor 0x2902: habilita notificaciones


