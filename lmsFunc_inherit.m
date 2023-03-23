% �������:
%   xn   ������ź�
%   dn   ����������Ӧ
%   M    �˲����Ľ���
%   mu   ��������(����)
% �������:
%   W    �˲���ϵ������
%   en   �������
%   yn   �˲������
function [W_before, en]=lmsFunc_inherit(xn, dn, M, mu, W_before)
itr = length(xn);
en = zeros(itr-M,1);
W  = zeros(M,itr);    % ÿһ�д���-�ε���,��ʼΪ0
W(:,1) = W_before;
% ��������
for k = 1:itr                    % ��k�ε���
    
    if k<(itr-M+1)
        x = xn(k:k+M-1);         % �˲���M����ͷ������
    else
        x = xn(itr-M+1:itr);
    end
    
    if any(W(:,1))==0
        y = W(:,k).' * x;             % �˲��������
        en(k) = dn(k) - y ;           % ��k�ε��������
        W(:,k+1) = W(:,k) + 2*mu*en(k)*x;
    else 
        if k<M+1 
            y = W(:,k).' * x;        
            en(1) = dn(k) - y ;
            W(:,k+1) = W(:,k) + 2*mu*en(1)*x;
        else
            y = W(:,k).' * x;        
            en(k-M) = dn(k) - y ;
            W(:,k+1) = W(:,k) + 2*mu*en(k-M)*x;            
        end
    end
    % �˲���Ȩֵ����ĵ���ʽ
    W_before = W(:,end);
end
%
% yn = inf * ones(size(xn)); % ��ֵΪ������ǻ�ͼʹ�ã�����󴦲����ͼ
% for k = 1:itr
%     if k<(itr-M+1)
%         x = xn(k:k+M-1);              % �˲���M����ͷ������
%     else
%         x = xn(itr-M+1:itr);
%     end
%     yn(k) = W(:,end).'* x;  % ����������
% end

