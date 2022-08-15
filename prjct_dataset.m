clc;
clear;
%close all;
warning off all;
%Image Loading
%here = genpath('.');
%addpath(here);
%[file,path] = uigetfile('*.jpg','Select  Sample Image ');  %% uigetfile displays a dialog box used to retrieve one or more files. The dialog box lists the files and directories in the current directory.
%image_file = fullfile(path,file);%% fullfile(dir1, dir2, ..., filename) builds a full filename from the directories and filename specified.
filelist=dir(fullfile('D:\project\dataset\normal','*.jpg'));
x=length(filelist);
fprintf('total no of images found = %d \n',x);
count=0;
for i=1:100
    
    file=fullfile(filelist(i).name);
    fprintf('Image %d is in progress\n',i);
  %img=sprintf('filelist(%d).jpg',i);  
GIm = imread(file);
%figure;
%subplot(1,2,1);

%imshow(GIm);
mytitle = strcat('Original image:',num2str(i));
%title(mytitle);

%% convert to grayscale and do Histogram Equalization

gray = rgb2gray(GIm);
%gray=imresize(gray,3);

 %subplot(1,2,2);
%imshow(gray);
%title('GrayScale Image');
%image=gray2rgb(gray);
%figure;
%imshow(image);title('reverse Image');
%% Image enhancement
Enhanced_gray = imadjust(gray);
%{

numofpixels=size(gray,1)*size(gray,2);


figure;
subplot(2,2,1);
imshow(GIm);

title(' Original Image');
HIm=uint8(zeros(size(GIm,1),size(GIm,2)));

freq=zeros(256,1);

probf=zeros(256,1);

probc=zeros(256,1);

cum=zeros(256,1);

output=zeros(256,1);


%freq counts the occurrence of each pixel value.

%The probability of each occurrence is calculated by probf.


for i=1:size(GIm,1)

    for j=1:size(GIm,2)

        value=GIm(i,j);

        freq(value+1)=freq(value+1)+1;

        probf(value+1)=freq(value+1)/numofpixels;

    end

end


sum=0;

no_bins=255;


%The cumulative distribution probability is calculated. 

for i=1:size(probf)

   sum=sum+freq(i);

   cum(i)=sum;

   probc(i)=cum(i)/numofpixels;

   output(i)=round(probc(i)*no_bins);

end

for i=1:size(GIm,1)

    for j=1:size(GIm,2)

            HIm(i,j)=output(GIm(i,j)+1);

    end

end

subplot(2,2,2);
imshow(HIm);

title('Enhancement using manual coding');
%}
a=histeq(gray);
%subplot(2,2,3);
%imshow(a);
%title('Enhancement using histeq');
Enhanced_gray=imadjust(gray);
%subplot(2,2,4);
%imshow(Enhanced_gray);
%title('Enhancement using imadjust');

%figure;
%subplot(1,2,1);
%imshow(Enhanced_gray);
%title('enhanced image');
%subplot(1,2,2);
%imshow(gray);
%title('gray image');


%% Image Segmentation
BW = edge(Enhanced_gray,'Canny',0.7);

%figure;
% subplot(3,3,4);
%imshow(BW);
%title('Detected Edges');

%% Morphological Operations

se = strel('square',1);
BW2 = imdilate(BW,se);

%figure;
% subplot(3,3,5);
%imshow(BW2);
BW3 = imfill(BW2,'holes');
%title('Holes Filled');
% BW3 = ~BW3;
L=bwlabel(BW3);
S = regionprops(L,'BoundingBox');
%figure;
%imshow(~BW3);hold on;
for nn = 1:length(S)
    
   rectangle('Position',S(nn).BoundingBox,'EdgeColor','r');
    
end

% subplot(3,3,6);


%mytitle = strcat('No. of objects detected:',num2str(length(S)));
%title(mytitle);
%% %%%%%%%%%  RBC Extraction  %%%%%%%%%%%% %%


total_rows = size(GIm,1);
total_columns = size(GIm,2);

old_color_image = GIm;

new_color_image = uint8(zeros(total_rows,total_columns,3));

for rows = 1:total_rows
    for columns = 1:total_columns
        
        if (old_color_image(rows,columns,1) <= 255 && old_color_image(rows,columns,1) >= 170 )
            new_color_image(rows,columns,1) = old_color_image(rows,columns,1);
        else
            new_color_image(rows,columns,1) = 255;
        end
        
        if (old_color_image(rows,columns,2) <= 201 && old_color_image(rows,columns,2) >= 150 )
            new_color_image(rows,columns,2) = old_color_image(rows,columns,2);
        else
            new_color_image(rows,columns,2) = 255;
        end
        
        if (old_color_image(rows,columns,3) <= 220 && old_color_image(rows,columns,3) >= 160 )
            new_color_image(rows,columns,3) = old_color_image(rows,columns,3);
        else
            new_color_image(rows,columns,3) = 255;
        end
        
    end
