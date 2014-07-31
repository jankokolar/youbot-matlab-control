function varargout = youbot_control(varargin)
% YOUBOT_CONTROL MATLAB code for youbot_control.fig
%      YOUBOT_CONTROL, by itself, creates a new YOUBOT_CONTROL or raises the existing
%      singleton*.
%
%      H = YOUBOT_CONTROL returns the handle to a new YOUBOT_CONTROL or the handle to
%      the existing singleton*.
%
%      YOUBOT_CONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in YOUBOT_CONTROL.M with the given input arguments.
%
%      YOUBOT_CONTROL('Property','Value',...) creates a new YOUBOT_CONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before youbot_control_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to youbot_control_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help youbot_control

% Last Modified by GUIDE v2.5 21-Jul-2014 10:59:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @youbot_control_OpeningFcn, ...
                   'gui_OutputFcn',  @youbot_control_OutputFcn, ...
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


% --- Executes just before youbot_control is made visible.
function youbot_control_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to youbot_control (see VARARGIN)

% Choose default command line output for youbot_control
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes youbot_control wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = youbot_control_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function file_mnu_Callback(hObject, eventdata, handles)
% hObject    handle to file_mnu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function close_mnu_Callback(hObject, eventdata, handles)

if isfield(handles,'connected_to_ros')
    if handles.connected_to_ros == 1
        disp('Ups, Im connected');
        handles.ros_node.delete();
        handles.connected_to_ros = 0;
    end
else
    disp('Ne najdem fielda connected to ros');
end
guidata(hObject, handles);
if  (isfield(handles,'base_ctrl_handle'))&&(isfield(handles,'base_ctrl_opened'))&&(handles.base_ctrl_opened == 1)
    try
        delete(handles.base_ctrl_handle);
    catch
        disp('Hmm, base window seems to be already closed');
    end
end

if  (isfield(handles,'arm_ctrl_handle'))&&(isfield(handles,'arm_ctrl_opened'))&&(handles.arm_ctrl_opened == 1)
    try
        delete(handles.arm_ctrl_handle);
    catch
        disp('Hmm, arm window seems to be already closed');
    end
end

if  (isfield(handles,'gripper_ctrl_handle'))&&(isfield(handles,'gripper_ctrl_opened'))&&(handles.gripper_ctrl_opened == 1)
    try
        delete(handles.gripper_ctrl_handle);
    catch
        disp('Hmm, gripper window seems to be already closed');
    end
end
delete(handles.output);
%close all;
% hObject    handle to close_mnu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function window_mnu_Callback(hObject, eventdata, handles)
% hObject    handle to window_mnu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_mnu_Callback(hObject, eventdata, handles)
% hObject    handle to help_mnu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_content_mnu_Callback(hObject, eventdata, handles)

doc youbot_control;

% hObject    handle to help_content_mnu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_about_mnu_Callback(hObject, eventdata, handles)
% hObject    handle to help_about_mnu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function base_control_mnu_Callback(hObject, eventdata, handles)
handles.base_ctrl_handle = base_control({handles.ros_node});
handles.base_ctrl_opened = 1;
guidata(hObject, handles);
% hObject    handle to base_control_mnu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function arm_control_mnu_Callback(hObject, eventdata, handles)
handles.arm_ctrl_handle = arm_control({handles.ros_node});
handles.arm_ctrl_opened = 1;
guidata(hObject, handles);
% hObject    handle to arm_control_mnu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function gripper_control_mnu_Callback(hObject, eventdata, handles)
handles.gripper_ctrl_handle = gripper_control({handles.ros_node});
handles.gripper_ctrl_opened = 1;
guidata(hObject, handles);
% hObject    handle to gripper_control_mnu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in logo_btn.
function logo_btn_Callback(hObject, eventdata, handles)
web('www.robolab.si','-browser');

% hObject    handle to logo_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function roscore_ip_edt_Callback(hObject, eventdata, handles)
% hObject    handle to roscore_ip_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roscore_ip_edt as text
%        str2double(get(hObject,'String')) returns contents of roscore_ip_edt as a double


% --- Executes during object creation, after setting all properties.
function roscore_ip_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roscore_ip_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function roscore_port_edt_Callback(hObject, eventdata, handles)
% hObject    handle to roscore_port_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roscore_port_edt as text
%        str2double(get(hObject,'String')) returns contents of roscore_port_edt as a double


% --- Executes during object creation, after setting all properties.
function roscore_port_edt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roscore_port_edt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in connect_btn.
function connect_btn_Callback(hObject, eventdata, handles)
persistent ros_node;
button_state = get(hObject,'Value');

if button_state == get(hObject,'Max')    
     disp('Connect button is pressed');
     set(hObject,'Enable','inactive');
     handles.connected_to_ros= 1;
     ros_ip = get(handles.roscore_ip_edt,'String');
     disp(ros_ip);
     ros_port = get(handles.roscore_port_edt,'String');
     disp(ros_port);
     
     ros_node = rosmatlab.node('KUKA_MATLAB_CONTROL',ros_ip,str2num(ros_port));
     disp(ros_node);
     handles.ros_node = ros_node;
     
     set(handles.conection_status_lbl,'String','Connected');
     set(handles.conection_status_lbl,'BackgroundColor','green');
     set(handles.window_mnu,'Enable','on');
     
     set(hObject,'String','Disconnect');
     set(hObject,'Enable','on');
     
else
   disp('Connect button NOT pressed');
   set(hObject,'Enable','off');
   
   %Close base, arm and gripper control windows if they are opened
   
   if (isfield(handles,'base_ctrl_handle'))&&(isfield(handles,'base_ctrl_opened'))&&(handles.base_ctrl_opened == 1)
       try
           delete(handles.base_ctrl_handle) ;
       catch
            disp('Hmm, base window seems to be already closed');
       end
       handles.base_ctrl_opened = 0;
   end
   if (isfield(handles,'arm_ctrl_handle'))&&(isfield(handles,'arm_ctrl_opened'))&&(handles.arm_ctrl_opened == 1)
       try
           delete(handles.arm_ctrl_handle);
       catch
           disp('Hmm, arm window seems to be already closed');
       end
       handles.arm_ctrl_opened = 0;
   end
   
   if (isfield(handles,'gripper_ctrl_handle'))&&(isfield(handles,'gripper_ctrl_opened'))&&(handles.gripper_ctrl_opened == 1)
       try
           delete(handles.gripper_ctrl_handle);
       catch
           disp('Hmm, gripper window seems to be already closed');
       end
       handles.gripper_ctrl_opened = 0;
   end
   
   handles.connected_to_ros= 0; 
   ros_node.delete;
   handles.ros_node = 0;
   
  
   
   set(handles.conection_status_lbl,'String','Not Connected');
   set(handles.conection_status_lbl,'BackgroundColor','red');
   set(handles.window_mnu,'Enable','off');
   
   set(hObject,'String','Connect');
   set(hObject,'Enable','on');
end

guidata(hObject, handles);
% hObject    handle to connect_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close_mnu_Callback(hObject, eventdata, handles);

% Hint: delete(hObject) closes the figure
% delete(hObject);
