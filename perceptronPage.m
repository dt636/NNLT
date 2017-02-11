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

% Last Modified by GUIDE v2.5 13-Dec-2016 14:42:56

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

set (handles.x1InputEdit,'String','0.1');
set (handles.x2InputEdit,'String','0.3');
set (handles.w0InputEdit,'String','0.3');
set (handles.w1InputEdit,'String','3.1');
set (handles.w2InputEdit,'String','0.5');
set (handles.desiredOutputEdit,'String','1');
set (handles.y0Output,'String','');

set (handles.anpx1InputEdit,'String',get(handles.x1InputEdit,'String'));
set (handles.anpx2InputEdit,'String',get(handles.x2InputEdit,'String'));
set (handles.anpw0InputEdit,'String',get(handles.w0InputEdit,'String'));
set (handles.anpw1InputEdit,'String',get(handles.w1InputEdit,'String'));
set (handles.anpw2InputEdit,'String',get(handles.w2InputEdit,'String'));
set (handles.anpdOutputEdit,'String',get(handles.desiredOutputEdit,'String'));
set (handles.anpy0Output,'String',get(handles.y0Output,'String'));

set (handles.notRunningColourChoice,'Visible','off');
set (handles.processingColourChoice,'Visible','off');
set (handles.completedColourChoice,'Visible','off');
    
set (handles.statusColourToggle,'String','Off');

% %set (handles.x0Input,'Units','pixels');
% %set (handles.x1InputEdit,'Units','pixels');
% %set (handles.x2InputEdit,'Units','pixels');
% 
% %set (handles.w0InputEdit,'Units','pixels');
% %set (handles.w1InputEdit,'Units','pixels');
% %set (handles.w2InputEdit,'Units','pixels');
% 
% inputTempPosition = [(get(handles.x0Input,'Position')),...
%                      get(handles.x1InputEdit,'Position'),...
%                      get(handles.x2InputEdit,'Position')]
% 
% weightTempPosition = [get(handles.w0InputEdit,'Position'),...
%                       get(handles.w1InputEdit,'Position'),...
%                       get(handles.w2InputEdit,'Position')]
%         
% a = axes;
% set(a, 'Visible', 'off');
% %# Stretch the axes over the whole figure.
% set(a, 'Position', [0, 0, 1, 1]);
% %# Switch off autoscaling.
% set(a, 'Xlim', [0, 1], 'YLim', [0, 1]);
%            
% noOfInputs = 3;
% for index = 1:noOfInputs
% 
%     %(1+(index-1)*4) gets the x position of the current Position data
%     %(3+(index-1)*4) gets the width to add to the x position to get the
%     %final x position
% ixPoint = inputTempPosition(1+(index-1)*4)+inputTempPosition(3+(index-1)*4)
% 
%     %the final y position is half way up from current y, so half the
%     %height is added to current y
% iyPoint = inputTempPosition(2+(index-1)*4)+(inputTempPosition(4+(index-1)*4)/2)
%     
% wxPoint = weightTempPosition(1+(index-1)*4)
% wyPoint = weightTempPosition(2+(index-1)*4)+(weightTempPosition(4+(index-1)*4)/2)
%     
% line([ixPoint,iyPoint],[wxPoint,wyPoint],'Parent',a)
% end

global notRunningColour;
global greyColour;
greyColour = [.80 .80 .80];
notRunningColour = greyColour;

global processingColour;
processingColour = 'y';

global completedColour;
completedColour = 'g';

set (handles.weightedSum,'BackgroundColor',notRunningColour);


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


% --- Executes on button press in backToMainMenu.
function backToMainMenu_Callback(hObject, eventdata, handles)
% hObject    handle to backToMainMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in helpButton.
function helpButton_Callback(hObject, eventdata, handles)
% hObject    handle to helpButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in runButton.
function runButton_Callback(hObject, eventdata, handles)
% hObject    handle to runButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global notRunningColour;
global processingColour;
global completedColour;

set (handles.desiredOutputEdit,'BackgroundColor','w');
set (handles.weightedSum,'BackgroundColor',processingColour);
pause(0.5);

inputs = [str2double(get(handles.x0Input,'String'));...
          str2double(get(handles.x1InputEdit,'String'));...
          str2double(get(handles.x2InputEdit,'String'))];
      
weights = [str2double(get(handles.w0InputEdit,'String'));...
           str2double(get(handles.w1InputEdit,'String'));...
           str2double(get(handles.w2InputEdit,'String'))];

