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

% Last Modified by GUIDE v2.5 14-Mar-2017 19:05:48

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

%Initialise the perceptron with hard-coded data
setHardCodedData(handles);

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


%initialise the graph toggle (an arbitrary choice between graph and manual
%toggle) so only one datapoint creation option is ever available at a time
set(handles.graphDatapointCreationToggle,'Value',1);
graphDatapointCreationToggle_Callback(hObject, eventdata, handles);

%stop the user from being able to use the slider until the program has classified
%the data. 
set (handles.stepSlider,'Enable','off');

handles.inputData = [];
handles.inputSize = zeros;
handles.originalDataForReset = [];
handles.desiredOutput = [];
handles.dataPresent = false;

handles.manualX1Input = 0;
handles.manualX2Input = 0;
handles.manualClassInput = 0;

handles.presetDataBoolean = false;

handles.initialStepThroughComplete = false;
handles.numDatapointsToCycleThrough = 0;
handles.maxIteration = 0;
handles.currentIteration = 0;
handles.minBlockDatapoints = 0;
handles.maxBlockDatapoints = 0;

handles.correct = -1;

%handle for appending to handles.inputData in ManualDatapointCreationCompleteButton_Callback
%resetting the data to include the users created datapoints 
%as well as originally loaded or generated datapoints
handles.createdDatapoints = [];

%set (handles.networkGraph, 'HitTest','off');
%set (handles.networkGraph,'ButtonDownFcn',{@networkGraphDatapointCreation});
%set (gca, 'buttondownfcn',{@networkGraph_ButtonDownFcn,handles})
guidata(hObject,handles);

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

function setHardCodedData(handles)
    set (handles.x1InputLabel,'String','0.1');
    set (handles.x2InputLabel,'String','0.3');
    set (handles.w0InputLabel,'String','0.3');
    set (handles.w1InputLabel,'String','3.1');
    set (handles.w2InputLabel,'String','0.5');
    set (handles.desiredOutputLabel,'String','1');
    set (handles.actualOutputLabel,'String','');
    set (handles.learningRateEdit,'String','1');

function setWeightLabels(hObject,handles)
    set (handles.w0InputLabel,'String',handles.weights(1));
    set (handles.w1InputLabel,'String',handles.weights(2));
    set (handles.w2InputLabel,'String',handles.weights(3));

function setInputLabels(hObjects, handles, i)
    set (handles.x1InputLabel,'String',handles.inputData(2,i));
    set (handles.x2InputLabel,'String',handles.inputData(3,i)); 
    
function setOutputLabels(hObjects, handles, i)
    set (handles.desiredOutputLabel,'String',handles.desiredOutput(i));
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

function backToMainMenuButton_Callback(hObject, eventdata, handles)

function helpButton_Callback(hObject, eventdata, handles)

function playButton_Callback(hObject, eventdata, handles)

%if no data has been entered then show an error message and exit the
%playButton function

if (handles.dataPresent == false)
    msgbox('No data has been given. Please provide data.', 'Error: No data given', 'error');
    
elseif (handles.correct == 1)
    msgbox('Data has been correctly classified. Please press "Reset Dataset" to restart the learning process.');

    %if data has been entered, proceed
elseif (handles.dataPresent == true)

    %%  ask for a number of iterations/epochs/time stamps
        title = 'Set maximum number of iterations:';
        prompt = 'Set the maximum number of iterations / epochs / time stamps:';
        default_ans = {'10'};
        maxt = str2double(inputdlg(prompt,title,1,default_ans));
        
    %%  set background colours
    %set the desired output to white to show its outcome hasn't been determined
        set (handles.desiredOutputLabel,'BackgroundColor','w');
    %set the perceptron colour to the processing colour to show the data is
    %being processed

    set (handles.weightedSumLabel,'BackgroundColor',handles.processingColour);
        
    %%  wait and initialise correct and time
    %wait for an arbitrary amount of time so the processing isn't almost instantaneous
        pause(0.5);
        disableEditBoxesAndThresholdToggles(hObject,eventdata,handles);

    %assume the data has not classified correctly
        correct = -1; 
    
    %initialise a time variable to act as a counter for the number of
    %epochs/iterations/time stamps
        t=0;
        
    %%  get the learning rate
            learningRate = str2double(get(handles.learningRateEdit,'String'));

