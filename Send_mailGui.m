function varargout = Send_mailGui(varargin)
% SEND_MAILGUI MATLAB code for Send_mailGui.fig
%      SEND_MAILGUI, by itself, creates a new SEND_MAILGUI or raises the existing
%      singleton*.
%
%      H = SEND_MAILGUI returns the handle to a new SEND_MAILGUI or the handle to
%      the existing singleton*.
%
%      SEND_MAILGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEND_MAILGUI.M with the given input arguments.
%
%      SEND_MAILGUI('Property','Value',...) creates a new SEND_MAILGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Send_mailGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Send_mailGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Send_mailGui

% Last Modified by GUIDE v2.5 22-Jul-2018 23:05:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Send_mailGui_OpeningFcn, ...
                   'gui_OutputFcn',  @Send_mailGui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Send_mailGui is made visible.
function Send_mailGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Send_mailGui (see VARARGIN)

% Choose default command line output for Send_mailGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Send_mailGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

set(handles.edit1,'String', '');

% --- Outputs from this function are returned to the command line.
function varargout = Send_mailGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

message = get(handles.edit1,'String');
mail = 'jakirdu15@gmail.com';    %Your GMail email address
password = 'coclans 2';          %Your GMail password

id = 'jakireee15';
subject = 'Message from doctor';
emailto = strcat(id,'@gmail.com');

setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

sendmail(emailto, subject, message);
msg = msgbox('Mail Sent');
hf=findobj('Name', 'Send_mailGui');
    close(hf);
    pause(5);
    close(msg);