weightedSum = sum(inputs.*weights);
set (handles.weightedSum,'String',weightedSum);

if (get(handles.sigmoidToggle,'Value')==1) 
    
    sigmoidFunction = 1 / (1 + exp(-weightedSum));
    set (handles.y0Output,'String',sigmoidFunction);
    set (handles.anpy0Output,'String',get(handles.y0Output,'String'));
    
elseif (get(handles.stepToggle,'Value')==1)
    
    if weightedSum >= 0
        set (handles.y0Output,'String','1');
        set (handles.anpy0Output,'String',get(handles.y0Output,'String'));
    else
        set (handles.y0Output,'String','0');
        set (handles.anpy0Output,'String',get(handles.y0Output,'String'));
    end 
end

set (handles.desiredOutputEdit,'BackgroundColor',completedColour);
set (handles.weightedSum,'BackgroundColor',notRunningColour);

function desiredOutputEdit_Callback(hObject, eventdata, handles)
% hObject    handle to desiredOutputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of desiredOutputEdit as text
%        str2double(get(hObject,'String')) returns contents of desiredOutputEdit as a double


%desiredOutput must be a number
desiredOutput = str2double(get(handles.desiredOutputEdit,'String'));

%if desiredOutput is anything but 1 or 0 then the User
%receives an error message and must reenter their value
if (get(handles.sigmoidToggle,'Value')==1)
    
    set (handles.desiredOutputEdit,'String',desiredOutput)
    set (handles.anpdOutputEdit,'String',get(handles.desiredOutputEdit,'String'))
    
elseif (get(handles.stepToggle,'Value')==1)
    
    if (desiredOutput == 1) | (desiredOutput == 0)
    
        %set desiredOutput to be displayed in all other desiredOutput edit
        %boxes
        set (handles.anpdOutputEdit,'String', desiredOutput);
    else
        errorMessage = msgbox('Desired Output must be equal to 1 or 0', 'Error', 'error');
        %empty the desiredOutput edit box as a prompt to reenter a
        %value
        set (handles.desiredOutputEdit, 'String', '');
    end
end





% --- Executes during object creation, after setting all properties.
function desiredOutputEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to desiredOutputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x1InputEdit_Callback(hObject, eventdata, handles)
% hObject    handle to x1InputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x1InputEdit as text
%        str2double(get(hObject,'String')) returns contents of x1InputEdit as a double

x1Input = str2double(get(handles.x1InputEdit,'String'));

if isnumeric(x1Input)...
   & ~isnan(x1Input)...
   & isreal(x1Input)
    set (handles.anpx1InputEdit,'String', x1Input);
else
    errorMessage = msgbox('x1 Input must be numerical', 'Error', 'error');
    set (handles.x1InputEdit, 'String', '');
end

% --- Executes during object creation, after setting all properties.
function x1InputEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x1InputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x2InputEdit_Callback(hObject, eventdata, handles)
% hObject    handle to x2InputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x2InputEdit as text
%        str2double(get(hObject,'String')) returns contents of x2InputEdit as a double

x2Input = str2double(get(handles.x2InputEdit,'String'));

if isnumeric(x2Input)...
   && ~isnan(x2Input)...
   & isreal(x2Input)
    set (handles.anpx2InputEdit,'String', x2Input);
else
    errorMessage = msgbox('x2 Input must be numerical', 'Error', 'error');
    set (handles.x2InputEdit, 'String', '');
end

% --- Executes during object creation, after setting all properties.
function x2InputEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x2InputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function w0InputEdit_Callback(hObject, eventdata, handles)
% hObject    handle to w0InputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of w0InputEdit as text
%        str2double(get(hObject,'String')) returns contents of w0InputEdit as a double
w0Input = str2double(get(handles.w0InputEdit,'String'));

if isnumeric(w0Input)...
   & ~isnan(w0Input)...
   & isreal(w0Input)
    set (handles.anpw0InputEdit,'String', w0Input);
else
    errorMessage = msgbox('w0 Input must be numerical', 'Error', 'error');
    set (handles.w0InputEdit, 'String', '');
end

% --- Executes during object creation, after setting all properties.
function w0InputEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w0InputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function w1InputEdit_Callback(hObject, eventdata, handles)
% hObject    handle to w1InputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of w1InputEdit as text
%        str2double(get(hObject,'String')) returns contents of w1InputEdit as a double
w1Input = str2double(get(handles.w1InputEdit,'String'));

