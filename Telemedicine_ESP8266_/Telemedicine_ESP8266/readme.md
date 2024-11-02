# ESP8266 IoT Temperature and Heartbeat Monitoring

This project utilizes an ESP8266 microcontroller to monitor temperature and heartbeat data. It sends the collected data to [ThingSpeak](https://thingspeak.com/) for remote monitoring and analysis.

## Features

- Reads temperature from an analog temperature sensor.
- Calculates heartbeat rate from a digital heartbeat sensor.
- Sends the temperature and heartbeat data to ThingSpeak over WiFi.

## Components

- **ESP8266** microcontroller
- **Temperature Sensor** (connected to analog pin `A0`)
- **Heartbeat Sensor** (connected to digital pin `D2`)
- **WiFi** connection for data transmission to ThingSpeak

## Circuit Diagram

- Temperature Sensor: Connect the output to `A0`.
- Heartbeat Sensor: Connect the output to `D2`.
- ESP8266: Connect to WiFi to send data.

## Setup

### Prerequisites

- Install the [ESP8266 Board Package](https://arduino-esp8266.readthedocs.io/en/latest/installing.html) in the Arduino IDE.
- Install the **ESP8266WiFi** library, which is usually included with the board package.

### Configuration

1. **ThingSpeak API Key**: Sign up for a ThingSpeak account and create a new channel to receive an API key. Replace `apiKey` with your unique key.
2. **WiFi Credentials**: Replace `ssid` and `pass` with your WiFi network's name and password.

### Code

```cpp
#include <ESP8266WiFi.h>// Defining Connection Settings
String apiKey = "G7VF8BE10A9HIC90";   // ThingSpeak API Key
const char *ssid = "SBH 4012";          // WiFi SSID
const char *pass = "kamruz1415";        // WiFi Password
const char* server = "api.thingspeak.com"; // ThingSpeak Server

#define Data_pin_temp A0
#define Data_pin_hbeat D2

int State = 0, BPM = 0;
unsigned long Start_Time, End_Time;

WiFiClient client;

```

### Code Overview

- **Libraries and Settings**: Includes the `ESP8266WiFi.h` library for WiFi functions. Defines WiFi and ThingSpeak server details.
- **Pins Setup**: `A0` for temperature sensor and `D2` for heartbeat sensor.
- **Variables**:
    - `State`, `BPM`: Used to track the heartbeat state and beats per minute.
    - `Start_Time`, `End_Time`: Track time to calculate the heartbeat rate.

### `setup()` Function

Connects the ESP8266 to the specified WiFi network and prints the connection status to the serial monitor.

```cpp
void setup()
{
  Serial.begin(115200);
  delay(10);

  pinMode(Data_pin_hbeat, INPUT);
  pinMode(Data_pin_temp, INPUT);

  Serial.print("Connecting to ");
  Serial.print(ssid);

  WiFi.begin(ssid, pass);

  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");
}

```

### `loop()` Function

The main program loop reads temperature and heartbeat data, then sends this information to ThingSpeak.

- **Temperature Reading**:
    - Converts the analog value from the temperature sensor to Fahrenheit.
- **Heartbeat Calculation**:
    - Uses the digital heartbeat sensor input to calculate beats per minute (BPM).
- **Data Validation**:
    - Ensures both `temp` and `hbeat` values are valid before sending to ThingSpeak.
- **Data Transmission**:
    - If data is valid, the ESP8266 connects to ThingSpeak and sends the readings.

```cpp
void loop()
{
  float temp;
  float hbeat;

  int analogValue = analogRead(Data_pin_temp);
  float millivolts = (analogValue / 1024.0) * 3300;
  float celsius = millivolts / 10;
  temp = ((celsius * 9) / 5 + 32);  // Convert to Fahrenheit

  while (State < 15)
  {
    if (digitalRead(Data_pin_hbeat))
    {
      if (State == 0)
        Start_Time = millis();
      State++;
      while (digitalRead(Data_pin_hbeat))
      {
        delay(0);
      }
    }
    delay(0);
  }
  End_Time = millis();
  float BPM = End_Time - Start_Time;
  BPM = BPM / 15;
  hbeat = 6000 / BPM;
  State = 0;
  BPM = 0;

  if (isnan(hbeat) || isnan(temp))
  {
    Serial.println("Failed to read from sensors!");
    return;
  }

  if (hbeat > 55 && hbeat < 110)
  {
    if (client.connect(server, 80))
    {
      String postStr = apiKey;
      postStr += "&field1=";
      postStr += String(temp);
      postStr += "&field2=";
      postStr += String(hbeat);
      postStr += "\r\n\r\n";

      client.print("POST /update HTTP/1.1\n");
      client.print("Host: api.thingspeak.com\n");
      client.print("Connection: close\n");
      client.print("X-THINGSPEAKAPIKEY: " + apiKey + "\n");
      client.print("Content-Type: application/x-www-form-urlencoded\n");
      client.print("Content-Length: ");
      client.print(postStr.length());
      client.print("\n\n");
      client.print(postStr);

      Serial.print("Temperature: ");
      Serial.print(temp);
      Serial.print(" degrees Fahrenheit, Heartbeat: ");
      Serial.print(hbeat);
      Serial.println("");
    }
    client.stop();
    delay(5000);
  }
}

```

## Usage

1. Upload the code to your ESP8266.
2. Open the Serial Monitor in the Arduino IDE to observe the connection status and sensor readings.
3. Check your ThingSpeak channel to view the recorded temperature and heartbeat data.

## Future Improvements

- **Security**: Store WiFi credentials and API key securely.
- **Performance**: Use an interrupt-based approach for heartbeat calculation.
- **Error Handling**: Add retry mechanisms for network and server errors.
