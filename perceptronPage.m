function varargout = perceptronPage(varargin)
% PERCEPTRONPAGE MATLAB code for perceptronPage.fig
%      PERCEPTRONPAGE, by itself, creates a new PERCEPTRONPAGE or raises the existing
%      singleton*.
%
%      H = PERCEPTRONPAGE returns the handle to a new PERCEPTRONPAGE or the handle to
%      the existing singleton*.
%
%      PERCEPTRONPAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PERCEPTRONPAGE.M with the given input arguments.
%
%      PERCEPTRONPAGE('Property','Value',...) creates a new PERCEPTRONPAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before perceptronPage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to perceptronPage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help perceptronPage

% Last Modified by GUIDE v2.5 01-Apr-2017 21:57:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @perceptronPage_OpeningFcn, ...
                   'gui_OutputFcn',  @perceptronPage_OutputFcn, ...
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


% --- Executes just before perceptronPage is made visible.
function perceptronPage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to perceptronPage (see VARARGIN)

% Choose default command line output for perceptronPage
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%initialise handle variable and colours
handles.inputData = [];
handles.weights = [];
handles.weightedSum = 0;

set (handles.weightedSumLabel,'String','');
set (handles.actualOutputLabel,'String','');
set (handles.errorLabel,'String','');
    
setDefaultColours(hObject,handles);
    handles = guidata(hObject);
    
randInputButton_Callback(hObject, eventdata, handles);
randWeightsButton_Callback(hObject, eventdata, handles);

%randomly set the desired output to 1 or -1
set (handles.desiredOutputEdit,'String',2*(rand > 0.5) - 1);

guidata(hObject,handles);
    
function setDefaultColours(hObject,handles)
% make the colour selectors invisible to show they are not currently in use
% create and initialise colour variables
handles.notRunningColour = [.8 .8 .8];
handles.processingColour = [1 1 0];
handles.completedColour = [0 1 0];

set (handles.weightedSumLabel,'BackgroundColor',handles.notRunningColour);
set (handles.notRunningPanel,'BackgroundColor',handles.notRunningColour);
set (handles.processingPanel,'BackgroundColor',handles.processingColour);
set (handles.completedPanel,'BackgroundColor',handles.completedColour);

set (handles.desiredOutputPanel,'BackgroundColor','w');

guidata(hObject,handles);

% UIWAIT makes perceptronPage wait for user response (see UIRESUME)
% uiwait(handles.perceptronPage);


% --- Outputs from this function are returned to the command line.
function varargout = perceptronPage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function backToMainMenu_Callback(hObject, eventdata, handles)
close(perceptronPage)
mainMenu

function playButton_Callback(hObject, eventdata, handles)

set (handles.desiredOutputPanel,'BackgroundColor','w');
set (handles.weightedSumLabel,'BackgroundColor',handles.processingColour);
pause(0.5);

handles.weights = [str2double(get(handles.w0Edit,'String'));...
                    str2double(get(handles.w1Edit,'String'));...
                    str2double(get(handles.w2Edit,'String'))];

handles.inputData = [1; str2double(get(handles.x1Edit,'String'));...
                        str2double(get(handles.x2Edit,'String'));...
                        str2double(get(handles.desiredOutputEdit,'String'))];

if ~any(handles.weights) || ~any(handles.inputData)
    return;
end

handles.weightedSum = handles.weights' * handles.inputData(1:3,1);

if (get(handles.stepToggle,'Value')== 1)

    handles.actualOutput = sign(handles.weightedSum);
    handles.error = handles.inputData(4) - handles.actualOutput;
    
