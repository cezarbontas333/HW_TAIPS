clear;
close all;
clc;

BL  = [blanks(3) '* Insert '] ;
TS  = [BL 'the ID of the time series to insert: '];
SRS = [BL 'the channel which to select: '];
PMO = [BL 'the trend order: '];
idx = input(TS);

while((idx <= 0 || idx > 20))
    warning(['Time series ID must be in rage of 1 to 20!']);
    idx = input(TS);
end
% Fixed filename string for Windows directories, with proper relative path
load(sprintf(".\\data\\Y%02d.mat", idx));

if(idx > 15)
    channel = input(SRS);
else
    channel = 1;
end

while((channel < 1 || channel > 2))
    warning(['Channel must be 1 or 2!']);
    channel = input(SRS);
end
if(~exist('DATA', 'var'))
    DATA = Y;
end
DATA = DATA(:, channel);
y = DATA.y;
y_k = y(end - 4 : end);
y_t = y(1 : end - 5);
pMax = input(PMO);
while(~isa(pMax, 'double'))
    warning('Trend order must be a number!');
    pMax = input(PMO);
end

[ysta, yT, theta] = trend(y_t, pMax)
