# include <ESP8266WiFi.h>

// Defining Connection Settings
String apiKey = "G7VF8BE10A9HIC90";
const char *ssid = "SBH 4012";
const char *pass = "kamruz1415";
const char* server = "api.thingspeak.com";

#define Data_pin_temp A0
#define Data_pin_hbeat D2

int State=0,BPM=0;
unsigned long Start_Time,End_Time;

WiFiClient client;


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


void loop()
{
  float temp;
  float hbeat;
  
  int analogValue = analogRead(Data_pin_temp);
  float millivolts = (analogValue/1024.0) * 3300;
  float celsius = millivolts/10;
  temp = ((celsius * 9)/5 + 32);
  //temp = temp/97*98.5;

  while(State<15)
  {
    if(digitalRead(Data_pin_hbeat))
    {
      if(State==0)
      Start_Time=millis(); 
      State++; 
      while(digitalRead(Data_pin_hbeat))
      {
        delay(0);
      }
    }
    delay(0);
  }
  End_Time=millis();
  float BPM=End_Time-Start_Time;
  BPM=BPM/15;
  hbeat=6000/BPM;
  State=0;
  BPM=0;
  
  //temp = 30;
  //hbeat = 80;

  if (isnan(hbeat) || isnan(temp))
  {
    Serial.println("Failed to read from sensors!");
    return;
  }
  if (hbeat > 55 && hbeat < 110)
  { 
    if (client.connect (server, 80))
    {
      String postStr = apiKey;
      postStr += "&field1=";
      postStr += String(temp);
      postStr +="&field2=";
      postStr += String(hbeat);
      postStr += "\r\n\r\n";
  
      client.print("POST /update HTTP/1.1\n");
      client.print("Host: api.thingspeak.com\n");
      client.print("Connection: close\n");
      client.print("X-THINGSPEAKAPIKEY: "+apiKey+"\n");
      client.print("Content-Type: application/x-www-form-urlencoded\n");
      client.print("Content-Length: ");
      client.print(postStr.length());
      client.print("\n\n");
      client.print(postStr);
  
      Serial.print("Temperature: ");
      Serial.print(temp);
      Serial.print(" degrees Farenheight, Heartbeat: ");
      Serial.print(hbeat);
      Serial.println("");
    }
    client.stop();
    delay(5000);
  }
}

