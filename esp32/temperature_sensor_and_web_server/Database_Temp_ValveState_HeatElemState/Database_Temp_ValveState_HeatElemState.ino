// Facilitate Wifi connection
#include <Arduino.h>
#if defined(ESP32)
  #include <WiFi.h>
#elif defined(ESP8266)
  #include <ESP8266WiFi.h>
#endif

// Facilitate Firebase connection
#include <Firebase_ESP_Client.h>

// Facilitate token generation process info
#include "addons/TokenHelper.h"
// Facilitate RTDB payload printing info and other helper functions
#include "addons/RTDBHelper.h"

// Facilitate temperature measurements
#include <OneWire.h>
#include <DallasTemperature.h>

// Network credentials
#define WIFI_SSID "TMNL-AEF681"
#define WIFI_PASSWORD "YJQPMV7P3CM7MRXG"

// Firebase API Key
#define API_KEY "AIzaSyCpS6UvXWv6vPGAOWM52QCTT9EHnI8pMMo"

// RTDB URL
#define DATABASE_URL "https://engineer-design-default-rtdb.europe-west1.firebasedatabase.app/"

// Data wire of temperature sensor is connected to GPIO 4
#define ONE_WIRE_BUS 4

// Control pins of the H-bridge to the valve
#define VALVE_PIN_1 12
#define VALVE_PIN_2 14

// Control pin of the relais for the heating element
#define HEATING_ELEMENT_PIN 25

// Firebase Data object
FirebaseData fbdo;

// Required to sign up to the database
FirebaseAuth auth;
FirebaseConfig config;

// Setup a oneWire instance to communicate with any OneWire devices
OneWire oneWire(ONE_WIRE_BUS);

// Pass oneWire reference to Dallas Temperature sensor 
DallasTemperature sensors(&oneWire);

// Timestamp of previous data interfacing moment
unsigned long sendDataPrevMillis = 0;

// Sign up status
bool signupOK = false;

// User
String user = "user1";

// Data variables
float temperatureC = -128.00;

// State variables
boolean dbValveState = false;
boolean phyValveState = false;

boolean dbHeatingElementState = false;
boolean phyHeatingElementState = false;


float readDSTemperatureC() {
  // Issue a global temperature request to all devices on the bus
  sensors.requestTemperatures(); 
  float tempC = sensors.getTempCByIndex(0);

  if(tempC == -127.00) {
    Serial.println("Failed to read from DS18B20 sensor");
  } else {
    Serial.print("Temperature Celsius: ");
    Serial.println(tempC); 
  }
  return tempC;
}

int switchValveON() {
  Serial.println("Opening the valve");

  digitalWrite(VALVE_PIN_1, HIGH);
  digitalWrite(VALVE_PIN_2, LOW);

  // Predefined pulse width from datasheet
  delay(30); 

  digitalWrite(VALVE_PIN_1, LOW);
  digitalWrite(VALVE_PIN_2, LOW);

  return 1;
}

int switchValveOFF() {
  Serial.println("Closing the valve");

  digitalWrite(VALVE_PIN_1, LOW);
  digitalWrite(VALVE_PIN_2, HIGH);

  // Predefined pulse width from datasheet
  delay(30); 

  digitalWrite(VALVE_PIN_1, LOW);
  digitalWrite(VALVE_PIN_2, LOW);

  return 1;
}

int switchHeatingElementON() {
  Serial.println("Turning heating element ON");

  digitalWrite(HEATING_ELEMENT_PIN, HIGH);

  return 1;
}

int switchHeatingElementOFF() {
  Serial.println("Turning heating element OFF");
  
  digitalWrite(HEATING_ELEMENT_PIN, HIGH);

  return 1;
}