%%
    
    %while the data hasn't been classified correctly and there is still
    %time to compute the classification
        while (correct == -1) && (t < maxt)

            %% classify correctly and increment time
            %assume the data has been classified correctly
                correct = 1;
            %increment the time variable
                t = t + 1;
            %%
              
            if (get(handles.stepToggle,'Value')== 1) 
                
               
                    weightedSum = handles.weights' * handles.inputData;
                    handles.actualOutput = sign(weightedSum);
                    
                    error = handles.desiredOutput - handles.actualOutput;

                %what we want, what we get, what the difference is
                    %[handles.desiredOutput; handles.actualOutput; error]

                %% compare actual with desired, classify correct or not
                %if any of the actual output is not the same as the desired output then
                %it is incorrectly classified
                if any(handles.actualOutput ~=handles.desiredOutput)
                    correct = -1;
                end
                %%

                %if any datapoint is incorrectly classified, adjust the weights
                if correct == -1

                    %for each datapoint, check if its actual output matches the desired
                    %output. If not, adjust its weight accordingly.
                    for i = 1:handles.inputSize
                        %% select the currently considered point and highlight it
                            %handles.inputData(1,i) is the +1 bias constant
                            x1 = handles.inputData(2,i);
                            x2 = handles.inputData(3,i);
                            hold on;
                            handles.highlightedPoint = plot(x1,x2,'o','MarkerSize',10);
                            guidata(hObject,handles);

                        %% set the data on the GUI inputEdits and All Network Parameters
                            setInputLabels(hObject,handles,i);
                            setWeightLabels(hObject,handles)
                            setOutputLabels(hObject, handles, i);
                            set (handles.weightedSumLabel,'String', weightedSum(i));
                        
                        %%

                        %if the handles.actualOutput is not the same as the desiredOutput then the weights must be changed
                        if handles.actualOutput(1,i) ~= handles.desiredOutput(1,i)

                            handles.weights = handles.weights + learningRate*error(i)*handles.inputData(:,i);

                            %handles.weights = handles.weights + handles.desiredOutput(1,i) * handles.inputData(:,i);

                            %arbitrary pause to allow the user to see the change in
                            %the threshold boundary as it moves around
                            pause(0.001);
                            displayThresholdBoundary(hObject, handles);

                            %% show the weight changes on the GUI as they are processed
                                setWeightLabels(hObject,handles);           
                        end
                        
                        %after the current point has been considered, delete the current highlight
                            delete(handles.highlightedPoint);
                    end
                end
                
            elseif (get(handles.sigmoidToggle,'Value')==1)
                
                    weightedSum = handles.weights' * handles.inputData;
                        handles.actualOutput = 1 ./ (1 + exp(-weightedSum));
                            error = handles.desiredOutput - handles.actualOutput;
                            
                            %reassign the actual output to be thresholded
                            %once the error has been calculated
                        handles.actualOutput = sign(1 ./ (1 + exp(-weightedSum)));
                        
                        %% compare actual with desired, classify correct or not
                    %if any of the actual output is not the same as the desired output then
                    %it is incorrectly classified
                    if any(handles.actualOutput ~=handles.desiredOutput)
                        correct = -1;
                    end
                    %%

                    %if any datapoint is incorrectly classified, adjust the weights
                    if correct == -1

                        %for each datapoint, check if its actual output matches the desired
                        %output. If not, adjust its weight accordingly.
                        for i = 1:handles.inputSize
                            %% select the currently considered point and highlight it
                                %handles.inputData(1,i) is the +1 bias constant
                                x1 = handles.inputData(2,i);
                                x2 = handles.inputData(3,i);
                                hold on;
                                handles.highlightedPoint = plot(x1,x2,'o','MarkerSize',10);
                                guidata(hObject,handles);

                            %% set the data on the GUI inputEdits and All Network Parameters
                                setInputLabels(hObject,handles,i);
                                setWeightLabels(hObject,handles)
                                setOutputLabels(hObject, handles, i);
                                set (handles.weightedSumLabel,'String', weightedSum(i));

                            %%

                            %if the handles.actualOutput is not the same as the desiredOutput then the weights must be changed
                            if handles.actualOutput(1,i) ~= handles.desiredOutput(1,i)

                                handles.weights = handles.weights + learningRate*error(i)*handles.inputData(:,i);

                                %handles.weights = handles.weights + handles.desiredOutput(1,i) * handles.inputData(:,i);

                                %arbitrary pause to allow the user to see the change in
                                %the threshold boundary as it moves around
                                pause(0.001);
                                displayThresholdBoundary(hObject, handles);

                                %% show the weight changes on the GUI as they are processed
                                    setWeightLabels(hObject,handles);           
                            end

                            %after the current point has been considered, delete the current highlight
                                delete(handles.highlightedPoint);
                        end
                    end
            else
                %ERROR
            end
        end

    pause(0.01);
     displayThresholdBoundary(hObject, handles);
     
    %% change feedback colours to show the processing has completed
        set (handles.desiredOutputLabel,'BackgroundColor',handles.completedColour);
        set (handles.weightedSumLabel,'BackgroundColor',handles.notRunningColour);
