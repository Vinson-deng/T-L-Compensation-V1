clear all;clc;close all
%Data_Fly_Hainan_Downsample_Displacement数据格式如下所示
%第1列：光泵1的数据(Cs1)
%第2列：光泵2的数据(Cs2)
%第3列：磁通门x数据(Fx_1)
%第4列：磁通门y数据(Fx_2)
%第5列：磁通门z数据(Fx_3)
%第6列：地磁场数据(ToF)
%第7列：惯导X轴加速度
%第8列：惯导Y轴加速度
%第9列：惯导Z轴加速度
%第10列：加速度计X轴
%第11列：加速度计Y轴
%第12列: 加速度计Z轴
%第13列: V_East
%第14列: V_North
%第15列: V_Up
%第16列: 纬度(Latitude)
%第17列: 经度(Longitude)
%第18列：高度(H_Ell)
%第19列：航向角Heading
%第20列：俯仰角Pitch
%第21列：翻滚角Roll
%第22列：采样点Lable
%第23列：UTC_Time
%第24列：时Hour
%第25列：分Min
%第26列：秒Sec
%第27列：IMU_gyro_x
%第28列：IMU_gyro_y
%第29列：IMU_gyro_z
%第30列：加速度计X轴位移
%第31列：加速度计Y轴位移
%第32列：加速度计Z轴位移
%==========================================================================
%==========================================================================
%读取数据
load Data_Fly_Hainan_Downsample_Displacement/L1_downsample.mat
load Data_Fly_Hainan_Downsample_Displacement/L2_downsample.mat
load Data_Fly_Hainan_Downsample_Displacement/L3_downsample.mat
load Data_Fly_Hainan_Downsample_Displacement/L4_downsample.mat

FsPre = 160;%原始采样率
Fs = 40;    %降采样后的采样率
Channel = 2;%远端光泵磁力仪置2；近端光泵磁力仪置1；

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
%参数估计
% ******************************最小二乘************************************
Coff_LS =(X0'*X0)\X0'*OptMagData;
save CompenCoff.mat Coff_LS
% ******************************递推最小二乘********************************
[len,num] = size(X0);
Coff_LS_RLS = RLS(X0,OptMagData,num,len);
save CompenCoff_RLS.mat Coff_LS_RLS




