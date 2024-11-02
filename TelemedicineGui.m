function varargout = TelemedicineGui(varargin)
% TELEMEDICINEGUI MATLAB code for TelemedicineGui.fig
%      TELEMEDICINEGUI, by itself, creates a new TELEMEDICINEGUI or raises the existing
%      singleton*.
%
%      H = TELEMEDICINEGUI returns the handle to a new TELEMEDICINEGUI or the handle to
%      the existing singleton*.
%
%      TELEMEDICINEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TELEMEDICINEGUI.M with the given input arguments.
%
%      TELEMEDICINEGUI('Property','Value',...) creates a new TELEMEDICINEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TelemedicineGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TelemedicineGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TelemedicineGui

% Last Modified by GUIDE v2.5 19-Jul-2018 14:48:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @TelemedicineGui_OpeningFcn, ...
    'gui_OutputFcn',  @TelemedicineGui_OutputFcn, ...
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


% --- Executes just before TelemedicineGui is made visible.
function TelemedicineGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TelemedicineGui (see VARARGIN)

% Choose default command line output for TelemedicineGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TelemedicineGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

temp = load('temp.mat');
set(handles.temp, 'string', num2str(temp(1).temp));
if temp(1).temp > 100 | temp(1).temp < 97
    set(handles.temp, 'BackgroundColor', [1 0 0]);
    [y, f]=audioread('danger.mp3');
    sound(y, f);
end

hbeat = load('hbeat.mat');
set(handles.hbeat, 'string', num2str(hbeat(1).hbeat));
if hbeat(1).hbeat > 100 || hbeat(1).hbeat <60
    set(handles.hbeat, 'BackgroundColor', [1 0 0]);
    [y, f]=audioread('danger.mp3');
    sound(y, f);
end

time = load('time.mat');
set(handles.time, 'string', datestr(time(1).time));


% --- Outputs from this function are returned to the command line.
function varargout = TelemedicineGui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function temp_Callback(hObject, eventdata, handles)
% hObject    handle to temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of temp as text
%        str2double(get(hObject,'String')) returns contents of temp as a double


% --- Executes during object creation, after setting all properties.
function temp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hbeat_Callback(hObject, eventdata, handles)
% hObject    handle to hbeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hbeat as text
%        str2double(get(hObject,'String')) returns contents of hbeat as a double


% --- Executes during object creation, after setting all properties.
function hbeat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hbeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time_Callback(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time as text
%        str2double(get(hObject,'String')) returns contents of time as a double


% --- Executes during object creation, after setting all properties.
function time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
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

url = 'https://thingspeak.com/channels/535032/private_show';
web(url);


% --- Executes on button press in mail.
function mail_Callback(hObject, eventdata, handles)
% hObject    handle to mail (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Send_mailGui