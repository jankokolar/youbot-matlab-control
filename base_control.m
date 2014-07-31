function varargout = base_control(varargin)
% BASE_CONTROL MATLAB code for base_control.fig
%      BASE_CONTROL, by itself, creates a new BASE_CONTROL or raises the existing
%      singleton*.
%
%      H = BASE_CONTROL returns the handle to a new BASE_CONTROL or the handle to
%      the existing singleton*.
%
%      BASE_CONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BASE_CONTROL.M with the given input arguments.
%
%      BASE_CONTROL('Property','Value',...) creates a new BASE_CONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before base_control_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to base_control_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help base_control

% Last Modified by GUIDE v2.5 31-Jul-2014 10:08:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @base_control_OpeningFcn, ...
                   'gui_OutputFcn',  @base_control_OutputFcn, ...
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


% --- Executes just before base_control is made visible.
function base_control_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to base_control (see VARARGIN)

% Choose default command line output for base_control
handles.output = hObject;
ros_node = varargin{1}{1}; %First element of varagin cell array is cell array containing rosnode
disp(ros_node);
class(ros_node);
handles.ros_node = ros_node;
% Here also publisher and message is created.

youbot_base_publisher = rosmatlab.publisher('/cmd_vel','geometry_msgs/Twist',ros_node);
handles.youbot_base_publisher = youbot_base_publisher;

youbot_base_message = rosmatlab.message('geometry_msgs/Twist',ros_node);
handles.youbot_base_message = youbot_base_message;

youbot_base_message.getLinear.setX(0);
youbot_base_message.getLinear.setY(0);
youbot_base_message.getLinear.setZ(0);

youbot_base_message.getAngular.setX(0);
youbot_base_message.getAngular.setY(0);
youbot_base_message.getAngular.setZ(0);

youbot_base_publisher.publish(youbot_base_message);

% reader
youbot_base_encoder_reader = rosmatlab.subscriber('/joint_states','sensor_msgs/JointState',10,ros_node);
handles.youbot_base_encoder_reader = youbot_base_encoder_reader;

global wheel_fl_position_plot;
global wheel_fr_position_plot;
global wheel_bl_position_plot;
global wheel_br_position_plot;
global caster_fl_position_plot;
global caster_fr_position_plot;
global caster_bl_position_plot;
global caster_br_position_plot;

global wheel_fl_speed_plot;
global wheel_fr_speed_plot;
global wheel_bl_speed_plot;
global wheel_br_speed_plot;
global caster_fl_speed_plot;
global caster_fr_speed_plot;
global caster_bl_speed_plot;
global caster_br_speed_plot;

axes(handles.base_position_axes);
wheel_fl_position_plot = plot(zeros(1,100),'b');
hold on;
wheel_fr_position_plot = plot(ones(1,100),'r');
wheel_bl_position_plot = plot(2*ones(1,100),'g');
wheel_br_position_plot = plot(3*ones(1,100),'k');
caster_fl_position_plot = plot(4*ones(1,100),'m');
caster_fr_position_plot = plot(4*ones(1,100),'c');
caster_bl_position_plot = plot(4*ones(1,100),'y');
caster_br_position_plot = plot(4*ones(1,100),'m');

%axis([0 100 -360 360]);
ylabel('Joint  position  [rad]');

axes(handles.base_speed_axes);

wheel_fl_speed_plot = plot(zeros(1,100),'b');
hold on;
wheel_fr_speed_plot = plot(ones(1,100),'r');
wheel_bl_speed_plot = plot(2*ones(1,100),'g');
wheel_br_speed_plot = plot(3*ones(1,100),'k');
caster_fl_speed_plot = plot(4*ones(1,100),'m');
caster_fr_speed_plot = plot(4*ones(1,100),'c');
caster_bl_speed_plot = plot(4*ones(1,100),'y');
caster_br_speed_plot = plot(4*ones(1,100),'m');
%axis([0 100 -20 20]);
ylabel('Joint  speed  [rad/s]');

apply_base_plot_btn_Callback(hObject, eventdata, handles);

youbot_base_encoder_reader.setOnNewMessageListeners({@youbot_base_encoders})



% Here update gui

