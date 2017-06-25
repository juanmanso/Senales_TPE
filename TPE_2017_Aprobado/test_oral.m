close all;
clear all;


%%
%%% PRINCIPIO PRUEBAS %%%
Fs=8000;   %8k
tiempo=1; %0.1 segundos
largo=Fs*tiempo;
f0=250;    %250
f1=260;      %260
l_ventana=(Fs)/25;
ejes=[230 270 0 5e3];
%ejes2=ejes;%[1800/4-200 2100/3+100 -1.5 1.5];

t=linspace(0,tiempo,largo);
x=sin(2*pi*f0.*t)+sin(2*pi*f1.*t);
%x(end/2+192:end)=x(end/2+192:end)+sin(2*pi*f0*13.*t(end/2+192:end));

%figure
%plot(x);


NFFT=2^(nextpow2(length(x))+5);
x_fft=fft(x,NFFT);
figure
plot(linspace(0,Fs,length(x_fft)),abs(x_fft));
axis(ejes);

figure
plot(linspace(0,Fs,length(x_fft)),abs(x_fft));
return;


n_fft=2^(nextpow2(l_ventana));
ventana=hamming(n_fft);
overlap=round(3);
step=overlap;

figure
[S,f,t]=specgram(x,n_fft,Fs,ventana,overlap);
specgram(x,n_fft,Fs,ventana,overlap);
colorbar('peer',gca);
%close

%%% FIN PRUEBAS %%%

audio_spec=rec_spec(S,ventana,overlap);

figure
specgram(audio_spec,n_fft,Fs,ventana,step);
colorbar('peer',gca);

if(0)
    S_doble=[S S].*0;
    S_doble(:,1:2:end-1)=S;

% Interpolación matricial
    S_doble(:,2:2:end-1)=(S(:,2:end));%+S(:,1:end-1))/2;
    
%    S_doble=S_doble./(length(f)*2);
    


% Llamar al reconstructor de la señal por espectograma

    doble_audio_spec=rec_spec2(S_doble,ventana,overlap,n_fft);
%    doble_audio_spec=rec_spec(S_doble,ventana,overlap);
%    doble_audio_spec=doble_audio_spec./max(doble_audio_spec);
    y=(doble_audio_spec);

    t1=linspace(t(1),t(end),length(doble_audio_spec));
    t0=[t;t];
    t0(1:2:end-1)=t; t0(2:2:end-1)=(t(2:end)+t(1:end-1))/2;
    figure
    plot(doble_audio_spec);
%    axis(ejes2);
end    

return;
figure
specgram(doble_audio_spec,n_fft,Fs,ventana,step);
title('Espectograma - Interpolacion de la matriz S');
xlabel('Tiempo [s]','Interpreter','latex');
ylabel('Frecuencia [Hz]','Interpreter','latex');
colorbar('peer',gca);
%close