end

%figure;
% subplot(3,3,7);
%imshow(new_color_image);
%title('RBC Extraction');

new_gray_image = rgb2gray(new_color_image);
Enhanced_gray=imadjust(new_gray_image);
th = graythresh(Enhanced_gray);
edge_detected_image = edge(Enhanced_gray,'Canny',.7);

%figure;
%imshow(degi);
%title('Detected Edges');
BW = im2bw(edge_detected_image,th);
se = strel('square',1);
BW2 = imdilate(BW,se);

%figure;
%imshow(BW2);
BW3 = imfill(BW2,'holes');
%title('Holes Filled');
% BW3 = ~BW3;
%figure;
%    imshow(BW3);
L=bwlabel(BW3);
S = regionprops(L,'BoundingBox');
%figure;
%imshow(~BW3);hold on;
for nn = 1:length(S)
    
   rectangle('Position',S(nn).BoundingBox,'EdgeColor','b','linewidth',1);
    
end

% subplot(3,3,6);


mytitle = strcat('No. of RBCs detected:',num2str(length(S)));
%title(mytitle);
 
%{

new_gray_image = rgb2gray(new_color_image);
th = graythresh(new_gray_image);
new_bw_image = im2bw(new_gray_image,th);
st = strel('disk',1);
BW_1 = imdilate(new_bw_image,st);
BW_2 = bwareaopen(BW_1,100);
BW_3= imfill(BW_2,'holes');

Iprops_rbc = regionprops(BW_3,'BoundingBox');
figure;
imshow(new_bw_image);
title('RBC Detection B n W');
for jj = 1:length(Iprops_rbc)
   
    rectangle('Position',Iprops_rbc(jj).BoundingBox,'EdgeColor','r','LineWidth',2);
    
end
mtitle=strcat('Malaria Cells Detected : ',num2str(length(Iprops_rbc)));
title(mtitle);

%}

% Malarial Parasite Detection


new_color_image_malarial = uint8(zeros(total_rows,total_columns,3));

for rows = 1:total_rows
    for columns = 1:total_columns
        
        if (old_color_image(rows,columns,1) <= 202 && old_color_image(rows,columns,1) >= 127 )
            new_color_image_malarial(rows,columns,1) = old_color_image(rows,columns,1);
        else
            new_color_image_malarial(rows,columns,1) = 255;
        end
        
        if (old_color_image(rows,columns,2) <= 131 && old_color_image(rows,columns,2) >= 35 )
            new_color_image_malarial(rows,columns,2) = old_color_image(rows,columns,2);
        else
            new_color_image_malarial(rows,columns,2) = 255;
        end
        
        if (old_color_image(rows,columns,3) <= 211 && old_color_image(rows,columns,3) >= 143 )
            new_color_image_malarial(rows,columns,3) = old_color_image(rows,columns,3);
        else
            new_color_image_malarial(rows,columns,3) = 255;
        end
        
    end
end

%figure;
%imshow(new_color_image_malarial);

%hold on;

% Malaria Cells Segmentation

mgi = rgb2gray(new_color_image_malarial);
gth = graythresh(mgi);
BW = im2bw(mgi);
BW2 = bwareaopen(BW,500);
BW = ~BW;

BW3= imfill(BW,'holes');

se = strel('square',1);
BW4 = imdilate(BW3,se);
BW5 = bwareaopen(BW4,500);
BW6= imfill(BW5,'holes');

Iprops = regionprops(BW6,'BoundingBox');

for jj = 1:length(Iprops)
   
    rectangle('Position',Iprops(jj).BoundingBox,'EdgeColor','r','LineWidth',2);
    
end
mtitle=strcat('Malaria Cells Detected : ',num2str(length(Iprops)));
title(mtitle);
%figure;
%imshow(BW4);
%figure;
%imshow(BW6);
for jj = 1:length(Iprops)
   
    rectangle('Position',Iprops(jj).BoundingBox,'EdgeColor','r','LineWidth',2);
    
end
mtitle=strcat('Malaria Cells Detected : ',num2str(length(Iprops)));
title(mtitle);

if((length(Iprops))==0)
    fprintf('%s is normal\n ',file);
    count=count+1;
end
end 

fprintf('normal cells=%d\n',count);
disp('executed successsfully');
clear;
close all;