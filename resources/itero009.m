%Restauracion de imagenes - Ejemplo 

flag=0;

% Blurred + Noised for testing refocusing algorithm.
close all
clear all;
clf;
%%%%%%%%%%%%%%%%%%%%%% SET UP AREA %%%%%%%%%%%%%%%%%%%%%%%%
%degradation parameters


SNR_dB=20;                 % Real Signal to noise ratio 

kmax=8;                    %nr of iterations

%######################## Leo Imagen ####################################

load lenna;
my_image = double(lenna)/256;

%############## Elimino color ##########################################

bw_my_image(:,:) = my_image(:,:,1);     %% Solo me quedo con la informacion  de grises
imsize = size(bw_my_image);                  %Determino el  tamanio de la imagen original

%######################## Blurred Image =  H(w) * IMAGE(w) #############################################

% Convoluciono la imagen con la PSF (OTF) el dominio de la frecuencia y posteriormente antitransformo.
  
[blurred_my_image,blur_kernnel] = degrado(bw_my_image); % 1st call
 
%#############################  N O I S E  #############################################

sigma_burrled_image=std2(blurred_my_image);             % Encuentro la desviacion std de mi imagen
sigma_noise=sqrt((sigma_burrled_image)^2*10^(-SNR_dB/10));  % y junto con la SNR saco la desviacion std del ruido (el '-' es porque al aumentar SNR quiero que baje el ruido
noise=my_random(0,sigma_noise,imsize(1),imsize(2));               % para luego generar el ruido  
degraded_my_image = blurred_my_image  + noise;      % Senial mas ruido !!!

%########################Show original###################################################

%%%%%%%%%%%%%%%%%%%%%%%%%%%%degraded_my_image=bw_my_image; %jumper ojo!!!!!!!!!!!!!!!!
figure(1) 
subplot(2,3,1)
imshow(bw_my_image,[]);
xlabel('Original image')

figure(1) 
subplot(2,3,2)
imshow(blurred_my_image,[]);
xlabel('Burrled image')%%%%%%%%%%%%%%%%%%%%%%%% Imagen distorsionada mas ruido %%%%%%%%%%%%%%%%%%%
blurred_my_image_0=blurred_my_image; 

figure(1)
subplot(2,3,3)
imshow(degraded_my_image,[]);  
xlabel('Blurred and noised image')

degraded_my_image_0=degraded_my_image; 




%%.#################### W I E N E R ######################################
restored_my_image_wien=restorewien(blur_kernnel,degraded_my_image,noise,bw_my_image);
std_err_Restored_wien= my_std2(restored_my_image_wien - bw_my_image);
std_err_Degraded_wien= my_std2(degraded_my_image_0 - bw_my_image);
figure(2)
subplot(2,1,1)
imshow(restored_my_image_wien,[]);  
xlabel (sprintf('Restored wien Stderr: %0.5f',std_err_Restored_wien))
global Snn_Sxx_dB_wien
%%...........................
%##############################Let's iterate###########################

global k
for k=1:kmax
 %   k
blurred_my_image = degrado(degraded_my_image); 
restored_my_image=restore(blur_kernnel,blurred_my_image,noise,bw_my_image);
degraded_my_image=restored_my_image;

[restored_my_image, my_GH, my_ZK ]=restore(blur_kernnel,restored_my_image,noise,bw_my_image);
%%%%%imshow(defocused_my_image,[0 defocused_my_image(s(1),s(2))]); %%%ponja
figure(1)
subplot(2,3,4)
imshow(restored_my_image,[]);
xlabel (sprintf('Restored  k=%d',k))


drawnow
%disp (k)
% pause
%%%%%end
%#####################################################################


 % Mediciones



%SNR_improvement=10*log10(nmse(bw_my_image,degraded_my_image_0)/nmse(bw_my_image,restored_my_image)) % JAE S LIM pag 529
%SNR_R=10*log10(std2(restored_my_image)^2/std2(noise)^2)
%SNR_D=10*log10(std2(degraded_my_image_0)^2/std2(noise)^2)

% 
% diff = abs(restored_my_image - bw_my_image);
% diffsqr = diff'*diff;
% meandiffsqr = mean(mean(diffsqr));
% %SNR_restored_original = 10*log10(max(max(bw_my_image))/meandiffsqr)

%%%%%%%%%% STDDEV err ***********************
std_err_Restored= my_std2(restored_my_image - bw_my_image);
std_err_Degraded= my_std2(degraded_my_image_0 - bw_my_image);


%%%%%%%%%  ISNR ************************
diff_fg=bw_my_image-degraded_my_image_0;
diff_fr=bw_my_image-restored_my_image;
ISNR=10*log10(sum(diff_fg.^2)/sum(diff_fr.^2));



sumad=sum(sum(degraded_my_image_0-mean2(degraded_my_image_0)));
NM=imsize(1)*imsize(2);
BSNR=10*log10( (1/NM) * (sumad.^2)/ (std2(noise)^2) );


disp('      k      deg        res      ISNR     ')
merit=[k std_err_Degraded std_err_Restored ISNR  ]%%%my_GH  ]%my_ZK]

pause
figure(1)
subplot(2,3,5)
hold on
%plot(k,my_ZK,'rx');
plot(k,std_err_Restored,'gx');
figure(1)
%xlabel (sprintf('Std err Res:%0.5f  Std err Degr %0.5f',std_err_Restored , std_err_Degraded))
xlabel (sprintf('stderr RES: %0.5f',std_err_Restored))
%AXIs([0 kmax .1 .2])
%%%%my_GH

figure(1)
subplot(2,3,6)
hold on
%plot(k,my_ZK,'rx');
plot(k,ISNR,'rx');

%xlabel (sprintf('Std err Res:%0.5f  Std err Degr %0.5f',std_err_Restored , std_err_Degraded))
xlabel (sprintf('ISNR: %0.5f',ISNR))
%AXIs([0 kmax .1 .2])
%%%%my_GH


%%%% Copmpare w/wien
figure(2)
subplot(2,1,2)
imshow(restored_my_image,[]);  
xlabel (sprintf('Restored Stderr: %0.5f',std_err_Restored))
end  %iterate loop

% figure
% set (gcf,'Name','Original')
% imshow(bw_my_image,[]);
% figure
% set (gcf,'Name','Blurred')
% imshow(blurred_my_image_0,[]);
% figure
% set (gcf,'Name','Blurred + Noise')
% imshow(degraded_my_image_0,[]);
% figure
% set (gcf,'Name','Restored')
% imshow(restored_my_image,[]);

Snn_Sxx_dB_wien