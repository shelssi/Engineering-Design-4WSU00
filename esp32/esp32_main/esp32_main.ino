#include "WiFiManager.h"
#include "FirebaseManager.h"
#include "TemperatureSensor.h"
#include "DeviceController.h"

unsigned long sendDataPrevMillis = 0; // record the time for the last time sent
String user = "user1"; // the path of database user

void setup() {
    Serial.begin(115200);
    
    WiFiManager::connect(WIFI_SSID, WIFI_PASSWORD);

    FirebaseManager::init();

    TemperatureSensor::begin();

    DeviceController::begin();
}

void loop() {
    
    if (millis() - sendDataPrevMillis > 5000 || sendDataPrevMillis == 0) {
        sendDataPrevMillis = millis();
        
        float temperature = TemperatureSensor::readTemperature();

        FirebaseManager::uploadTemperature(user, temperature);

        bool dbValveState = FirebaseManager::getValveState(user);
        bool dbHeatingElementState = FirebaseManager::getHeatingElementState(user);

        DeviceController::updateStates(dbValveState, dbHeatingElementState);
    }
}
