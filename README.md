# IoT-Based-Patient-Monitoring-System-Using-Arduino

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

## `TelemedecineGui.m` - Remote Health Data Monitoring

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
matlab
Copy code
time_last = {'25-Jul-2018 23:42:26'};   % Initial last read time
Read_API = 'XSILQMGX4XKBKGRQ';           % ThingSpeak Read API Key

```

#### Main Loop

The script enters an infinite `while` loop to constantly check for new data on ThingSpeak. It retrieves data in table format and converts it into a structured array for easy access to temperature, heartbeat, and timestamp values.

#### Data Retrieval and Processing

1. **thingSpeakRead**: Retrieves data from ThingSpeak using the specified channel and Read API key.
2. **Timestamp Comparison**: Checks if the retrieved timestamp is more recent than `time_last`. If it is, the data is saved and the GUI is updated.

```matlab
matlab
Copy code
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
matlab
Copy code
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

### License

This project is licensed under the MIT License.
