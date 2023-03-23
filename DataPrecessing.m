function [X0,OptMagData] = DataPrecessing(Data,Channel,Fs)
%第1列：光泵1的数据(Cs1)
%第2列：光泵2的数据(Cs2)
%第3列：磁通门x数据(Fx_1)
%第4列：磁通门y数据(Fx_2)
%第5列：磁通门z数据(Fx_3)
%第6列：地磁场数据(ToF)
%第7列：加速度计X轴位移
%第8列：加速度计Y轴位移
%第9列：加速度计Z轴位移

%当飞行方向沿着东西方向时，Flag=2，IGRF模型的磁场采用0.2Hz带宽
%数据预处理及规整
highpassFilt=designfilt('highpassiir','FilterOrder',4, ...
    'PassbandFrequency',0.1,'PassbandRipple',0.1, ...
    'SampleRate',Fs);
lowpassFilt=designfilt('lowpassiir','FilterOrder',4, ...
    'PassbandFrequency',1,'PassbandRipple',0.1, ...
    'SampleRate',Fs);
rounddata = zeros(size(Data));%规整的数据
rounddata(:,7:9) = Data(:,7:9);
for i=1:6
    rounddata(:,i)=filtfilt(lowpassFilt,Data(:,i));
end
%地磁梯度场计算与补偿
rounddata(:,Channel) = rounddata(:,Channel)-rounddata(:,6);
%姿态信息
FluxDataX=rounddata(:,3);FluxDataY=rounddata(:,4);FluxDataZ=rounddata(:,5);
DisData = rounddata(:,7:9);
FluxDataM = sqrt(FluxDataX.^2 + FluxDataY.^2 + FluxDataZ.^2);
FluxDataL = length(FluxDataX);
%滤波处理
OptMagData = rounddata(:,Channel); % 磁总场干扰
X0=ZiTai_Infor(FluxDataX,FluxDataY,FluxDataZ,DisData,Data(:,2),FluxDataL,Fs);% 信息矩阵
[~,X0_C] = size(X0);
for ii=1:X0_C
    X0(:,ii)=filtfilt(highpassFilt,X0(:,ii));
end
OptMagData = filtfilt(highpassFilt,OptMagData-mean(OptMagData));
end





