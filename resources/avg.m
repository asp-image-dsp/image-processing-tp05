%Image averaging function

im1 = imread('I6o1.JPG');
im2 = imread('I6o2.JPG');
im3 = imread('I6o3.JPG');
im4 = imread('I6o4.JPG');
im5 = imread('I6o5.JPG');
im6 = imread('I6o6.JPG');
im = double(im1) + double(im2) + double(im3) + double(im4) + double(im5) + double(im6);
im = uint8(round(im./6));
imwrite(im,'I6o.JPG');




