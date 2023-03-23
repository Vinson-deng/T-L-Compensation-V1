clear all;clc;close all
%Data_Fly_Hainan_Downsample_Displacement���ݸ�ʽ������ʾ
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
%��30�У����ٶȼ�X��λ��
%��31�У����ٶȼ�Y��λ��
%��32�У����ٶȼ�Z��λ��
%==========================================================================
%==========================================================================
%��ȡ����
load Data_Fly_Hainan_Downsample_Displacement/L1_downsample.mat
load Data_Fly_Hainan_Downsample_Displacement/L2_downsample.mat
load Data_Fly_Hainan_Downsample_Displacement/L3_downsample.mat
load Data_Fly_Hainan_Downsample_Displacement/L4_downsample.mat

FsPre = 160;%ԭʼ������
Fs = 40;    %��������Ĳ�����
Channel = 2;%Զ�˹�ô�������2�����˹�ô�������1��

[X01,OptMagData1] = DataPrecessing([L1_downsample(:,1:6),...
    L1_downsample(:,30:32)],Channel,Fs);
[X02,OptMagData2] = DataPrecessing([L2_downsample(:,1:6),...
    L2_downsample(:,30:32)],Channel,Fs);
[X03,OptMagData3] = DataPrecessing([L3_downsample(:,1:6),...
    L3_downsample(:,30:32)],Channel,Fs);
[X04,OptMagData4] = DataPrecessing([L4_downsample(:,1:6),...
    L4_downsample(:,30:32)],Channel,Fs);

X0 = [X01;X02;X03;X04];
OptMagData = [OptMagData1;OptMagData2;OptMagData3;OptMagData4]; 
%==========================================================================
%==========================================================================
%��������
% ******************************��С����************************************
Coff_LS =(X0'*X0)\X0'*OptMagData;
save CompenCoff.mat Coff_LS
% ******************************������С����********************************
[len,num] = size(X0);
Coff_LS_RLS = RLS(X0,OptMagData,num,len);
save CompenCoff_RLS.mat Coff_LS_RLS




