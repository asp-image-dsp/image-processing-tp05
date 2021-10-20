%#######################  P S F ' s  ###############################################

function [image_out,blur_kernnel]=degrado(image_in)

% ######################### My LOW PASS ################################################

% Creamos el nucleo de degradacion (Degradation kernel)
de_pix = 10;

for x = 1:(de_pix*2+1)
	for y = 1:(de_pix*2+1)
		if ((x-de_pix-1)^2+(y-de_pix-1)^2 <= de_pix*2);
			kernnel(x,y) = 1;
		else 
			kernnel(x,y) = 0;		
		end
	end
end

% Creamos una imagen del mismo tamanio de la imagen original para poder operar con la FFT.

imsize = size(image_in);                  %Determino el  tamanio de la imagen original
rect_kernnel = zeros(imsize);                %La pongo en cero y le copio el Kernel . Esto es la PSF 
rect_kernnel(round(imsize(1)/2)-de_pix:round(imsize(1)/2)+de_pix,round(imsize(2)/2)-de_pix:round(imsize(2)/2)+de_pix) = kernnel;

%################################## Low pass Filters #######################

lpass0=    [0  0  0;
           0  1  0;
           0  0  0];

lpass1=1/9*[1  1  1;
           1  1  1;
           1  1  1];
       
lpass2=1/5*[1/2  1/2  1/2;
           1/2  1    1/2;
           1/2  1/2  1/2];
       
lpass3=1/16*[1  1  1;
            1  8  1;
            1  1  1];
       
lpass4=1/12*[1  1  1;
            1  4  1;
            1  1  1];
 
hpass1=1/12*[-1  -1  -1;
            -1  4  -1;
            -1  -1  -1];
             

h_Low_Pass=zeros(imsize);
h_Low_Pass(ceil(imsize(1)/2)-1:ceil(imsize(1)/2)+1,ceil(imsize(2)/2)-1:ceil(imsize(2)/2)+1)=lpass4;


%################### Gausian PSF #############################
gks= 70;
%%%%gks = 80;
gk = gausswin(max(imsize),gks);
gauss_kernnel = gk*gk';
gauss_kernnel = gauss_kernnel(round((max(imsize)-imsize(1))/2)+1:round((max(imsize)-imsize(1))/2)+imsize(1),round((max(imsize)-imsize(2))/2)+1:round((max(imsize)-imsize(2))/2)+imsize(2));


%################### PSF Selector  ###########################################

blur_kernnel=gauss_kernnel;

%######################## Blurred Image =  H(w) * IMAGE(w) #############################################

% Convoluciono la imagen con la PSF (OTF) el dominio de la frecuencia y posteriormente antitransformo.
 image_out = abs(ifft2c(fft2c(image_in).*fft2c(blur_kernnel)));

