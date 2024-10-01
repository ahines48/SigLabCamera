function Msg2Video() 
    % Read in message file and convert to binary
    byteFile = fopen('inputOpticalMsg.bin');
    messageSymbols = fread(byteFile, 'double');
    messageSymbols = messageSymbols(messageSymbols == 1 | messageSymbols == -1);
    % Define video parameters
    frameSize = [1440, 1080]; % 1440x1080 / 8 
    frameRate = 25; % Match Ts from encoder
    numFrames = length(messageSymbols);
    
    % Set up Video Recorder
    video = VideoWriter('encodedVideo', 'MPEG-4');
    video.FrameRate = frameRate;
    open(video)

    for i= 1:numFrames
        % Set frame color based on read bit
        if messageSymbols(i) > 0
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
