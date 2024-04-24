clear 'all';
close 'all';

%========================================%
% EBV Testat                             %
%========================================%
% Author: Joel von Rotz

% read image
Image = imread('./Muenzen.png');
[Hist, Vals] = imhist(Image);

%% Process Image
% Convert image to binary image
ImageBW = Image < (graythresh(Hist) * 255);

% Close Up Holes of the
structure = strel('disk',3);
ClosedImage = imclose(ImageBW, structure);

% Do labeling with 8 neighbors
[LabelImage, NumberLabels] = bwlabel(ClosedImage);

% Feature Extractions -> Centroid for center point
Prop = regionprops(LabelImage,'BoundingBox', 'Area','Centroid');

%% Process Features
Centroid = zeros(NumberLabels,2); % (x,y)
AreaValues = zeros(NumberLabels,1);
CoinValue = zeros(NumberLabels,1);

            %  min,  max
CoinRanges = [4800, 5700,... % 0.50 Fr.
              6700, 7600,... % 0.20 Fr.
              8000, 9000,... % 1.00 Fr.
              11200,12500,... % 2.00 Fr.
              15200,16000]; % 5.00 Fr.

for i=1:size(Prop,1)
    % Center Points
    Centroid(i,:) = Prop(i).Centroid;

    % Coin Sizes
    Area = Prop(i).Area;
    
    AreaValues(i) = Prop(i).Area;

    if (Area > CoinRanges(1)) && (Area < CoinRanges(2)) % 0.50 Fr.
        CoinValue(i) = 0.5;
    elseif (Area > CoinRanges(3)) && (Area < CoinRanges(4)) % 0.20 Fr.
        CoinValue(i) = 0.2;
    elseif (Area > CoinRanges(5)) && (Area < CoinRanges(6)) % 1.00 Fr.
        CoinValue(i) = 1.0;
    elseif (Area > CoinRanges(7)) && (Area < CoinRanges(8)) % 2.00 Fr.
        CoinValue(i) = 2.0;
    elseif (Area > CoinRanges(9)) && (Area < CoinRanges(10)) % 5.00 Fr.
        CoinValue(i) = 5.0;
    else
        error("unknown coin detected");
    end

    TotalCoinValue = sum(CoinValue);

end


%% Plotting
% [Figure 1]
% Draw Image
figure(1);
imshow(Image); hold on;

% Draw Total Value Box
text(10,10, sprintf('Total Value: %.2f Fr.',TotalCoinValue),'FontSize', 14 , 'BackgroundColor',[.8 .8 .8],'HorizontalAlignment', 'left', 'VerticalAlignment','top');

% Draw Center Points
plot(Centroid(:,1),Centroid(:,2), "r+", 'MarkerSize',10,'LineWidth',1.5);

for i=1:size(Prop,1)
    % Draw Bounding Boxes
    rectangle('Position',Prop(i).BoundingBox,'EdgeColor',"g",'LineWidth',1.5);
    text(Centroid(i,1)+10,Centroid(i,2), sprintf('%.2f Fr.',CoinValue(i)),'FontSize', 14 , 'BackgroundColor',[.8 .8 .8],'HorizontalAlignment', 'left', 'VerticalAlignment','middle');
end

% [Figure 2]
% Draw Coin Area Distribution
CoinRangeLabels = ["0.50 Fr. min", "0.50 Fr. max", "0.20 Fr. min", "0.20 Fr. max", "1.00 Fr. min", "1.00 Fr. max","2.00 Fr. min","2.00 Fr. max","5.00 Fr. min","5.00 Fr. max"];

figure(2);
plot(AreaValues,1,'bo');
xticks(4000:1000:17000);
title("Coin Area Distribution");

for i=1:size(CoinRangeLabels,2)
    xline(CoinRanges(i),'--','Color','#7E2F8E','LineWidth',1.5,'Label',CoinRangeLabels(i),'LabelHorizontalAlignment','left');
end

text(mean([CoinRanges(1), CoinRanges(2)]), 1.1,sprintf("$$%u\\times$$",sum(CoinValue == 0.5)),FontWeight="bold",FontSize=20,HorizontalAlignment="center",Interpreter="latex");
text(mean([CoinRanges(3), CoinRanges(4)]), 1.1,sprintf("$$%u\\times$$",sum(CoinValue == 0.2)),FontWeight="bold",FontSize=20,HorizontalAlignment="center",Interpreter="latex");
text(mean([CoinRanges(5), CoinRanges(6)]), 1.1,sprintf("$$%u\\times$$",sum(CoinValue == 1.0)),FontWeight="bold",FontSize=20,HorizontalAlignment="center",Interpreter="latex");
text(mean([CoinRanges(7), CoinRanges(8)]), 1.1,sprintf("$$%u\\times$$",sum(CoinValue == 2.0)),FontWeight="bold",FontSize=20,HorizontalAlignment="center",Interpreter="latex");
text(mean([CoinRanges(9), CoinRanges(10)]), 1.1,sprintf("$$%u\\times$$",sum(CoinValue == 5.0)),FontWeight="bold",FontSize=20,HorizontalAlignment="center",Interpreter="latex");

grid minor;
yticks(0.5:0.5:1.5);
set(gca,'YTick',[]);
set(gca,'Yticklabel',[]);
