clc;clear;close all;
img=imread('../Pictures/terrace.jpg');
result = myResize(img,0.5);

figure;
imshow(result/255);%colormap(gray);

function [ret_Image] = myResize(img,scale)
    if length(size(img)) == 3
        img = rgb2gray(img);
        [rows,columns] = size(img);
    
    else 
        [rows,columns] = size(img);
    end    
    
    ret_Image = zeros(floor(rows*scale),floor(columns*scale));
    i = 1;
    for x = 1 : 1/scale : rows
    j = 1;
        for y = 1 : 1/scale : columns
            ret_Image(i,j) = img(x,y);
            j = j + 1;
        end
    i = i + 1;
    end
end