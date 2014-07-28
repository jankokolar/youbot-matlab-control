function varargout = arm_control(varargin)
% ARM_CONTROL MATLAB code for arm_control.fig
%      ARM_CONTROL, by itself, creates a new ARM_CONTROL or raises the existing
%      singleton*.
%
%      H = ARM_CONTROL returns the handle to a new ARM_CONTROL or the handle to
%      the existing singleton*.
%
%      ARM_CONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ARM_CONTROL.M with the given input arguments.
%
%      ARM_CONTROL('Property','Value',...) creates a new ARM_CONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before arm_control_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to arm_control_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help arm_control

% Last Modified by GUIDE v2.5 23-Jul-2014 15:36:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @arm_control_OpeningFcn, ...
                   'gui_OutputFcn',  @arm_control_OutputFcn, ...
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


% --- Executes just before arm_control is made visible.
function arm_control_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to arm_control (see VARARGIN)

% Choose default command line output for arm_control
handles.output = hObject;

ros_node = varargin{1}{1}; %First element of varagin cell array is cell array containing rosnode
handles.ros_node = ros_node;

youbot_arm_publisher = rosmatlab.publisher('/arm_1/arm_controller/position_command','brics_actuator/JointPositions',ros_node);

youbot_arm_message = rosmatlab.message('brics_actuator/JointPositions', ros_node);

arm_header_message = rosmatlab.message('brics_actuator/Poison', ros_node);

joint_1_message =  rosmatlab.message('brics_actuator/JointValue', ros_node);

joint_2_message= rosmatlab.message('brics_actuator/JointValue', ros_node);

joint_3_message = rosmatlab.message('brics_actuator/JointValue', ros_node);

joint_4_message = rosmatlab.message('brics_actuator/JointValue', ros_node);

joint_5_message = rosmatlab.message('brics_actuator/JointValue', ros_node);

arm_header_message.setDescription('Hello from Matlab');
arm_header_message.setOriginator('Matlab');
arm_header_message.setQos(0.0);
youbot_arm_message.setPoisonStamp(arm_header_message);

joint_1_message.setJointUri('arm_joint_1');
joint_1_message.setUnit('rad');
joint_1_message.setValue(get(handles.joint_1_slider,'Min'));

joint_2_message.setJointUri('arm_joint_2');
joint_2_message.setUnit('rad');
joint_2_message.setValue(get(handles.joint_2_slider,'Min'));

joint_3_message.setJointUri('arm_joint_3');
joint_3_message.setUnit('rad');
joint_3_message.setValue(get(handles.joint_3_slider,'Max'));

joint_4_message.setJointUri('arm_joint_4');
joint_4_message.setUnit('rad');
joint_4_message.setValue(get(handles.joint_4_slider,'Min'));

joint_5_message.setJointUri('arm_joint_5');
joint_5_message.setUnit('rad');
joint_5_message.setValue(get(handles.joint_5_slider,'Min'));

youbot_arm_message.getPositions.add(joint_1_message);
youbot_arm_message.getPositions.add(joint_2_message);
youbot_arm_message.getPositions.add(joint_3_message);
youbot_arm_message.getPositions.add(joint_4_message);
youbot_arm_message.getPositions.add(joint_5_message);

youbot_arm_publisher.publish(youbot_arm_message);

handles.youbot_arm_publisher = youbot_arm_publisher;
handles.youbot_arm_message =  youbot_arm_message;
handles.joint_1_message = joint_1_message;
handles.joint_2_message = joint_2_message;
handles.joint_3_message = joint_3_message;
handles.joint_4_message = joint_4_message;
handles.joint_5_message = joint_5_message;

% here subscriber is defined
youbot_arm_encoder_reader = rosmatlab.subscriber('/joint_states','sensor_msgs/JointState',10,ros_node);
handles.youbot_arm_encoder_reader = youbot_arm_encoder_reader;

global joint_1_position_plot;
global joint_2_position_plot;
global joint_3_position_plot;
global joint_4_position_plot;
global joint_5_position_plot;

