# IoT-Based-Patient-Monitoring-System-Using-Arduino

## MATLAB GUI: Send Email Application

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
