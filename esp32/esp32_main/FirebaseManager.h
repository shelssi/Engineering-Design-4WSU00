#ifndef FIREBASE_MANAGER_H
#define FIREBASE_MANAGER_H

#include <Arduino.h>
#include <Firebase_ESP_Client.h>
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

#define API_KEY "AIzaSyCpS6UvXWv6vPGAOWM52QCTT9EHnI8pMMo"
#define DATABASE_URL "https://engineer-design-default-rtdb.europe-west1.firebasedatabase.app/"

class FirebaseManager {
public:
    static void init();
    static void uploadTemperature(const String& user, float temperature);
    static bool getValveState(const String& user);
    static bool getHeatingElementState(const String& user);
};

#endif