global joint_1_speed_plot;
global joint_2_speed_plot;
global joint_3_speed_plot;
global joint_4_speed_plot;
global joint_5_speed_plot;

axes(handles.position_axes);
joint_1_position_plot = plot(zeros(1,100),'b');
hold on;
joint_2_position_plot = plot(ones(1,100),'r');
joint_3_position_plot = plot(2*ones(1,100),'g');
joint_4_position_plot = plot(3*ones(1,100),'k');
joint_5_position_plot = plot(4*ones(1,100),'m');

axis([0 100 -3 6]);
ylabel('Joint  position  [rad]');


axes(handles.speed_axes);
joint_1_speed_plot = plot(zeros(1,100),'b');
hold on;
joint_2_speed_plot = plot(ones(1,100),'r');
joint_3_speed_plot = plot(2*ones(1,100),'g');
joint_4_speed_plot = plot(3*ones(1,100),'k');
joint_5_speed_plot = plot(4*ones(1,100),'m');
axis([0 100 -4 4]);
ylabel('Joint  speed  [rad/s]');

apply_plot_select_btn_Callback(hObject, eventdata, handles);

youbot_arm_encoder_reader.setOnNewMessageListeners({@youbot_arm_encoders})

% Update gui
string_value = ['Joint 1 :    ' num2str(get(handles.joint_1_slider,'Min'))];
set(handles.joint_1_lbl,'String',string_value);

string_value = ['Joint 2 :    ' num2str(get(handles.joint_2_slider,'Min'))];
set(handles.joint_2_lbl,'String',string_value);

string_value = ['Joint 3 :    ' num2str(get(handles.joint_3_slider,'Max'))];
set(handles.joint_3_lbl,'String',string_value);

string_value = ['Joint 4 :    ' num2str(get(handles.joint_4_slider,'Min'))];
set(handles.joint_4_lbl,'String',string_value);

string_value = ['Joint 5 :    ' num2str(get(handles.joint_5_slider,'Min'))];
set(handles.joint_5_lbl,'String',string_value);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes arm_control wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function youbot_arm_encoders(message)

persistent joint_1_position_value;
persistent joint_2_position_value;
persistent joint_3_position_value;
persistent joint_4_position_value;
persistent joint_5_position_value;

persistent joint_1_speed_value;
persistent joint_2_speed_value;
persistent joint_3_speed_value;
persistent joint_4_speed_value;
persistent joint_5_speed_value;

global joint_1_speed_plot;
global joint_1_position_plot;
global joint_2_speed_plot;
global joint_2_position_plot;
global joint_3_speed_plot;
global joint_3_position_plot;
global joint_4_speed_plot;
global joint_4_position_plot;
global joint_5_speed_plot;
global joint_5_position_plot;

if isempty(joint_1_position_value)
    joint_1_position_value = zeros(1,100);
    joint_2_position_value = zeros(1,100);
    joint_3_position_value = zeros(1,100);
    joint_4_position_value = zeros(1,100);
    joint_5_position_value = zeros(1,100);
    joint_1_speed_value = zeros(1,100);
    joint_2_speed_value = zeros(1,100);
    joint_3_speed_value = zeros(1,100);
    joint_4_speed_value = zeros(1,100);
    joint_5_speed_value = zeros(1,100);       
end

name = message.getName.get(0); 
pozicije = message.getPosition;
hitrosti = message.getVelocity;

