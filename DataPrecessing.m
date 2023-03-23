function [X0,OptMagData] = DataPrecessing(Data,Channel,Fs)
%��1�У����1������(Cs1)
%��2�У����2������(Cs2)
%��3�У���ͨ��x����(Fx_1)
%��4�У���ͨ��y����(Fx_2)
%��5�У���ͨ��z����(Fx_3)
%��6�У��شų�����(ToF)
%��7�У����ٶȼ�X��λ��
%��8�У����ٶȼ�Y��λ��
%��9�У����ٶȼ�Z��λ��

%�����з������Ŷ�������ʱ��Flag=2��IGRFģ�͵Ĵų�����0.2Hz����
%����Ԥ��������
highpassFilt=designfilt('highpassiir','FilterOrder',4, ...
    'PassbandFrequency',0.1,'PassbandRipple',0.1, ...
    'SampleRate',Fs);
lowpassFilt=designfilt('lowpassiir','FilterOrder',4, ...
    'PassbandFrequency',1,'PassbandRipple',0.1, ...
    'SampleRate',Fs);
rounddata = zeros(size(Data));%����������
rounddata(:,7:9) = Data(:,7:9);
for i=1:6
    rounddata(:,i)=filtfilt(lowpassFilt,Data(:,i));
end
%�ش��ݶȳ������벹��
rounddata(:,Channel) = rounddata(:,Channel)-rounddata(:,6);
%��̬��Ϣ
FluxDataX=rounddata(:,3);FluxDataY=rounddata(:,4);FluxDataZ=rounddata(:,5);
DisData = rounddata(:,7:9);
FluxDataM = sqrt(FluxDataX.^2 + FluxDataY.^2 + FluxDataZ.^2);
FluxDataL = length(FluxDataX);
%�˲�����
OptMagData = rounddata(:,Channel); % ���ܳ�����
X0=ZiTai_Infor(FluxDataX,FluxDataY,FluxDataZ,DisData,Data(:,2),FluxDataL,Fs);% ��Ϣ����
[~,X0_C] = size(X0);
for ii=1:X0_C
    X0(:,ii)=filtfilt(highpassFilt,X0(:,ii));
end
OptMagData = filtfilt(highpassFilt,OptMagData-mean(OptMagData));
end