if isnumeric(w1Input)...
   & ~isnan(w1Input)...
   & isreal(w1Input)
    set (handles.anpw1InputEdit,'String', w1Input);
else
    errorMessage = msgbox('w1 Input must be numerical', 'Error', 'error');
    set (handles.w1InputEdit, 'String', '');
end

% --- Executes during object creation, after setting all properties.
function w1InputEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w1InputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function w2InputEdit_Callback(hObject, eventdata, handles)
% hObject    handle to w2InputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of w2InputEdit as text
%        str2double(get(hObject,'String')) returns contents of w2InputEdit as a double
w2Input = str2double(get(handles.w2InputEdit,'String'));

if isnumeric(w2Input)...
   & ~isnan(w2Input)...
   & isreal(w2Input)
    set (handles.anpw2InputEdit,'String', w2Input);
else
    errorMessage = msgbox('w2 Input must be numerical', 'Error', 'error');
    set (handles.w2InputEdit, 'String', '');
end

% --- Executes during object creation, after setting all properties.
function w2InputEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w2InputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function anpx1InputEdit_Callback(hObject, eventdata, handles)
% hObject    handle to anpx1InputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of anpx1InputEdit as text
%        str2double(get(hObject,'String')) returns contents of anpx1InputEdit as a double
x1Input = str2double(get(handles.anpx1InputEdit,'String'));

if isnumeric(x1Input)...
   & ~isnan(x1Input)...
   & isreal(x1Input)
    set (handles.x1InputEdit,'String', x1Input);
else
    errorMessage = msgbox('x1 Input must be numerical', 'Error', 'error');
    set (handles.anpx1InputEdit, 'String', '');
end

% --- Executes during object creation, after setting all properties.
function anpx1InputEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to anpx1InputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function anpx2InputEdit_Callback(hObject, eventdata, handles)
% hObject    handle to anpx2InputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of anpx2InputEdit as text
%        str2double(get(hObject,'String')) returns contents of anpx2InputEdit as a double
x2Input = str2double(get(handles.anpx2InputEdit,'String'));

if isnumeric(x2Input)...
   & ~isnan(x2Input)...
   & isreal(x2Input)
    set (handles.x2InputEdit,'String', x2Input);
else
    errorMessage = msgbox('x2 Input must be numerical', 'Error', 'error');
    set (handles.anpx2InputEdit, 'String', '');
end

% --- Executes during object creation, after setting all properties.
function anpx2InputEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to anpx2InputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function anpw0InputEdit_Callback(hObject, eventdata, handles)
% hObject    handle to anpw0InputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of anpw0InputEdit as text
%        str2double(get(hObject,'String')) returns contents of anpw0InputEdit as a double
w0Input = str2double(get(handles.anpw0InputEdit,'String'));

if isnumeric(w0Input)...
   & ~isnan(w0Input)...
   & isreal(w0Input)
    set (handles.w0InputEdit,'String', w0Input);
else
    errorMessage = msgbox('w0 Input must be numerical', 'Error', 'error');
    set (handles.anpw0InputEdit, 'String', '');
end

% --- Executes during object creation, after setting all properties.
function anpw0InputEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to anpw0InputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function anpw1InputEdit_Callback(hObject, eventdata, handles)
% hObject    handle to anpw1InputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of anpw1InputEdit as text
%        str2double(get(hObject,'String')) returns contents of anpw1InputEdit as a double
w1Input = str2double(get(handles.anpw1InputEdit,'String'));

if isnumeric(w1Input)...
   & ~isnan(w1Input)...
   & isreal(w1Input)
    set (handles.w1InputEdit,'String', w1Input);
else
    errorMessage = msgbox('w1 Input must be numerical', 'Error', 'error');
    set (handles.anpw1InputEdit, 'String', '');
end

% --- Executes during object creation, after setting all properties.
function anpw1InputEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to anpw1InputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function anpw2InputEdit_Callback(hObject, eventdata, handles)
% hObject    handle to anpw2InputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of anpw2InputEdit as text
%        str2double(get(hObject,'String')) returns contents of anpw2InputEdit as a double
w2Input = str2double(get(handles.anpw2InputEdit,'String'));

if isnumeric(w2Input)...
   & ~isnan(w2Input)...
   & isreal(w2Input)
    set (handles.w2InputEdit,'String', w2Input);
else
    errorMessage = msgbox('w2 Input must be numerical', 'Error', 'error');
    set (handles.anpw2InputEdit, 'String', '');
end

