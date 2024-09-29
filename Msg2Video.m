function Msg2Video() 
    % Read in message file and convert to binary
    byteFile = fopen('inputOpticalMsg.bin');
    message_bytes = fread(byteFile);
    binaryMessage = dec2bin(message_bytes, 8).' - '0';
    binaryMessage = reshape(binaryMessage, 1, []);
    
    % Define video parameters
    frameSize = [1440, 1080]; % 1440x1080 / 8 
    frameRate = 5; 
    numFrames = length(binaryMessage);
    
    % Set up Video Recorder
    video = VideoWriter('encodedVideo.mp4', 'MPEG-4');
    video.FrameRate = frameRate;
    open(video)
    
    for i= 1:numFrames
        % Set frame color based on read bit
        if binaryMessage(i) == 1
            frame = uint8(ones(frameSize)*255);
        else
            frame = uint8(zeros(frameSize)*255);
        end
    
        % Write da video
        writeVideo(video, frame);
    end
    
    close(video)
    disp('Video encoded!')
end