#ifndef DEVICE_CONTROLLER_H
#define DEVICE_CONTROLLER_H

#include <Arduino.h>

#define VALVE_PIN_1 12
#define VALVE_PIN_2 14
#define HEATING_ELEMENT_PIN 25

class DeviceController {
public:
    static void begin();
    static void updateStates(bool dbValveState, bool dbHeatingElementState);
};

#endif
