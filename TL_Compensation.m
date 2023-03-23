clear all;clc;close all
warning off;

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

% 基本信息
load CompenCoff.mat
load CompenCoff_RLS.mat
FsPre = 160;
Fs = 40;
Line_num=8;
highpassFilt=designfilt('highpassiir','FilterOrder',4, ...
    'PassbandFrequency',0.1,'PassbandRipple',0.1, ...
    'SampleRate',Fs);
lowpassFilt=designfilt('lowpassiir','FilterOrder',4, ...
    'PassbandFrequency',1,'PassbandRipple',0.1, ...
    'SampleRate',Fs);
% 运用计算出来的信息矩阵对8条航线进行补偿
for i=1:Line_num
    Load_Command = sprintf...
        ('load Data_Fly_Hainan_Downsample_Displacement/L%d_downsample.mat;',i);
    eval(Load_Command);
    Change_Command = sprintf('Data = L%d_downsample;',i);
    eval(Change_Command);
    rounddata = zeros(length(Data),9);
    rounddata(:,7:9) = Data(:,30:32);
    for ii=1:6
        rounddata(:,ii)=filtfilt(lowpassFilt,Data(:,ii));
    end
    %地磁梯度场计算与补偿
    rounddata(:,2) = rounddata(:,2)-rounddata(:,6);
    FluxDataX=rounddata(:,3);FluxDataY=rounddata(:,4);FluxDataZ=rounddata(:,5);
    FluxDataM = sqrt(FluxDataX.^2 + FluxDataY.^2 + FluxDataZ.^2);
    FluxDataL = length(FluxDataX);
    OptMagData = rounddata(:,2);
    DisData = rounddata(:,7:9);
    X0 = ZiTai_Infor(FluxDataX,FluxDataY,FluxDataZ,DisData,Data(:,2),FluxDataL,Fs);% 信息矩阵
    %使用最小二乘法补偿
    NoiseMagneticCom = X0*Coff_LS;
    OptMagDataAfterCom = OptMagData - NoiseMagneticCom + mean(NoiseMagneticCom);
    OptMagDataBeforeCom = OptMagData;
    
    OptMagDataAfterCom=filtfilt(highpassFilt,OptMagDataAfterCom);
    OptMagDataBeforeCom=filtfilt(highpassFilt,OptMagDataBeforeCom);
    disp(['L',num2str(i),'的OptMagDataBeforeCom的std值：',num2str(std(OptMagDataBeforeCom)*1000)]);
    disp(['L',num2str(i),'的OptMagDataAfterCom的std值：',num2str(std(OptMagDataAfterCom)*1000)]);
    %使用递推最小二乘法补偿
    NoiseMagneticCom = X0*Coff_LS_RLS;
    OptMagDataAfterCom_RLS = OptMagData - NoiseMagneticCom + mean(NoiseMagneticCom);
    
    OptMagDataAfterCom_RLS=filtfilt(highpassFilt,OptMagDataAfterCom_RLS);
    
    %在机动噪声部位插入磁异常观察自适应噪声消除效果
    %     if i==5
    %         noise_geomag = OptMagDataAfterCom_RLS(6639:7065);
    %         OptMagDataAfterCom_RLS(3336:3336+length(noise_geomag)-1) = OptMagDataAfterCom_RLS(3336:3336+length(noise_geomag)-1) + noise_geomag;
    %     end
    %     if i==6
    %         noise_geomag = OptMagDataAfterCom_RLS(6478:6924);
    %         OptMagDataAfterCom_RLS(1956:1956+length(noise_geomag)-1) = OptMagDataAfterCom_RLS(1956:1956+length(noise_geomag)-1) + noise_geomag;
    %     end
    %     if i==8
    %         noise_geomag = OptMagDataAfterCom_RLS(6548:7064);
    %         OptMagDataAfterCom_RLS(1648:1648+length(noise_geomag)-1) = OptMagDataAfterCom_RLS(1648:1648+length(noise_geomag)-1) + noise_geomag;
    %     end
    %Adactive Noise Cancellation自适应噪声消除二次补偿
    
    [~,en_result_1] = ANC(1000,50,OptMagDataAfterCom_RLS,DisData(:,1),2);
    [~,en_result_2] = ANC(1000,50,OptMagDataAfterCom_RLS,DisData(:,2),2);
%     [~,en_result_3] = ANC(1000,80,OptMagDataAfterCom_RLS,DisData(:,3),2);
    %     disp(['RLS_L',num2str(i),'的OptMagDataAfterCom的std值：',num2str(std(OptMagDataAfterCom_RLS)*1000)]);
    disp(['RLS_ADF_1_L',num2str(i),'的OptMagDataAfterCom的std值：',num2str(std(en_result_1)*1000)]);
    disp(['RLS_ADF_2_L',num2str(i),'的OptMagDataAfterCom的std值：',num2str(std(en_result_2)*1000)]);
%     disp(['RLS_ADF_3_L',num2str(i),'的OptMagDataAfterCom的std值：',num2str(std(en_result_3)*1000)]);
    %单纯使用自适应滤波对光泵磁干扰进行消除
    %     [~,en_result_ANC] = ANC(3000,100,OptMagDataBeforeCom,DisData);
    %     disp(['LMS_L',num2str(i),'的OptMagDataAfterCom的std值：',num2str(std(en_result_ANC)*1000)]);
    
    disp('--------------------------------------------------------------');
    
    
    
    %     if i>=7&&i<=8
    %         figure;
    %         plot(OptMagDataBeforeCom);
    %         legend('OptMagData');
    %         title(['L',num2str(i),' Data']);
    %         xlabel('Sample');
    %         ylabel('Mag(nT)');
    %     end
    %     OptMagDataAfterCom_k = OptMagDataAfterCom;
    %     save_command=sprintf('save Compensated_data_k/L%d_K.mat OptMagDataAfterCom_k OptMagDataBeforeCom',i);
    %     eval(save_command)
    %     OptMagDataAfterCom_no_k = OptMagDataAfterCom;
    %     save_command=sprintf('save Compensated_data_no_k/L%d_no_K.mat OptMagDataAfterCom_no_k OptMagDataBeforeCom',i);
    %     eval(save_command)
    if i>4&&i<9
        %         subplot(2,2,i-4);
        %         [c,lags] = xcorr(OptMagDataAfterCom_RLS(1:2300),DisData(1:2300,1));
        %         [~,mlocation]=max(c);
        %         max_point_location=[max_point_location,lags(mlocation)];
        %         plot(lags,c');
        %         ylabel('Amplitude')
        %         xlabel('Point Delay')
        %         title(['L',num2str(i),' Cross-Correlation'])
        figure;
        plot(OptMagDataAfterCom_RLS,'--');
        hold on
        plot(en_result_1);
        plot(en_result_2);
%         plot(en_result_3);
        legend('TL','TL-ANC1','TL-ANC2');
        hold off
        xlabel('Sample');
        ylabel('Mag(nT)');
        title(['L',num2str(i)]);
    end
    %     figure;
    %     plot(Data(:,30:end),'DisplayName','Data(:,30:end)')
end

















