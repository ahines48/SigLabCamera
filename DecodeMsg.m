clear all
close all

% camVid = VideoReader('bin4.mj2');
timeSeries = load('timeSeries.mat');
timeSeries = timeSeries.ROItimeSeries(:,:,2);
numFrames = length(timeSeries);
threshold = 50;
 
readBits = zeros(1, length(timeSeries));
for i = 1:length(timeSeries)
    if timeSeries(i) > threshold
        readBits(i) = 1;
    else
        readBits(i) = 0;
    end
end

framePlot = 1:numFrames;

figure;
subplot(2,1,1)
plot(framePlot, timeSeries)
title('Raw Time Series Data')
xlabel('Frames')
ylabel('Intensity')

subplot(2,1,2)
plot(framePlot, readBits)
title('Interpreted Bits')
xlabel('Frames')
ylabel('Value')


% Find approximate numFrames/bit
count = 0;
minFrames = inf;
for i = 1:length(readBits)
    if readBits(i) == 1
        count = count+1;
    else
        if count > 0 && count < minFrames
            minFrames = count;
        else 
            count = 0;
        end
    end
end

if minFrames == inf
    minFrames = 0;
end

% Convert multiple frame vals to single bit val
ones = 0;
zeros = 0;
binaryCode = [];
readBits = readBits(1:810);

for i = 1:length(readBits)
    if readBits(i) == 1
        ones = ones+1;
    else
        zeros = zeros+1;
    end 
    if ones == 5
        binaryCode(end+1) = 1;
        ones = 0;
    elseif zeros == 5
        binaryCode(end+1) = 0;
        zeros = 0;
    end
end

% Convert the Bits back to string
if mod(length(binaryCode),8) ~= 0
    remainder = mod(length(binaryCode), 8);
    binaryCode = binaryCode(1:length(binaryCode)-remainder);
end

numChars = length(binaryCode)/8;
disp(numChars)
chars = char(zeros(1, numChars));

for i = 1:numChars
    curByte = binaryCode((i-1)*8+1:i*8);
    curDecimal = bin2dec(curByte);
    chars(i) = char(curDecimal);
end

disp(['The converted string is: ', chars]);