if strcmp(name,'arm_joint_1')
    joint_1_position_value = [joint_1_position_value pozicije(1)];
    joint_1_position_value(1) = [];
    
    joint_2_position_value = [joint_2_position_value pozicije(2)];
    joint_2_position_value(1) = [];
    
    joint_3_position_value = [joint_3_position_value pozicije(3)];
    joint_3_position_value(1) = [];
    
    joint_4_position_value = [joint_4_position_value pozicije(4)];
    joint_4_position_value(1) = [];
    
    joint_5_position_value = [joint_5_position_value pozicije(5)];
    joint_5_position_value(1) = [];
    
    
    joint_1_speed_value = [joint_1_speed_value hitrosti(1)];
    joint_1_speed_value(1) = [];
    
    joint_2_speed_value = [joint_2_speed_value hitrosti(2)];
    joint_2_speed_value(1) = [];
    
    joint_3_speed_value = [joint_3_speed_value hitrosti(3)];
    joint_3_speed_value(1) = [];
    
    joint_4_speed_value = [joint_4_speed_value hitrosti(4)];
    joint_4_speed_value(1) = [];
    
    joint_5_speed_value = [joint_5_speed_value hitrosti(5)];
    joint_5_speed_value(1) = [];
    
    set(joint_1_speed_plot,'YData',joint_1_speed_value);
    set(joint_1_position_plot,'YData',joint_1_position_value);
    
    set(joint_2_speed_plot,'YData',joint_2_speed_value);
    set(joint_2_position_plot,'YData',joint_2_position_value);
    
    set(joint_3_speed_plot,'YData',joint_3_speed_value);
    set(joint_3_position_plot,'YData',joint_3_position_value);
    
    set(joint_4_speed_plot,'YData',joint_4_speed_value);
    set(joint_4_position_plot,'YData',joint_4_position_value);
    
    set(joint_5_speed_plot,'YData',joint_5_speed_value);
    set(joint_5_position_plot,'YData',joint_5_position_value);
    
end


% --- Outputs from this function are returned to the command line.
function varargout = arm_control_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function joint_1_slider_Callback(hObject, eventdata, handles)

slider_value = get(hObject,'Value');
string_value = ['Joint 1 :    ' num2str(slider_value)];
set(handles.joint_1_lbl,'String',string_value);
handles.joint_1_message.setValue(slider_value);

% hObject    handle to joint_1_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function joint_1_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to joint_1_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function joint_2_slider_Callback(hObject, eventdata, handles)
slider_value = get(hObject,'Value');
string_value = ['Joint 2 :    ' num2str(slider_value)];
set(handles.joint_2_lbl,'String',string_value);
handles.joint_2_message.setValue(slider_value);

% hObject    handle to joint_2_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function joint_2_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to joint_2_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function joint_3_slider_Callback(hObject, eventdata, handles)
slider_value = get(hObject,'Value');
string_value = ['Joint 3 :    ' num2str(slider_value)];
set(handles.joint_3_lbl,'String',string_value);
handles.joint_3_message.setValue(slider_value);
% hObject    handle to joint_3_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function joint_3_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to joint_3_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function joint_4_slider_Callback(hObject, eventdata, handles)
slider_value = get(hObject,'Value');
string_value = ['Joint 4 :    ' num2str(slider_value)];
set(handles.joint_4_lbl,'String',string_value);
handles.joint_4_message.setValue(slider_value);
% hObject    handle to joint_4_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function joint_4_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to joint_4_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function joint_5_slider_Callback(hObject, eventdata, handles)
slider_value = get(hObject,'Value');
string_value = ['Joint 5 :    ' num2str(slider_value)];
set(handles.joint_5_lbl,'String',string_value);
handles.joint_5_message.setValue(slider_value);
% hObject    handle to joint_5_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function joint_5_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to joint_5_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in move_arm_btn.
function move_arm_btn_Callback(hObject, eventdata, handles)
disp('Executing move arm commad');
handles.youbot_arm_publisher.publish(handles.youbot_arm_message);
% hObject    handle to move_arm_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in joint_1_chkb.
function joint_1_chkb_Callback(hObject, eventdata, handles)
% hObject    handle to joint_1_chkb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of joint_1_chkb


% --- Executes on button press in joint_2_chkb.
function joint_2_chkb_Callback(hObject, eventdata, handles)
% hObject    handle to joint_2_chkb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of joint_2_chkb


% --- Executes on button press in joint_3_chkb.
function joint_3_chkb_Callback(hObject, eventdata, handles)
% hObject    handle to joint_3_chkb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of joint_3_chkb


