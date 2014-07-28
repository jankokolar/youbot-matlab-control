function varargout = gripper_control(varargin)
% GRIPPER_CONTROL MATLAB code for gripper_control.fig
%      GRIPPER_CONTROL, by itself, creates a new GRIPPER_CONTROL or raises the existing
%      singleton*.
%
%      H = GRIPPER_CONTROL returns the handle to a new GRIPPER_CONTROL or the handle to
%      the existing singleton*.
%
%      GRIPPER_CONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRIPPER_CONTROL.M with the given input arguments.
%
%      GRIPPER_CONTROL('Property','Value',...) creates a new GRIPPER_CONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gripper_control_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gripper_control_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gripper_control

% Last Modified by GUIDE v2.5 18-Jul-2014 10:31:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gripper_control_OpeningFcn, ...
                   'gui_OutputFcn',  @gripper_control_OutputFcn, ...
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


% --- Executes just before gripper_control is made visible.
function gripper_control_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gripper_control (see VARARGIN)

% Choose default command line output for gripper_control
handles.output = hObject;

ros_node = varargin{1}{1}; %First element of varagin cell array is cell array containing rosnode
handles.ros_node = ros_node;

youbot_gripper_publisher = rosmatlab.publisher('/arm_1/gripper_controller/position_command','brics_actuator/JointPositions',ros_node);
youbot_gripper_message = rosmatlab.message('brics_actuator/JointPositions', ros_node);

gripper_header_message = rosmatlab.message('brics_actuator/Poison', ros_node);

gripper_L_message =  rosmatlab.message('brics_actuator/JointValue', ros_node);

gripper_R_message= rosmatlab.message('brics_actuator/JointValue', ros_node);
gripper_header_message.setDescription('Pozdrav iz Matlaba. Zdravo Gripper');
gripper_header_message.setOriginator('Matlab');
gripper_header_message.setQos(0.0);
youbot_gripper_message.setPoisonStamp(gripper_header_message);

gripper_L_message.setJointUri('gripper_finger_joint_l');
gripper_L_message.setUnit('m');
gripper_L_message.setValue(get(handles.left_gripper_slider,'Min'));

gripper_R_message.setJointUri('gripper_finger_joint_r');
gripper_R_message.setUnit('m');
gripper_R_message.setValue(get(handles.right_gripper_slider,'Min'));

youbot_gripper_message.getPositions.add(gripper_L_message);
youbot_gripper_message.getPositions.add(gripper_R_message);

youbot_gripper_publisher.publish(youbot_gripper_message);

handles.youbot_gripper_publisher = youbot_gripper_publisher;
handles.youbot_gripper_message =  youbot_gripper_message;
handles.gripper_L_message = gripper_L_message;
handles.gripper_R_message = gripper_R_message;

% here subscriber is defined
youbot_gripper_encoder_reader = rosmatlab.subscriber('/joint_states','sensor_msgs/JointState',10,ros_node);
handles.youbot_gripper_encoder_reader = youbot_gripper_encoder_reader;


global gripper_L_position_plot;
global gripper_L_speed_plot;
global gripper_R_speed_plot;
global gripper_R_position_plot;


axes(handles.gripper_position_axes);
gripper_L_position_plot = plot(zeros(1,100),'b');
hold on;
gripper_R_position_plot = plot(ones(1,100),'r');
axis([0 100 0 .012]);
%grid on;
title('Gripper position [m]');

% axes(handles.gripper_speed_axes);
% gripper_L_speed_plot = plot(zeros(1,100),'b');
% hold on;
% gripper_R_speed_plot = plot(ones(1,100),'r');
% axis([0 100 -0.04 0.04]);
% title('Gripper speed [m/s]');

youbot_gripper_encoder_reader.setOnNewMessageListeners({@youbot_gripper_encoders})


% Update GUI 
string_value = ['Left gripper position [m]: ' num2str(get(handles.left_gripper_slider,'Value'))];
set(handles.left_gripper_lbl,'String',string_value);

string_value = ['Right gripper position [m]: ' num2str(get(handles.right_gripper_slider,'Value'))];
set(handles.right_gripper_lbl,'String',string_value);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gripper_control wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function youbot_gripper_encoders(message)

persistent gripper_L_position_value;
persistent gripper_R_position_value;

persistent gripper_L_speed_value;
persistent gripper_R_speed_value;


global gripper_L_speed_plot;
global gripper_L_position_plot;
global gripper_R_speed_plot;
global gripper_R_position_plot;


if isempty(gripper_L_position_value)
    gripper_L_position_value = zeros(1,100);
    gripper_R_position_value = zeros(1,100);
    
    gripper_L_speed_value = zeros(1,100);
    gripper_R_speed_value = zeros(1,100);
          
end

name = message.getName.get(0); 
pozicije = message.getPosition;
hitrosti = message.getVelocity;

if strcmp(name,'arm_joint_1')
    gripper_L_position_value = [gripper_L_position_value pozicije(6)];
    gripper_L_position_value(1) = [];
    
    gripper_R_position_value = [gripper_R_position_value pozicije(7)];
    gripper_R_position_value(1) = [];
    
    
%     gripper_L_speed_value = [gripper_L_speed_value hitrosti(6)];
%     gripper_L_speed_value(1) = [];
    
%     gripper_R_speed_value = [gripper_R_speed_value hitrosti(7)];
%     gripper_R_speed_value(1) = [];
    
%     set(gripper_L_speed_plot,'YData',gripper_L_speed_value);
    set(gripper_L_position_plot,'YData',gripper_L_position_value);
    
%     set(gripper_R_speed_plot,'YData',gripper_R_speed_value);
    set(gripper_R_position_plot,'YData',gripper_R_position_value);
    
    if hitrosti(6) ~= 0
        disp('Hitrost gripperja je razlicna od 0');
        disp(hitrosti(6));
    end
    
end

% --- Outputs from this function are returned to the command line.
function varargout = gripper_control_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function left_gripper_slider_Callback(hObject, eventdata, handles)
slider_value = get(hObject,'Value');
string_value = ['Left gripper position [m]: ' num2str(slider_value)];
set(handles.left_gripper_lbl,'String',string_value);

handles.gripper_L_message.setValue(slider_value);
% hObject    handle to left_gripper_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function left_gripper_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to left_gripper_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function right_gripper_slider_Callback(hObject, eventdata, handles)
slider_value = get(hObject,'Value');
string_value = ['Right gripper position [m]: ' num2str(slider_value)];
set(handles.right_gripper_lbl,'String',string_value);

handles.gripper_R_message.setValue(slider_value);
% hObject    handle to right_gripper_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function right_gripper_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to right_gripper_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in move_gripper_btn.
function move_gripper_btn_Callback(hObject, eventdata, handles)
disp('Executing move gripper command');
handles.youbot_gripper_publisher.publish(handles.youbot_gripper_message);
% hObject    handle to move_gripper_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
