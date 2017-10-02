%second order IIR filter 
%y(n) = b(1)*x(n) + b(2)*x(n-1) + b(3)*x(n-2)- a(2)*y(n-1) - a(3)*y(n-2)

b = [0.049468994140625 -0.08551025390625 0.049468994140625]
a = [1 -1.8333740234375 0.8468017578125]       

B = int32(round(b.*2^20));
A = int32(round(a.*2^14));

ADCfactor = 2^10;
N=300;
x=1:N;

in = 1*rand(1,N);
in(1)=0;in(2)=0;

IN= int32(in.*ADCfactor);

IN(1)=0;IN(2)=0;
yref=filter(b,a,in);

Y= int32(zeros(1,length(x)));
Acc = int32(0);
for n = 3:N
    tmpB = int32(B(1)*IN(n)); 
    tmpB = tmpB + ((B(2)*IN(n-1)));
    tmpB = tmpB + ((B(3)*IN(n-2)));
    
    tmpA = int32(-A(2)*Y(n-1));
    tmpA = tmpA - A(3)*Y(n-2);%result is 30bit
    
    Acc = int32(tmpA + tmpB);%2^30
    Y(n) = Acc/int32(2^14);%=>convert 30 to 16
end
error = yref -(double(Y)./((2^6)*(1/ADCfactor)));
E2 =sum (error.^2)
%convert to ticks
Ytick = double(Y./int32(2^6))/ADCfactor;
subplot(3,1,1),plot(x,yref,'g-o',x,Ytick,'r*',x,in);
subplot(3,1,2), plot(x,Y./int32(2^6),'m-*')
subplot(3,1,3), plot(x,error)

