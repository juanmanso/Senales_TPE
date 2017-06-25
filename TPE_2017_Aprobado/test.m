close all;
clear all;


%%
%%% PRINCIPIO PRUEBAS %%%
Fs=16e3;
largo=Fs*40;
f0=1000;
f1=40;
l_ventana=(Fs)/25;
ejes=[1800 2100 -1.5 1.5];
ejes2=ejes;%[1800/4-200 2100/3+100 -1.5 1.5];

t=linspace(0,40,Fs*40);
x=sin(2*pi*f0.*t).*cos(2*pi*f1.*t);
%x(end/2+192:end)=x(end/2+192:end)+sin(2*pi*f0*13.*t(end/2+192:end));

figure
plot(x);
axis(ejes);



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
    axis(ejes2);
    

figure
specgram(doble_audio_spec,n_fft,Fs,ventana,step);
title('Espectograma - Interpolacion de la matriz S');
xlabel('Tiempo [s]','Interpreter','latex');
ylabel('Frecuencia [Hz]','Interpreter','latex');
colorbar('peer',gca);
%close

