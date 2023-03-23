function [W_before,en_result] = ANC(doc,M,OptMagDataAfterCom,DisData,type)
%使用自适应噪声消除LMS补偿
en_result = [];
integer = mod(length(OptMagDataAfterCom),doc);       % 取余
length_opt = length(OptMagDataAfterCom(1:end-integer));
W_before=zeros(M,1);                                 % 权数初始化
if type==1
    mu=1;
elseif type==2
    mu=0.005;
end
for round=1:doc:length_opt                           % 将数据进行分块
    if round==1
        xn=DisData(round:round+doc-1);               % 输入的数据
        dn=OptMagDataAfterCom(round:round+doc-1);    % 期望响应
    else
        xn=DisData(round-M:round+doc-1);             % 输入的数据
        dn=OptMagDataAfterCom(round-M:round+doc-1);  % 期望响应
    end
%     rho_max = max(eig(xn*xn'));                          % 输入信号相关矩阵的最大特征值
%     mu = (1/rho_max) ;                                   % 收敛因子 0 < mu < 1/rho
if type==1
    [W_before,en] = clmsFunc_inherit(xn,dn,M,mu,W_before);
elseif type==2
    [W_before,en] = lmsFunc_inherit(xn,dn,M,mu,W_before);
end
    en_result=cat(1,en_result,en);
end
if integer~=0
    if type==1
        [W_before,en] = clmsFunc_inherit(DisData(end-integer-M+1:end),...
            OptMagDataAfterCom(end-integer-M+1:end,1),M,mu,W_before);
    elseif type==2
        [W_before,en] = lmsFunc_inherit(DisData(end-integer-M+1:end),...
            OptMagDataAfterCom(end-integer-M+1:end,1),M,mu,W_before);
    end
    en_result=cat(1,en_result,en);
end
end

