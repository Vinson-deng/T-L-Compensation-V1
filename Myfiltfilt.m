function y = Myfiltfilt(b,x)
%b:滤波器系数，行向量
%x：待滤波数据，列向量
%y：输出结果，列向量
Npts = length(x);
[b,zi,nfact] = getCoeffsAndInitialConditions(b,1,Npts);
y = ffOneChanCat(b,x,zi,nfact);
%--------------------------------------------------------------------------
function [b,zi,nfact] = getCoeffsAndInitialConditions(b,a,Npts)
b = b(:);
a = a(:);
nb = length(b);
nfilt = nb;
nfact = 3*(nfilt-1);
if Npts <= nfact
    error(message('数据长度要大于滤波器长度的3倍'));
end
a(nfilt,1)=0;
rhs  = b(2:nfilt) - b(1)*a(2:nfilt);
zi = (eye(nfilt-1) - [-a(2:nfilt), [eye(nfilt-2);zeros(1,nfilt-2)]]) \ rhs;

%--------------------------------------------------------------------------
function y = ffOneChanCat(b,y,zi,nfact)
y = [2*y(1)-y(nfact+1:-1:2); y; 2*y(end)-y(end-1:-1:end-nfact)];
y = Myfilter(b',y,zi*y(1));
y = y(end:-1:1);
y = Myfilter(b',y,zi*y(1));
y = y(end-nfact:-1:nfact+1);

