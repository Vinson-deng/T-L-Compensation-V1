function varargout = Myfilter(Num,x,zi)
%Num:�˲���ϵ����������
%x�����˲����ݣ�������
%zi����ʼ״̬��������
%y����������������
%zf����������������
Ndata = length(x);%���ݳ���
y = zeros(Ndata,1);
if nargin <3
    zi = zeros(length(Num)-1,1);
end
for kk = 1:Ndata
    temp = Num'*x(kk)+[zi;0];
    y(kk) = temp(1);
    zi = temp(2:end);
end
if nargout == 1
    varargout{1} = y;
else
    varargout{1} = y;
    varargout{2} = zi;
end