slider_value = get(handles.rot_speed_slider,'Value');
string_value = ['Rotational speed: ' num2str(slider_value)];
set(handles.rot_speed_lbl,'String',string_value);

slider_value = get(handles.linear_speed_slider,'Value');
string_value = ['Linear speed: ' num2str(slider_value)];
set(handles.linear_speed_lbl,'String',string_value);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes base_control wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function youbot_base_encoders(message)

persistent wheel_fl_position_value;
persistent wheel_fr_position_value;
persistent wheel_bl_position_value;
persistent wheel_br_position_value;
persistent caster_fl_position_value;
persistent caster_fr_position_value;
persistent caster_bl_position_value;
persistent caster_br_position_value;

persistent wheel_fl_speed_value;
persistent wheel_fr_speed_value;
persistent wheel_bl_speed_value;
persistent wheel_br_speed_value;
persistent caster_fl_speed_value;
persistent caster_fr_speed_value;
persistent caster_bl_speed_value;
persistent caster_br_speed_value;



global wheel_fl_position_plot;
global wheel_fr_position_plot;
global wheel_bl_position_plot;
global wheel_br_position_plot;
global caster_fl_position_plot;
global caster_fr_position_plot;
global caster_bl_position_plot;
global caster_br_position_plot;

global wheel_fl_speed_plot;
global wheel_fr_speed_plot;
global wheel_bl_speed_plot;
global wheel_br_speed_plot;
global caster_fl_speed_plot;
global caster_fr_speed_plot;
global caster_bl_speed_plot;
global caster_br_speed_plot;


if isempty(wheel_fl_position_value)
    wheel_fl_position_value = zeros(1,100);
    wheel_fr_position_value = zeros(1,100);
    wheel_bl_position_value = zeros(1,100);
    wheel_br_position_value = zeros(1,100);
    caster_fl_position_value = zeros(1,100);
    caster_fr_position_value = zeros(1,100);
    caster_bl_position_value = zeros(1,100);
    caster_br_position_value = zeros(1,100);
    
    wheel_fl_speed_value = zeros(1,100);
    wheel_fr_speed_value = zeros(1,100);
    wheel_bl_speed_value = zeros(1,100);
    wheel_br_speed_value = zeros(1,100);
    caster_fl_speed_value = zeros(1,100); 
    caster_fr_speed_value = zeros(1,100); 
    caster_bl_speed_value = zeros(1,100); 
    caster_br_speed_value = zeros(1,100); 
    
    
end

name = message.getName.get(0); 
pozicije = message.getPosition;
hitrosti = message.getVelocity;