% --- Executes during object creation, after setting all properties.
function anpw2InputEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to anpw2InputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function anpy0Output_Callback(hObject, eventdata, handles)
% hObject    handle to anpy0Output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of anpy0Output as text
%        str2double(get(hObject,'String')) returns contents of anpy0Output as a double


% --- Executes during object creation, after setting all properties.
function anpy0Output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to anpy0Output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function anpdOutputEdit_Callback(hObject, eventdata, handles)
% hObject    handle to anpdOutputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of anpdOutputEdit as text
%        str2double(get(hObject,'String')) returns contents of anpdOutputEdit as a double

desiredOutput = str2double(get(handles.anpdOutputEdit,'String'));

if (desiredOutput == 1) | (desiredOutput == 0)
    set (handles.desiredOutputEdit,'String', desiredOutput);
else
    errorMessage = msgbox('Desired Output must be equal to 1 or 0', 'Error', 'error');
    set (handles.anpdOutputEdit, 'String', '');
end


% --- Executes during object creation, after setting all properties.
function anpdOutputEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to anpdOutputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in statusColourToggle.
function statusColourToggle_Callback(hObject, eventdata, handles)
% hObject    handle to statusColourToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of statusColourToggle
global notRunningColour;
global processingColour;
global completedColour;
global greyColour;

if (get(handles.statusColourToggle,'Value')==1)
    set (handles.notRunningColourChoice,'Visible','on');
    set (handles.processingColourChoice,'Visible','on');
    set (handles.completedColourChoice,'Visible','on');
    
    set (handles.statusColourToggle,'String','On');
    
elseif (get (handles.statusColourToggle,'Value')==0)
    set (handles.notRunningColourChoice,'Visible','off');
    set (handles.processingColourChoice,'Visible','off');
    set (handles.completedColourChoice,'Visible','off');
    
    set (handles.statusColourToggle,'String','Off');
    
    notRunningColour = greyColour;
    processingColour = 'y';
    completedColour = 'g';
    
    set (handles.weightedSum,'BackgroundColor',notRunningColour);
    set (handles.desiredOutputEdit,'BackgroundColor','w');
    
end

% --- Executes on selection change in notRunningColourList.
function notRunningColourChoice_Callback(hObject, eventdata, handles)
% hObject    handle to notRunningColourList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns notRunningColourList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from notRunningColourList
global notRunningColour;

notRunningColour=uisetcolor;
set (handles.weightedSum,'BackgroundColor',notRunningColour);
set (handles.notRunningColourChoice,'BackgroundColor',notRunningColour);

% --- Executes during object creation, after setting all properties.
function notRunningColourChoice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to notRunningColourList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in processingColourList.
function processingColourChoice_Callback(hObject, eventdata, handles)
% hObject    handle to processingColourList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns processingColourList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from processingColourList
global processingColour;

processingColour=uisetcolor;
%set (handles.weightedSum,'BackgroundColor',processingColour);
set (handles.processingColourChoice,'BackgroundColor',processingColour);

% --- Executes during object creation, after setting all properties.
function processingColourChoice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to processingColourList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in completedColourList.
function completedColourChoice_Callback(hObject, eventdata, handles)
% hObject    handle to completedColourList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns completedColourList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from completedColourList
global completedColour;

completedColour=uisetcolor;
set (handles.desiredOutputEdit,'BackgroundColor',completedColour);
set (handles.completedColourChoice,'BackgroundColor',completedColour);

% --- Executes during object creation, after setting all properties.
function completedColourChoice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to completedColourList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in randInputButton.
function randInputButton_Callback(hObject, eventdata, handles)
% hObject    handle to randInputButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set (handles.x1InputEdit,'String',randn);
set (handles.x2InputEdit,'String',randn);

set (handles.anpx1InputEdit,'String',get(handles.x1InputEdit,'String'));
set (handles.anpx2InputEdit,'String',get(handles.x2InputEdit,'String'));

% --- Executes on button press in randWeightsButton.
function randWeightsButton_Callback(hObject, eventdata, handles)
% hObject    handle to randWeightsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set (handles.w0InputEdit,'String',randn);
set (handles.w1InputEdit,'String',randn);
set (handles.w2InputEdit,'String',randn);

set (handles.anpw0InputEdit,'String',get(handles.w0InputEdit,'String'));
set (handles.anpw1InputEdit,'String',get(handles.w1InputEdit,'String'));
set (handles.anpw2InputEdit,'String',get(handles.w2InputEdit,'String'));
