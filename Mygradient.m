function y = Mygradient(x)
%x���������ݣ�������
%y����������������
N = length(x);
y = zeros(N,1);
if N<=1
    disp('�������ݴ������ݳ���Ӧ���ڵ���2');
    return
end
y(2:end-1) = (x(3:end) - x(1:end-2))/2;
y(1) = x(2) - x(1);
y(end) = x(end) - x(end-1);