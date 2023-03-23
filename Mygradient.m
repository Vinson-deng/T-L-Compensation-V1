function y = Mygradient(x)
%x：输入数据，列向量
%y：输出结果，列向量
N = length(x);
y = zeros(N,1);
if N<=1
    disp('输入数据错误：数据长度应大于等于2');
    return
end
y(2:end-1) = (x(3:end) - x(1:end-2))/2;
y(1) = x(2) - x(1);
y(end) = x(end) - x(end-1);