void setup() {
  // Start the serial and WiFi connection
  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  // Assign the api key
  config.api_key = API_KEY;

  // Assign the RTDB URL
  config.database_url = DATABASE_URL;

  // Sign up as an anonymous user
  // user1@gmail.com password1
  if (Firebase.signUp(&config, &auth, "", "")){
    Serial.println("Signed up succesfully");
    signupOK = true;
  }
  else {
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  // Assign the callback function for the long running token generation task, see addons/TokenHelper.h
  config.token_status_callback = tokenStatusCallback;
  
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  // Start up the DS18B20 (i.e. temperature sensor) library
  sensors.begin();
  temperatureC = readDSTemperatureC();

  // Configure the valve H-bridge pins
  pinMode(VALVE_PIN_1, OUTPUT);
  pinMode(VALVE_PIN_2, OUTPUT);

  // Configure the heating element relais pin
  pinMode(HEATING_ELEMENT_PIN, OUTPUT);

  // Switch initialized pins to LOW to keep them from being floating
  digitalWrite(VALVE_PIN_1, LOW);
  digitalWrite(VALVE_PIN_2, LOW);
  digitalWrite(HEATING_ELEMENT_PIN, LOW);

  // Make sure to initiliaze the system in the OFF state (valve close, heating element off)
  switchValveOFF();
  switchHeatingElementOFF();

}

void loop() {

  // Slow down microcontroller
  if (millis() - sendDataPrevMillis > 5000 || sendDataPrevMillis == 0) {

    // Update timestamp of previous data interfacing moment
    sendDataPrevMillis = millis();
    
    // Perform measurements
    temperatureC = readDSTemperatureC();

    // Check whether the the database is available and the device succesfully signed up
    if (Firebase.ready() && signupOK) {

      // Update database
      Serial.println("Attempting to upload");

      // Write the temperature measurement (float) on the database path user/temperatureC
      if (Firebase.RTDB.setFloat(&fbdo, user + "/temperatureC", temperatureC)){
        Serial.println("PASSED");
        Serial.println("PATH: " + fbdo.dataPath());
        Serial.println("TYPE: " + fbdo.dataType());
      }
      else {
        Serial.println("FAILED");
        Serial.println("REASON: " + fbdo.errorReason());
      }

      // Update local variables from database
      Serial.println("Attempting to download");
      
      // Read the valve state (boolean) on the database path user/valveState
      if (Firebase.RTDB.getBool(&fbdo, user + "/valveState")){
        if (fbdo.dataType() == "bool") {
          dbValveState = fbdo.boolData();
          Serial.print("dbValveState: ");
          Serial.println(dbValveState);
          Serial.println("PASSED");
          Serial.println("PATH: " + fbdo.dataPath());
          Serial.println("TYPE: " + fbdo.dataType());
        }
      }
      else {
        Serial.println("FAILED");
        Serial.println("REASON: " + fbdo.errorReason());
      }

      // Read the heating element state (boolean) on the database path user/heatingElementState
      if (Firebase.RTDB.getBool(&fbdo, user + "/heatingElementState")){
        if (fbdo.dataType() == "bool") {
          dbHeatingElementState = fbdo.boolData();
          Serial.print("dbHeatingElementState: ");
          Serial.println(dbHeatingElementState);
          Serial.println("PASSED");
          Serial.println("PATH: " + fbdo.dataPath());
          Serial.println("TYPE: " + fbdo.dataType());
        }
      }
      else {
        Serial.println("FAILED");
        Serial.println("REASON: " + fbdo.errorReason());
      }

    }

    // Change the state of the device

    // Heating element
    if (phyHeatingElementState == false && dbHeatingElementState == true) {
      if(switchHeatingElementON()) {
        Serial.println("Succesfully switched heating element ON");
      }
    }
    else if (phyHeatingElementState == true && dbHeatingElementState == false) {
      if(switchHeatingElementOFF()) {
        Serial.println("Succesfully switched heating element OFF");
      }
    }

    // Valve
    if (phyValveState == false && dbValveState == true) {
      if(switchValveON()) {
        Serial.println("Succesfully opened the valve");
      }
    }
    else if (phyHeatingElementState == true && dbHeatingElementState == false) {
      if(switchHeatingElementOFF()) {
        Serial.println("Succesfully close the valve");
      }
    }

  }
}