else
    %ERROR
end

function displayThresholdBoundary(hObject, handles)

    guidata(hObject,handles);
global thresholdBoundary;
%delete the current line so we can draw a new line
delete(thresholdBoundary);

%DRAW THE NEW LINE
%======================================================
%x1a and x1b are the minimum and maximum (respectively)
%points on the x1 axis. The boundary line is defined
%on the x1 axis as slightly smaller and bigger than x1a
%and x1b
    %min - 0.1 * min ==> min * (1 - 0.1) ==> min * 0.9
    %max + 0.1 * max ==> max * (1 + 0.1) ==> max * 1.1
    x1a = min(handles.inputData(2,:))* 0.9;
    x1b = max(handles.inputData(2,:))* 1.1;

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
    thresholdBoundary = plot([x1a; x1b], [x2a,x2b], 'k-', 'linewidth',0.5);
    
    guidata(hObject,handles);

function plotData(hObject,handles)
    
 %workable data has been uploaded
    handles.dataPresent = true;

    handles.inputSize = size(handles.inputData,2); %number of data points
    handles.numInputVariables = size(handles.inputData,1); %number of input variables

    %clear previous data from axes and plot new data on the axes
    cla(handles.networkGraph);
    reset(handles.networkGraph);

    %set (handles.networkGraph, 'XLim',[min(handles.inputData(2,:))* 0.9 max(handles.inputData(2,:))* 1.1]);
    %set (handles.networkGraph, 'YLim',[min(handles.inputData(3,:))* 0.9 max(handles.inputData(3,:))* 1.1]);                          
    
    handles.plottedData = gscatter(handles.inputData(1,1:handles.inputSize),...
            handles.inputData(2,1:handles.inputSize),...
            handles.inputData(3,1:handles.inputSize),'br','xo');

    if (handles.presetDataBoolean==true)
        %To make classification calculations easier, turn all desired outputs
        %into [-1,+1] if they are in [0,1] form. The user will still see the classes 
        %as [0,1] graphically but mathematically they will be different.
        if (ismember([0 1], handles.inputData(3,:)))
            for i = 1:handles.inputSize
                handles.inputData(3,i) = 2*handles.inputData(3,i) - 1;
            end
        end
    end
    
    %separate the desired output classification and remove it from the input data
    handles.desiredOutput = handles.inputData(3,:);
    handles.inputData(3,:)=[];
    
    %add the bias inputs to the data
    handles.inputData = [ ones(1,handles.inputSize) ; handles.inputData ];
    
    handles.weights=randn(handles.numInputVariables,1);
    guidata(hObject,handles);
    
    %display new weights on the GUI
    setWeightLabels(hObject,handles);
    
    hold on;
    displayThresholdBoundary(hObject,handles);

    guidata(hObject,handles);
    
function stepThroughButton_Callback(hObject, eventdata, handles)

%if no data has been entered then show an error message and exit the
%playButton function
if (handles.dataPresent == false)
    msgbox('No data has been given. Please provide data.', 'Error: No data given', 'error');
    
elseif (handles.correct == 1)
    msgbox('Data has been correctly classified. Please press "Reset Dataset" to restart the learning process.');
    
    %if data has been entered, proceed
