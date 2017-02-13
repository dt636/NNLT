function varargout = RBFNPage(varargin)
% RBFNPAGE MATLAB code for RBFNPage.fig
%      RBFNPAGE, by itself, creates a new RBFNPAGE or raises the existing
%      singleton*.
%
%      H = RBFNPAGE returns the handle to a new RBFNPAGE or the handle to
%      the existing singleton*.
%
%      RBFNPAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RBFNPAGE.M with the given input arguments.
%
%      RBFNPAGE('Property','Value',...) creates a new RBFNPAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RBFNPage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RBFNPage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RBFNPage

% Last Modified by GUIDE v2.5 13-Feb-2017 17:42:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RBFNPage_OpeningFcn, ...
                   'gui_OutputFcn',  @RBFNPage_OutputFcn, ...
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


% --- Executes just before RBFNPage is made visible.
function RBFNPage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RBFNPage (see VARARGIN)

% Choose default command line output for RBFNPage
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RBFNPage wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RBFNPage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in rbfnPlay.
function rbfnPlay_Callback(hObject, eventdata, handles)
% hObject    handle to rbfnPlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.inputSize = size(handles.inputData,2);

handles.numberOfCentres = 3;%ceil(nthroot(handles.inputSize,3));

handles.inputIndexSample = randsample(handles.inputSize, handles.numberOfCentres);

handles.chosenCentres = handles.inputData(:,handles.inputIndexSample');



%%%%%%%%%%%%%%%%%%
x1 = handles.chosenCentres(1,:);
x2 = handles.chosenCentres(2,:);
hold on;
handles.highlightedPoint = plot(x1, x2,'o','LineWidth',2,'MarkerEdgeColor','k','MarkerSize',10);
guidata(hObject,handles);
%%%%%%%%%%%%%%%%%%%%%


handles.listOfDatapoints = [handles.inputData handles.chosenCentres];

handles.distFromPoint2AllOtherPoints = squareform(pdist(handles.listOfDatapoints'));

handles.distFromPoint2Centres = handles.distFromPoint2AllOtherPoints(...
    1:handles.inputSize,...
    handles.inputSize + 1 : handles.inputSize+handles.numberOfCentres);

handles.distFromCentre2Centre = handles.distFromPoint2AllOtherPoints(...
    handles.inputSize + 1 : end,...
    handles.inputSize + 1 : end);

handles.maxDistanceFromCentre2Centre = max(max(handles.distFromCentre2Centre));

handles.functionResponse = exp((-handles.numberOfCentres * (handles.distFromPoint2Centres.^2)...
    / (handles.maxDistanceFromCentre2Centre^2)));

handles.pseudoInverseResponse = pinv(handles.functionResponse);

handles.rbfnWeights = handles.pseudoInverseResponse * handles.rbfnDesiredOutput';

handles.rbfnActualOutput = handles.functionResponse * handles.rbfnWeights;

 handles.rbfnOutputClass = handles.rbfnActualOutput > 0.5;
 
 y = handles.rbfnOutputClass;

x = handles.rbfnOutputClass' - handles.rbfnDesiredOutput;


%%%%===========
%x = [
%norm = normpdf(x,handles.chosenCentres(
%rbfnh1ResponseGraph = plot(x,norm);


function plotData(hObject,handles)

 %workable data has been uploaded
    handles.dataPresent = true;

    handles.inputSize = size(handles.inputData,2); %number of data points
    handles.numInputVariables = 2;%size(handles.inputData,1); %number of input variables

    %clear previous data from axes and plot new data on the axes
    cla(handles.rbfnDataGraph);
    reset(handles.rbfnDataGraph);

    %set (handles.rbfnDataGraph, 'XLim',[min(handles.inputData(2,:))* 0.9 max(handles.inputData(2,:))* 1.1]);
    %set (handles.rbfnDataGraph, 'YLim',[min(handles.inputData(3,:))* 0.9 max(handles.inputData(3,:))* 1.1]);                          
    
    handles.rbfnDataGraph = gscatter(handles.inputData(1,1:handles.inputSize),...
            handles.inputData(2,1:handles.inputSize),...
            handles.inputData(3,1:handles.inputSize),'br','xo');
        

%     if (handles.presetDataBoolean==true)
%         %To make classification calculations easier, turn all desired outputs
%         %into [-1,+1] if they are in [0,1] form. The user will still see the classes 
%         %as [0,1] graphically but mathematically they will be different.
%         if (ismember([0 1], handles.inputData(3,:)))
%             for i = 1:handles.inputSize
%                 handles.inputData(3,i) = 2*handles.inputData(3,i) - 1;
%             end
%         end
%     end
    
    %separate the desired output classification and remove it from the input data
    handles.rbfnDesiredOutput = handles.inputData(3,:);
    handles.inputData(3,:)=[];
    
    %add the bias inputs to the data
    %handles.inputData = [ ones(1,handles.inputSize) ; handles.inputData ];
    
    %handles.weights=randn(handles.numInputVariables,1);
    guidata(hObject,handles);
    
    %display new weights on the GUI
    %setWeightLabels(hObject,handles);
    
    %hold on;
    %displayThresholdBoundary(hObject,handles);

% --- Executes on button press in rbfnLoadPresetDataButton.
function rbfnLoadPresetDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to rbfnLoadPresetDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
        
        guidata(hObject,handles);

        plotData(hObject,handles);

end

% --- Executes on button press in rbfnGenerateDatasetButton.
function rbfnGenerateDatasetButton_Callback(hObject, eventdata, handles)
% hObject    handle to rbfnGenerateDatasetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
         promptData = inputdlg(prompt,title,1,default_ans)

%     sampleAsize   = 30;
%     sampleBsize   = 30;
% 
%     sampleAmean   = [ 1.3 1.3]
%     sampleAstdDev = [ 0.1 0.1 ]
% 
%     sampleBmean   = [ 0.7 0.9 ]
%     sampleBstdDev = [ 0.34 0.16 ]

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
%% ===============================================
 
    handles.inputData  = [...
        normallyDistributedSample( sampleAsize, sampleAmean, sampleAstdDev )' ...
        normallyDistributedSample( sampleBsize, sampleBmean, sampleBstdDev )';...
        ones(sampleAsize,1)' -ones(sampleBsize,1)'];
    
    % ---------------------------------------------------------------------
    % Randomly permute samples & class labels.
    %
    %   This is not really necessary, but done to illustrate that the order
    %   in which observations are evaluated does not matter.
    %
     %randomOrder   = randperm( sampleAsize + sampleBsize );
     %handles.inputData  = handles.inputData( :, randomOrder );
     %handles.inputData
%     Data.labels   = Data.labels(  randomOrder, : );

    %store the originally loaded data so it can be reset later
    handles.originalDataForReset = handles.inputData;

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

% --- Executes on button press in rbfnResetDatasetButton.
function rbfnResetDatasetButton_Callback(hObject, eventdata, handles)
% hObject    handle to rbfnResetDatasetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.inputData)

    
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
    
    guidata(hObject,handles);
end
