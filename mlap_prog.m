
%!/usr/bin/env matlab
function []=mlap_prog(taskNum, data)

if taskNum == '1'
    TaskOne(data)
elseif taskNum == '2'
    TaskTwo(data)
elseif taskNum == '3'
    TaskThree(data)
elseif taskNum == '4'
    TaskFour(data)
else
    disp 'Task number =/= 1, 2, 3 or 4'
end

end

function TaskOne(data)

 fileID = fopen(data);
 tempStringData = textscan(fileID,'%s','delimiter','\n');
 fclose(fileID);
 
 stringData = tempStringData{1};

%initialise the number of episodes
episodes = 0;

%init: number of times in h1
%probablity = column one / number of episodes
init = zeros(16, 1);

%trans:  number of times moving from S(i) to S(j)
trans = zeros(16, 16);

%emis: column 1-3: number of times emitting -1, 0, +1 reward, respectively
%probablity = number of times of (-1|0|+1) / number of times in state S(i)
emis = zeros(16, 3);

%total number of times in each state
noTimesInSI = zeros(16,1);

for i = 1:numel(stringData)
    
    %if this is the first line or if the line before i is empty then this is the start of a new episode
    if isequal(stringData{i},'')
        continue
    else
        %extract the numbers as strings from the stringData on line i
        extractedNums = regexp(stringData{i}, '-?\d*','match');
        
        %calculate the row for the current line using 4*x + (y+1)
        sI = 4 * str2double(extractedNums{1}) + (str2double(extractedNums{2}) + 1);
        %turn the emission string into a number
        em = str2double(extractedNums{3});
        
        %increment the number of times in sI
        noTimesInSI(sI) = noTimesInSI(sI) + 1;
        
        %increment the emission counts
        if em == -1
            emis(sI,1) = emis(sI,1) + 1;
        elseif em == 0
            emis(sI,2) = emis(sI,2) + 1;
        elseif em == 1
            emis(sI,3) = emis(sI,3) + 1;
        else
            disp 'Emission =/= -1, 0 or +1'
        end
        
        if (i==1) || isequal(stringData{i-1},'')
            %increment the number of times in sI for the initial state
            init(sI,1) = init(sI,1) + 1;
            %increment the number of episodes
            episodes = episodes + 1;
        else
            %if i isn't the start or after an empty space, increment how
            %many time we've moved from the previous state to the current
            %state
            trans(tempSI,sI) = trans(tempSI,sI) + 1;
        end
        
        %change the previous state to the current state, ready for the next
        %iteration
        tempSI = sI;
    end
end


% %calculate the initial probablities
     probInit = init(:,1) ./ episodes;
fprintf('Initial h1 probabilities:\n');
fprintf('Coord\tProb\n');
for x = 0:3
    for y = 0:3
        fprintf('(%d,%d)\t%.3f\n',x,y,probInit(4*x + (y+1)));
    end
end

%calculate the emission probabilities
    probEmis = emis(:,:) ./ noTimesInSI;
    %turn NaN to 0
    probEmis(isnan(probEmis))=0;
fprintf('\nEmission probabilities:\n');
fprintf('Coord     -1       0      1\n');
for x = 0:3
    for y = 0:3
        fprintf('(%d,%d)\t%0.3f\t%0.3f\t%0.3f\n',x,y,probEmis(4*x + (y+1),:));
    end
end

%calculate the transition probabilities
    probTrans = trans(:,:) ./ noTimesInSI;
    %turn NaN to 0
    probTrans(isnan(probTrans))=0;
fprintf('\nTransition probabilities:\n\t\t');

for x = 0:3
    for y = 0:3
        fprintf('(%d,%d)\t',x,y);
    end
end
 
fprintf('\n');

for x = 0:3
    for y = 0:3
        fprintf('(%d,%d)\t',x,y);
        fprintf('%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t \n',probTrans(4*x + (y+1),:));
    end
end

end


function TaskTwo(data)

fileID = fopen(data);
tempStringData = textscan(fileID,'%s','delimiter','\n');
fclose(fileID);
 
stringData = tempStringData{1};
 
%initialise the number of episodes
episodes = 0;

for i = 1:numel(stringData)
    
    %skip if the current input is a space i.e. empty
    if isequal(stringData{i},'')
        continue
    else
        
        %if this is the first line or if the line before i is empty then this is the start of a new episode
        if (i==1) || isequal(stringData{i-1},'')
            episodes = episodes + 1;
            %reset observation index
            ObsIndex = 1;
        end
        
        %extract the numbers as strings from the stringData on line i
        extractedNums = regexp(stringData{i}, '-?\d*','match');
        
        %turn the emission string into a number
        em = str2double(extractedNums{1});

        %add offset to make it easier to index emission columns
        %%%%%%%
        Obs(episodes,ObsIndex) = em+2;
            ObsIndex = ObsIndex + 1;
    end
