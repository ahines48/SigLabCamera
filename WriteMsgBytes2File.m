function WriteMsgBytes2File()
    message = input('Please input the message you would like to send: ', 's');
    message_string = ['start ' message ' end'];
    message_bytes = uint8(message_string);
    
    % Visualize binary message
    message_binary = dec2bin(message_bytes, 8);
    disp(message_binary);
    
    % Save bytes to file
    if ~exist('inputOpticalMsg.bin', 'file')
        byteFile = fopen('inputOpticalMsg.bin','w');
        fwrite(byteFile, message_bytes);
        fclose(byteFile);
        disp('Writing input message to file')
    else 
        delete('inputOpticalMsg.bin');
        disp('Previous Message File Deleted')
        byteFile = fopen('inputOpticalMsg.bin','w');
        fwrite(byteFile, message_bytes);
        fclose(byteFile);
        disp('Writing input message to file')
    end
end