elseif (handles.dataPresent == true)
            
    %%  set background colours
    %set the desired output to white to show its outcome hasn't been determined
        set (handles.desiredOutputLabel,'BackgroundColor','w');
    %set the perceptron colour to the processing colour to show the data is
    %being processed

        set (handles.weightedSumLabel,'BackgroundColor',handles.processingColour);
        
    %%  wait and initialise correct and time
    %wait for an arbitrary amount of time so the processing isn't almost instantaneous
        pause(0.5);
        
        disableEditBoxesAndThresholdToggles(hObject,eventdata,handles);

        %if this is the first time step through has been pressed with the
        %current data
        if (handles.initialStepThroughComplete == false)
            
            %set the number of datapoints to cycle through
            handles.numDatapointsToCycleThrough = str2double(get(handles.stepThroughEdit,'String'));

            %get the maximum number of iterations entered by the user
            handles.maxIteration = str2double(get(handles.iterationEdit,'String'));
            handles.currentIteration = 0;

            %set the data to being uncorrectly classified
            handles.correct = -1;

            %initialise the number of datapoints to cycle through as
            %"blocks"
            handles.minBlockDatapoints = 1 - handles.numDatapointsToCycleThrough;
            handles.maxBlockDatapoints = 0;

            %the initial step has been completed
            handles.initialStepThroughComplete = true;

            guidata(hObject,handles);
        end
        
    %%  set the learning rate
            learningRate = str2double(get(handles.learningRateEdit,'String'));
        
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
                if handles.maxBlockDatapoints >= handles.inputSize
                    handles.maxBlockDatapoints = handles.inputSize;
                end
            %%
            
            %choose which threshold function to use
            if (get(handles.stepToggle,'Value')== 1) 
                
               
                    weightedSum = handles.weights' * handles.inputData;
                    handles.actualOutput = sign(weightedSum);
                    
                    error = handles.desiredOutput - handles.actualOutput;

                %what we want, what we get, what the difference is
                    %[handles.desiredOutput; handles.actualOutput; error]

                %% compare actual with desired, classify correct or not
                %if any of the actual output is not the same as the desired output then
                %it is incorrectly classified
                if any(handles.actualOutput ~=handles.desiredOutput)
                    handles.correct = -1;
                end
                %%

                %if any datapoint is incorrectly classified, adjust the weights
                if handles.correct == -1

                    %for each datapoint, check if its actual output matches the desired
                    %output. If not, adjust its weight accordingly.
                    for i = handles.minBlockDatapoints:handles.maxBlockDatapoints
                        %% select the currently considered point and highlight it
                            %handles.inputData(1,i) is the +1 bias constant
                            x1 = handles.inputData(2,i);
                            x2 = handles.inputData(3,i);
                            hold on;
                            handles.highlightedPoint = plot(x1,x2,'o','MarkerSize',10);
                            guidata(hObject,handles);
                            pause(0.1);

                        %% set the data on the GUI
                            setInputLabels(hObject,handles,i);
                            setWeightLabels(hObject,handles)
                            setOutputLabels(hObject, handles, i);
                            set (handles.weightedSumLabel,'String', weightedSum(i));
                        %%

                        %if the handles.actualOutput is not the same as the desiredOutput then the weights must be changed
                        if handles.actualOutput(1,i) ~= handles.desiredOutput(1,i)

                            handles.weights = handles.weights + learningRate*error(i)*handles.inputData(:,i);
                                %handles.weights = handles.weights + handles.desiredOutput(1,i) * handles.inputData(:,i);

                            %arbitrary pause to allow the user to see the change in
                            %the threshold boundary as it moves around
                            pause(0.1);
                            
                            %as only one threshold boundary is drawn for a
                            %user defined number of datapoints, the program
                            %can drop out of the classification if statement
                            %and draw the line at the end
                            

                            %% show the weight changes on the GUI as they are processed
                                setWeightLabels(hObject,handles);           
                        end
                        
                        %after the current point has been considered, delete the current highlight
                            delete(handles.highlightedPoint);
                    end
                end
                
            elseif (get(handles.sigmoidToggle,'Value')==1)
                
                    weightedSum = handles.weights' * handles.inputData;
                        handles.actualOutput = 1 ./ (1 + exp(-weightedSum));
                            error = handles.desiredOutput - handles.actualOutput;
                            
                            %reassign the actual output to be thresholded
                            %once the error has been calculated
                        handles.actualOutput = sign(1 ./ (1 + exp(-weightedSum)));
                        
                        %% compare actual with desired, classify correct or not
                    %if any of the actual output is not the same as the desired output then
                    %it is incorrectly classified
                    if any(handles.actualOutput ~=handles.desiredOutput)
                        correct = -1;
                    end
                    %%

                    %if any datapoint is incorrectly classified, adjust the weights
                    if correct == -1

                        %for each datapoint, check if its actual output matches the desired
                        %output. If not, adjust its weight accordingly.
                        for i = 1:handles.inputSize
                            %% select the currently considered point and highlight it
                                %handles.inputData(1,i) is the +1 bias constant
                                x1 = handles.inputData(2,i);
                                x2 = handles.inputData(3,i);
                                hold on;
                                handles.highlightedPoint = plot(x1,x2,'o','MarkerSize',10);
                                guidata(hObject,handles);

                            %% set the data on the GUI inputEdits and All Network Parameters
                                setInputLabels(hObject,handles,i);
                                setWeightLabels(hObject,handles)
                                setOutputLabels(hObject, handles, i);
                                set (handles.weightedSumLabel,'String', weightedSum(i));

                            %%

                            %if the handles.actualOutput is not the same as the desiredOutput then the weights must be changed
                            if handles.actualOutput(1,i) ~= handles.desiredOutput(1,i)

                                handles.weights = handles.weights + learningRate*error(i)*handles.inputData(:,i);

                                %handles.weights = handles.weights + handles.desiredOutput(1,i) * handles.inputData(:,i);

                                %arbitrary pause to allow the user to see the change in
                                %the threshold boundary as it moves around
                                pause(0.001);
                                displayThresholdBoundary(hObject, handles);

                                %% show the weight changes on the GUI as they are processed
                                    setWeightLabels(hObject,handles);           
                            end

                            %after the current point has been considered, delete the current highlight
                                delete(handles.highlightedPoint);
                        end
                    end
            else
                %ERROR
            end
        end

    pause(0.01);
    displayThresholdBoundary(hObject, handles);
    
    %debug statements
     %x =handles.maxBlockDatapoints
     %y=handles.minBlockDatapoints
     %z=handles.inputSize
    
