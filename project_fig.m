function varargout = project_fig(varargin)
% PROJECT_FIG MATLAB code for project_fig.fig
%      PROJECT_FIG, by itself, creates a new PROJECT_FIG or raises the existing
%      singleton*.
%
%      H = PROJECT_FIG returns the handle to a new PROJECT_FIG or the handle to
%      the existing singleton*.
%
%      PROJECT_FIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT_FIG.M with the given input arguments.
%
%      PROJECT_FIG('Property','Value',...) creates a new PROJECT_FIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before project_fig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to project_fig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help project_fig

% Last Modified by GUIDE v2.5 03-Oct-2018 08:09:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @project_fig_OpeningFcn, ...
                   'gui_OutputFcn',  @project_fig_OutputFcn, ...
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


% --- Executes just before project_fig is made visible.
function project_fig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to project_fig (see VARARGIN)

% Choose default command line output for project_fig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes project_fig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = project_fig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load_image.
function load_image_Callback(hObject, eventdata, handles)
% hObject    handle to load_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



warning off all;
path = genpath('.');
addpath(path);
[file,path] = uigetfile('*.jpg','Select Blood Sample Image File');  
% uigetfile displays a dialog box used to retrieve one or more files. 
%The dialog box lists the files and directories in the current directory.
image_file = fullfile(path,file);                                               
% fullfile(dir1, dir2, ..., filename) builds a full filename from the directories and filename specified.
[image_path,image_name,image_extension]=fileparts(image_file);
x=strcmp(image_extension,'.jpg');
if(x==1)
im = imread(image_file);

axes(handles.axes1);
hold off;
imshow(im);
title('Original Image');
str=strcat('image selected : ',file);
set(handles.disp_result,'string',str);

handles.str=str;
handles.im=im;
handles.image_file=image_file;
handles.image_extension=image_extension;
guidata(hObject, handles);
else
    
    errormsg='this is not a jpg file!!! please select a jpg image file';
    set(handles.disp_result,'string',errormsg);
   % msgbox('invalid file','Error','error');
    axes(handles.axes1);
    hold off;
    imshow('C:\Users\user\Pictures\error.png');

    handles.image_extension=image_extension;
    guidata(hObject,handles);
end
% --- Executes on button press in rbc_ext.
function rbc_ext_Callback(hObject, eventdata, handles)
% hObject    handle to rbc_ext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
image_extension=handles.image_extension;
if strcmp(image_extension,'.jpg')
im=handles.im;
total_rows = size(im,1);
total_columns = size(im,2);

old_color_image = im;

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
axes(handles.axes1);
hold off;
imshow(new_color_image);
title('RBC Extraction');
str='RBC extracted image';
set(handles.disp_result,'string',str);
handles.total_rows=total_rows;
handles.total_columns=total_columns;
handles.new_color_image=new_color_image;
handles.old_color_image=old_color_image;
guidata(hObject, handles);
else
    
    errormsg='you have selected an invalid file... please select a jpg image file';
    set(handles.disp_result,'string',errormsg);
     %axes(handles.axes1);
    %imshow('C:\Users\user\Pictures\error.png');
end
% --- Executes on button press in detection.
function detection_Callback(hObject, eventdata, handles)
% hObject    handle to detection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_extension=handles.image_extension;
if strcmp(image_extension,'.jpg')
total_rows=handles.total_rows;
total_columns=handles.total_columns;
old_color_image=handles.old_color_image;
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
axes(handles.axes1);
hold off;
imshow(new_color_image_malarial);
handles.new_color_image_malarial=new_color_image_malarial;
guidata(hObject,handles);
% Malaria Cells Segmentation

gg = rgb2gray(new_color_image_malarial);
gth = graythresh(gg);
BW = im2bw(gg);
BW2 = bwareaopen(BW,300);
BW2 = ~BW2;

BW3= imfill(BW2,'holes');

se = strel('square',1);
BW4 = imdilate(BW3,se);
BW5 = bwareaopen(BW4,300);
BW6= imfill(BW5,'holes');

Iprops = regionprops(BW6,'BoundingBox');

for jj = 1:length(Iprops)
   
    rectangle('Position',Iprops(jj).BoundingBox,'EdgeColor','r','LineWidth',2);
    