if strcmp(name,'wheel_joint_fl')
    wheel_fl_position_value = [wheel_fl_position_value pozicije(1)];
    wheel_fl_position_value(1) = [];
    
    wheel_fr_position_value = [wheel_fr_position_value pozicije(2)];
    wheel_fr_position_value(1) = [];
    
    wheel_bl_position_value = [wheel_bl_position_value pozicije(3)];
    wheel_bl_position_value(1) = [];
    
    wheel_br_position_value = [wheel_br_position_value pozicije(4)];
    wheel_br_position_value(1) = [];
    
    caster_fl_position_value = [caster_fl_position_value pozicije(5)];
    caster_fl_position_value(1) = [];
    
    caster_fr_position_value = [caster_fr_position_value pozicije(6)];
    caster_fr_position_value(1) = [];
    
    caster_bl_position_value = [caster_bl_position_value pozicije(7)];
    caster_bl_position_value(1) = [];
    
    caster_br_position_value = [caster_br_position_value pozicije(8)];
    caster_br_position_value(1) = [];
    
    
    wheel_fl_speed_value = [wheel_fl_speed_value hitrosti(1)];
    wheel_fl_speed_value(1) = [];
    
    wheel_fr_speed_value = [wheel_fr_speed_value hitrosti(2)];
    wheel_fr_speed_value(1) = [];
    
    wheel_bl_speed_value = [wheel_bl_speed_value hitrosti(3)];
    wheel_bl_speed_value(1) = [];
    
    wheel_br_speed_value = [wheel_br_speed_value hitrosti(4)];
    wheel_br_speed_value(1) = [];
    
    caster_fl_speed_value = [caster_fl_speed_value hitrosti(5)];
    caster_fl_speed_value(1) = [];
    
    caster_fr_speed_value = [caster_fr_speed_value hitrosti(6)];
    caster_fr_speed_value(1) = [];
    
    caster_bl_speed_value = [caster_bl_speed_value hitrosti(7)];
    caster_bl_speed_value(1) = [];
    
    caster_br_speed_value = [caster_br_speed_value hitrosti(8)];
    caster_br_speed_value(1) = [];
    
    
    set(wheel_fl_speed_plot,'YData',wheel_fl_speed_value);
    set(wheel_fl_position_plot,'YData',wheel_fl_position_value);
    
    set(wheel_fr_speed_plot,'YData',wheel_fr_speed_value);
    set(wheel_fr_position_plot,'YData',wheel_fr_position_value);
    
    set(wheel_bl_speed_plot,'YData',wheel_bl_speed_value);
    set(wheel_bl_position_plot,'YData',wheel_bl_position_value);
    
    set(wheel_br_speed_plot,'YData',wheel_br_speed_value);
    set(wheel_br_position_plot,'YData',wheel_br_position_value);
    
    set(caster_fl_speed_plot,'YData',caster_fl_speed_value);
    set(caster_fl_position_plot,'YData',caster_fl_position_value);
    
    set(caster_fr_speed_plot,'YData',caster_fr_speed_value);
    set(caster_fr_position_plot,'YData',caster_fr_position_value);
    
    set(caster_bl_speed_plot,'YData',caster_bl_speed_value);
    set(caster_bl_position_plot,'YData',caster_bl_position_value);
    
    set(caster_br_speed_plot,'YData',caster_br_speed_value);
    set(caster_br_position_plot,'YData',caster_br_position_value);
    
end


% --- Outputs from this function are returned to the command line.
function varargout = base_control_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in stop_btn.
function stop_btn_Callback(hObject, eventdata, handles)

set(handles.status_lbl,'String','Emergency STOP button pressed');

handles.youbot_base_message.getLinear.setX(0);
handles.youbot_base_message.getLinear.setY(0);
handles.youbot_base_message.getLinear.setZ(0);

handles.youbot_base_message.getAngular.setX(0);
handles.youbot_base_message.getAngular.setY(0);
handles.youbot_base_message.getAngular.setZ(0);

handles.youbot_base_publisher.publish(handles.youbot_base_message);

% Update handles structure
guidata(hObject, handles);

% hObject    handle to stop_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function rot_speed_slider_Callback(hObject, eventdata, handles)
slider_value = get(hObject,'Value');
string_value = ['Rotational speed: ' num2str(slider_value)];
set(handles.rot_speed_lbl,'String',string_value);
% hObject    handle to rot_speed_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function rot_speed_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rot_speed_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in rotate_right_btn.
function rotate_right_btn_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
vel = get(handles.rot_speed_slider,'Value');
if button_state == get(hObject,'Max')
    disp('Rotate right button pressed');
    set(handles.status_lbl,'String','Rotating to the right');

    
    handles.youbot_base_message.getLinear.setX(0);
    handles.youbot_base_message.getLinear.setY(0);
    handles.youbot_base_message .getLinear.setZ(0);
    
    handles.youbot_base_message.getAngular.setX(0);
    handles.youbot_base_message.getAngular.setY(0);
    handles.youbot_base_message.getAngular.setZ(-1.0*vel);
    
    handles.youbot_base_publisher.publish(handles.youbot_base_message);

    
else
    disp('Rotate right button depressed')
    set(handles.status_lbl,'String',' ');
    handles.youbot_base_message.getLinear.setX(0);
    handles.youbot_base_message.getLinear.setY(0);
    handles.youbot_base_message .getLinear.setZ(0);
    
    handles.youbot_base_message.getAngular.setX(0);
    handles.youbot_base_message.getAngular.setY(0);
    handles.youbot_base_message.getAngular.setZ(0);
    
    handles.youbot_base_publisher.publish(handles.youbot_base_message);
end
   

% hObject    handle to rotate_right_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rotate_right_btn


