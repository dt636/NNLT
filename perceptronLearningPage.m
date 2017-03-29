function varargout = perceptronLearningPage(varargin)
% PERCEPTRONLEARNINGPAGE MATLAB code for perceptronLearningPage.fig
%      PERCEPTRONLEARNINGPAGE, by itself, creates a new PERCEPTRONLEARNINGPAGE or raises the existing
%      singleton*.
%
%      H = PERCEPTRONLEARNINGPAGE returns the handle to a new PERCEPTRONLEARNINGPAGE or the handle to
%      the existing singleton*.
%
%      PERCEPTRONLEARNINGPAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PERCEPTRONLEARNINGPAGE.M with the given input arguments.
%
%      PERCEPTRONLEARNINGPAGE('Property','Value',...) creates a new PERCEPTRONLEARNINGPAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before perceptronLearningPage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to perceptronLearningPage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help perceptronLearningPage

% Last Modified by GUIDE v2.5 25-Mar-2017 15:28:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @perceptronLearningPage_OpeningFcn, ...
                   'gui_OutputFcn',  @perceptronLearningPage_OutputFcn, ...
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

% --- Executes just before perceptronLearningPage is made visible.
function perceptronLearningPage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to perceptronLearningPage (see VARARGIN)

% Choose default command line output for perceptronLearningPage
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%initialise handle variables, colour and graph toggle
resetHandleVariables(hObject,eventdata,handles);
    handles = guidata(hObject);
    
setDefaultColours(hObject,handles);
    handles = guidata(hObject);

%only one data creation method available at a time
set(handles.graphDatapointCreationToggle,'Value',1);
graphDatapointCreationToggle_Callback(hObject, eventdata, handles);
    handles = guidata(hObject);
    
guidata(hObject,handles);
    
%%

% UIWAIT makes perceptronLearningPage wait for user response (see UIRESUME)
% uiwait(handles.plpf);

% --- Outputs from this function are returned to the command line.
function varargout = perceptronLearningPage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function resetHandleVariables(hObject,eventdata,handles)

handles.inputData = [];
handles.inputSize = zeros;
handles.originalDataForReset = [];
handles.createdDatapoints = [];
handles.weights = [];
handles.learningRate = 1;
set (handles.learningRateEdit,'String','1');
handles.weightedSum = 0;

handles.manualX1Input = 0;
handles.manualX2Input = 0;
handles.manualClassInput = 0;

handles.numDatapointsToCycleThrough = 0;
handles.maxIteration = 0;
handles.currentIteration = 0;
handles.minBlockDatapoints = 0;
handles.maxBlockDatapoints = 0;

handles.play = false;

%handle for appending to handles.inputData in ManualDatapointCreationCompleteButton_Callback
%resetting the data to include the users created datapoints 
%as well as originally loaded or generated datapoints
handles.createdDatapoints = [];

handles.dataPresent = false;
handles.initialStepThroughComplete = false;

handles.correct = -1;

