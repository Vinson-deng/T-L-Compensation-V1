function [W_before,en_result] = ANC(doc,M,OptMagDataAfterCom,DisData,type)
%ʹ������Ӧ��������LMS����
en_result = [];
integer = mod(length(OptMagDataAfterCom),doc);       % ȡ��
length_opt = length(OptMagDataAfterCom(1:end-integer));
W_before=zeros(M,1);                                 % Ȩ����ʼ��
if type==1
    mu=1;
elseif type==2
    mu=0.005;
end
for round=1:doc:length_opt                           % �����ݽ��зֿ�
    if round==1
        xn=DisData(round:round+doc-1);               % ���������
        dn=OptMagDataAfterCom(round:round+doc-1);    % ������Ӧ
    else
        xn=DisData(round-M:round+doc-1);             % ���������
        dn=OptMagDataAfterCom(round-M:round+doc-1);  % ������Ӧ
    end
%     rho_max = max(eig(xn*xn'));                          % �����ź���ؾ�����������ֵ
%     mu = (1/rho_max) ;                                   % �������� 0 < mu < 1/rho
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

