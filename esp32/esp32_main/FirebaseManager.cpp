#include "FirebaseManager.h"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
bool signupOK = false;

void FirebaseManager::init() {
    config.api_key = API_KEY;
    config.database_url = DATABASE_URL;

    if (Firebase.signUp(&config, &auth, "", "")) {
        Serial.println("Signed up successfully");
        signupOK = true;
    } else {
        Serial.printf("Signup error: %s\n", config.signer.signupError.message.c_str());
    }

    config.token_status_callback = tokenStatusCallback;
    Firebase.begin(&config, &auth);
    Firebase.reconnectWiFi(true);
}

void FirebaseManager::uploadTemperature(const String& user, float temperature) {
    if (Firebase.ready() && signupOK) {
        if (Firebase.RTDB.setFloat(&fbdo, user + "/temperatureC", temperature)) {
            Serial.println("Temperature uploaded successfully");
        } else {
            Serial.println("Failed to upload temperature: " + fbdo.errorReason());
        }
    }
}

bool FirebaseManager::getValveState(const String& user) {
    if (Firebase.RTDB.getBool(&fbdo, user + "/valveState")) {
        return fbdo.boolData();
    }
    return false;
}

bool FirebaseManager::getHeatingElementState(const String& user) {
    if (Firebase.RTDB.getBool(&fbdo, user + "/heatingElementState")) {
        return fbdo.boolData();
    }
    return false;
}
