#ifndef WIFI_MANAGER_H
#define WIFI_MANAGER_H

#include <Arduino.h>
#if defined(ESP32)
  #include <WiFi.h>
#elif defined(ESP8266)
  #include <ESP8266WiFi.h>
#endif

// Network credentials
#define WIFI_SSID "TMNL-AEF681"
#define WIFI_PASSWORD "YJQPMV7P3CM7MRXG"

class WiFiManager {
public:
    static void connect(const char* ssid, const char* password);
};

#endif