% --- Executes on button press in rotate_left_btn.
function rotate_left_btn_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
vel = get(handles.rot_speed_slider,'Value');
if button_state == get(hObject,'Max')
    disp('Rotate left button pressed');
    set(handles.status_lbl,'String','Rotating to the left');
    
    handles.youbot_base_message.getLinear.setX(0);
    handles.youbot_base_message.getLinear.setY(0);
    handles.youbot_base_message .getLinear.setZ(0);
    
    handles.youbot_base_message.getAngular.setX(0);
    handles.youbot_base_message.getAngular.setY(0);
    handles.youbot_base_message.getAngular.setZ(vel);
    
    handles.youbot_base_publisher.publish(handles.youbot_base_message);

    
else
    disp('Rotate left button depressed');
    set(handles.status_lbl,'String',' ');
    handles.youbot_base_message.getLinear.setX(0);
    handles.youbot_base_message.getLinear.setY(0);
    handles.youbot_base_message .getLinear.setZ(0);
    
    handles.youbot_base_message.getAngular.setX(0);
    handles.youbot_base_message.getAngular.setY(0);
    handles.youbot_base_message.getAngular.setZ(0);
    
    handles.youbot_base_publisher.publish(handles.youbot_base_message);
end

% hObject    handle to rotate_left_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rotate_left_btn


% --- Executes on slider movement.
function linear_speed_slider_Callback(hObject, eventdata, handles)

slider_value = get(hObject,'Value');
string_value = ['Linear speed: ' num2str(slider_value)];
set(handles.linear_speed_lbl,'String',string_value);
% hObject    handle to linear_speed_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function linear_speed_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linear_speed_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in move_forward_btn.
function move_forward_btn_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
vel = get(handles.linear_speed_slider,'Value');
if button_state == get(hObject,'Max')
    disp('Move forward button pressed');
    set(handles.status_lbl,'String','Moving forward');
    
    handles.youbot_base_message.getLinear.setX(vel);
    handles.youbot_base_message.getLinear.setY(0);
    handles.youbot_base_message .getLinear.setZ(0);
    
    handles.youbot_base_message.getAngular.setX(0);
    handles.youbot_base_message.getAngular.setY(0);
    handles.youbot_base_message.getAngular.setZ(0);
    
    handles.youbot_base_publisher.publish(handles.youbot_base_message);

    
else
    disp('Move forward button depressed');
    set(handles.status_lbl,'String',' ');
    handles.youbot_base_message.getLinear.setX(0);
    handles.youbot_base_message.getLinear.setY(0);
    handles.youbot_base_message .getLinear.setZ(0);
    
    handles.youbot_base_message.getAngular.setX(0);
    handles.youbot_base_message.getAngular.setY(0);
    handles.youbot_base_message.getAngular.setZ(0);
    
    handles.youbot_base_publisher.publish(handles.youbot_base_message);
end

% hObject    handle to move_forward_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of move_forward_btn


% --- Executes on button press in move_left_btn.
function move_left_btn_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
vel = get(handles.linear_speed_slider,'Value');
if button_state == get(hObject,'Max')
    disp('Move left button pressed');
    set(handles.status_lbl,'String','Moving to the left');
    
    handles.youbot_base_message.getLinear.setX(0);
    handles.youbot_base_message.getLinear.setY(-1.0*vel);
    handles.youbot_base_message .getLinear.setZ(0);
    
    handles.youbot_base_message.getAngular.setX(0);
    handles.youbot_base_message.getAngular.setY(0);
    handles.youbot_base_message.getAngular.setZ(0);
    
    handles.youbot_base_publisher.publish(handles.youbot_base_message);

    
else
    disp('Move left button depressed');
    set(handles.status_lbl,'String',' ');
    handles.youbot_base_message.getLinear.setX(0);
    handles.youbot_base_message.getLinear.setY(0);
    handles.youbot_base_message .getLinear.setZ(0);
    
    handles.youbot_base_message.getAngular.setX(0);
    handles.youbot_base_message.getAngular.setY(0);
    handles.youbot_base_message.getAngular.setZ(0);
    
    handles.youbot_base_publisher.publish(handles.youbot_base_message);
end
% hObject    handle to move_left_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of move_left_btn


