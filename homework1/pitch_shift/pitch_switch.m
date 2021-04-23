function varargout = pitch_switch(varargin)
% PITCH_SWITCH MATLAB code for pitch_switch.fig
%      PITCH_SWITCH, by itself, creates a new PITCH_SWITCH or raises the existing
%      singleton*.
%
%      H = PITCH_SWITCH returns the handle to a new PITCH_SWITCH or the handle to
%      the existing singleton*.
%
%      PITCH_SWITCH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PITCH_SWITCH.M with the given input arguments.
%
%      PITCH_SWITCH('Property','Value',...) creates a new PITCH_SWITCH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pitch_switch_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pitch_switch_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pitch_switch

% Last Modified by GUIDE v2.5 03-Apr-2019 12:56:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pitch_switch_OpeningFcn, ...
                   'gui_OutputFcn',  @pitch_switch_OutputFcn, ...
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


% --- Executes just before pitch_switch is made visible.
function pitch_switch_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pitch_switch (see VARARGIN)

% Choose default command line output for pitch_switch
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pitch_switch wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pitch_switch_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.*','ALL FILES'},'ѡ������');%��ʾģ̬�Ի���
%�г���ǰ�ļ����е��ļ�������ļ���Ч�������ʱ�᷵���ļ�����������ȡ��������0
if isequal([filename pathname],[0,0])
return;
end
str=[pathname filename];%�ϳ�·��+�ļ���
[temp,Fs]=audioread(str);%��ȡ��Ƶ����
temp=temp(:,1);  %ȡһ����ȡ����
temp1=resample(temp,16000,Fs);%�źŽ���������
handles.y=temp1;%�������ľ��
handles.y1=temp;%y1Ϊԭ��
handles.Fs=16000;%����Ƶ��
guidata(hObject,handles);%�洢����� UI ����


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pitch_para=get(handles.pitch_para,'string');
formant_para=get(handles.formant_para,'string');
pitch_para=str2num(pitch_para);
formant_para=str2num(formant_para);
FL =  80 ;               % ֡��
WL = 240 ;               % ����
P = 10 ;                 %Ԥ��ϵ������
s = handles.y;
fs = handles.Fs;
% ���峣��
s = s-mean(s);
s = s/max(s);             % ��һ��
L = length(s);            % ������������
FN = floor(L/FL)-2;       % ����֡����floor���������
% Ԥ����ؽ��˲���
exc = zeros(L,1);         % �����źţ�double�������L��1��
zi_pre = zeros(P,1);      % Ԥ���˲���״̬
s_rec = zeros(L,1);       % �ؽ�����
zi_rec = zeros(P,1);
% ����˲���
exc_syn_t = zeros(L,1);   % �ϳɵļ����źţ�����һ��L��1�е�0����
s_syn_t = zeros(L,1);     % �ϳ�����
last_syn_t = 0;           % �洢��һ���ε����һ��������±�
zi_syn_t = zeros(P,1);    % �ϳ��˲���
hw = hamming(WL);         %������
% �˲���
% ���δ���ÿ֡����
for n = 3:FN             %�ӵ����������鿪ʼ
    % ����Ԥ��ϵ��
    s_w = s(n*FL-WL+1:n*FL).*hw;    %��������Ȩ
    [A,E]=lpc(s_w,P);               %����Ԥ�����Ԥ��ϵ��
    % A��Ԥ��ϵ����E�ᱻ��������ϳɼ���������
    s_f=s((n-1)*FL+1:n*FL);        % ��֡����  
    % ����filter�����ؽ�����
    [exc1,zi_pre] = filter(A,1,s_f,zi_pre); 
    exc((n-1)*FL+1:n*FL) = exc1;           %���㼤��
    % ����filter�����ؽ�����
    [s_rec1,zi_rec] = filter(1,A,exc1,zi_rec);
    s_rec((n-1)*FL+1:n*FL) = s_rec1; %�ؽ�����
    % ����ֻ�еõ�exc��ſ���
    s_Pitch = exc(n*FL-222:n*FL);
    PT(n) = findpitch(s_Pitch);    %�����������pt
    G = sqrt(E*PT(n));             %����ϳɼ���������G
    PT1 =floor(PT(n)/pitch_para);           %��С��������
    poles = roots(A);
    deltaOMG =formant_para*2*pi/fs;

    for p=1:10   %���ӹ����
        if imag(poles(p))>0
            poles(p) = poles(p)*exp(1j*deltaOMG);
        elseif imag(poles(p))<0 
            poles(p) = poles(p)*exp(-1j*deltaOMG);
        end
    end
    A1=poly(poles);
    tempn_syn_t=(1:n*FL-last_syn_t);
    exc_syn1_t = zeros(length(tempn_syn_t),1);
    exc_syn1_t(mod(tempn_syn_t,PT1)==0) = G; 
    exc_syn1_t = exc_syn1_t((n-1)*FL-last_syn_t+1:n*FL-last_syn_t);
    [s_syn1_t,zi_syn_t] = filter(1,A1,exc_syn1_t,zi_syn_t);
    exc_syn_t((n-1)*FL+1:n*FL) = exc_syn1_t;        %�ϳɼ���
    s_syn_t((n-1)*FL+1:n*FL) = s_syn1_t;            %�ϳ�����
    last_syn_t = last_syn_t+PT1*floor((n*FL-last_syn_t)/PT1);
