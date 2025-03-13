#include "DeviceController.h"

void DeviceController::begin() {
    pinMode(VALVE_PIN_1, OUTPUT);
    pinMode(VALVE_PIN_2, OUTPUT);
    pinMode(HEATING_ELEMENT_PIN, OUTPUT);
    digitalWrite(VALVE_PIN_1, LOW);
    digitalWrite(VALVE_PIN_2, LOW);
    digitalWrite(HEATING_ELEMENT_PIN, LOW);
}

void DeviceController::updateStates(bool dbValveState, bool dbHeatingElementState) {
    
    digitalWrite(HEATING_ELEMENT_PIN, dbHeatingElementState ? HIGH : LOW);
    
    if (dbValveState) {
        digitalWrite(VALVE_PIN_1, HIGH);
        digitalWrite(VALVE_PIN_2, LOW);
        delay(30);
    } else {
        digitalWrite(VALVE_PIN_1, LOW);
        digitalWrite(VALVE_PIN_2, HIGH);
        delay(30);
    }

    digitalWrite(VALVE_PIN_1, LOW);
    digitalWrite(VALVE_PIN_2, LOW);
}
