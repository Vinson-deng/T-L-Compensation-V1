function res = RLS(A,b,num,len)
%num为辨识参数的个数，即A的列数
%len为数据的长度，即A的行数
%求解Ax=b
%res为辨识的参数，即求解得到的x值
format long;
x = rand(num,1);
I = eye(num, num);
P = (10^6) * I;

for k = 1:len
    Ak = A(k,:); %新的数据行，即phi
    Q1 = P*(Ak'); %K（k）的分子
    Q2 = 1 + Ak * P * (Ak'); %K(k)的分母
    K = Q1/Q2;   %更新K(k) 
    x = x + K * (b(k) - Ak*x);  %更新辨识的参数
    P = (I - K*Ak)*P;    %更新P
    thetae(:,k) = x;   %记录每次计算的辨识参数
    steps(k) = k;     %记录当前步数（也可理解为当前用到的数据个数）
end
steps = steps';
res=thetae(:,end);
end

