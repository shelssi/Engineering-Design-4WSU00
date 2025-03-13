#include "WiFiManager.h"

void WiFiManager::connect(const char* ssid, const char* password) {
    WiFi.begin(ssid, password);
    Serial.print("Connecting to Wi-Fi");
    
    while (WiFi.status() != WL_CONNECTED) {
        Serial.print(".");
        delay(300);
    }
    
    Serial.println("\nConnected to WiFi");
    Serial.print("IP Address: ");
    Serial.println(WiFi.localIP());
}
