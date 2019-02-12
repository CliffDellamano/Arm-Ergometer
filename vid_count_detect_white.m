%% Blanking Workspace

clear
close
clc

%% Analysis

Vid=VideoReader('20180105_133947.mp4');

nframes=Vid.NumberOfFrames;

I=read(Vid, 1); 
imshow(I);
disp('Select area that will be used to count revolutions. ');
rect=getrect(1);
close
clc

thresh=input('Type the grayscale value at which anything higher will count. ');
clc

cycles=0;
prev_detect=0;
clear I
detect_frames=[];

for k=2:nframes
    
    CurrentFrame=read(Vid,k);
    CF=rgb2gray(CurrentFrame);
    
    PrevFrame=read(Vid,k-1);
    PF=rgb2gray(PrevFrame);
    
    detect=0;
    
    for n=floor(rect(1)):ceil(rect(1)+rect(3))
        for j=floor(rect(2)):ceil(rect(2)+rect(4))
            if CF(size(CF,1)-j,n)>thresh
                detect=1;
            end
        end
    end
    
    if detect==1&&prev_detect==0
        cycles=cycles+1;
        detect_frames=[detect_frames;k];
    end
    
    prev_detect=detect;
end