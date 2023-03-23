clear all;clc;close all
warning off;

%Data_Fly_Hainan_Original���ݸ�ʽ������ʾ
%��1�У����1������(Cs1)
%��2�У����2������(Cs2)
%��3�У���ͨ��x����(Fx_1)
%��4�У���ͨ��y����(Fx_2)
%��5�У���ͨ��z����(Fx_3)
%��6�У��شų�����(ToF)
%��7�У��ߵ�X����ٶ�
%��8�У��ߵ�Y����ٶ�
%��9�У��ߵ�Z����ٶ�
%��10�У����ٶȼ�X��
%��11�У����ٶȼ�Y��
%��12��: ���ٶȼ�Z��
%��13��: V_East
%��14��: V_North
%��15��: V_Up
%��16��: γ��(Latitude)
%��17��: ����(Longitude)
%��18�У��߶�(H_Ell)
%��19�У������Heading
%��20�У�������Pitch
%��21�У�������Roll
%��22�У�������Lable
%��23�У�UTC_Time
%��24�У�ʱHour
%��25�У���Min
%��26�У���Sec
%��27�У�IMU_gyro_x
%��28�У�IMU_gyro_y
%��29�У�IMU_gyro_z

% �������ݼ����ݻ����趨
fc=160;fs=40;dfs=0.01;ts=1/fs;DownNum=fc/fs;
Line_num = 8;
% �����˲�����
bandpassFilt=designfilt('bandpassiir','FilterOrder',6, ...
    'HalfPowerFrequency1',0.1,'HalfPowerFrequency2',0.5, ...
    'SampleRate',fs);
highpassFilt=designfilt('highpassiir','FilterOrder',4, ...
    'PassbandFrequency',0.1,'PassbandRipple',0.1, ...
    'SampleRate',fs);
lowpassFilt=designfilt('lowpassiir','FilterOrder',4, ...
         'PassbandFrequency',3,'PassbandRipple',0.1, ...
         'SampleRate',fs);
for line=1:Line_num
    load_command = sprintf('load Data_Fly_Hainan_Original/L%d.txt -ASCII;',...
        line);
    eval(load_command);
    load_command = sprintf('Data = L%d;',...
        line);
    eval(load_command);
    [Length,Clu] = size(Data);
    % �²���
    fly_data = zeros(ceil(Length/DownNum),Clu);
    for itotalnum=1:Clu
        fly_data(:,itotalnum) = decimate(Data(:,itotalnum),DownNum,'fir');
    end
    N = length(fly_data);
    % ʱ�����
    fag=fly_data(:,10:12)-fly_data(:,7:9);
    Vel_body=zeros(N,3);
    Dis_body=zeros(N,3);
    for i=1:3
        for ii=2:N-1
            Vel_body(ii,i) = Vel_body(ii-1,i)+(fag(ii-1,i)+4*fag(ii,i)+fag(ii+1,i))/6*ts;
        end
        Vel_body(end,i)=Vel_body(end-1,i);
        p = polyfit((1:N)',Vel_body(:,i),1);%һ�����
        Vel_body(:,i) = Vel_body(:,i)-polyval(p,(1:N)');
        % ���λ��ֵõ�λ��
        for ii=2:N-1
            Dis_body(ii,i)=Dis_body(ii-1,i)+(Vel_body(ii-1,i)+4*Vel_body(ii,i)+Vel_body(ii+1,i))/6*ts;
        end
        % ȥ����������λ��������
        Dis_body(end,i)=Dis_body(end-1,i);
        p=polyfit((1:N)',Dis_body(:,i),1);%һ�����
        Dis_body(:,i)=Dis_body(:,i)-polyval(p,(1:N)');
        %λ���˲�
        Dis_body(:,i)=filtfilt(highpassFilt,Dis_body(:,i));
        Dis_body(:,i)=filtfilt(lowpassFilt,Dis_body(:,i));
    end
    % �ɵش��ݶȼ������
    % ����ת��
%     Dis_frqent_w_reference = zeros(3,N);
%     for i=1:N
%         r_roll = [1 0 0;0 cosd(Data(i,21)) sind(Data(i,21));0 -sind(Data(i,21)) cosd(Data(i,21))];
%         r_pitch = [cosd(Data(i,20)) 0 -sind(Data(i,20));0 1 0;sind(Data(i,20)) 0 cosd(Data(i,20))];
%         r_yaw = [cosd(Data(i,19)) sind(Data(i,19)) 0;-sind(Data(i,19)) cosd(Data(i,19)) 0;0 0 1];
%         C_b2w = (r_roll*r_pitch*r_yaw)';
%         Dis_frqent_w_reference(:,i) = C_b2w*Dis_body(i,:)';
%     end
    Down_data = [fly_data,Dis_body];
    equal_command = sprintf('L%d_downsample = Down_data;',...
        line);
    eval(equal_command);
    Save_Command = ...
        sprintf('save Data_Fly_Hainan_Downsample_Rlative_Displacement/L%d_downsample.mat L%d_downsample;',line,line);
    eval(Save_Command);
end




















