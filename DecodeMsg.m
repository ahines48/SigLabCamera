clear all
close all

% camVid = VideoReader('bin4.mj2');
timeSeries = load('timeSeries.mat');
timeSeries = timeSeries.ROItimeSeries(:,:,2);
numFrames = length(timeSeries);

% Define Raised Cosine Pulse for Matched Filter
Ts = .04; % Should be safely within nyquist if Camera FR = 70 Hz, Fs/2 = .025
t = -4*Ts:Ts:4*Ts; 
beta = 0.5; % Roll-off, prolly need to adjust
raisedCos = sinc(t/Ts).*(cos(pi*beta*t/Ts)./(1-(2*beta*t/Ts).^2));
raisedCos(t == Ts/(2*beta) | t == -Ts/(2*beta)) = pi/4*sinc(1/(2*beta)); % Deal with 0/0

filtered_signal = conv(modulated_signal, raisedCos, 'same');
downSampleFactor = 4;
signalDSFilt = filtered_signal(1:downSampleFactor:end);
 
readBits = zeros(1, length(timeSeries));
for i = 1:length(timeSeries)
    if timeSeries(i) > 0
        readBits(i) = 1;
    else
        readBits(i) = 0;
    end
end

readBytes = reshape(readBits,8,[]).';
stringBytes = bin2dec(num2str(received_bytes));
recievedMessage = char(stringBytes)';
% Remove Start and End
recievedMessage = strrep(recievedMessage, 'start ', '');
recievedMessage = strrep(recievedMessage, ' end', '');

disp('Decoded message:');
disp(received_message);

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


% % Convert the Bits back to string
% if mod(length(binaryCode),8) ~= 0
%     remainder = mod(length(binaryCode), 8);
%     binaryCode = binaryCode(1:length(binaryCode)-remainder);
% end
% 
% 
% numChars = length(binaryCode)/8;
% disp(numChars)
% chars = cell(numChars,1);
% 
% for i = 1:numChars
%     curByte = binaryCode((i-1)*8+1:i*8);
%     temp = 0;
%     for j=1:length(curByte)
%         temp = temp + curByte(j)*10^(length(curByte)-j);
%     end
%     chars{i} = char(string(temp));
% end
% curDecimal = bin2dec(chars);
% curDecimal = curDecimal';
% 
% %disp(['The converted string is: ', char(chars)]);
% disp(char(curDecimal))

%% Calculate BER

inputMessage = [01110011 01110100 01100001 01110010 01110100 00100000 01001000 ...
    01100101 01101100 01101100 01101111 00100000 01010111 01101111 01110010 ...
    01101100 01100100 00100001 00100000 01100101 01101110 01100100];
inputMessage  = reshape(inputMe
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
