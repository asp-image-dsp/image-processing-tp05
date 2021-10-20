function [restored_my_image, GH, ZK] = restore(blur_kernnel,degraded_my_image,noise,my_image)

%%%%%%%%%%%%%%%%%%%%%R E S T O R A T I O N %%%%%%%%%%%%%%%%%%%%%



H = fft2c(blur_kernnel);
fft_degraded_my_image = fft2c(degraded_my_image); %% imagen de entrada al restaurador
deapo=std2(noise)/std2(my_image);   %%%%%posta !!!!!!!!!!!!!!!!!!!
%deapo = mean(mean(abs(H.*conj(H))));
restored_my_image = abs(ifft2c((fft_degraded_my_image.*conj(H))./(H.*conj(H)+deapo)));

global Snn_Sxx_dB_wien
Snn_Sxx_dB_wien=10*log10(deapo)


