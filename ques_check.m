%This portion of the script will check all questions and answers to ensure they are under
%the allowable limit of characters, and will output a report stating which
%questions follow these guidelines and which need to be removed.

%% Start with Clean Workspace

clear
clc
close

%% Importing Data

[~, ~, raw] = xlsread('C:\Users\Cliff\Documents\VA\Ergometer Game\Trivia Questions.xlsx','Sheet1');
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,[1,2]);

questions = cellVectors(1:5:end,2);

answers = cellVectors(2:end,2);
answers(5:5:end)=[];

clearvars data raw cellVectors;

%% Checking Question Length

discard_ques=[];
bad_ques=0;

for ques_num=1:length(questions)
    if length(questions{ques_num})>=50
        bad_ques=1;
        discard_ques=[discard_ques;ques_num];
    end
end

discard_ans=[];
bad_ans=0;

for ans_num=1:length(answers)
    if length(answers{ans_num})>=25
        bad_ans=1;
        discard_ans=[discard_ans;ans_num];
    end
end
        

%% Output

if bad_ques==0&&bad_ans==0
    disp('All questions and answers are formatted correctly. Press any key to continue the script.')
    pause
end

if bad_ques==1
    disp([ num2str(length(discard_ques)) ' questions are formatted incorrectly. The questions that do not fit the format are: '])
    disp(discard_ques)
    if bad_ans==0
        return
    end
end
    
if bad_ans==1
    disp([ num2str(length(discard_ans)) ' answers are formatted incorrectly. The questions that correspond to these answers are: '])
    disp(ceil(discard_ans./4))
    return
end