% --- Executes on button press in move_right_btn.
function move_right_btn_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
vel = get(handles.linear_speed_slider,'Value');
if button_state == get(hObject,'Max')
    disp('Move right button pressed');
    set(handles.status_lbl,'String','Moving to the right');
    handles.youbot_base_message.getLinear.setX(0);
    handles.youbot_base_message.getLinear.setY(vel);
    handles.youbot_base_message .getLinear.setZ(0);
    
    handles.youbot_base_message.getAngular.setX(0);
    handles.youbot_base_message.getAngular.setY(0);
    handles.youbot_base_message.getAngular.setZ(0);
    
    handles.youbot_base_publisher.publish(handles.youbot_base_message);

    
else
    disp('Move right button depressed');
    set(handles.status_lbl,'String',' ');
    handles.youbot_base_message.getLinear.setX(0);
    handles.youbot_base_message.getLinear.setY(0);
    handles.youbot_base_message .getLinear.setZ(0);
    
    handles.youbot_base_message.getAngular.setX(0);
    handles.youbot_base_message.getAngular.setY(0);
    handles.youbot_base_message.getAngular.setZ(0);
    
    handles.youbot_base_publisher.publish(handles.youbot_base_message);
end
% hObject    handle to move_right_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of move_right_btn


% --- Executes on button press in move_back_btn.
function move_back_btn_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
vel = get(handles.linear_speed_slider,'Value');
if button_state == get(hObject,'Max')
    disp('Move back button pressed');
    set(handles.status_lbl,'String','Moving back');
    handles.youbot_base_message.getLinear.setX(-1.0*vel);
    handles.youbot_base_message.getLinear.setY(0);
    handles.youbot_base_message .getLinear.setZ(0);
    
    handles.youbot_base_message.getAngular.setX(0);
    handles.youbot_base_message.getAngular.setY(0);
    handles.youbot_base_message.getAngular.setZ(0);
    
    handles.youbot_base_publisher.publish(handles.youbot_base_message);

    
else
    disp('Move back button depressed');
    set(handles.status_lbl,'String',' ');
    handles.youbot_base_message.getLinear.setX(0);
    handles.youbot_base_message.getLinear.setY(0);
    handles.youbot_base_message .getLinear.setZ(0);
    
    handles.youbot_base_message.getAngular.setX(0);
    handles.youbot_base_message.getAngular.setY(0);
    handles.youbot_base_message.getAngular.setZ(0);
    
    handles.youbot_base_publisher.publish(handles.youbot_base_message);
end
% hObject    handle to move_back_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of move_back_btn


% --- Executes on button press in wheel_fl_chkb.
function wheel_fl_chkb_Callback(hObject, eventdata, handles)
% hObject    handle to wheel_fl_chkb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of wheel_fl_chkb


% --- Executes on button press in wheel_fr_chkb.
function wheel_fr_chkb_Callback(hObject, eventdata, handles)
% hObject    handle to wheel_fr_chkb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of wheel_fr_chkb


% --- Executes on button press in wheel_bl_chkb.
function wheel_bl_chkb_Callback(hObject, eventdata, handles)
% hObject    handle to wheel_bl_chkb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of wheel_bl_chkb


% --- Executes on button press in wheel_br_chkb.
function wheel_br_chkb_Callback(hObject, eventdata, handles)
% hObject    handle to wheel_br_chkb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of wheel_br_chkb


% --- Executes on button press in caster_fl_chkb.
function caster_fl_chkb_Callback(hObject, eventdata, handles)
% hObject    handle to caster_fl_chkb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of caster_fl_chkb


% --- Executes on button press in caster_fr_chkb.
function caster_fr_chkb_Callback(hObject, eventdata, handles)
% hObject    handle to caster_fr_chkb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of caster_fr_chkb


% --- Executes on button press in caster_bl_chkb.
function caster_bl_chkb_Callback(hObject, eventdata, handles)
% hObject    handle to caster_bl_chkb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of caster_bl_chkb


% --- Executes on button press in caster_br_chkb.
function caster_br_chkb_Callback(hObject, eventdata, handles)
% hObject    handle to caster_br_chkb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of caster_br_chkb


