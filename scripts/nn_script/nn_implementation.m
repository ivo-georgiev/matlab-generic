clear all
load net5-7_2134.mat
X=P(2:6,35)'%Input            % Input vector [Temp SOC U00 U0L Res]
NbNIL = length(net.b{1});     % Number of Neurons for Input Layer
NbNHL = length(net.b{2});     % Number of Neurons for Hiden Layer
NbNOL = length(net.b{3});     % Number of Neurons for Output Layer
NbI = length(X);              % Number of Inputs
%-------------------------------------------------------------------------%
%--------Loop for calculation on outputs of Input Layer ------------------%
%-------------------------------------------------------------------------%
for j=1:NbNIL                 % loop for Input Layer SINK
    sum(j)= net.b{1}(j);      % Load biases for Input Layer        5x1   
    for i = 1:length(X)       % SOURCE 
        sum(j)=sum(j)+X(i)*net.IW{1,1}(j,i); % sum(Xi*IWj,i)+bias
    end
    NIL(j)=2/(1+exp(-2*sum(j)))-1; % NeuronInputLayer(j) = tanh(sum(Xi*IW(j,i))+bias)
    sum(j)=0;  % reset temp variable
end
%-------------------------------------------------------------------------%
%--------Loop for calculation on outputs of Hiden Layer ------------------%
%-------------------------------------------------------------------------%
for j=1:NbNHL                   %SINK is Inputs of Hiden Layer
    sum(j)= net.b{2}(j);        %Load biases for Hiden Layer       7x1
    for i=1:NbNIL               %SOURCE is Output of Input Layer
       sum(j)=sum(j)+ NIL(i)*net.LW{2,1}(j,i);% sum(NIL(i)*HW(j,i)+bias_hiden
    end
    NHL(j)=2/(1+exp(-2*sum(j)))-1; %NeuronHidenLayer(j) = tanh(sum(NIL(i)*HW(j,i))+bias_hiden)
    sum(j)=0;% reset temp variable
end
%-------------------------------------------------------------------------%
%--------Loop for calculation on output of Output Layer ------------------%
%-------------------------------------------------------------------------%
sum(1) = net.b{3}(1);           %Load bias for Output Layer        1x1
for j =1: NbNHL                 %SOURCE is Output of Hiden Layer
    sum(1)=sum(1)+ NHL(j)*net.LW{3,2}(j); % sum(NHL(i)*OW(j,i))+bias_out
end

SOH_prediction = sum(1)
