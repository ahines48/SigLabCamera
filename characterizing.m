%% Noise
% Field of view
% Under 1000 us exposure time, 45dB gain and binning of 1
clear;

superHugeData = uint8(zeros(1080, 1440, 3, 100));

debug = false;

[infilepath,infilename,infileext] = fileparts('noise/white/gain/gain25.mj2');
v = VideoReader([infilepath filesep infilename  infileext]);

if debug
    figure('Position',[50 50 v.Width v.Height],"Color","black","DefaultAxesFontSize",20,"DefaultAxesXColor","white","DefaultAxesYColor","white","DefaultAxesColor","black");
    axVideo = axes('position',[0 0 1 1]);
    hImage = image(zeros(v.Height, v.Width, 3),"Parent",axVideo);
    axis(axVideo,"image","off");
    hText = text(0,0,"Frame #",...
            'color','g','FontSize',12,'VerticalAlignment','top','parent',axVideo);
end

% read initial frame
frameNum=1;
img = readFrame(v);
superHugeData(:,:,:,frameNum) = img;

if debug
    hImage.CData = img;
end

% read video, output data files
while v.hasFrame
    if v.hasFrame  
        % read next frame
        img = readFrame(v);

        frameNum=frameNum+1;
        superHugeData(:,:,:,frameNum) = img;

        % debug: show video being read
        if debug
            hImage.CData = img;
            hText.String = "Frame " + num2str(frameNum);
            drawnow limitrate nocallbacks;
        end
    end
end
%%
stdRGB = std(double(superHugeData),0,4);
stdR = stdRGB(:,:,1);
stdG = stdRGB(:,:,2);
stdB = stdRGB(:,:,3);

%%
figure;
hImage = image(zeros(length(superHugeData(:,1,1,1)),length(superHugeData(1,:,1,1)),3));

hText = text(0,0,"Frame #",...
        'color','g','FontSize',12,'VerticalAlignment','top');

for i=1:length(superHugeData(1,1,1,:))
    if ishandle(hImage)
        hImage.CData = superHugeData(:,:,:,i);
        hText.String = "Frame " + num2str(i);
        drawnow limitrate nocallbacks;
        pause(5/100);
    end
end
%%
figure('Position', [0, 500, 1400, 400]); % [left, bottom, width, height]
tiledlayout(1, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

nexttile
imagesc(stdR)
colormap turbo
colorbar;
clim([min(stdR(:)),max(stdR(:))]);
title("R")

nexttile
imagesc(stdG)
colormap turbo
colorbar;
clim([min(stdG(:)),max(stdG(:))]);
title("G")

nexttile
imagesc(stdB)
colormap turbo
colorbar;
clim([min(stdB(:)),max(stdB(:))]);
title("B")
%%
[maxR,indxR]=max(stdR(:));
[Rx,Ry]=ind2sub(size(stdR),indxR);
dataR = squeeze(superHugeData(Rx,Ry,1,:));
dataG = squeeze(superHugeData(Rx,Ry,2,:));
dataB = squeeze(superHugeData(Rx,Ry,3,:));

figure;
subplot(3,1,1)
histogram(dataR, 'FaceColor', 'r','NumBins',256);
xlim([-1 255])
subplot(3,1,2)
histogram(dataG, 'FaceColor', 'g','NumBins',256);
xlim([-1 255])
subplot(3,1,3)
histogram(dataB, 'FaceColor', 'b','NumBins',256);
xlim([-1 255])
%%
[maxG,indxG]=max(stdG(:));
[Gx,Gy]=ind2sub(size(stdG),indxG);
dataR = squeeze(superHugeData(Gx,Gy,1,:));
dataG = squeeze(superHugeData(Gx,Gy,2,:));
dataB = squeeze(superHugeData(Gx,Gy,3,:));

figure('Units','normalized','Position',[0.2 0.1 0.6 0.8]);
subplot(3,1,1)
histogram(dataR, 'FaceColor', 'r','NumBins',256);
xlim([-1 255])
subplot(3,1,2)
histogram(dataG, 'FaceColor', 'g','NumBins',256);
xlim([-1 255])
subplot(3,1,3)
histogram(dataB, 'FaceColor', 'b','NumBins',256);
xlim([-1 255])
%%
[maxB,indxB]=max(stdB(:));
[Bx,By]=ind2sub(size(stdB),indxB);
dataR = squeeze(superHugeData(Bx,By,1,:));
dataG = squeeze(superHugeData(Bx,By,2,:));
dataB = squeeze(superHugeData(Bx,By,3,:));

figure('Units','normalized','Position',[0.2 0.1 0.6 0.8]);
subplot(3,1,1)
histogram(dataR, 'FaceColor', 'r','NumBins',256);
xlim([-1 255])
subplot(3,1,2)
histogram(dataG, 'FaceColor', 'g','NumBins',256);
xlim([-1 255])
subplot(3,1,3)
histogram(dataB, 'FaceColor', 'b','NumBins',256);
xlim([-1 255])
%% Color accuracy
load bars/raw/bars_ROItimeSeries.mat
color = ["black","yellow","cyan","green","magenta","red","blue"];
figure;
for j=1:3
    subplot(3,1,j)
    for i=1:length(color)
        plot(ROItimeSeries(i,:,j)','Color',color(i));
        hold on;
    end
end

%% Timing
folderPath = 'timing/fig';
fileList = dir(fullfile(folderPath, '*.fig'));

numFiles = length(fileList);

figure('Position', [0, 0, 500, 1000]); % [left, bottom, width, height]

for i = 1:numFiles
    path = fullfile(fileList(i).folder, fileList(i).name);
    f = openfig(path, 'invisible');

    a = get(f, 'Children');
    
    hLine = findobj(a, 'Type', 'line');
    
    xdata = get(hLine, 'XData');
    ydata = get(hLine, 'YData');
    
    close(f);
    clear f;
    
    variance = var(ydata{3});
    subplot(numFiles,1,i)
    plot(xdata{3}, ydata{3});
    xlabel('Frame');
    ylabel('Timing interval(ms)');
    title([fileList(i).name " var: " num2str(variance)]);
end