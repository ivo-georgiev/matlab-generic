% Thermistor equation
% R25 = 10000 ohms
% Tkel(R) = 1./(A1+B1*log(R/R25)+C1*log(R/R25)+D1*log(R/R25)) equation 1
% R(Tkel) = R25*exp(A+ B/T + B/T^2 + B/T^3) equation 2
% NTC coefficient equation 1 for type 9
A1 = 3.354016e-3;
B1 = 2.569850e-4;
C1 = 2.620131e-6;
D1 = 6.383091e-8;
% NTC coefficient equation 2 for type 9
A = -14.6337;
B = 4791.842;
C = -115334;
D = -3.730535e6;
% NTC resistanse for 25 deg
R25 = 10000;
% Referense voltage for divider Uref = 5 V
Uref = 5;
%Referense resistanse for divider Rref = 7320 Ohms
Rref = 7320;

% Generate resistanse in interval -40 +125 deg
MinStep = 1;
MaxStep = 5;
T = (-40:MinStep:125) + 273.15;
R = R25*exp(A + (B./T) + (C./(T.^2)) + (D./(T.^3))); 

%Thermistor equation calculation for kelvin and celsius scale
Tkel = 1./(A1 + B1*log(R/R25) + C1*(log(R/R25).^2)+ D1*(log(R/R25).^3));
Tcel = Tkel - 273.15;
SplineCoef = spline(R(1:MaxStep:end),Tkel(1:MaxStep:end));
fiSplineCoef = fi(SplineCoef.coefs);
fiSplineCoef.int;
SplineTkel = ppval(SplineCoef,R);
%  PolyCoef = polyfit(R,Tkel,4)
%  PolyTkel = polyval(PolyCoef,R);
%figure(1), plot(R,T,'-ob',R,SplineTkel,'r*');grid
figure(1), subplot(2,1,1), plot(R,T-273.15,'-ob',R,SplineTkel-273.15,'r*')
           subplot(2,1,2), plot(R, (SplineTkel - T)-273.15)
           

Vref = 5;%Volts
R15 = 7320;
N = 1024;%ADC resolution 10bit
VoltsForBit = Vref/N;
RntcMIN = min(R) % for max temperature
RntcMAX = max(R) % for min temperature
IdivMIN = Uref/(RntcMAX + R15) % for min temp
IdivMAX = Uref/(RntcMIN + R15) % for max temp
UdivMIN = RntcMIN*IdivMAX %
UdivMAX = RntcMAX*IdivMIN
Nmin = round(UdivMIN/VoltsForBit)-1%?
Nmax = round(UdivMAX/VoltsForBit)+1%?
step = 50;
%n = Nmin:1:Nmax;%real possible range
n=50:1000;
ns=50:step:1000;
breaks=[50:25:200, 400, 600, 800:25:1000]
Rntc = R15./((N./n)-1); %Rntc = F(ADC)
RntcTemp = R15./((N./breaks)-1); %Rntc = F(ADC)
TkelN = 1./(A1 + B1*log(Rntc/R25) + C1*(log(Rntc/R25).^2)+ D1*(log(Rntc/R25).^3));
TkelNtemp = 1./(A1 + B1*log(RntcTemp/R25) + C1*(log(RntcTemp/R25).^2)+ D1*(log(RntcTemp/R25).^3));

whos temp
whos ns
%adcSplineCoef = spline(ns,temp)
adcSplineCoef = spline(breaks,TkelNtemp)
fiCoef= round(adcSplineCoef.coefs*2^12)
ppvalObj=adcSplineCoef ;
ppvalObj.coefs = fiCoef;
adcTemp = ppval(adcSplineCoef,n);
fiadcTemp = ppval(ppvalObj,n)/2^12;
%figure(2),plot(n,TkelN - 273.15,n,adcTemp-273.15,'*')
figure(4), subplot(2,1,1), plot(n,TkelN-273.15,'-b',n,adcTemp-273.15,'-r',n,fiadcTemp-273.15,'g')
           subplot(2,1,2), plot(n, TkelN-adcTemp,n,TkelN-fiadcTemp,'r')
%figure(3),plot(n,Rntc)