% --- Executes on button press in joint_4_chkb.
function joint_4_chkb_Callback(hObject, eventdata, handles)
% hObject    handle to joint_4_chkb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of joint_4_chkb


% --- Executes on button press in joint_5_chkb.
function joint_5_chkb_Callback(hObject, eventdata, handles)
% hObject    handle to joint_5_chkb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of joint_5_chkb


% --- Executes on button press in apply_plot_select_btn.
function apply_plot_select_btn_Callback(hObject, eventdata, handles)

global joint_1_speed_plot;
global joint_1_position_plot;
global joint_2_speed_plot;
global joint_2_position_plot;
global joint_3_speed_plot;
global joint_3_position_plot;
global joint_4_speed_plot;
global joint_4_position_plot;
global joint_5_speed_plot;
global joint_5_position_plot;

minimum_value = [];
maximum_value = [];

if get(handles.joint_1_chkb,'Value') == get(handles.joint_1_chkb,'Max')
    disp('Joint 1 plot selected')
    set(joint_1_position_plot,'Visible','on');
    set(joint_1_speed_plot,'Visible','on');
    minimum_value = [minimum_value get(handles.joint_1_slider,'Min')];
    maximum_value = [maximum_value get(handles.joint_1_slider,'Max')];
else
    disp('Joint 1 plot not selected')
    set(joint_1_position_plot,'Visible','off');
    set(joint_1_speed_plot,'Visible','off');
end

if get(handles.joint_2_chkb,'Value') == get(handles.joint_2_chkb,'Max')
    disp('Joint 2 plot selected')
    set(joint_2_position_plot,'Visible','on');
    set(joint_2_speed_plot,'Visible','on');
    minimum_value = [minimum_value get(handles.joint_2_slider,'Min')];
    maximum_value = [maximum_value get(handles.joint_2_slider,'Max')];
else
    disp('Joint 2 plot not selected')
    set(joint_2_position_plot,'Visible','off');
    set(joint_2_speed_plot,'Visible','off');
end
    
if get(handles.joint_3_chkb,'Value') == get(handles.joint_3_chkb,'Max')
    disp('Joint 3 plot selected')
    set(joint_3_position_plot,'Visible','on');
    set(joint_3_speed_plot,'Visible','on');
    minimum_value = [minimum_value get(handles.joint_3_slider,'Min')];
    maximum_value = [maximum_value get(handles.joint_3_slider,'Max')];
else
    disp('Joint 3 plot not selected')
    set(joint_3_position_plot,'Visible','off');
    set(joint_3_speed_plot,'Visible','off');
end

if get(handles.joint_4_chkb,'Value') == get(handles.joint_4_chkb,'Max')
    disp('Joint 4 plot selected')
    set(joint_4_position_plot,'Visible','on');
    set(joint_4_speed_plot,'Visible','on');
    minimum_value = [minimum_value get(handles.joint_4_slider,'Min')];
    maximum_value = [maximum_value get(handles.joint_4_slider,'Max')];
else
    disp('Joint 4 plot not selected')
    set(joint_4_position_plot,'Visible','off');
    set(joint_4_speed_plot,'Visible','off');
end

if get(handles.joint_5_chkb,'Value') == get(handles.joint_5_chkb,'Max')
    disp('Joint 5 plot selected')
    set(joint_5_position_plot,'Visible','on');
    set(joint_5_speed_plot,'Visible','on');
    minimum_value = [minimum_value get(handles.joint_5_slider,'Min')];
    maximum_value = [maximum_value get(handles.joint_5_slider,'Max')];
else
    disp('Joint 5 plot not selected')
    set(joint_5_position_plot,'Visible','off');
    set(joint_5_speed_plot,'Visible','off');
end

if ~isempty(minimum_value)
    plot_minimum_value = floor(min(minimum_value));
    plot_maximum_value = ceil(max(maximum_value));
    
    axes(handles.position_axes);
    axis([0 100 plot_minimum_value plot_maximum_value]);
end
% hObject    handle to apply_plot_select_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
