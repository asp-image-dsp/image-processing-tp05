function [restored_my_image, GH, ZK] = restore(blur_kernnel,degraded_my_image,noise,my_image)

%%%%%%%%%%%%%%%%%%%%%R E S T O R A T I O N %%%%%%%%%%%%%%%%%%%%%



H = fft2c(blur_kernnel);
fft_degraded_my_image = fft2c(degraded_my_image); %% imagen de entrada al restaurador

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% psd_noise=fft2(corrcoef(noise));
% psd_my_image=fft2(corrcoef(my_image));
% 
% Snn_Sxx_A=max(max(abs(psd_noise./psd_my_image)))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Snn_Sxx_B = mean(mean(abs(H.*conj(H))))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global k
persistent Snn_Sxx delsnxx

Snn_Sxx_P=std2(noise)/std2(my_image);   %%%%%posta !!!!!!!!!!!!!!!!!!!
Snn_Sxx_A=std2(noise)/std2(degraded_my_image-my_image);   

%selector

%Snn_Sxx=Snn_Sxx_A; 
%%%%Snn_Sxx= 0.000001; %Esto simula un cero en h
%Snn_Sxx= .3509; %ok gauss
%Snn_Sxx= 12; %ok rect SNR= 10      mayor al aumentar el ruido

%********************************
%Sxx_Snn_dB=-2 ; %TESTING Fijo EStimado ok SNR=30 PSF gauss

Sxx_Snn_dB= 30; %TESTING Fijo SNR 30 kopt 12 Psf gauss

Sxx_Snn_dB=2.7 ; %TESTING Fijo SNR 20 kopt 12 PSF gauss

Sxx_Snn_dB=15 ; %TESTING Fijo SNR 10 / Sxx_nn= 15 FC=18..


%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
FC=18 %correction
Sxx_Snn_dB=Sxx_Snn_dB-FC;
Snn_Sxx=10^(-Sxx_Snn_dB/10);  % le pongo '-' porque quiero "pensar" en terminos de Sxx_Snn
%*********************************

restored_my_image = abs(ifft2c((fft_degraded_my_image.*conj(H))./(H.*conj(H)+Snn_Sxx)));

GH = max (max (abs  (  (H.*conj(H))./(H.*conj(H)+Snn_Sxx) )));

GH=max(max(abs(GH)));
ZK=(k+1)*(GH)^k;

Snn_Sxx_dB=10*log10(Snn_Sxx);

Ck= max(max(abs( H.*conj(H))))*(exp(1/(1+k))-1);
Ck_dB=10*log10(Ck);

disp('[ C_dB   Snn_Sxx_dB  GH  ZK]')

[ Ck_dB   Snn_Sxx_dB  GH  ZK]


