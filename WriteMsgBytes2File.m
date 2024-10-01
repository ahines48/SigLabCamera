function WriteMsgBytes2File()
    message = input('Please input the message you would like to send: ', 's');
    message_string = ['start ' message ' end'];
    message_bytes = uint8(message_string);
    
    % Visualize binary message
    message_binary = dec2bin(message_bytes, 8).' - '0';
    message_binary = reshape(message_binary, 1, []);
    disp(message_binary);
    
    % Up sample signal to minimize data loss
    upSampleFactor = 4; % Random decision we can adjust
    message_upSampled = upsample(message_binary, upSampleFactor);

    % Convert Binary to symbols with BPSK (1 = +1, 0 = -1)
    msgSymbols = 2*message_upSampled-1;

    % Define Raised Cosine Pulse for Matched Filter
    Ts = .04; % Should be safely within nyquist if Camera FR = 70 Hz, Fs/2 = .025
    t = -4*Ts:Ts:4*Ts; 
    beta = 0.5; % Roll-off, prolly need to adjust
    raisedCos = sinc(t/Ts).*(cos(pi*beta*t/Ts)./(1-(2*beta*t/Ts).^2));
    raisedCos(t == Ts/(2*beta) | t == -Ts/(2*beta)) = pi/4*sinc(1/(2*beta)); % Deal with 0/0
    %raisedCos = raisedCos / sqrt(sum(raisedCos.^2)); %Normalize pulse

    % Modulate Bits
    modulated_signal = conv(msgSymbols, raisedCos);
    
    t_plot = (0:length(modulated_signal)-1) * Ts;
    figure
    plot(t_plot, modulated_signal)
    title('Modulated Signal')
    xlabel('Time (sec)')
    ylabel('Amplitude')

    % Save bytes to file
    if ~exist('inputOpticalMsg.bin', 'file')
        byteFile = fopen('inputOpticalMsg.bin','w');
        fwrite(byteFile, modulated_signal, 'double');
        fclose(byteFile);
        disp('Input message written to file')
    else 
        delete('inputOpticalMsg.bin');
        disp('Previous Message File Deleted')
        byteFile = fopen('inputOpticalMsg.bin','w');
        fwrite(byteFile, modulated_signal, 'double');
        fclose(byteFile);
        disp('Input message written to file')
    end
end
