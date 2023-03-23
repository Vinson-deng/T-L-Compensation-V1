function res = RLS(A,b,num,len)
%numΪ��ʶ�����ĸ�������A������
%lenΪ���ݵĳ��ȣ���A������
%���Ax=b
%resΪ��ʶ�Ĳ����������õ���xֵ
format long;
x = rand(num,1);
I = eye(num, num);
P = (10^6) * I;

for k = 1:len
    Ak = A(k,:); %�µ������У���phi
    Q1 = P*(Ak'); %K��k���ķ���
    Q2 = 1 + Ak * P * (Ak'); %K(k)�ķ�ĸ
    K = Q1/Q2;   %����K(k) 
    x = x + K * (b(k) - Ak*x);  %���±�ʶ�Ĳ���
    P = (I - K*Ak)*P;    %����P
    thetae(:,k) = x;   %��¼ÿ�μ���ı�ʶ����
    steps(k) = k;     %��¼��ǰ������Ҳ�����Ϊ��ǰ�õ������ݸ�����
end
steps = steps';
res=thetae(:,end);
end

