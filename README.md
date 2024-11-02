# IoT Based Patient Monitoring System Using ESP8266 Microcontroller
This project utilizes an ESP8266 microcontroller to monitor temperature and heartbeat data. It sends the collected data to [ThingSpeak](https://thingspeak.com/) for remote monitoring and analysis.


  * [Features](#features)
  * [Components](#components)
  * [Circuit Connections](#circuit-connections)
  * [Setup](#setup)
  * [`Telemedicine_ESP8266.ino` - Configuring the ESP8266 Microcontroller](#-telemedicine-esp8266ino----configuring-the-esp8266-microcontroller)
 
  * [`Send_mailGui.m` - MATLAB GUI: Send Email Application](#-send-mailguim----matlab-gui--send-email-application)
 
  * [`Telemedecine.m` - Remote Health Data Monitoring](#-telemedecinem----remote-health-data-monitoring)
 
  * [`send_mail_message.m` - Notifying Users via Email](#-send-mail-messagem----notifying-users-via-email)




## Features

- Reads temperature from an analog temperature sensor.
- Calculates heartbeat rate from a digital heartbeat sensor.
- Sends the temperature and heartbeat data to [ThingSpeak](https://thingspeak.com/) over WiFi.

## Components

- **ESP8266** microcontroller
- **Temperature Sensor** (connected to analog pin `A0`)
- **Heartbeat Sensor** (connected to digital pin `D2`)
- **WiFi** connection for data transmission to [ThingSpeak](https://thingspeak.com/)

## Circuit Connections

- Temperature Sensor: Connect the output to `A0`.
- Heartbeat Sensor: Connect the output to `D2`.
- ESP8266: Connect to WiFi to send data.

## Setup

### Prerequisites

- Install the [ESP8266 Board Package](https://arduino-esp8266.readthedocs.io/en/latest/installing.html) in the Arduino IDE.
- Install the **ESP8266WiFi** library, which is usually included with the board package.

## `Telemedicine_ESP8266.ino` - Configuring the ESP8266 Microcontroller
Configure the ESP8266 microcontroller by modifying the `Telemedicine_ESP8266.ino` file which can be found in the filepath: `/Telemedicine_ESP8266_/Telemedicine_ESP8266/Telemedicine_ESP8266.ino`

### Configuration

1. **ThingSpeak API Key**: Sign up for a [ThingSpeak](https://thingspeak.com/) account and create a new channel to receive an API key. Replace `apiKey` with your unique key.
2. **WiFi Credentials**: Replace `ssid` and `pass` with your WiFi network's name and password in the `Telemedicine_ESP8266.ino` file.

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

#### `setup()` Function

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

#### `loop()` Function

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

### Usage

1. Upload the code to your ESP8266.
2. Open the Serial Monitor in the Arduino IDE to observe the connection status and sensor readings.
3. Check your ThingSpeak channel to view the recorded temperature and heartbeat data.

### Future Improvements

- **Security**: Store WiFi credentials and API key securely.
- **Performance**: Use an interrupt-based approach for heartbeat calculation.
- **Error Handling**: Add retry mechanisms for network and server errors.

## `Send_mailGui.m` - MATLAB GUI: Send Email Application

This MATLAB GUI application allows users to send emails directly from within MATLAB using a simple graphical interface. Users can input a message, and upon pressing the send button, the application will email the message to a predefined recipient.

### Features

- User-friendly interface to enter and send email messages.
- Uses MATLAB's `sendmail` function to securely send messages via Gmail's SMTP server.
- Automatically closes the application after sending the email.

### Prerequisites

- **MATLAB**: Make sure MATLAB is installed on your system.
- **SMTP Server Access**: The program is configured to use Gmail's SMTP server. Update the email and password to match your Gmail credentials in the code.
- **Java**: Ensure Java is properly configured, as `sendmail` relies on Java-based SMTP properties.

### Code Overview

#### Initialization and GUI Setup

The file `Send_mailGui.m` is responsible for initializing the GUI and setting up the callbacks for user interactions.

#### Function: `Send_mailGui_OpeningFcn`

This function initializes the GUI, updates the handles structure, and sets up the default behavior when the GUI is opened.

```matlab
function Send_mailGui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
set(handles.edit1,'String', '');
```

#### Function: `Send_mailGui_OutputFcn`

Defines the output for the GUI.

```matlab
function varargout = Send_mailGui_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;
```

#### Callback Functions

The GUI includes two main components: an editable text field and a send button.

#### `edit1_Callback` and `edit1_CreateFcn`

Manages user input in the text field where the message is entered.

#### `pushbutton1_Callback`

Triggered when the send button is clicked. This function retrieves the entered message, configures email settings, and sends the email using MATLAB’s `sendmail` function. After sending the email, it displays a confirmation message and closes the GUI.

```matlab
function pushbutton1_Callback(hObject, eventdata, handles)
message = get(handles.edit1,'String');
mail = 'your-email@gmail.com';    % Your Gmail address
password = 'your-password';       % Your Gmail password

id = 'recipient-id';               % Recipient's ID
subject = 'Message from MATLAB GUI';
emailto = strcat(id,'@gmail.com'); % Constructs the recipient's email

% Configure email preferences
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);

% Set SMTP properties
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

% Send the email
sendmail(emailto, subject, message);
msg = msgbox('Mail Sent');
hf = findobj('Name', 'Send_mailGui');
close(hf);
pause(5);
close(msg);
```

#### Security Note

For security purposes, avoid hardcoding email addresses and passwords directly in the script. Consider using environment variables or a secure credential store if deploying this code in a production environment.

### Usage

1. Open MATLAB and load `Send_mailGui.m`.
2. Run the file to open the GUI.
3. Enter your message in the text box.
4. Press the **Send** button. The GUI will:
    - Send the email message.
    - Display a confirmation box.
    - Automatically close the GUI after a short delay.

## `Telemedecine.m` - Remote Health Data Monitoring

This MATLAB script continuously reads temperature and heartbeat data from a ThingSpeak channel. When new data is available, it saves the latest readings to `.mat` files and updates the GUI for remote health monitoring.

### Features

- Connects to ThingSpeak to retrieve remote temperature and heartbeat data.
- Detects new data and saves it in `.mat` files for further analysis.
- Opens or refreshes the `TelemedicineGui` GUI to display the latest data.

### Prerequisites

- **MATLAB**: Ensure that MATLAB is installed.
- **ThingSpeak Access**: This code uses ThingSpeak’s `thingSpeakRead` function, so you’ll need a valid Read API key for your channel.
- **GUI File**: The `TelemedicineGui.m` file must be available in the same directory to launch the GUI.

### Code Overview

#### Configuration and API Key

The script initializes by defining the `Read_API` key, the ThingSpeak channel ID, and `time_last`, which stores the timestamp of the last read entry.

```matlab
time_last = {'25-Jul-2018 23:42:26'};   % Initial last read time
Read_API = 'XSILQMGX4XKBKGRQ';           % ThingSpeak Read API Key

```

#### Main Loop

The script enters an infinite `while` loop to constantly check for new data on ThingSpeak. It retrieves data in table format and converts it into a structured array for easy access to temperature, heartbeat, and timestamp values.

#### Data Retrieval and Processing

1. **thingSpeakRead**: Retrieves data from ThingSpeak using the specified channel and Read API key.
2. **Timestamp Comparison**: Checks if the retrieved timestamp is more recent than `time_last`. If it is, the data is saved and the GUI is updated.

```matlab
while (1)
    data = thingSpeakRead(535032, 'ReadKey', Read_API, 'OutputFormat','table');
    value = table2struct(data);
    temp = value.Temperature;
    hbeat = value.HeartBeat;
    time = value.Timestamps;

    if time > time_last
        save('temp.mat', 'temp');   % Save temperature data
        save('hbeat.mat', 'hbeat'); % Save heartbeat data
        save('time.mat', 'time');   % Save timestamp

```

#### Updating the GUI

When new data is saved, the script closes any open instance of `TelemedicineGui` and reopens it to display the latest data.

```matlab
        hf = findobj('Name', 'TelemedicineGui');
        close(hf);
        TelemedicineGui    % Launch or refresh the GUI
        time_last = time;  % Update last read time
    end
end

```

#### Security Note

Ensure that the `Read_API` key is handled securely, especially if sharing the code or repository publicly.

### Usage

1. Run the script in MATLAB.
2. The script will continuously monitor the ThingSpeak channel for new data.
3. When new data is detected:
    - The latest temperature, heartbeat, and timestamp will be saved to `temp.mat`, `hbeat.mat`, and `time.mat`.
    - The `TelemedicineGui` will open or refresh to display the latest values.



## `send_mail_message.m` - Notifying Users via Email

The `send_mail_message` function allows users to send emails via Gmail using MATLAB. This function can be utilized after completing calculations or simulations to notify users of the results.

### Features

- Sends an email with a specified subject and message.
- Optionally attaches a file to the email.
- Configured for use with Gmail's SMTP server.

### Prerequisites

- **MATLAB**: Ensure MATLAB is installed on your system.
- **Gmail Account**: You will need a valid Gmail account to send emails.

### Function Syntax

```matlab
send_mail_message(id, subject, message, attachment)
```

#### Parameters

- **id**: Recipient's email ID (without the `@gmail.com` part).
- **subject**: Subject line of the email.
- **message**: The body content of the email.
- **attachment**: (Optional) Path to a file to be attached to the email.

#### Example

To send an email after a simulation is complete, use the following command:

```matlab
send_mail_message('its.neeraj', 'Simulation finished', 'This is the message area', 'results.doc')
```

### Code Overview

#### Email Configuration

At the beginning of the function, users need to input their Gmail credentials. Replace the placeholders with your actual Gmail email address and password:

```matlab
mail = '<Your GMail email address>';    % Replace with your Gmail address
password = '<Your GMail password>';      % Replace with your Gmail password
```

#### Handling Input Arguments

The function checks the number of input arguments to manage optional parameters:

- If only `id` is provided, the `subject` is set to `''` and `message` is set to `subject`.
- If `id` and `subject` are provided, the `message` is set to `''` and `attachment` to `''`.
- If all three (`id`, `subject`, and `message`) are provided, `attachment` is set to `''`.

#### SMTP Configuration

The function sets up the preferences for the Gmail SMTP service:

```matlab
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
```

#### Sending the Email

The function checks if the `mail` variable matches a placeholder and prompts the user to update their credentials if it does. It then uses MATLAB's `sendmail` function to send the email:

```matlab
sendmail(emailto, subject, message, attachment);
```

### Security Note

For security reasons, avoid hardcoding your Gmail credentials directly in the script if sharing it. Consider using environment variables or a secure credential manager.

### Usage

1. Update the Gmail credentials in the function.
2. Call the function with the required parameters to send an email.