set (handles.dataTable, 'Data', handles.inputData');
clearAllLabels(hObject,handles)
cla(handles.networkGraph);
reset(handles.networkGraph);

enableEditBoxesAndThresholdToggles(hObject,eventdata, handles);

resetSliderData(hObject,handles);
    handles = guidata(hObject);
resetError(hObject,handles);
    handles  = guidata(hObject);
    
guidata(hObject,handles);
function setWeightLabels(hObject,handles)
    set (handles.w0InputLabel,'String',handles.weights(1));
    set (handles.w1InputLabel,'String',handles.weights(2));
    set (handles.w2InputLabel,'String',handles.weights(3));
function setInputLabels(hObject, handles, i)
    set (handles.x1InputLabel,'String',handles.inputData(2,i));
    set (handles.x2InputLabel,'String',handles.inputData(3,i)); 
function setOutputLabels(hObject, handles, i)
    set (handles.desiredOutputLabel,'String',handles.inputData(4,i));
    set (handles.actualOutputLabel,'String',handles.actualOutput(i));
function clearAllLabels(hObject,handles)
    set (handles.w0InputLabel,'String','');
    set (handles.w1InputLabel,'String','');
    set (handles.w2InputLabel,'String','');
    set (handles.x1InputLabel,'String','');
    set (handles.x2InputLabel,'String','');
    set (handles.weightedSumLabel,'String','');
    set (handles.desiredOutputLabel,'String','');
    set (handles.actualOutputLabel,'String','');
    
    set (handles.minmaxValueLabel,'string','');
    set (handles.currentIterationValueLabel,'string','');
function setDefaultColours(hObject,handles)
% make the colour selectors invisible to show they are not currently in use
% create and initialise colour variables
handles.notRunningColour = [.8 .8 .8];
handles.processingColour = [1 1 0];
handles.completedColour = [0 1 0];

handles.classAColour = [0 0 1];
handles.classBColour = [1 0 0];
handles.thresholdColour = [0 0 0];

set (handles.weightedSumLabel,'BackgroundColor',handles.notRunningColour);
set (handles.notRunningPanel,'BackgroundColor',handles.notRunningColour);
set (handles.processingPanel,'BackgroundColor',handles.processingColour);
set (handles.completedPanel,'BackgroundColor',handles.completedColour);

set (handles.classAPanel,'BackgroundColor',handles.classAColour);
set (handles.classBPanel,'BackgroundColor',handles.classBColour);
set (handles.thresholdPanel,'BackgroundColor',handles.thresholdColour);

set (handles.weightedSumLabel,'BackgroundColor',handles.notRunningColour);
set (handles.desiredOutputLabel,'BackgroundColor','w');

plotData(hObject,handles);

guidata(hObject,handles);
function resetSliderData(hObject,handles)
    
handles.playCount = 0;
handles.playHistory = [];
handles.iterationHistory = [];
handles.datapointHistory = [];
handles.weightHistory = [];

%stop the user from being able to use the slider until the program has classified
%the data. 
set (handles.stepSlider,'Enable','off');

%disable the play through and iteration counters
set (handles.playThroughCountLabel,'Visible','off');
set (handles.playThroughValueLabel,'Visible','off');
set (handles.iterationCountLabel,'Visible','off');
set (handles.iterationValueLabel,'Visible','off');

guidata(hObject,handles);
function enableSlider(hObject,handles)
    
set (handles.stepSlider,'Enable', 'on');
set (handles.stepSlider,'Min', 1);
set (handles.stepSlider,'Max', length(handles.weightHistory));
set (handles.stepSlider,'Value', 1);
set (handles.stepSlider,'SliderStep', [1/length(handles.weightHistory), 1/length(handles.weightHistory)]);

%enable the play through and iteration counters
set (handles.playThroughCountLabel,'Visible','on');
set (handles.playThroughValueLabel,'Visible','on');
    set (handles.playThroughValueLabel,'string', '');
set (handles.iterationCountLabel,'Visible','on');
set (handles.iterationValueLabel,'Visible','on');
    set (handles.iterationValueLabel,'string', '');
    
%%%stepSlider_Callback(hObject, eventdata, handles);

guidata(hObject,handles);
function plotData(hObject,handles)

if ~isempty(handles.inputData)
    
    cla(handles.networkGraph);
    reset(handles.networkGraph);
    
    set (handles.networkGraph, 'XLim',[min(handles.inputData(2,:))* 0.9 max(handles.inputData(2,:))* 1.1]);
    set (handles.networkGraph, 'YLim',[min(handles.inputData(3,:))* 0.9 max(handles.inputData(3,:))* 1.1]);

    axes(handles.networkGraph);
    
    handles.plottedData = gscatter(handles.inputData(2,1:handles.inputSize),...
                                    handles.inputData(3,1:handles.inputSize),...
                                    handles.inputData(4,1:handles.inputSize),[handles.classAColour; handles.classBColour],'xo');
    hold on;
    displayThresholdBoundary(hObject,handles);
        handles = guidata(hObject);

    guidata(hObject,handles);
end
%====================
function plotError(hObject,handles)
    
handles.sumSquaredError = [handles.sumSquaredError sum(handles.error.^2)];

set (handles.errorLabel,'String', sum(handles.error.^2));

hold on;
plot (handles.errorGraph,handles.sumSquaredError(1,:),'x-');

xlabel(handles.errorGraph,'Iteration')
ylabel(handles.errorGraph,'Error')

guidata(hObject,handles);
function resetError(hObject,handles)

handles.error = 0;
handles.sumSquaredError = [];

set (handles.errorLabel,'String','');

cla(handles.errorGraph);
reset(handles.errorGraph);

xlabel(handles.errorGraph,'Iteration')
ylabel(handles.errorGraph,'Error')

guidata(hObject,handles);
%====================
function compareClassAndAdjustWeights(hObject, handles)
% compare actual with desired, classify correct or not
if any(handles.actualOutput ~=handles.inputData(4,:))
    handles.correct = -1;
end

plotError(hObject,handles);
    handles = guidata(hObject);

%adjust weights if any points are incorrectly classified
if handles.correct == -1
    
    %if play is running use all inputs, if not, step is running so use min
    %and max block sizes
    if handles.play == true
        minI = 1;
        maxI = handles.inputSize;
    else
        minI = handles.minBlockDatapoints;
        maxI = handles.maxBlockDatapoints;
    end
    
    %for each datapoint
    for i = minI:maxI

        %exit the datapoint selection loop if stop button is pressed
         drawnow
         if get(handles.stopButton,'userdata')
             break;
         end

        highlightDatapointAndSetLabels(hObject,handles,i)
        %plotStepOrSigmoid(hObject,handles,i)

        %change weights of the datapoint if actual =/= desired
        if handles.actualOutput(1,i) ~= handles.inputData(4,i)
            handles.weights = handles.weights + handles.learningRate*handles.error(i)*handles.inputData(1:3,i);
            %pause to allow user to see threshold boundary move
            pause(0.001);
            if handles.play == true
                displayThresholdBoundary(hObject, handles);
            end
            setWeightLabels(hObject,handles);  
        end
        %store data and get updated copy
        stepSliderDataGather(hObject,handles,i);
            handles = guidata(hObject);
    end
end

guidata(hObject,handles);
function calculateActualAndError(hObject,handles)

    handles.weightedSum = handles.weights' * handles.inputData(1:3,:);

    if (get(handles.stepToggle,'Value')== 1)

        handles.actualOutput = sign(handles.weightedSum);
        handles.error = handles.inputData(4,:) - handles.actualOutput;
        
    elseif (get(handles.sigmoidToggle,'Value')==1)
        
        handles.actualOutput = 1 ./ (1 + exp(-handles.weightedSum));
        handles.error = handles.inputData(4,:) - handles.actualOutput;

        %sigmoid squashes to [0,1] range. Need classes [-1,+1] so
        %if x < 0.5 then -1 else +1
        handles.actualOutput(handles.actualOutput < 0.5) = -1;
        handles.actualOutput(handles.actualOutput >= 0.5) = 1;
        
    else
        %Should not reach this stage. elseif's used to be specific with
        %options available
    end
    
    displayDataTable(hObject,handles)
    
    guidata(hObject,handles);
function checkClassification(hObject,handles)
%enable slider if data is correctly classified
%if weightedHistory is empty then no changes have been made to the weights
%meaning no slider data can be presented as the data has already been
%classified
if handles.correct == 1% && ~isempty(handles.weightedHistory)
    enableSlider(hObject,handles);
end

%if not classified yet, ask if user wants to continue
%COULD USE ERROR TO CHECK WHETHER TO KEEP CLASSIFYING OR NOT. WHEN ERROR
%DOESNT CHANGE FOR A WHILE, SAY IT HASNT CLASSIFIED
if handles.correct == -1 && handles.currentIteration >= handles.maxIteration

    decision = questdlg('The data has not yet been classified correctly. Continue classifying?', ...
    'Continue classifying?', ...
    'Yes','No','No');

    switch decision
        case 'Yes'
            % increment the number of play throughs to achieve a correct
            % classification
            handles.playCount = handles.playCount + 1;
            handles.currentIteration = 0;

        case 'No'  
            handles.correct = 1;
            enableSlider(hObject,handles);          
    end
end

guidata(hObject,handles);
function displayDataTable(hObject,handles)
    
% if isempty(handles.originalDataForReset)
%     tempInputData = handles.inputData;
%     
% end
    
%[-1,1] => [0,+1] make sure if user enters 0's as data they are shown as
%0's in the data table
if (ismember([0], handles.originalDataForReset(4,:)))
    tempInputData = handles.inputData;
    tempInputData(4,:) = (handles.inputData(4,:) + 1) ./ 2;
    
    if ~isempty(handles.actualOutput)
        tempActualOutput = (handles.actualOutput + 1) ./ 2;
    else
        tempActualOutput = [];
    end
else
    tempInputData = handles.inputData;
    
    if ~isempty(handles.actualOutput)
        tempActualOutput = handles.actualOutput;
    else
        tempActualOutput = [];
    end
end
    
set (handles.dataTable,'Data',[tempInputData' tempActualOutput']);
%% function plotStepOrSigmoid(hObject,handles,i)
% 
%     xAxes = min(handles.weightedSum):0.1:max(handles.weightedSum)
%     
%     if get(handles.stepToggle,'Value')== 1
%         hold on;
%         plot (handles.stepSigmoidGraph,xAxes,2*(xAxes>handles.weights(1))-1)
%         hold on;
%        % plot (handles.stepSigmoidGraph,handles.weightedSum(i),handles.actualOutput(i))
%         
%     elseif get(handles.sigmoidToggle,'Value')== 1
%         hold on;
%         plot (handles.stepSigmoidGraph,xAxes,2*1./(1+exp(-x))-1)
%         
%     else
%         
%     end
%     
% %     xlim([min(handles.weightedSum) max(handles.weightedSum)]);
% %     xlabel(handles.stepSigmoidGraph,'Weighted Sum');
% %     ylabel(handles.stepSigmoidGrapg,'Actual Output');
% %     
% %     handles.sumSquaredError = [handles.sumSquaredError sum(handles.error.^2)];
% % 
% % set (handles.errorLabel,'String', sum(handles.error.^2));
% % 
% % hold on;
% % plot (handles.errorGraph,handles.sumSquaredError(1,:),'x-');
% 
% % plot (handles.stepSigmoidGraph,x,2*1./(1+exp(-x))-1
% % 
% %  plot(x,2*(x>0.5)-1)
% %====================

function playButton_Callback(hObject, eventdata, handles)

%if no data then error and exit
if (handles.dataPresent == false)
    msgbox('No data has been given. Please provide data.', 'Error: No data given', 'error');
    
elseif (handles.correct == 1)
    msgbox('Data has been correctly classified. Please press "Reset Dataset" to restart the learning process.');

    %if data has been entered, proceed
elseif (handles.dataPresent == true)
    
    set (handles.stopButton,'userdata',0);
    
    %Play is running, therefore play = true
    handles.play = true;
    
    %% get and set variables
    handles.maxIteration = str2double(get(handles.iterationEdit,'String'));
    handles.currentIteration = 0;
    handles.correct = -1;
    % increment the number of play throughs to achieve a correct
    % classification
    handles.playCount = handles.playCount + 1;
    %%
    %%  set background colours for processing and to show the data isn't classified yet
    set (handles.weightedSumLabel,'BackgroundColor',handles.processingColour);
    set (handles.desiredOutputLabel,'BackgroundColor','w');
    %%

    disableEditBoxesAndThresholdToggles(hObject,eventdata,handles);

    %while the data hasn't been classified correctly and there is still
    %time to compute the classification
    while (handles.correct == -1) && (handles.currentIteration < handles.maxIteration) && ~get(handles.stopButton,'userdata')

        %exit the while loop for play. Need to exit the while (playButton)
        %and for loop (compareClassAndAdjustWeights) to fully stop playing
        pause(0.0001);
        drawnow
        if get(handles.stopButton,'userdata')
            break;
        end
        
        %% classify correctly and increment iteration
        handles.correct = 1;
        handles.currentIteration = handles.currentIteration + 1;
        %%
        
        calculateActualAndError(hObject,handles);
            handles = guidata(hObject);
        
        compareClassAndAdjustWeights(hObject, handles);
            handles = guidata(hObject);

    end

    %final threshold boundary drawn
    pause(0.01);
    displayThresholdBoundary(hObject, handles);

    %% change feedback colours to show the processing has completed
    set (handles.desiredOutputLabel,'BackgroundColor',handles.completedColour);
    set (handles.weightedSumLabel,'BackgroundColor',handles.notRunningColour);
    %%

    checkClassification(hObject,handles);
        handles = guidata(hObject);
        
    set (handles.stopButton,'userdata',0);   
    
    set (handles.loadPresetDataButton, 'Enable','on');
    set (handles.generateDatasetButton, 'Enable','on');
    set (handles.resetDatasetButton, 'Enable','on');
    set (handles.deleteDatasetButton, 'Enable','on');
        
    guidata(hObject,handles);
else
    %Should not reach this stage. elseif's used to be specific with options
    %available
end
function stepThroughButton_Callback(hObject, eventdata, handles)

if (handles.dataPresent == false)
    msgbox('No data has been given. Please provide data.', 'Error: No data given', 'error');
    
elseif (handles.correct == 1)
    msgbox('Data has been correctly classified or is unable to be classified. Please press "Reset Dataset" to restart the learning process.');
    
elseif (handles.dataPresent == true)

    %% set background colours for processing and to show the data isn't classified yet
    set (handles.weightedSumLabel,'BackgroundColor',handles.processingColour);
    set (handles.desiredOutputLabel,'BackgroundColor','w');
    %%
    
    %Step is running, therefore play = false
    handles.play = false;   
    
    %% initialise variables if this is the first iteration of step through
    if (handles.initialStepThroughComplete == false)

        %no. datapoints to cycle through
        handles.numDatapointsToCycleThrough = str2double(get(handles.stepThroughEdit,'String'));

        %maximum number of iterations entered by the user
        handles.maxIteration = str2double(get(handles.iterationEdit,'String'));
        handles.currentIteration = 0;

        %incorrectly classified
        handles.correct = -1;

        %initialise the number of datapoints to cycle through as "blocks"
        handles.minBlockDatapoints = 1 - handles.numDatapointsToCycleThrough;
        handles.maxBlockDatapoints = 0;

        %the initial step has been completed
        handles.initialStepThroughComplete = true;
        
        %prevent the user from interacting with most GUI functions
        disableEditBoxesAndThresholdToggles(hObject,eventdata,handles);

        guidata(hObject,handles);
    end
    %%
    
    if handles.maxBlockDatapoints == 0
        handles.playCount = handles.playCount + 1;
    end

    %if the data hasn't been classified correctly and there is still
    %time to compute the classification
        if (handles.correct == -1) && (handles.currentIteration < handles.maxIteration)
            
        %% classify correctly, increment time, set min and max block size
        %assume the data has been classified correctly
            handles.correct = 1;
            handles.currentIteration = handles.currentIteration + 1;

            %increment the "block" to consider the next set of
            %datapoints
            handles.minBlockDatapoints = handles.minBlockDatapoints + handles.numDatapointsToCycleThrough;
            handles.maxBlockDatapoints = handles.maxBlockDatapoints + handles.numDatapointsToCycleThrough;
            
            %if the max block size is greater than the total number of datapoints
            %then reduce its size 
            if handles.maxBlockDatapoints > handles.inputSize
                handles.maxBlockDatapoints = handles.inputSize;
            end
        %%
            set(handles.currentIterationValueLabel,'String',handles.currentIteration);
            set(handles.minmaxValueLabel,'String',sprintf('%d / %d', handles.minBlockDatapoints, handles.maxBlockDatapoints));
            
            calculateActualAndError(hObject,handles);
                handles = guidata(hObject);

            compareClassAndAdjustWeights(hObject, handles);
                handles = guidata(hObject);
            
        end

    %one threshold boundary is drawn for a user defined number of datapoints, the program
    %can drop out of the classification if statement and draw the line at the end
    pause(0.01);
    displayThresholdBoundary(hObject, handles);
    
    %if all datapoints have been considered, one pass has been made and the block
    %sizes must be reset
    if handles.maxBlockDatapoints >= handles.inputSize
        handles.maxBlockDatapoints = 0;
        handles.minBlockDatapoints = 1 - handles.numDatapointsToCycleThrough;
        %handles.playCount = handles.playCount + 1;
    end
     
    %% change feedback colours to show the processing has completed
    set (handles.desiredOutputLabel,'BackgroundColor',handles.completedColour);
    set (handles.weightedSumLabel,'BackgroundColor',handles.notRunningColour);
    
    guidata(hObject,handles);
        checkClassification(hObject,handles);
            handles = guidata(hObject);
        
    set (handles.loadPresetDataButton, 'Enable','on');
    set (handles.generateDatasetButton, 'Enable','on');
    set (handles.resetDatasetButton, 'Enable','on');
    set (handles.deleteDatasetButton, 'Enable','on');
    
else
    %Should not reach this stage. elseif's used to be specific with options
    %available
end

guidata(hObject,handles);
function stopButton_Callback(hObject, eventdata, handles)

set (handles.stopButton,'userdata',1);
%=======================
function highlightDatapointAndSetLabels(hObject,handles,i)
    
global highlightedPoint;
delete(highlightedPoint);

% select the currently considered point and highlight it
x1 = handles.inputData(2,i);
x2 = handles.inputData(3,i);
hold on;

highlightedPoint = plot(x1,x2,'o','MarkerSize',15);
% set the data on the GUI
setInputLabels(hObject,handles,i);
setWeightLabels(hObject,handles)
setOutputLabels(hObject, handles, i);
set (handles.weightedSumLabel,'String', handles.weightedSum(i));

guidata(hObject,handles);
function displayThresholdBoundary(hObject, handles)

global thresholdBoundary;
%delete the current line so we can draw a new line
delete(thresholdBoundary);

%DRAW THE NEW LINE
%======================================================

%IGNORE:x1a and x1b are the minimum and maximum (respectively)
%points on the x1 axis. The boundary line is defined
%on the x1 axis as slightly smaller and bigger than x1a
%and x1b
    %min - 0.1 * min ==> min * (1 - 0.1) ==> min * 0.9
    %max + 0.1 * max ==> max * (1 + 0.1) ==> max * 1.1
    
    % max (x1b) and min (x1a) have been swapped i.e. max(x1a) min(x1b) to
    %try and get a better threshold boundary. Can be changed again at
    %anytime
%===========================
    
    x1a = min(handles.inputData(2,:));
    x1b = max(handles.inputData(2,:));

    %% create weights and display them on the GUI
    if isempty(handles.weights)
       handles.weights=randn(3,1); %handles.numInputVariables = size(handles.inputData,1);
       setWeightLabels(hObject,handles);
    end
    %%      
    
%separate the weights for the next calculation
    biasWeight = handles.weights(1);
    x1Weight = handles.weights(2);
    x2Weight = handles.weights(3);

%the corresponding x2a and x2b points are calculated
    x2a = (biasWeight*1 + x1Weight*x1a) / -x2Weight;
    x2b = (biasWeight*1 + x1Weight*x1b) / -x2Weight;
    
    %set (handles.networkGraph, 'XLim',[x1a x1b]);
    %set (handles.networkGraph, 'YLim',[min(handles.inputData(3,:))* 0.9 max(handles.inputData(3,:))* 1.1]); 
    
%finally, draw the line on the axes
    thresholdBoundary = plot([x1a; x1b], [x2a,x2b], 'Color',handles.thresholdColour, 'linewidth',0.5);
    guidata(hObject,handles);
%======================
function loadPresetDataButton_Callback(hObject, eventdata, handles)

%Get the filename and pathname for files of .mat type
[filename, pathname] = uigetfile('*.mat', 'Load .mat data');

%If the file is not empty
if filename ~= 0
    %% data entry
        handles.inputData = load(fullfile(pathname, filename));
    
    %The data loaded SHOULD have ONE field name, i.e. [1x1 struct] 
    %The name, i.e. the name of the file loaded, is used to get
    %the data from the array structure
        name = fieldnames(handles.inputData);
    
    %retrieve the input data from the [1x1 struct]
        handles.inputData = handles.inputData.(name{1});
    %%
        
    %check if file is empty and if data is valid
    if isempty(handles.inputData)
        msgbox('The file loaded is empty. Please load a non-empty file','Error: Empty file','error');
        return;
    elseif ~isnumeric(handles.inputData)
        msgbox('Data provided must be numerical','Error: Data is not numerical','error');
        return;
    elseif any(any(isnan(handles.inputData)))
        msgbox('Data contains Not a Number(NaN) elements','Error: Data contains NaN elements','error');
        return;
    elseif ~isreal(handles.inputData)
        msgbox('Data must not contain imaginary/complex elements','Error: Data contains imaginary/complex elements','error');
        return;
    elseif size(handles.inputData,1) ~= 3
        msgbox('Input Data must be a 3 row x N column matrix (3 x N) of [X1;X2;Desired Ouput] data','Error: Matrix size incorrect','error')
        return;
            %dataset may only contain [0,1] or [-1,1] class values.
            %Any other values are invalid.
    elseif ~xor(all(ismember(unique(handles.inputData(3,:)),[0 1])),all(ismember(unique(handles.inputData(3,:)),[-1 1])))
        msgbox('Desired Output must have [0,1] or [-1,+1] values only','Error: Desired Output incorrect','error')
        return;
    else
        %TO DO: if data is valid
            %workable data has been uploaded
            handles.dataPresent = true;

            %% add biases(ones), store as original data for reset, show data on GUI table
                handles.inputSize = size(handles.inputData,2); 
                handles.inputData = [ ones(1,handles.inputSize) ; handles.inputData ];
                handles.originalDataForReset = handles.inputData;
                
                set (handles.dataTable, 'Data', handles.inputData');
            %%
                clearAllLabels(hObject,handles);
            
            %% create weights and display them on the GUI
                handles.weights=randn(3,1); %handles.numInputVariables = size(handles.inputData,1);
                setWeightLabels(hObject,handles);
            %%
                plotData(hObject,handles);
                                            
            %% [0,1] => [-1,+1]
                %To make classification calculations easier, turn all desired outputs
                %into [-1,+1] if they are in [0,1] form. The user will still see the classes 
                %as [0,1] graphically but mathematically they will be different.
                if (ismember([0], handles.inputData(4,:)))
                    handles.inputData(4,:) = 2*handles.inputData(4,:) - 1;
                end
            %%

            % unclassified, step through uninitialised, erase all user created data
                handles.correct = -1;
                handles.initialStepThroughComplete = false;
                handles.createdDatapoints = [];

                enableEditBoxesAndThresholdToggles(hObject,eventdata,handles);
                resetSliderData(hObject,handles);
                    handles = guidata(hObject);
                resetError(hObject,handles);
                    handles = guidata(hObject);

                guidata(hObject,handles);
        %else
            %msgbox('Data invalid','Error: Data invalid','error');
            %return;
        %end
    end
end
function generateDatasetButton_Callback(hObject, eventdata, handles)

 %% data entry
title = 'Generate a dataset';
prompt{1} = 'Set Class A (+1) dataset size:';
prompt{2} = 'Set Class B (-1) dataset size:';
prompt{3} = 'Set Class A X1 Mean:';
prompt{4} = 'Set Class A X2 Mean:';
prompt{5} = 'Set Class A X1 Standard Deviation:';
prompt{6} = 'Set Class A X2 Standard Deviation:';
prompt{7} = 'Set Class B X1 Mean:';
prompt{8} = 'Set Class B X2 Mean:';
prompt{9} = 'Set Class B X1 Standard Deviation:';
prompt{10} = 'Set Class B X2 Standard Deviation:';
      
%given example{'50','50','[5.5 5.0]','[0.5 1.0]','[2.5 3.0]','[0.3 0.7]'};
%suggested example{'50','50','[0.55 0.50]','[0.05 0.1]','[0.25 0.30]','[0.03 0.07]'};
default_ans = {'50','50','5.5','5.0','0.5', '1.0',...
             '2.5', '3.0','0.3', '0.7'};

promptData = str2double(inputdlg(prompt,title,1,default_ans));

%%

 %if the user cancels, exit the function
 if isempty(promptData)
     return;
%  elseif ~all(isnumeric(promptData))
%      msgbox('Data entered must be numerical', 'Error: Data not numerical', 'error');
%      return;
 elseif any(isnan(promptData))
     msgbox('Data entered contains Not a Number(NaN) elements. Data must be numerical','Error: Data not numerical','error');
     return;
 elseif any(~isreal(promptData))
     msgbox('Data entered contains imaginary / complex elements','Error: Data contains imaginary / complex elements','error');
     return;
 else
        %% data entry
        sampleAsize = promptData(1);
        sampleBsize = promptData(2);

        sampleAmean = [promptData(3), promptData(4)];
        sampleAstdDev = [promptData(5), promptData(6)];

        sampleBmean = [promptData(7), promptData(8)];
        sampleBstdDev = [promptData(9), promptData(10)];


        handles.inputData  = [...
            normallyDistributedSample( sampleAsize, sampleAmean, sampleAstdDev )' ...
            normallyDistributedSample( sampleBsize, sampleBmean, sampleBstdDev )';...
            ones(sampleAsize,1)' -ones(sampleBsize,1)'];
        %%
        %% ---------------------------------------------------------------------
        % Randomly permute samples & class labels.
        %
        %   This is not really necessary, but done to illustrate that the order
        %   in which observations are evaluated does not matter.
        %
        %randomOrder   = randperm( sampleAsize + sampleBsize );
        %handles.inputData  = handles.inputData( :, randomOrder );
        %handles.inputData
        %Data.labels   = Data.labels(  randomOrder, : );
        %% 

        %workable data has been uploaded
        handles.dataPresent = true;

        %% add biases(ones), store as original data for reset, show data on GUI table
        handles.inputSize = size(handles.inputData,2); 
        handles.inputData = [ ones(1,handles.inputSize) ; handles.inputData ];
        handles.originalDataForReset = handles.inputData;

        set (handles.dataTable, 'Data', handles.inputData');
        %%
        
        clearAllLabels(hObject,handles);
        
        %% create weights and display them on the GUI
        handles.weights=randn(3,1); %handles.numInputVariables = size(handles.inputData,1);
        setWeightLabels(hObject,handles);
        %%
        
        plotData(hObject,handles);

        %unclassified, step through uninitialised, erase all user created data
        handles.correct = -1;
        handles.initialStepThroughComplete = false;
        handles.createdDatapoints = [];

        enableEditBoxesAndThresholdToggles(hObject,eventdata,handles);
        resetSliderData(hObject,handles);
            handles = guidata(hObject);
        resetError(hObject,handles);
            handles  = guidata(hObject);
        guidata(hObject,handles);
    %else
        %msgbox('Data invalid','Error: Data invalid','error');
        %return;
    %end
 end
      
%%  title = 'Generate a dataset';
%     prompt{1} = 'Set Class A and B dataset size [A B]:';
%     prompt{2} = 'Set Class A mean [X1 X2]:';
%     prompt{3} = 'Set Class A standard deviation [X1 X2]:';
%     prompt{4} = 'Set Class B mean [X1 X2]:';
%     prompt{5} = 'Set Class B standard deviation [X1 X2]:';
%     
%     default_ans = {'[50 50]','[5.5 5.0]','[0.5 1.0]','[2.5 3.0]','[0.3 0.7]'};
%     
%     promptData = inputdlg(prompt,title,1,default_ans);
%     
%     if isempty(promptData)
%         return;
%     else
%         
%         for i = 1:5
%             sample(i) = str2double(regexp(promptData(i),'-?\d*','match'));
%         end
%             
%         tempPromptData = textscan(fileID,'%s','delimiter','\n');
%         extractedNums = regexp(stringData{i}, '-?\d*','match');
%         
%sampleAsize = str2double(promptData(1))
     %sampleBsize = str2double(promptData(2))
     %%cell2mat
%       sampleAmean = str2num(promptData(3))
%   	sampleAstdDev = str2num(promptData(4)) 
%       sampleBmean = cell2mat(promptData(5))
%    	sampleBstdDev = cell2mat(promptData(6))
%         
%         sampleAsize = str2double(
%         
%     end   
% Example sample
%     sampleAsize   = 30;
%     sampleBsize   = 30;
% 
%     sampleAmean   = [ 1.3 1.3]
%     sampleAstdDev = [ 0.1 0.1 ]
% 
%     sampleBmean   = [ 0.7 0.9 ]
%     sampleBstdDev = [ 0.34 0.16 ]
%%

function samples = normallyDistributedSample( sampleSize, sampleMean, sampleStdDev )
    %CODE TAKEN FROM:
    % http://stackoverflow.com/questions/4882367/implementing-and-ploting-a-perceptron-in-matlab
    %source: William Payne, Feb 4/11, 13:52   
    
%NORMALDISTRIBUTIONSAMPLE
%
%   Draw a sample from a normal distribution with specified mean and
%   standard deviation.
%

    assert(    isequal( size( sampleMean ), size( sampleStdDev ) ) ...
            && 1 == size( sampleMean, 1 ),                         ...
        'Sample mean and standard deviation must be row vectors of equal length.' );

    numFeatures = numel( sampleMean );
    samples     = randn( sampleSize, numFeatures );
    samples     = bsxfun( @times, samples, sampleStdDev );
    samples     = bsxfun( @plus,  samples, sampleMean   );
%end % NORMALDISTRIBUTIONSAMPLE   
%======================
function resetDatasetButton_Callback(hObject, eventdata, handles)
if ~isempty(handles.inputData)
    
    %% keep user created data?
    decision = questdlg('Would you like to keep al l user created datapoints?', ...
        'Keep user created datapoints?', ...
        'Yes','No','No');
    
    switch decision
        case 'Yes'  %keep the user created data

            %if preset data consists of [0,1] and user created data consists of
            %[-1,+1], then plotting 0,1 and -1 will create a bugged plot so
            %need to turn -1's to 0 so the data is consistent

            if (ismember([-1], handles.createdDatapoints)) && (~isempty(handles.originalDataForReset)) && ...
                                                               (ismember([0],handles.originalDataForReset(4,:)))
                handles.createdDatapoints(handles.createdDatapoints == -1) = 0;
            end
            
            handles.inputData = [handles.originalDataForReset handles.createdDatapoints];
        case 'No'   %reload data from when data was loaded
            handles.inputData = handles.originalDataForReset;
            handles.createdDatapoints = [];
    end
    %%
    clearAllLabels(hObject,handles);
    cla(handles.networkGraph);
    reset(handles.networkGraph);

    if ~isempty(handles.inputData)
    
        %% data is present
        %workable data has been uploaded
        handles.dataPresent = true;
        %%

        %% create weights and display them on the GUI
        handles.weights=randn(3,1); %handles.numInputVariables = size(handles.inputData,1);
        setWeightLabels(hObject,handles);
        %%
        
        %% show data in the GUI table
        set (handles.dataTable, 'Data', handles.inputData');
        %%
        
        %update number of datapoints
        handles.inputSize = size(handles.inputData,2); 

        plotData(hObject,handles);
        
        %% [0,1] => [-1,+1]
            %To make classification calculations easier, turn all desired outputs
            %into [-1,+1] if they are in [0,1] form. The user will still see the classes 
            %as [0,1] graphically but mathematically they will be different.
            if (ismember([0], handles.inputData(4,:)))
                handles.inputData(4,:) = 2*handles.inputData(4,:) - 1;
            end
        %%
    
        %% unclassified, step through uninitialised
        handles.correct = -1;
        handles.initialStepThroughComplete = false;
        %%

        guidata(hObject,handles);
    end

    enableEditBoxesAndThresholdToggles(hObject,eventdata,handles);
    resetSliderData(hObject,handles);
        handles = guidata(hObject);
    resetError(hObject,handles);
        handles  = guidata(hObject);

    guidata(hObject,handles);
end
function deleteDatasetButton_Callback(hObject, eventdata, handles)

    decision = questdlg('Delete all loaded and user defined data?', ...
        'Delete all data?', ...
        'Yes','No','No');
    
    switch decision
        case 'Yes'  %delete all data
            resetHandleVariables(hObject,eventdata,handles);
                handles = guidata(hObject);
            guidata(hObject,handles);
        case 'No'   %do nothing
    end
%======================
function disableEditBoxesAndThresholdToggles(hObject, eventdata, handles)
    
    %stop the user from changing values, threshold function types, or create new datapoints half
    %way through the learning process. This will prevent unwanted errors.
    
    %only one method of classifying the data can be run at a time to
    %prevent potential interaction bugs/problems when using one then the
    %other for the same dataset at the same time
    if handles.play == true
        set (handles.stepThroughButton, 'Enable','off');
    else
        set (handles.playButton, 'Enable','off');
    end
    
        set (handles.loadPresetDataButton, 'Enable','off');
        set (handles.generateDatasetButton, 'Enable','off');
        set (handles.resetDatasetButton, 'Enable','off');
        set (handles.deleteDatasetButton, 'Enable','off');
    
    set(handles.stepToggle,'Enable','Off');
    set(handles.sigmoidToggle,'Enable','Off');
    
    set(handles.learningRateEdit,'Enable','Off');
    set(handles.iterationEdit,'Enable','Off');
    set(handles.stepThroughEdit,'Enable','Off');
    
    set(handles.graphDatapointCreationToggle,'Enable','off');
    set(handles.manualDatapointCreationToggle,'Enable','off');
 
    set (handles.classAToggle,'Enable','off');
    set (handles.classBToggle,'Enable','off');
    set (handles.addDatapoints,'Enable','off');

    set (handles.manualDatapointCreationX1Edit,'Enable','off');
    set (handles.manualDatapointCreationX2Edit,'Enable','off');
    set (handles.manualDatapointCreationClassEdit,'Enable','off');
    set (handles.manualDatapointCreationCompleteButton,'Enable','off');
        
    set (handles.defaultColoursButton,'Enable','off');
    set (handles.notRunningColourChoice,'Enable','off');
    set (handles.processingColourChoice,'Enable','off');
    set (handles.completedColourChoice,'Enable','off');
    set (handles.classAColourChoice,'Enable','off');
    set (handles.classBColourChoice,'Enable','off');
    set (handles.thresholdBoundaryColourChoice,'Enable','off');
    
    guidata(hObject,handles);     
function enableEditBoxesAndThresholdToggles(hObject, eventdata, handles)
            
    %renable the ability for users to change values, threshold functions
    %and create new values.
    
    %enable both classifcation methods
    set (handles.stepThroughButton,'Enable','On');
    set (handles.playButton,'Enable','On');
    set (handles.stopButton,'Enable','On');
    
    set(handles.stepToggle,'Enable','On');
    set(handles.sigmoidToggle,'Enable','On');
    
    set(handles.learningRateEdit,'Enable','On');
    set(handles.iterationEdit,'Enable','On');
    set(handles.stepThroughEdit,'Enable','On');
    
    set(handles.graphDatapointCreationToggle,'Enable','on');
    set(handles.manualDatapointCreationToggle,'Enable','on');
        graphDatapointCreationToggle_Callback(hObject,eventdata, handles);
        manualDatapointCreationToggle_Callback(hObject,eventdata, handles);
        
    set (handles.defaultColoursButton,'Enable','on');
    set (handles.notRunningColourChoice,'Enable','on');
    set (handles.processingColourChoice,'Enable','on');
    set (handles.completedColourChoice,'Enable','on');
    set (handles.classAColourChoice,'Enable','on');
    set (handles.classBColourChoice,'Enable','on');
    set (handles.thresholdBoundaryColourChoice,'Enable','on');
    
    guidata(hObject,handles);
%======================
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
function classAColourChoice_Callback(hObject, eventdata, handles)
 
handles.classAColour = uisetcolor;

if handles.classAColour == 0
     return;
end

set(handles.classAPanel,'BackgroundColor',handles.classAColour);
plotData(hObject,handles);
guidata(hObject,handles);
function classBColourChoice_Callback(hObject, eventdata, handles)

handles.classBColour = uisetcolor;

if handles.classBColour == 0
     return;
end

set(handles.classBPanel,'BackgroundColor',handles.classBColour);
plotData(hObject,handles);
guidata(hObject,handles);
function thresholdBoundaryColourChoice_Callback(hObject, eventdata, handles)
    
handles.thresholdColour = uisetcolor;

if handles.thresholdColour == 0
     return;
end

set(handles.thresholdPanel,'BackgroundColor',handles.thresholdColour);
plotData(hObject,handles);
guidata(hObject,handles);  
function defaultColoursButton_Callback(hObject, eventdata, handles)

setDefaultColours(hObject,handles);
%======================
function stepSliderDataGather(hObject,handles,i)
 
    handles.playHistory = [handles.playHistory handles.playCount];
    handles.iterationHistory = [handles.iterationHistory handles.currentIteration];
    handles.datapointHistory = [handles.datapointHistory [handles.inputData(2:4,i); handles.actualOutput(i); handles.weightedSum(i)]];
    handles.weightHistory = [handles.weightHistory handles.weights];
    
    guidata(hObject,handles)
function stepSlider_Callback(hObject, eventdata, handles)
    
sliderValue = ceil(get(handles.stepSlider,'Value'));

%handles.inputSize weightHistory - for saving data by not using
%datapointHistory
 
handles.weights = handles.weightHistory(:,sliderValue);
displayThresholdBoundary(hObject,handles);
handles = guidata(hObject);

%=========
    
global highlightedPoint;
delete(highlightedPoint);

x1 = handles.datapointHistory(1,sliderValue);
x2 = handles.datapointHistory(2,sliderValue);
hold on;
highlightedPoint = plot(x1,x2,'o','MarkerSize',15);

%set weight labels
setWeightLabels(hObject,handles);
%set input labels
set (handles.x1InputLabel,'String',x1);
set (handles.x2InputLabel,'String',x2); 
%set output labels
set (handles.desiredOutputLabel,'String',handles.datapointHistory(3,sliderValue));
set (handles.actualOutputLabel,'String',handles.datapointHistory(4,sliderValue));

set (handles.weightedSumLabel,'String', handles.datapointHistory(5,sliderValue));

%set playThroughLabel = 'current / max' 
tempValue = sprintf('%d / %d',handles.playHistory(sliderValue), max(handles.playHistory));
set (handles.playThroughValueLabel,'string', tempValue);

%find the maximum iteration array position for the current play through
tempIterationMax = find(handles.playHistory == (handles.playHistory(sliderValue) + 1), 1, 'first') - 1;

%if there is no more play throughs after this one then tempIterationMax should be empty
if isempty(tempIterationMax)
    %get the last position of iterationHistory
    tempIterationMax = length(handles.iterationHistory);
end

%set the iterationLabel = LOCAL 'current / max'
tempValue = sprintf('%d / %d', handles.iterationHistory(sliderValue), handles.iterationHistory(tempIterationMax));
set (handles.iterationValueLabel,'string', tempValue);

guidata(hObject,handles);
            function stepSlider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%=====================
function learningRateEdit_Callback(hObject, eventdata, handles)

handles.learningRate = str2double(get(handles.learningRateEdit,'String'));

if (~(isnumeric(handles.learningRate)...
   & ~isnan(handles.learningRate)...
   & isreal(handles.learningRate)))...
   || (handles.learningRate<0 || handles.learningRate>1)
    
    errorMessage = msgbox('Learning rate must be in the range of 0 - 1 ', 'Error', 'error');
    set (handles.learningRateEdit, 'String', '1');
    handles.learningRate = 1;
end
guidata(hObject,handles);
            function learningRateEdit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function iterationEdit_Callback(hObject, eventdata, handles)

tempIteration = str2double(get(handles.iterationEdit,'String'));

%if temp is not a number    OR
%   temp is not an integer e.g. 10.5 ~= floor(10.5), where floor(10.5) == 10 OR
%   temp is less than 1
%THEN
%   error message

if isnan(tempIteration) || (tempIteration ~= floor(tempIteration)) || tempIteration < 1
    msgbox('Number of Iterations/Epochs must be an integer greater than 0. Default set to "10".', 'Error: Invalid iteration number','error');
    set (handles.iterationEdit,'String',10);
end
            function iterationEdit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function stepThroughEdit_Callback(hObject, eventdata, handles)

if handles.dataPresent == true

    tempStepThrough = str2double(get(handles.stepThroughEdit,'String'));

    if isnan(tempStepThrough) || (tempStepThrough ~= floor(tempStepThrough)) || tempStepThrough < 1 || tempStepThrough > handles.inputSize
        
        %create a separate message so handles.inputSize can be inserted
        %into the messagebox
        message = sprintf('Number of datapoints to step through must be an integer between 1 and %d. Default set to "1".', handles.inputSize);
        
        msgbox(message, 'Error: Invalid number of datapoints to step through','error');
        set (handles.stepThroughEdit,'String',1);
    end
    
else
    msgbox('No data has been given. Please provide data to set the number of datapoints to step through.', 'Error: No data given', 'error');
end
            function stepThroughEdit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%==================
function graphDatapointCreationToggle_Callback(hObject, eventdata, handles)

    %turn on graphical datapoint creation and turn off manual datapoint
    %creation
    if (get (handles.graphDatapointCreationToggle,'Value')==1)
        
        set (handles.classAToggle,'Enable','on');
        set (handles.classBToggle,'Enable','on');
        set (handles.addDatapoints,'Enable','on');
       
        set (handles.manualDatapointCreationX1Edit,'Enable','off');
        set (handles.manualDatapointCreationX2Edit,'Enable','off');
        set (handles.manualDatapointCreationClassEdit,'Enable','off');
        set (handles.manualDatapointCreationCompleteButton,'Enable','off');
    end

guidata(hObject, handles);
function manualDatapointCreationToggle_Callback(hObject, eventdata, handles)

    %turn on manual datapoint creation and turn off graphical datapoint
    %creation
    if (get (handles.manualDatapointCreationToggle,'Value')==1)
        
        set (handles.manualDatapointCreationX1Edit,'Enable','on');
        set (handles.manualDatapointCreationX2Edit,'Enable','on');
        set (handles.manualDatapointCreationClassEdit,'Enable','on');
        set (handles.manualDatapointCreationCompleteButton,'Enable','on');
        
        set (handles.classAToggle,'Enable','off');
        set (handles.classBToggle,'Enable','off');
        set (handles.addDatapoints,'Enable','off');
    end

    guidata(hObject, handles);
%==============
function manualDatapointCreationX1Edit_Callback(hObject, eventdata, handles)

manualX1Input = str2double(get(handles.manualDatapointCreationX1Edit,'String'));

if isnumeric(manualX1Input) && ~isnan(manualX1Input) && isreal(manualX1Input)
    handles.manualX1Input = manualX1Input;
else
    msgbox('X1 Input must be numerical', 'Error', 'error');
    set (handles.manualDatapointCreationX1Edit, 'String', '');
end

guidata(hObject,handles);
            function manualDatapointCreationX1Edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function manualDatapointCreationX2Edit_Callback(hObject, eventdata, handles)

manualX2Input = str2double(get(handles.manualDatapointCreationX2Edit,'String'));

if isnumeric(manualX2Input) && ~isnan(manualX2Input) && isreal(manualX2Input)
    handles.manualX2Input = manualX2Input;
else
    msgbox('X2 Input must be numerical', 'Error', 'error');
    set (handles.manualDatapointCreationX2Edit, 'String', '');
end

guidata(hObject,handles);
            function manualDatapointCreationX2Edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function manualDatapointCreationClassEdit_Callback(hObject, eventdata, handles)

manualClassInput = str2double(get(handles.manualDatapointCreationClassEdit,'String'));

if isnumeric(manualClassInput) && (manualClassInput == 1 || manualClassInput == -1)
    handles.manualClassInput = manualClassInput;
else
    msgbox('Desired class must be +1 or -1', 'Error', 'error');
    set (handles.manualDatapointCreationClassEdit, 'String', '');
end

guidata(hObject,handles);
            function manualDatapointCreationClassEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%==============
function classBToggle_Callback(hObject, eventdata, handles)
function classAToggle_Callback(hObject, eventdata, handles) 
%==============
    
function manualDatapointCreationCompleteButton_Callback(hObject, eventdata, handles)

%% data entry

    %append the new datapoint to createdDatapoints. Allows the user the
    %option of including manually created data when reseting datapoints
    handles.createdDatapoints = [handles.createdDatapoints [1; handles.manualX1Input; handles.manualX2Input; handles.manualClassInput]];

    %append the new datapoint to the input data and
    %recalculate inputSize
    handles.inputData = [handles.inputData [1; handles.manualX1Input; handles.manualX2Input; handles.manualClassInput]];
    %handles.desiredOutput = [handles.desiredOutput handles.manualClassInput];
    handles.inputSize = size(handles.inputData,2);
%%

%% data is present
%workable data has been uploaded
handles.dataPresent = true;
%%

%% show data in the GUI table
set (handles.dataTable, 'Data', handles.inputData');
%%

plotData(hObject,handles);

%update the guidata after accessing the custom displayThreshold function
handles = guidata(hObject);
%%

%% set the editboxes to empty to show they're ready for new input
    set (handles.manualDatapointCreationX1Edit,'String','');
    set (handles.manualDatapointCreationX2Edit,'String','');
    set (handles.manualDatapointCreationClassEdit,'String','');
%%

guidata(hObject,handles);
function addDatapoints_Callback(hObject, eventdata, handles)
% hObject    handle to addDatapoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (get(handles.graphDatapointCreationToggle,'Value')==1)

    %% data entry
        [X1,X2] = getpts(handles.networkGraph);
    %%
    disp 'in add datapoint'
    %% get class
    if (get(handles.classAToggle,'Value')==1)
        tempDesiredOutput = 1;
    elseif (get(handles.classBToggle,'Value')==1)
        %if the data entered by the user has [0,1] desired outputs then the
        %created data must also have the same desired output value
%         if ~isempty(handles.inputData) && (ismember([0], handles.originalDataForReset(4,:))) 
%             tempDesiredOutput = 0;
%         else
            tempDesiredOutput = -1;
%         end
    else
        %Should not reach this stage. elseif's used to be specific with
        %options available
    end
    %%
    
    %% data is present
    %workable data has been uploaded
    handles.dataPresent = true;
    %%

    %% data entry
    %append the new datapoints to createdDatapoints. Allows the user the
    %option of including manually created data when reseting datapoints
    handles.createdDatapoints = [handles.createdDatapoints [ones(1,length(X1'));X1';X2';[ones(1,length(X1'))*tempDesiredOutput]]];

    %append the created datapoints to the input data
    %need to create a vector of 1's and multiply by the class (+1 or -1)
    %to create a row vector of +1 or -1 to append to the input data
    handles.inputData = [handles.inputData [ones(1,length(X1'));X1';X2';[ones(1,length(X1'))*tempDesiredOutput]]];
    
    handles.inputSize = size(handles.inputData,2);
    %%

    %% show data in the GUI table
    %displayDataTable(hObject,handles);
    set (handles.dataTable, 'Data', handles.inputData');
    %%

    plotData(hObject,handles);
        handles = guidata(hObject);
        
    guidata(hObject,handles);
end
