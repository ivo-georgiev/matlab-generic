R=1000;
C=1e-6;
tau=R*C;
T0=tau/5;

%%%%%%%%%%
%Variant 1 
%Y(k)= [T0/(2*tau+T0)]*[X(k)+X(k-1)] -  [T0-2*tau]*Y(k-1)

%Variant 2 
%Y(k) = [T0/tau]*X(k-1) + [(tau-T0)/tau]*Y(k-1)