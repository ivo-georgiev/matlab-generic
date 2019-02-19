R=50;
Cap=1e-6;
L=10e-3;
num = [Cap 0]
den = [L*Cap R*Cap 1];
roots(den)
%continius time State Space model input voltage - current,voltage accros L
A = [-R/L -1/L;1/Cap 0];
B = [1/L 0]';
C = [1 0];
D= 0;
%discrete time SS
dT = 0.00001;
Ad = eye(2)+A*dT
Bd = B*dT;
Cd = C
Dd =D
detA=det(A)