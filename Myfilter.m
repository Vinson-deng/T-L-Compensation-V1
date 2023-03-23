function varargout = Myfilter(Num,x,zi)
%Num:滤波器系数，行向量
%x：待滤波数据，列向量
%zi：初始状态，列向量
%y：输出结果，列向量
%zf：输出结果，列向量
Ndata = length(x);%数据长度
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