%if all datapoints have been considered, one pass has been made and the block
%sizes must be reset
    if handles.maxBlockDatapoints >= handles.inputSize
        handles.maxBlockDatapoints = 0;
        handles.minBlockDatapoints = 1 - handles.numDatapointsToCycleThrough;
    end
     
    %debug statements
      %x = handles.maxBlockDatapoints
      %y = handles.minBlockDatapoints
     
    %% change feedback colours to show the processing has completed
        set (handles.desiredOutputLabel,'BackgroundColor',handles.completedColour);
        set (handles.weightedSumLabel,'BackgroundColor',handles.notRunningColour);
else
    %ERROR
end

guidata(hObject,handles);

function stopButton_Callback(hObject, eventdata, handles)

function loadPresetDataButton_Callback(hObject, eventdata, handles)

%Get the filename and pathname for files of .mat type
[filename, pathname] = uigetfile('*.mat', 'Load .mat data');

%If the file is empty
if filename ~= 0

    %load the data stored in the pathname
        handles.inputData = load(fullfile(pathname, filename));
    
    %The data loaded SHOULD have ONE field name, i.e. [1x1 struct] 
    %The name, i.e. the name of the file loaded, is used to get
    %the data from the array structure
        name = fieldnames(handles.inputData);
    
    %retrieve the input data from the [1x1 struct]
        handles.inputData = handles.inputData.(name{1});
        
        %store the originally loaded data so it can be reset later
        handles.originalDataForReset = handles.inputData;
        
        handles.presetDataBoolean = true;
        clearAllLabels(hObject,handles);
        enableEditBoxesAndThresholdToggles(hObject,eventdata,handles);
        
        %%%%%%%
        set (handles.dataTable, 'Data', handles.inputData');
        a = handles.inputData
        
        %=======
        handles.correct = -1;
        handles.initialStepThroughComplete = false;
        
        guidata(hObject,handles);


        plotData(hObject,handles);
end
    
function generateDatasetButton_Callback(hObject, eventdata, handles)

%NEEDS A BETTER INPUT METHOD I.E. [X1 X2] FOR MEAN AND STD
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

         %ERROR PROTECTION FOR INVALID DATA NEEDED
         promptData = inputdlg(prompt,title,1,default_ans);
         
         %if the user cancels, exit the function
         if isempty(promptData)
             return;
         end

%% Example sample
%     sampleAsize   = 30;
%     sampleBsize   = 30;
% 
%     sampleAmean   = [ 1.3 1.3]
%     sampleAstdDev = [ 0.1 0.1 ]
% 
%     sampleBmean   = [ 0.7 0.9 ]
%     sampleBstdDev = [ 0.34 0.16 ]
%%

    sampleAsize = str2double(promptData(1));
    sampleBsize = str2double(promptData(2));

    sampleAmean = [str2double(promptData(3)), str2double(promptData(4))];
   	sampleAstdDev = [str2double(promptData(5)), str2double(promptData(6))];
    
    sampleBmean = [str2double(promptData(7)), str2double(promptData(8))];
    sampleBstdDev = [str2double(promptData(9)), str2double(promptData(10))];
    
%% IGNORE=========================================
     %sampleAsize = str2double(promptData(1))
     %sampleBsize = str2double(promptData(2))
     %%cell2mat
%       sampleAmean = str2num(promptData(3))
%   	sampleAstdDev = str2num(promptData(4)) 
%       sampleBmean = cell2mat(promptData(5))
%    	sampleBstdDev = cell2mat(promptData(6))
% ===============================================
%%
    handles.inputData  = [...
        normallyDistributedSample( sampleAsize, sampleAmean, sampleAstdDev )' ...
        normallyDistributedSample( sampleBsize, sampleBmean, sampleBstdDev )';...
        ones(sampleAsize,1)' -ones(sampleBsize,1)'];
    
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

    %store the originally loaded data so it can be reset later
    handles.originalDataForReset = handles.inputData;

    handles.presetDataBoolean = false;
    cla(handles.networkGraph);
    reset(handles.networkGraph);
    clearAllLabels(hObject,handles);
    
    set (handles.dataTable, 'Data', handles.inputData');
    

    handles.correct = -1;
    handles.initialStepThroughComplete = false;
    enableEditBoxesAndThresholdToggles(hObject,eventdata,handles);
        
    guidata(hObject,handles);
    
    plotData(hObject,handles);

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

function resetDatasetButton_Callback(hObject, eventdata, handles)
if ~isempty(handles.inputData)
    clearAllLabels(hObject,handles);
    
    decision = questdlg('Would you like to keep all user created datapoints?', ...
        'Keep user created datapoints?', ...
        'Yes','No','No');
    
    switch decision
        case 'Yes'  %keep the user created data
            handles.inputData = [handles.originalDataForReset handles.createdDatapoints];
        case 'No'   %reload data from when data was loaded
            handles.inputData = handles.originalDataForReset;
            handles.createdDatapoints = [];
    end
    
   plotData(hObject,handles);
    
   handles.correct = -1;
   handles.initialStepThroughComplete = false;
   
   %allow users to make changes to the learning process again
   enableEditBoxesAndThresholdToggles(hObject,eventdata,handles);
    
   guidata(hObject,handles);
end

%======================
function disableEditBoxesAndThresholdToggles(hObject,eventdata, handles)
    
    %stop the user from changing values, threshold function types, or create new datapoints half
    %way through the learning process. This will prevent unwanted errors.
    set(handles.stepToggle,'Enable','Off');
    set(handles.sigmoidToggle,'Enable','Off');
    
    set(handles.learningRateEdit,'Enable','Off');
    
    set(handles.iterationEdit,'Enable','Off');
    set(handles.stepThroughEdit,'Enable','Off');
    
    set(handles.graphDatapointCreationToggle,'Enable','off');
    set(handles.manualDatapointCreationToggle,'Enable','off');
 
        set (handles.classAToggle,'Enable','off');
        set (handles.classBToggle,'Enable','off');

        set (handles.manualDatapointCreationX1Edit,'Enable','off');
        set (handles.manualDatapointCreationX2Edit,'Enable','off');
        set (handles.manualDatapointCreationClassEdit,'Enable','off');
        set (handles.manualDatapointCreationCompleteButton,'Enable','off');
    
    guidata(hObject,handles);     
function enableEditBoxesAndThresholdToggles(hObject,eventdata, handles)
            
    %renable the ability for users to change values, threshold functions
    %and create new values.
    set(handles.stepToggle,'Enable','On');
    set(handles.sigmoidToggle,'Enable','On');
    
    set(handles.learningRateEdit,'Enable','On');
    
    set(handles.iterationEdit,'Enable','On');
    set(handles.stepThroughEdit,'Enable','On');
    
    set(handles.graphDatapointCreationToggle,'Enable','on');
    set(handles.manualDatapointCreationToggle,'Enable','on');
        graphDatapointCreationToggle_Callback(hObject,eventdata, handles);
        manualDatapointCreationToggle_Callback(hObject,eventdata, handles);
    
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
guidata(hObject,handles);

function classBColourChoice_Callback(hObject, eventdata, handles)

handles.classBColour = uisetcolor;

if handles.classBColour == 0
     return;
end

set(handles.classBPanel,'BackgroundColor',handles.classBColour);
guidata(hObject,handles);

function thresholdBoundaryColourChoice_Callback(hObject, eventdata, handles)
    
handles.thresholdColour = uisetcolor;

if handles.thresholdColour == 0
     return;
end

set(handles.thresholdPanel,'BackgroundColor',handles.thresholdColour);
guidata(hObject,handles);  
%========================

function setSliderMaxValue(hObject, handles)

if handles.inputSize ~= 0
    set (handles.stepSlider,'Max',handles.inputSize);
else 
    set (handles.stepSlider,'Max', 0);
end

function stepSlider_Callback(hObject, eventdata, handles)
            function stepSlider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%=====================

function learningRateEdit_Callback(hObject, eventdata, handles)

learningRate = str2double(get(handles.learningRateEdit,'String'));

if (~(isnumeric(learningRate)...
   & ~isnan(learningRate)...
   & isreal(learningRate)))...
   || (learningRate<0 || learningRate>1)
    
    errorMessage = msgbox('Learning rate must be in the range of 0 - 1 ', 'Error', 'error');
    set (handles.learningRateEdit, 'String', '1');
end
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
    end

    guidata(hObject, handles);

function manualDatapointCreationCompleteButton_Callback(hObject, eventdata, handles)

%append the new datapoint to the input data, desiredOutput, and
%recalculate inputSize
    handles.inputData = [handles.inputData [1; handles.manualX1Input; handles.manualX2Input]];
    handles.desiredOutput = [handles.desiredOutput handles.manualClassInput];
    handles.inputSize = size(handles.inputData,2);

%append the new datapoint to createdDatapoints. Allows the user the
%option of including manually created data when reseting datapoints
    handles.createdDatapoints = [handles.createdDatapoints [handles.manualX1Input; handles.manualX2Input; handles.manualClassInput]];

%referesh the data on the graph
%%%%%COULD BE DONE BY JUST ADDING THE NEW DATAPOINTS ONLY RATHER THAN
%REPLOTTING ALL DATAPOINTS
    cla(handles.networkGraph);
    reset(handles.networkGraph);

    set (handles.networkGraph, 'XLim',[min(handles.inputData(2,:))* 0.9 max(handles.inputData(2,:))* 1.1]);
    set (handles.networkGraph, 'YLim',[min(handles.inputData(3,:))* 0.9 max(handles.inputData(3,:))* 1.1]); 


 handles.plottedData = gscatter(handles.inputData(2,1:handles.inputSize),...
                                handles.inputData(3,1:handles.inputSize),...
                                handles.desiredOutput(1,1:handles.inputSize),'br','xo');

%set the editboxes to empty to show they're ready for new input
    set (handles.manualDatapointCreationX1Edit,'String','');
    set (handles.manualDatapointCreationX2Edit,'String','');
    set (handles.manualDatapointCreationClassEdit,'String','');

guidata(hObject,handles);
        
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

% --- Executes on button press in addDatapoints.
function addDatapoints_Callback(hObject, eventdata, handles)
% hObject    handle to addDatapoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (get(handles.graphDatapointCreationToggle,'Value')==1)

    [X1,X2] = getpts(handles.networkGraph);

    if (get(handles.classAToggle,'Value')==1)
        tempDesiredOutput = 1;
    elseif (get(handles.classBToggle,'Value')==1)
        tempDesiredOutput = -1;
    else
        %Error
    end
    
    if handles.dataPresent == true
        
        handles.inputData = [handles.inputData [ones(1,length(X1'));X1';X2']];
        handles.desiredOutput = [handles.desiredOutput [ones(1,length(X1'))*tempDesiredOutput]];
        
    elseif handles.dataPresent == false
        
        %append the created datapoints to the input data
    %need to create a vector of 1's and multiply by the class (+1 or -1)
    %to create a row vector of +1 or -1 to append to the input data
    handles.inputData = [handles.inputData [X1';X2';ones(1,length(X1'))*tempDesiredOutput]];

    end
    
    
    
    
    
end