%     syms x
%     fplot(heaviside((x-handles.weightedSum),[handles.weightedSum-5,handles.weightedSum+5])
%     hold on;
%     plot(handles.stepSigmoidGraph, handles.weightedSum, handles.actualOutput,'x')
%     %fplot(heaviside(handles.weightedSum),[handles.weightedSum*0.5,handles.weightedSum*1.5]);
%     
% %     xAxes = [handles.weightedSum*0.5:0.1:handles.weightedSum*1.5];
% %     
% %     plot (handles.stepSigmoidGraph,xAxes,2*(xAxes>handles.weights(1))-1)
% %     hold on;
%     %plot (handles.stepSigmoidGraph,handles.weightedSum,handles.actualOutput)

elseif (get(handles.sigmoidToggle,'Value')==1)

    handles.actualOutput = 1 ./ (1 + exp(-handles.weightedSum));
    handles.error = handles.inputData(4) - handles.actualOutput;

    %sigmoid squashes to [0,1] range. Need classes [-1,+1] so
    %if x < 0.5 then -1 else +1
    handles.actualOutput(handles.actualOutput < 0.5) = -1;
    handles.actualOutput(handles.actualOutput >= 0.5) = 1;

else
    %Should not reach this stage. elseif's used to be specific with
    %options available
end

set (handles.weightedSumLabel,'String',handles.weightedSum);
set (handles.actualOutputLabel,'String',handles.actualOutput);

set (handles.errorLabel,'String',handles.error);

set (handles.desiredOutputPanel,'BackgroundColor',handles.completedColour);
set (handles.weightedSumLabel,'BackgroundColor',handles.notRunningColour);

function desiredOutputEdit_Callback(hObject, eventdata, handles)

desiredOutput = str2double(get(handles.desiredOutputEdit,'String'));

if ~ismember(desiredOutput,[1,-1])
    msgbox('Desired Output must be either 1 or -1', 'Error', 'error');
    set (handles.desiredOutputEdit, 'String', '');
end
        function desiredOutputEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function x1Edit_Callback(hObject, eventdata, handles)
x1Edit = str2double(get(handles.x1Edit,'String'));

if ~(isnumeric(x1Edit) && ~isnan(x1Edit)&& isreal(x1Edit))
    msgbox('x1 input must be a number (not NaN or imaginary)', 'Error', 'error');
    set (handles.x1Edit, 'String', '');
end
        function x1Edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function x2Edit_Callback(hObject, eventdata, handles)
x2Edit = str2double(get(handles.x2Edit,'String'));

if ~(isnumeric(x2Edit) && ~isnan(x2Edit) && isreal(x2Edit))
    msgbox('x2 input must be a number (not NaN or imaginary)', 'Error', 'error');
    set (handles.x2Edit, 'String', '');
end
        function x2Edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function w0Edit_Callback(hObject, eventdata, handles)
w0Edit = str2double(get(handles.w0Edit,'String'));

if ~(isnumeric(w0Edit) && ~isnan(w0Edit) && isreal(w0Edit))
    msgbox('w0 input must be a number (not NaN or imaginary)', 'Error', 'error');
    set (handles.w0Edit, 'String', '');
end
        function w0Edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function w1Edit_Callback(hObject, eventdata, handles)
w1Edit = str2double(get(handles.w1Edit,'String'));

if ~(isnumeric(w1Edit) && ~isnan(w1Edit) && isreal(w1Edit))
    msgbox('w1 input must be a number (not NaN or imaginary)', 'Error', 'error');
    set (handles.w1Edit, 'String', '');
end
        function w1Edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function w2Edit_Callback(hObject, eventdata, handles)

w2Edit = str2double(get(handles.w2Edit,'String'));

if ~(isnumeric(w2Edit) && ~isnan(w2Edit) && isreal(w2Edit))
    msgbox('w2 input must be a number (not NaN or imaginary)', 'Error', 'error');
    set (handles.w2Edit, 'String', '');
end
        function w2Edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function notRunningColourChoice_Callback(hObject, eventdata, handles)
handles.notRunningColour=uisetcolor;

if handles.notRunningColour == 0
     return;
end

set (handles.notRunningPanel,'BackgroundColor',handles.notRunningColour);
guidata(hObject,handles);
function processingColourChoice_Callback(hObject, eventdata, handles)
handles.processingColour=uisetcolor;

if handles.processingColour == 0
     return;
end

set (handles.processingPanel,'BackgroundColor',handles.processingColour);
guidata(hObject,handles);
function completedColourChoice_Callback(hObject, eventdata, handles)
handles.completedColour=uisetcolor;

if handles.completedColour == 0
     return;
end

set (handles.completedPanel,'BackgroundColor',handles.completedColour);
guidata(hObject,handles);
function defaultColoursButton_Callback(hObject, eventdata, handles)
setDefaultColours(hObject,handles);
%======================
function randInputButton_Callback(hObject, eventdata, handles)
set (handles.x1Edit,'String',randn);
set (handles.x2Edit,'String',randn);
function randWeightsButton_Callback(hObject, eventdata, handles)
set (handles.w0Edit,'String',randn);
set (handles.w1Edit,'String',randn);
set (handles.w2Edit,'String',randn);
