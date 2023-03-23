clear all;clc;close all
warning off;

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

% ������Ϣ
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
% ���ü����������Ϣ�����8�����߽��в���
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
    %�ش��ݶȳ������벹��
    rounddata(:,2) = rounddata(:,2)-rounddata(:,6);
    FluxDataX=rounddata(:,3);FluxDataY=rounddata(:,4);FluxDataZ=rounddata(:,5);
    FluxDataM = sqrt(FluxDataX.^2 + FluxDataY.^2 + FluxDataZ.^2);
    FluxDataL = length(FluxDataX);
    OptMagData = rounddata(:,2);
    DisData = rounddata(:,7:9);
    X0 = ZiTai_Infor(FluxDataX,FluxDataY,FluxDataZ,DisData,Data(:,2),FluxDataL,Fs);% ��Ϣ����
    %ʹ����С���˷�����
    NoiseMagneticCom = X0*Coff_LS;
    OptMagDataAfterCom = OptMagData - NoiseMagneticCom + mean(NoiseMagneticCom);
    OptMagDataBeforeCom = OptMagData;
    
    OptMagDataAfterCom=filtfilt(highpassFilt,OptMagDataAfterCom);
    OptMagDataBeforeCom=filtfilt(highpassFilt,OptMagDataBeforeCom);
    disp(['L',num2str(i),'��OptMagDataBeforeCom��stdֵ��',num2str(std(OptMagDataBeforeCom)*1000)]);
    disp(['L',num2str(i),'��OptMagDataAfterCom��stdֵ��',num2str(std(OptMagDataAfterCom)*1000)]);
    %ʹ�õ�����С���˷�����
    NoiseMagneticCom = X0*Coff_LS_RLS;
    OptMagDataAfterCom_RLS = OptMagData - NoiseMagneticCom + mean(NoiseMagneticCom);
    
    OptMagDataAfterCom_RLS=filtfilt(highpassFilt,OptMagDataAfterCom_RLS);
    
    %�ڻ���������λ������쳣�۲�����Ӧ��������Ч��
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
    %Adactive Noise Cancellation����Ӧ�����������β���
    
    [~,en_result_1] = ANC(1000,50,OptMagDataAfterCom_RLS,DisData(:,1),2);
    [~,en_result_2] = ANC(1000,50,OptMagDataAfterCom_RLS,DisData(:,2),2);
%     [~,en_result_3] = ANC(1000,80,OptMagDataAfterCom_RLS,DisData(:,3),2);
    %     disp(['RLS_L',num2str(i),'��OptMagDataAfterCom��stdֵ��',num2str(std(OptMagDataAfterCom_RLS)*1000)]);
    disp(['RLS_ADF_1_L',num2str(i),'��OptMagDataAfterCom��stdֵ��',num2str(std(en_result_1)*1000)]);
    disp(['RLS_ADF_2_L',num2str(i),'��OptMagDataAfterCom��stdֵ��',num2str(std(en_result_2)*1000)]);
%     disp(['RLS_ADF_3_L',num2str(i),'��OptMagDataAfterCom��stdֵ��',num2str(std(en_result_3)*1000)]);
    %����ʹ������Ӧ�˲��Թ�ôŸ��Ž�������
    %     [~,en_result_ANC] = ANC(3000,100,OptMagDataBeforeCom,DisData);
    %     disp(['LMS_L',num2str(i),'��OptMagDataAfterCom��stdֵ��',num2str(std(en_result_ANC)*1000)]);
    
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

















