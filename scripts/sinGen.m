function z = sinGen(duration,magnitude,decay,fnom,nharm,fs)
% duration[phaN], {sec} with duration in sec for each phase
% magnitude[phaseN,harN], {0..1} magnitude for each harmonic in each phase
% decay[phaseN][harmN], exp decay factor for each harmonic in each phase
% fnom[phaN], {Hz} Nominal freq for each phase
% nharm, scalar number of harmonics
% fs , {Hz} sampling frequency fs > 2*fkmax (harmonic with max freq.)!!
% Example:
% decay = [repmat([1.9 1.9 1.9 1.9],[5,1]); %phases 1:5
%          0.00003 0.00003 0.00003 0.00003];%phase 6
% magnitude = [1     1/3    1/5  1/7;       %phase 1
%              0     0      0    0 ;        %phase 2
%              1     1/3    1/5  1/7;       %phase 3
%              0     0      0    0 ;        %phase 4
%              1     1/3    1/5  1/7;       %phase 5
%              0.1 0.1/3  0.1/5  0.1/7;];   %phase 6
%          
% y = sinGen([0.1 0.03 0.1 0.03 0.1 0.9],magnitude ,decay ,ones(1,6)*1317 ,4 ,24000);

nphase = length(duration);

omega = repmat(fnom',[1,nharm]).*repmat(1:2:nharm*2,[nphase,1]).*2*pi;
dt = 1/fs;
cycles = duration/dt;

z=[];
dtime=[];

for phase=1:length(cycles)
    n = 1:cycles(phase);
    N = length(n);
    dtime = repmat(n,[nharm,1]).*dt;
    A = repmat(magnitude(phase,:)',[1, N]);
    EX = exp(-repmat(decay(phase,:)',[1, N]).*dtime);
    SI = arrayfun(@sin,repmat(omega(phase,:)',[1, N]).*dtime);
    z = [z sum(A.*EX.*SI,1)];
end
%output normalization
z=z./max(z);

figure(phase+1),plot(z);
title('Time domain m-file: son2/1 repetition')

end