end
mtitle=strcat('Malaria Cells Detected : ',num2str(length(Iprops)));
title(mtitle);
if((length(Iprops))==0)
    set(handles.disp_result,'string','this slide is normal');
else
    set(handles.disp_result,'string','this slide is infected');
end


for jj = 1:length(Iprops)
   
    rectangle('Position',Iprops(jj).BoundingBox,'EdgeColor','r','LineWidth',2);
    
end
mtitle=strcat('Malaria Cells Detected : ',num2str(length(Iprops)));
title(mtitle);
u=length(Iprops);
handles.u=u;
guidata(hObject,handles);
else
    
    errormsg='invalid file selected... please select a jpg image file';
    set(handles.disp_result,'string',errormsg);
     %axes(handles.axes1);
    %imshow('C:\Users\user\Pictures\error.png');
end

% --- Executes on button press in rbc_count.
function rbc_count_Callback(hObject, eventdata, handles)
% hObject    handle to rbc_count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_extension=handles.image_extension;
if strcmp(image_extension,'.jpg')
new_color_image=handles.new_color_image;
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
axes(handles.axes1);
imshow(~BW3);
hold off;
for nn = 1:length(S)
    
   rectangle('Position',S(nn).BoundingBox,'EdgeColor','b','linewidth',1);
    
end


mytitle = strcat('No. of RBCs detected:',num2str(length(S)));
title(mytitle);
 
r=length(S);

set(handles.disp_result,'string',mytitle);
handles.r=r;
guidata(hObject,handles);
else
    
    errormsg='invalid file selected... please select a jpg image file';
    set(handles.disp_result,'string',errormsg);
     %axes(handles.axes1);
    %imshow('C:\Users\user\Pictures\error.png');
end
% --- Executes on button press in parasite_count.
function parasite_count_Callback(hObject, eventdata, handles)
% hObject    handle to parasite_count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_extension=handles.image_extension;
if strcmp(image_extension,'.jpg')
u=handles.u;
new_color_image_malarial=handles.new_color_image_malarial;
gg = rgb2gray(new_color_image_malarial);
gth = graythresh(gg);
BW = im2bw(gg);
BW2 = bwareaopen(BW,300);
BW2 = ~BW2;

BW3= imfill(BW2,'holes');

se = strel('square',1);
BW4 = imdilate(BW3,se);
BW5 = bwareaopen(BW4,300);
BW6= imfill(BW5,'holes');

Iprops = regionprops(BW6,'BoundingBox');
%figure;
axes(handles.axes1);
imshow(BW6);
hold off;
for jj = 1:length(Iprops)
   
    rectangle('Position',Iprops(jj).BoundingBox,'EdgeColor','r','LineWidth',2);
    
end
mtitle=strcat('Malaria Cells Detected : ',num2str(length(Iprops)));
title(mtitle);
str1=strcat('total no of Parasites : ',num2str(u));

set(handles.disp_result,'string',str1);

else
    
    errormsg='invalid file selected... please select a jpg file first';
    set(handles.disp_result,'string',errormsg);
     %axes(handles.axes1);
    %imshow('C:\Users\user\Pictures\error.png');
end

function disp_result_Callback(hObject, eventdata, handles)
% hObject    handle to disp_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of disp_result as text
%        str2double(get(hObject,'String')) returns contents of disp_result as a double


% --- Executes during object creation, after setting all properties.
function disp_result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disp_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ratio.
function ratio_Callback(hObject, eventdata, handles)
% hObject    handle to ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_extension=handles.image_extension;
if strcmp(image_extension,'.jpg')
r=handles.r;
u=handles.u;

str=strcat('total no of RBCs : ',num2str(r));

str1=strcat('     total no of Parasites : ',num2str(u));
str2=strcat(str,str1);
prcnt=u/r*100;

str3=strcat('    infected RBC %age : ',num2str(prcnt));
str4=strcat(str2,str3);
set(handles.disp_result,'string',str4);
else
    
    errormsg='invalid file selected... please select a jpg file first';
    set(handles.disp_result,'string',errormsg);
    % axes(handles.axes1);
    %imshow('C:\Users\user\Pictures\error.png');
end
