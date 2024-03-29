%This portion of the script will check all questions and answers to ensure they are under
%the allowable limit of characters, and will output a report stating which
%questions follow these guidelines and which need to be removed.

%% Start with Clean Workspace

clear
clc
close

%% Importing Data

[~, ~, raw] = xlsread('C:\Users\Cliff\Documents\VA\Arm Ergometer\Trivia Questions.xlsx','Sheet1');
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
    if length(questions{ques_num})>50
        bad_ques=1;
        discard_ques=[discard_ques;ques_num];
    end
end

discard_ans=[];
bad_ans=0;

for ans_num=1:length(answers)
    if length(answers{ans_num})>25
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

%%
% This portion of the script will take an Excel sheet of questions and
% answers as input and output a JSON-compatible file for use in the game.

%The Word document of questions and answers that will be converted into the 
%Excel file, and therefore a set of variables for this script, will need to 
%be in the following format:

%1) Question
%a. 
%b.
%c.
%d.

%as well as be saved with the name "Trivia Questions.xlsx".

%Before copying the Word document into Excel, the list formatting
%automatically generated by Word will need to be removed. If not, Excel
%will place each line into one cell, rather than separating the
%letter/number from its corresponding question/answer. Spaces between
%questions will also need to be removed, as they will affect indexing.

%Correct answers will need to be marked in a separate answer key file, saved
%as "Answer Key.xlsx", in the form:

%1. A
%2. C

%% Start with Clean Workspace

clear
clc
close

%% Importing Data

[~, ~, raw] = xlsread('C:\Users\Cliff\Documents\VA\Arm Ergometer\Trivia Questions.xlsx','Sheet1');
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,[1,2]);

questions = cellVectors(1:5:end,2);

answers = cellVectors(2:end,2);
answers(5:5:end)=[];

clearvars data raw cellVectors;

[~, ~, raw] = xlsread('C:\Users\Cliff\Documents\VA\Arm Ergometer\Answer Key.xlsx','Sheet1');
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,[1,2]);

correct_ans=cellVectors(:,2);

clearvars data raw cellVectors;

%% Correct Answer Conversions

for ques_num=1:length(questions)
    if strcmp(correct_ans(ques_num),'A')==1
        correct_ans{ques_num,2}=1;
    elseif strcmp(correct_ans(ques_num),'B')==1
        correct_ans{ques_num,2}=2;
    elseif strcmp(correct_ans(ques_num),'C')==1
        correct_ans{ques_num,2}=3;
    elseif strcmp(correct_ans(ques_num),'D')==1
        correct_ans{ques_num,2}=4;
    end
    correct_ans{ques_num,3}=answers{((ques_num-1)*4)+correct_ans{ques_num,2}};
end

%% Outputting

disp('{')
disp('"Items": [')
        
for ques_num=1:length(questions)
    disp('{')
    disp(['"quesText": "' questions{ques_num} '",'])
    disp(['"ansA": "A) ' answers{((ques_num)-1)*4+1} '",'])
    disp(['"ansB": "B) ' answers{((ques_num)-1)*4+2} '",'])
    disp(['"ansC": "C) ' answers{((ques_num)-1)*4+3} '",'])
    disp(['"ansD": "D) ' answers{(ques_num)*4} '",'])
    disp(['"correctAnsNum": ' num2str(correct_ans{(ques_num),2}) ','])
    disp(['"correctAnsText": "' correct_ans{ques_num} ') ' correct_ans{(ques_num),3} '"'])
    disp('},')
end
    
    disp(']')

disp('}')