% --- Executes on button press in apply_base_plot_btn.
function apply_base_plot_btn_Callback(hObject, eventdata, handles)
% hObject    handle to apply_base_plot_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global wheel_fl_position_plot;
global wheel_fr_position_plot;
global wheel_bl_position_plot;
global wheel_br_position_plot;
global caster_fl_position_plot;
global caster_fr_position_plot;
global caster_bl_position_plot;
global caster_br_position_plot;

global wheel_fl_speed_plot;
global wheel_fr_speed_plot;
global wheel_bl_speed_plot;
global wheel_br_speed_plot;
global caster_fl_speed_plot;
global caster_fr_speed_plot;
global caster_bl_speed_plot;
global caster_br_speed_plot;

if get(handles.wheel_fl_chkb,'Value') == get(handles.wheel_fl_chkb,'Max')
    disp('Wheel fl plot selected');
    set(wheel_fl_position_plot,'Visible','on');
    set(wheel_fl_speed_plot,'Visible','on');
   
else
    disp('Wheel fl plot not selected');
    set(wheel_fl_position_plot,'Visible','off');
    set(wheel_fl_speed_plot,'Visible','off');
end

if get(handles.wheel_fr_chkb,'Value') == get(handles.wheel_fr_chkb,'Max')
    disp('Wheel fr plot selected');
    set(wheel_fr_position_plot,'Visible','on');
    set(wheel_fr_speed_plot,'Visible','on');
    
else
    disp('Wheel fr plot not selected');
    set(wheel_fr_position_plot,'Visible','off');
    set(wheel_fr_speed_plot,'Visible','off');
end
    
if get(handles.wheel_bl_chkb,'Value') == get(handles.wheel_bl_chkb,'Max')
    disp('Wheel bl plot selected');
    set(wheel_bl_position_plot,'Visible','on');
    set(wheel_bl_speed_plot,'Visible','on');
  
else
    disp('Wheel bl plot not selected');
    set(wheel_bl_position_plot,'Visible','off');
    set(wheel_bl_speed_plot,'Visible','off');
end

if get(handles.wheel_br_chkb,'Value') == get(handles.wheel_br_chkb,'Max')
    disp('Wheel br plot selected')
    set(wheel_br_position_plot,'Visible','on');
    set(wheel_br_speed_plot,'Visible','on');
   
else
    disp('Wheel br plot not selected');
    set(wheel_br_position_plot,'Visible','off');
    set(wheel_br_speed_plot,'Visible','off');
end

if get(handles.caster_fl_chkb,'Value') == get(handles.caster_fl_chkb,'Max')
    disp('Caster fl plot selected')
    set(caster_fl_position_plot,'Visible','on');
    set(caster_fl_speed_plot,'Visible','on');
  
else
    disp('Caster fl plot not selected')
    set(caster_fl_position_plot,'Visible','off');
    set(caster_fl_speed_plot,'Visible','off');
end

if get(handles.caster_fr_chkb,'Value') == get(handles.caster_fr_chkb,'Max')
    disp('Caster fr plot selected')
    set(caster_fr_position_plot,'Visible','on');
    set(caster_fr_speed_plot,'Visible','on');
  
else
    disp('Caster fr plot not selected')
    set(caster_fr_position_plot,'Visible','off');
    set(caster_fr_speed_plot,'Visible','off');
end

if get(handles.caster_bl_chkb,'Value') == get(handles.caster_bl_chkb,'Max')
    disp('Caster bl plot selected')
    set(caster_bl_position_plot,'Visible','on');
    set(caster_bl_speed_plot,'Visible','on');
  
else
    disp('Caster bl plot not selected')
    set(caster_bl_position_plot,'Visible','off');
    set(caster_bl_speed_plot,'Visible','off');
end

if get(handles.caster_br_chkb,'Value') == get(handles.caster_br_chkb,'Max')
    disp('Caster br plot selected')
    set(caster_br_position_plot,'Visible','on');
    set(caster_br_speed_plot,'Visible','on');
  
else
    disp('Caster br plot not selected')
    set(caster_br_position_plot,'Visible','off');
    set(caster_br_speed_plot,'Visible','off');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.youbot_base_encoder_reader.setOnNewMessageListeners({});
% Hint: delete(hObject) closes the figure
delete(hObject);