end

%set empty elements to NaN and readjust the matrix to original values
Obs(Obs==0)=NaN;

N = 16; %number of states
P = ones(N, 1)/N; %initial probability
A = ones(N, N)/N; %transition probability matrix
B = ones(N,3)/3; %emission probability matrix

for episode = 1:episodes
    
    %extract the current episode observation data, excluding NaN values
    Y = Obs(episode,:);
    Y(isnan(Y))=[];
    
    maxt = length(Y);

    %alpha forward procedure
        alpha = zeros(N ,maxt);
        alpha(:,1) = P.*B(:,Y(1));
        for t = 2:maxt
            for state = 1:N
                alpha(state,t)=sum((alpha(:,t-1).*A(:,state)))*B(state,Y(t));
            end
        end

    %beta backward procedure
        beta = ones(N, maxt);
         for t = maxt-1:-1:1
            for state = 1:N
                 beta(state,t) = sum(A(state,:)'.*beta(:,t+1).*B(:,Y(t+1)));
            end
         end
     
     %gamma procedure
         gamma =  zeros(N, maxt);
         for t = 1:maxt
             gamma(:,t) = alpha(:,t) .* beta(:,t);
             gamma(:,t) = gamma(:,t) / sum(gamma(:,t));
         end
     
     %xi procedure
     
        xi = zeros(N,N,maxt-1);
        for t = 1:maxt-1
            xi(:,:,t) = A .*alpha(:,t)' * beta(:,t+1) .*B(:,t+1);
            xi(:,:,t) = xi(:,:,t) / sum(sum(xi(:,:,t)));
        end

    P = gamma(:,1)

    %A=sum(xi)/sum(gamma)
    %B=sum(gamma)*Y(t)==v(t)/sum(gamma)
end 

end


function TaskThree(data)
fileID = fopen(data);
tempStringData = textscan(fileID,'%s','delimiter','\n');
fclose(fileID);
 
stringData = tempStringData{1};

%initialise the number of episodes
episodes = 0;

for i = 1:numel(stringData)
    
    %skip if the current input is a space i.e. empty
    if isequal(stringData{i},'')
        continue
    else
        
        %if this is the first line or if the line before i is empty then this is the start of a new episode
        if (i==1) || isequal(stringData{i-1},'')
            episodes = episodes + 1;
            %reset observation index
            ObsIndex = 1;
        end
        
        %extract the numbers as strings from the stringData on line i
        extractedNums = regexp(stringData{i}, '-?\d*','match');
        
        %turn the emission string into a number
        em = str2double(extractedNums{1});

        %add offset to so only extra matrix 0's get turned to NaN
        %%%%%%%
        Obs(episodes,ObsIndex) = em+2;
            ObsIndex = ObsIndex + 1;
    end
end

%set empty elements to NaN and readjust the matrix to original values
Obs(Obs==0)=NaN;


for run = 1:10

    N = 16; %number of states
    
    P = rand(N,1);
    P = P./sum(P);
    
    A = rand(N,N);
    A = A./sum(A);
    
    B = rand(N,3);
    B = B./sum(B);


    for episode = 1:episodes

        %extract the current episode observation data, excluding NaN values
        Y = Obs(episode,:);
        Y(isnan(Y))=[];

        maxt = length(Y);

        %alpha forward procedure
        alpha = zeros(N ,maxt);
        alpha(:,1) = P.*B(:,Y(1));
        for t = 2:maxt
                %alpha(:,t) = (alpha(:,t-1).*A(:,:))*B(:,Y(t));
            for state = 1:N
                alpha(state,t)=sum((alpha(:,t-1).*A(:,state)))*B(state,Y(t));
            end
        end

        %beta backward procedure
        beta = ones(N, maxt);
         for t = maxt-1:-1:1
            for state = 1:N
                 beta(state,t) = sum(A(state,:)'.*beta(:,t+1).*B(:,Y(t+1)));
            end
         end
     
        %gamma procedure
         gamma =  zeros(N, maxt);
         for t = 1:maxt
             gamma(:,t) = alpha(:,t) .* beta(:,t);
             gamma(:,t) = gamma(:,t) / sum(gamma(:,t));
         end
     
        %xi procedure
        xi = zeros(N,N,maxt-1);
        for t = 1:maxt-1
            xi(:,:,t) = (A(:,:) .*(alpha(:,t)' * (beta(:,t+1) .*B(:,t+1))));
            xi(:,:,t) = xi(:,:,t) / sum(sum(xi(:,:,t)));
        end
        
    end 

end

end

function TaskFour(data)
    disp('Not implemented');
end