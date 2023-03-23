clear all;clc;close all
warning off;

%Data_Fly_Hainan_Original数据格式如下所示
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

% 载入数据及数据基本设定
fc=160;fs=40;dfs=0.01;ts=1/fs;DownNum=fc/fs;
Line_num = 8;
% 设置滤波参数
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
    % 下采样
    fly_data = zeros(ceil(Length/DownNum),Clu);
    for itotalnum=1:Clu
        fly_data(:,itotalnum) = decimate(Data(:,itotalnum),DownNum,'fir');
    end
    N = length(fly_data);
    % 时域积分
    fag=fly_data(:,10:12)-fly_data(:,7:9);
    Vel_body=zeros(N,3);
    Dis_body=zeros(N,3);
    for i=1:3
        for ii=2:N-1
            Vel_body(ii,i) = Vel_body(ii-1,i)+(fag(ii-1,i)+4*fag(ii,i)+fag(ii+1,i))/6*ts;
        end
        Vel_body(end,i)=Vel_body(end-1,i);
        p = polyfit((1:N)',Vel_body(:,i),1);%一次拟合
        Vel_body(:,i) = Vel_body(:,i)-polyval(p,(1:N)');
        % 二次积分得到位移
        for ii=2:N-1
            Dis_body(ii,i)=Dis_body(ii-1,i)+(Vel_body(ii-1,i)+4*Vel_body(ii,i)+Vel_body(ii+1,i))/6*ts;
        end
        % 去除积分所得位移趋势项
        Dis_body(end,i)=Dis_body(end-1,i);
        p=polyfit((1:N)',Dis_body(:,i),1);%一次拟合
        Dis_body(:,i)=Dis_body(:,i)-polyval(p,(1:N)');
        %位移滤波
        Dis_body(:,i)=filtfilt(highpassFilt,Dis_body(:,i));
        Dis_body(:,i)=filtfilt(lowpassFilt,Dis_body(:,i));
    end
    % 由地磁梯度计算干扰
    % 坐标转换
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




















