% Image Compression Using SVD
% Author : Tejas Dhrangadharia

rankArray = [10,50,100,150];
squareImage = imageCompressionWithRanks('square.png',rankArray,'c_square.png');
% As square.png is a gray scale image all the images in given rank array
% looks similar.

% UB.png. Output image is : c_UB.png
rankArray2 = [40,50,100,80,150];
UBImage = imageCompressionWithRanks('UB.png',rankArray2,'c_UB.png');


% futurama.png. Output image is : c_futurama.png
rankArray3 = [50,100,150,200,220];
FuturamaImage = imageCompressionWithRanks('futurama.png',rankArray3,'c_futurama.png');

function imageArray = imageCompression(fileName, rank)
% function that takes in a file name and the SVD rank approximation
% and returns the compressed image as an mxnx3 array
A = imread(fileName);
info = imfinfo(fileName);
if info.ColorType == 'grayscale'
    G = double(A(:,:,1));
    [U,S,V] = svds(G,2);
    Gray = uint8(U * S * transpose(V));
    OutputImage(:,:,1) = Gray;
    imageArray = OutputImage
else
    R = double(A(:,:,1));
    G = double(A(:,:,2));
    B = double(A(:,:,3));
    
    [U,S,V] = svds(R,rank);
    Red = uint8(U * S * V.');
        
    [U,S,V] = svds(G,rank);
    Green = uint8(U * S * V.');

    [U,S,V] = svds(B,rank);
    Blue = uint8(U * S * V.');

    OutputImage(:,:,1) = Red;
    OutputImage(:,:,2) = Green;
    OutputImage(:,:,3) = Blue;

    imageArray = OutputImage
end 
end

function imageArray = imageCompressionWithRanks(fileName, rankArray,outputFileName)
% function that takes in an input file name, an array of SVD rank ap-
% proximations, and an output file name. And save that in the same
% location.
A = imread(fileName);
info = imfinfo(fileName);
L = length(rankArray);
if rem(L,2) == 1
    L = L + 1;
    vcvc = 0
end
m = L/2 + 1
figure
subplot(m,2,1);
imshow(fileName)
title('Original')
for i= 1:length(rankArray)
    if info.ColorType == 'grayscale'
        G = double(A(:,:,1));
        [U,S,V] = svds(G,rankArray(i));
        Gray = uint8(U * S * transpose(V));
        OutputImage(:,:,1) = Gray;
        imageArray = OutputImage;
    else
        R = double(A(:,:,1));
        G = double(A(:,:,2));
        B = double(A(:,:,3));

        [U,S,V] = svds(R,rankArray(i));
        Red = uint8(U * S * V.');

        [U,S,V] = svds(G,rankArray(i));
        Green = uint8(U * S * V.');

        [U,S,V] = svds(B,rankArray(i));
        Blue = uint8(U * S * V.');

        OutputImage(:,:,1) = Red;
        OutputImage(:,:,2) = Green;
        OutputImage(:,:,3) = Blue;

        imageArray = OutputImage;
    end
    subplot(m,2,i+1);
    imshow(imageArray)
    title(strcat('Rank:', num2str(rankArray(i))))
end
fig = gcf;
saveas(fig, outputFileName);
end
