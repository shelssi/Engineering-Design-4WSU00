#include "TemperatureSensor.h"

OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

float temp;

void TemperatureSensor::begin() {
    sensors.begin();
}

float TemperatureSensor::readTemperature() {
    sensors.requestTemperatures();
    float tempC = sensors.getTempCByIndex(0);
    temp = (tempC == -127.00) ? -128.00 : tempC;

    if(temp == -128.00) {
      Serial.println("Failed to read from DS18B20 sensor");
    } else {
      Serial.print("Temperature Celsius: ");
      Serial.println(temp); 
    }

    return temp;
}
