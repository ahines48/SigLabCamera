clear all
close all

% camVid = VideoReader('bin4.mj2');
timeSeries = load('60HzMatchedKindaTimeSeries.mat');
metronomeData = timeSeries.ROItimeSeries(1,:,2);
messageData = timeSeries.ROItimeSeries(2,:,2);
numFrames = length(metronomeData);

framePlot = 1:numFrames;

figure;
subplot(2,1,1)
plot(framePlot, metronomeData)
title('Metronome Time Series Data')
xlabel('Frames')
ylabel('Intensity')

subplot(2,1,2)
plot(framePlot, messageData)
title('Message Time Series Data')
xlabel('Frames')
ylabel('Intensity')

% Filter out end of message
dMetronome = diff(metronomeData);

diff_plot = 1:length(dMetronome);
figure
plot(diff_plot, dMetronome)
title('First Derivative of Metronome')
xlabel('Frames')
ylabel('Intensity per Frame')

tolerance = 15;
upperThresh = 250;
lowerThresh = 0;

lowerBound = lowerThresh + tolerance;
upperBound = upperThresh + tolerance;
dataInRange =  (metronomeData <= upperBound);
startIndex = 1;
endIndex = length(metronomeData);

while startIndex <= length(metronomeData) && dataInRange(startIndex)
    startIndex = startIndex + 1; 
end

while endIndex >= 1 && dataInRange(endIndex)
    endIndex = endIndex - 1;
end

filtMet = metronomeData(startIndex:endIndex);
filtMessage = messageData(startIndex:endIndex);

thresh = 25;
[metPeaks, locs] = findpeaks(filtMet);
[msgPeaks, locus] = findpeaks(filtMessage, 'MinPeakHeight',thresh);

filt_plot = 1:length(filtMessage);
figure;
subplot(2,1,1)
plot(filt_plot, filtMet)
hold on
title('Filtered Metronome Time Series Data')
xlabel('Frames')
ylabel('Intensity')
plot(filt_plot(locs), metPeaks, 'rv')
hold off

subplot(2,1,2)
plot(filt_plot, filtMessage)
hold on
title('Filtered Message Time Series Data')
xlabel('Frames')
ylabel('Intensity')
plot(filt_plot(locus), msgPeaks, 'rv')
hold off

metFreq = length(metPeaks)/(length(metronomeData)/226);
metFramesperPeak = length(metronomeData)/(2*length(metPeaks));
metTs = 1/metFreq;
disp(metFreq)
disp(metFramesperPeak)
disp(metTs)

% shiftMsg = messageData - metronomeData;
% figure
% plot(filt_plot, shiftMsg)
% title('Message - Metronome')
% xlabel('Frames');
% ylabel('Intsneity with respect to Metronome Time')
readBits = [];
% readBits(locus) = 1;

shiftMsg = messageData - max(messageData)/2;
for i = 1:4:length(shiftMsg)
    if shiftMsg(i) > 0
        readBits = [readBits, 1];
    else
        readBits = [readBits, 0];
    end
end

bit_plot = 1:length(readBits);
figure
plot(bit_plot, readBits)
title('Unfiltered Interpreted Bits')
xlabel('Frames')
ylabel('Bit Value')

% for i = 1:length(readBits)
%     if readBits(i) == 1 && 
% end
% % Find approximate numFrames/bit
% count = 0;
% minFrames = inf;
% for i = 1:length(readBits)
%     if readBits(i) == 1
%         count = count+1;
%     else
%         if count > 0 && count < minFrames
%             minFrames = count;
%         else 
%             count = 0;
%         end
%     end
% end
% 
% if minFrames == inf
%     minFrames = 0;
% end
% 
% % Convert multiple frame vals to single bit val
% ones = 0;
% numZeros = 0;
% binaryCode = [];
% readBits = readBits(1:810);
% 
% for i = 1:length(readBits)
%     if readBits(i) == 1
%         ones = ones+1;
%     else
%         numZeros = numZeros+1;
%     end 
%     if ones == 5
%         binaryCode(end+1) = 1;
%         ones = 0;
%     elseif numZeros == 5
%         binaryCode(end+1) = 0;
%         numZeros = 0;
%     end
% end
% 
% Convert the Bits back to string
if mod(length(readBits),8) ~= 0
    remainder = mod(length(readBits), 8);
    binaryCode = readBits(1:length(readBits)-remainder);
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

% inputMessage = [01110011 01110100 01100001 01110010 01110100 00100000 01001000 ...
%     01100101 01101100 01101100 01101111 00100000 01010111 01101111 01110010 ...
%     01101100 01100100 00100001 00100000 01100101 01101110 01100100];
% inputMessage  = reshape(inputMe
% figure
% plot(1:176, inputMessage)
% title('Input')
% 
% inputBinary = [];
% 
% for i = 1:length(inputMessage)
%     inputBinary = [inputBinary, binaryVec];
% end
% 
% % Now we compare inputBinary with binaryCode
% 
% % Ensure that the binaryCode has the same length as inputBinary
% minLength = min(length(inputBinary), length(binaryCode));
% binaryCode = binaryCode(1:minLength);
% inputBinary = inputBinary(1:minLength);
% 
% % Calculate the number of bit errors
% numErrors = sum(binaryCode ~= inputBinary);
% 
% % Calculate the bit error rate (BER)
% bitErrorRate = numErrors / minLength;
% 
% % Display the results
% disp(['Number of bit errors: ', num2str(numErrors)]);
% disp(['Total number of bits compared: ', num2str(minLength)]);
% disp(['Bit Error Rate (BER): ', num2str(bitErrorRate)]);
