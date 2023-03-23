% 输入参数:
%   xn   输入的信号
%   dn   所期望的响应
%   M    滤波器的阶数
%   mu   收敛因子(步长)
% 输出参数:
%   W    滤波器系数矩阵
%   en   误差序列
%   yn   滤波器输出
function [W_before, en]=clmsFunc_inherit(xn, dn, M, mu, W_before)
itr = length(xn);
en = zeros(itr-M,1);
W  = zeros(M,itr);    % 每一列代表-次迭代,初始为0
W(:,1) = W_before;
b = 0.95*mu;a = 1;
% 迭代计算
for k = 1:itr                    % 第k次迭代
    
    if k<(itr-M+1)
        x = xn(k:k+M-1);         % 滤波器M个抽头的输入
    else
        x = xn(itr-M+1:itr);
    end
    
    if any(W(:,1))==0
        y = W(:,k).' * x;             % 滤波器的输出
        en(k) = dn(k) - y ;           % 第k次迭代的误差
        mu = b*(1-(1/(a*en(k)*en(k)+1+0.000001))); 
        W(:,k+1) = W(:,k) + 2*mu*en(k)*x;
    else 
        if k<M+1 
            y = W(:,k).' * x;        
            en(1) = dn(k) - y ;
            mu = b*(1-(1/(a*en(1)*en(1)+1+0.000001)));
            W(:,k+1) = W(:,k) + 2*mu*en(1)*x;
        else
            y = W(:,k).' * x;
            en(k-M) = dn(k) - y ;
            mu = b*(1-(1/(a*en(k-M)*en(k-M)+1+0.000001)));
            W(:,k+1) = W(:,k) + 2*mu*en(k-M)*x;
        end
    end
    % 滤波器权值计算的迭代式
    W_before = W(:,end);
end
%
% yn = inf * ones(size(xn)); % 初值为无穷大是绘图使用，无穷大处不会绘图
% for k = 1:itr
%     if k<(itr-M+1)
%         x = xn(k:k+M-1);              % 滤波器M个抽头的输入
%     else
%         x = xn(itr-M+1:itr);
%     end
%     yn(k) = W(:,end).'* x;  % 最终输出结果
% end


