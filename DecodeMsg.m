clear all
close all

% camVid = VideoReader('bin4.mj2');
timeSeries = load('timeSeries.mat');

timeSeries = conv(timeSeries.ROItimeSeries(:,:,2), r;
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
numZeros = 0;
binaryCode = [];
readBits = readBits(1:810);

for i = 1:length(readBits)
    if readBits(i) == 1
        ones = ones+1;
    else
        numZeros = numZeros+1;
    end 
    if ones == 5
        binaryCode(end+1) = 1;
        ones = 0;
    elseif numZeros == 5
        binaryCode(end+1) = 0;
        numZeros = 0;
    end
end

% Convert the Bits back to string
if mod(length(binaryCode),8) ~= 0
    remainder = mod(length(binaryCode), 8);
    binaryCode = binaryCode(1:length(binaryCode)-remainder);
end


numChars = length(binaryCode)/8;
disp(numChars)
chars = cell(numChars,1);

for i = 1:numChars
    curByte = binaryCode((i-1)*8+1:i*8);
    temp = 0;
    for j=1:length(curByte)
        temp = temp + curByte(j)*10^(length(curByte)-j);
    end
    chars{i} = char(string(temp));
end
curDecimal = bin2dec(chars);
curDecimal = curDecimal';

%disp(['The converted string is: ', char(chars)]);
disp(char(curDecimal))

%% Calculate BER

inputMessage = [01110011 01110100 01100001 01110010 01110100 00100000 01001000 ...
    01100101 01101100 01101100 01101111 00100000 01010111 01101111 01110010 ...
    01101100 01100100 00100001 00100000 01100101 01101110 01100100];
inputMessage  = reshape(inputMessage) 
figure
plot(1:176, inputMessage)
title('Input')

inputBinary = [];

for i = 1:length(inputMessage)
    inputBinary = [inputBinary, binaryVec];
end

% Now we compare inputBinary with binaryCode

% Ensure that the binaryCode has the same length as inputBinary
minLength = min(length(inputBinary), length(binaryCode));
binaryCode = binaryCode(1:minLength);
inputBinary = inputBinary(1:minLength);

% Calculate the number of bit errors
numErrors = sum(binaryCode ~= inputBinary);

% Calculate the bit error rate (BER)
bitErrorRate = numErrors / minLength;

% Display the results
disp(['Number of bit errors: ', num2str(numErrors)]);
disp(['Total number of bits compared: ', num2str(minLength)]);
disp(['Bit Error Rate (BER): ', num2str(bitErrorRate)]);
