function X0 = ZiTai_Infor(L,T,V,Dis,M,Num,Fs)
X0=zeros(Num,21);
X0(:,1)=L./M;X0(:,2)=T./M; X0(:,3)=V./M;
X0(:,4)=L.*L./M.^2;X0(:,5)=L.*T./M.^2;X0(:,6)=L.*V./M.^2;
X0(:,7)=T.*T./M.^2;X0(:,8)=T.*V./M.^2;X0(:,9)=V.*V./M.^2;
X0(:,10)=X0(:,1).*(Fs*Mygradient(L)./M-L./M.^2.*Fs.*Mygradient(M));
X0(:,11)=X0(:,1).*(Fs*Mygradient(T)./M-T./M.^2.*Fs.*Mygradient(M));
X0(:,12)=X0(:,1).*(Fs*Mygradient(V)./M-V./M.^2.*Fs.*Mygradient(M));
X0(:,13)=X0(:,2).*(Fs*Mygradient(L)./M-L./M.^2.*Fs.*Mygradient(M));
X0(:,14)=X0(:,2).*(Fs*Mygradient(T)./M-T./M.^2.*Fs.*Mygradient(M));
X0(:,15)=X0(:,2).*(Fs*Mygradient(V)./M-V./M.^2.*Fs.*Mygradient(M));
X0(:,16)=X0(:,3).*(Fs*Mygradient(L)./M-L./M.^2.*Fs.*Mygradient(M));
X0(:,17)=X0(:,3).*(Fs*Mygradient(T)./M-T./M.^2.*Fs.*Mygradient(M));
X0(:,18)=X0(:,3).*(Fs*Mygradient(V)./M-V./M.^2.*Fs.*Mygradient(M));
X0(:,19)=Dis(:,1);
X0(:,20)=Dis(:,2);
X0(:,21)=Dis(:,3);
end