end
Y = s_syn_t;
F = fft(Y);
amp = abs(F);
amp = amp(2:length(amp)/2+1);
freq = linspace(0,fs/2,0.5*length(Y)+1);
freq(end) = [];
plot(handles.axes4,freq,amp);
xlabel(handles.axes4,'Ƶ��');
ylabel(handles.axes4,'����');
title(handles.axes4,'���������Ƶ������');
% handles.y=s_syn_t;
guidata(hObject,handles);

plot(handles.axes3,s_syn_t);
t1=1:length(s_syn_t);
t=t1/16000;
plot(handles.axes3,t,s_syn_t);
title(handles.axes3,'��������Ĳ���');
xlabel(handles.axes3,'ʱ��');
ylabel(handles.axes3,'����');
sound(s_syn_t,16000);  


% --- Executes on button press in PlayWav.
function PlayWav_Callback(hObject, eventdata, handles)
% hObject    handle to PlayWav (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fs=handles.Fs;
Y=handles.y;
Y=Y(:,1);%ȡ������
t1=1:length(Y);
t=t1/fs;
sound(Y,fs);   %����ԭ��

F = fft(Y);%���ٸ���Ҷ�任
amp = abs(F);
amp = amp(2:length(amp)/2+1);
freq = linspace(0,fs/2,0.5*length(Y)+1);
freq(end) = [];
plot(handles.axes1,t,Y)
xlabel(handles.axes1,'ʱ��');
ylabel(handles.axes1,'����');
title(handles.axes1,'ԭʼ�����Ĳ���');
% y1=fft(Y);
% plot(handles.axes4,abs(y1));
% xlabel(handles.axes4,'ԲƵ��');
% ylabel(handles.axes4,'����');
% title(handles.axes4,'δ�ı��������Ƶ������');

plot(handles.axes2,freq,amp);
% title(handles.axes2,'ԭ��������ʵƵ��');
xlabel(handles.axes2,'Ƶ��');
ylabel(handles.axes2,'����');
title(handles.axes2,'ԭʼ������Ƶ������');



function pitch_para_Callback(hObject, eventdata, handles)
% hObject    handle to pitch_para (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pitch_para as text
%        str2double(get(hObject,'String')) returns contents of pitch_para as a double


% --- Executes during object creation, after setting all properties.
function pitch_para_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pitch_para (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function formant_para_Callback(hObject, eventdata, handles)
% hObject    handle to formant_para (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of formant_para as text
%        str2double(get(hObject,'String')) returns contents of formant_para as a double


% --- Executes during object creation, after setting all properties.
function formant_para_CreateFcn(hObject, eventdata, handles)
% hObject    handle to formant_para (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
