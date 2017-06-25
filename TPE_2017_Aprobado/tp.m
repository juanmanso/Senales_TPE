%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trabajo práctico especial de Señales y Sistemas. 1er Cuatrimestre 2017
% Autor: Juan Manso
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Configuración previa al desarrollo del TP

close all;
clear all;
addpath('Filtros');



% 1=40, 2=85, 3=140, 4=210, 5=260, 6=300, 7=350
ej_selec=5;
bool_write=0;

[audio_input,Fs] = audioread('Audio.wav');
Ts = 1/Fs;

l_audio = length(audio_input);

% Gráfico previo de la señal entrante para análisis previo
figure
a=linspace(0,l_audio/Fs,l_audio);
plot(a,audio_input)

%set_graph('plot',['Tiempo [\si{\s}]'],['Amplitud'],['Señal a analizar'],'NorthWest',[0 40 -1.3 1.3],0);

if(ej_selec==0)
    return;
else
    close all;
end


%% Ejercicio 1
% Espectograma de banda ancha y angosta. Explicar parámetros


% Ancho (Buena definición en frecuencia)
% Si requiero definición en frecuencia, las ventanas tienen que ser
% grandes. l_ventana = t_ventana*Fs => 1/t = Fs/l_ventana = f.
% ==>> intervalo_f = 0.5 Hz = Fs/l_ventana =>
l_ventana=Fs*2;
ventana=hamming(l_ventana);
overlap=round(l_ventana/3);
n_fft=2^nextpow2(l_ventana);
step=overlap;

figure
%[S,f,t]=specgram(audio_input,n_fft,Fs,ventana,step);
specgram(audio_input,n_fft,Fs,ventana,step)
title('Espectograma de banda ancha (Ejercicio 1a)')
xlabel('Tiempo [s]','Interpreter','latex');
ylabel('Frecuencia [Hz]','Interpreter','latex');




% Angosto (Buena definición en tiempo)
% Los pulsos más cortos, según el gráfico, suelen ser del orden de 0.2 s.
% Por lo tanto, t_ventana=0.2 => l_ventana = 0.2 * Fs.
% Se propone tener 10 ventanas por cada "pulso" => l_ventana = 0.2*Fs/10.
l_ventana=Fs/50;
ventana=hamming(l_ventana);
overlap=round(l_ventana/3);
n_fft=2^nextpow2(l_ventana);
step=overlap;

figure
[S,f,t]=specgram(audio_input,n_fft,Fs,ventana,step);
specgram(audio_input,n_fft,Fs,ventana,step);
title('Espectograma de banda angosta (Ejercicio 1b)')
xlabel('Tiempo [s]','Interpreter','latex');
ylabel('Frecuencia [Hz]','Interpreter','latex');

if(ej_selec==1)
    return;
else
    close all;
end

%% Ejercicio 2
% Espectograma que permita visualizar mejor tiempo-frecuencia,
% y determinar los valores de las frecuencias de la tabla.

% Tabla: primer col, 4to armónico; segunda, 5to; tercera, nota
tabla_notas_4_arm=[523, 554, 587, 622, 659, 698, 740, 784, 831, 880, 932, 988];
tabla_notas_5_arm=[1046, 1108, 1174, 1244, 1318, 1386, 1480, 1568, 1662, 1760, 1864, 1976];
tabla_notas_label=['C ';'C#';'D ';'D#';'E ';'F ';'F#';'G ';'G#';'A ';'A#';'B '];


% Configuración del specgram:
% Se requiere diferenciar frecuencias con un mínimo de 554-523 de
% resolución. En tiempo, la mínima resolución tendría que ser la duración
% de las notas (0.2s). => 31*Fs > l_ventana > 0.2*Fs
l_ventana=Fs/10;
ventana=hamming(l_ventana);
overlap=round(l_ventana/3);
n_fft=2^nextpow2(l_ventana);
step=overlap;

figure
[S,f,t]=specgram(audio_input,n_fft,Fs,ventana,step);
specgram(audio_input,n_fft,Fs,ventana,step);
title('Espectograma relacion tiempo/frec (Ejercicio 2)')
xlabel('Tiempo [s]','Interpreter','latex');
ylabel('Frecuencia [Hz]','Interpreter','latex');

%axis([t(1) t(end) 0 2000])

%S=abs(S);

% Aproximo los valores de la muestra que representan las frecuencias de las
% tablas.
% Como el specgram tiene 0<f<Fs/2 => entre muestras hay Fs/2/length(f) Hz.
% El +1 es porque para referenciar al vector se hace desde 1 [f(1)=0].
n_notas_4_arm=round(tabla_notas_4_arm./(Fs/2/length(f)))+1;
n_notas_5_arm=round(tabla_notas_5_arm./(Fs/2/length(f)))+1;
n=[n_notas_4_arm n_notas_5_arm];
tab_f=[tabla_notas_4_arm tabla_notas_5_arm];

diferencia_f=1:length(tab_f);
diferencia_f(:)=abs(f(n(:))-tab_f(:));
error_f=max(diferencia_f);
% Ok, están bastante cerca los valores de frec. (error<5 Hz ~ 20%).

if(ej_selec==2)
    return;
else
    close all;
end

%%  Ejercicio 3
% Hay que duplicar la duración del audio por interpolación. Es decir, entre
% las muestras que hay del archivo, se une con una recta (se pone el valor
% medio).

doble_audio = linspace(0,1,length(audio_input)*2).*0;
doble_audio(1:2:end) = audio_input;

% Interpolación con bucle
y=1;
while(y<=(length(audio_input)-1))
    doble_audio(2*y)=(audio_input(y+1)-audio_input(y))/2+audio_input(y);    
    y=y+1;
end

% Interpolación matricial
%    doble_audio(2:2:end-1)=(audio_input(2:end)-audio_input(1:end-1))/2+audio_input(1:end-1);



% Al comprimir hay que eliminar las altas frecuencias "parásitas" que
% aparecen.

aux=fft(doble_audio);
l=round(length(aux)/4);
aux(l:end)=0;
%aux=[aux fliplr(conj(aux))];
doble_audio_fil=ifft(aux,'symmetric');
doble_audio_fil=doble_audio_fil./max(doble_audio_fil);


% Espectograma con las mismas características que el Ej2

l_ventana=Fs/10;
ventana=hamming(l_ventana);
overlap=round(l_ventana/3);
n_fft=2^nextpow2(l_ventana);
step=overlap;

figure
specgram(doble_audio,n_fft,Fs*2,ventana,step);
title('Espectograma - Interpolación del audio')
xlabel('Tiempo [s]','Interpreter','latex');
ylabel('Frecuencia [Hz]','Interpreter','latex');
colorbar('peer',gca);

% Para comparar:
figure
specgram(doble_audio_fil,n_fft,Fs*2,ventana,step);
title('Espectograma - Interpolación del audio con filtrado posterior')
xlabel('Tiempo [s]','Interpreter','latex');
ylabel('Frecuencia [Hz]','Interpreter','latex');
colorbar('peer',gca);


if(bool_write)
audiowrite('.\Audios\ej3_audio.wav',doble_audio,Fs);
audiowrite('.\Audios\ej3_audio_2fs.wav',doble_audio,2*Fs);
audiowrite('.\Audios\ej3_audio_filtrado.wav',doble_audio_fil,Fs);
audiowrite('.\Audios\ej3_audio_filtrado_2fs.wav',doble_audio_fil,Fs*2);
end

if(ej_selec==3)
    return;
else
    close all;
end

%% Ejercicio 4
% Hay que reducir a la mitad la duración del audio. Para eso, hay que
% decimar. Se recuerda que cuando se decima una señal discreta que fue
% muestreada, al comprimir el espectro, la señal útil queda entre -pi/N y
% pi/N (en vez de -pi,pi). Todo lo demás tendrá aliasing al pasar por el
% DAC. Por ende, como se pretende decimar por 2, se aplica un pasabajos
% ideal entre -pi/2,pi/2 (o en frecuencia -Fs/4,Fs/4). Como fft() da los
% valores entre 0 y 2pi, sólo se elimina de pi/2 hasta 2pi.
mitad_audio=linspace(0,1,round(length(audio_input)/2));
mitad_audio_aux=audio_input;


% Pasaje a frecuencia
NFFT=2^nextpow2(length(mitad_audio_aux));
fft_mitad=fft(mitad_audio_aux,NFFT);%/length(mitad_audio);
% Se divide por length() por la diferencia entre los coeficientes y la DFT.


% Frecuencias menores y mayores a |Fs/4| ==> =0
fft_mitad(fix(length(fft_mitad)/4)+1:end)=zeros(1,fix(3*length(fft_mitad)/4));

% Reconstrucción
mitad_audio_aux=ifft((fft_mitad),'symmetric');

% Decimación.
mitad_audio=mitad_audio_aux(1:2:end-1);
mitad_audio=mitad_audio(1:round(length(audio_input)/2));
mitad_audio=mitad_audio/max(mitad_audio);

% Espectograma

l_ventana=Fs/10;
ventana=hamming(l_ventana);
overlap=round(l_ventana/3);
n_fft=2^nextpow2(l_ventana);
step=overlap;

figure
specgram(mitad_audio,n_fft,Fs,ventana,step);
title('Espectograma - Decimación señal')
xlabel('Tiempo [s]','Interpreter','latex');
ylabel('Frecuencia [Hz]','Interpreter','latex');
colorbar('peer',gca);

% Para comparar
figure
specgram(mitad_audio,n_fft,Fs/2,ventana,step);
xlabel('Tiempo [s]','Interpreter','latex');
ylabel('Frecuencia [Hz]','Interpreter','latex');
colorbar('peer',gca);

if(bool_write)
audiowrite('.\Audios\ej4_audio.wav',mitad_audio,Fs);
audiowrite('.\Audios\ej4_audio_0.5_fs.wav',mitad_audio,Fs/2);
end

if(ej_selec==4)
    return;
else
    close all;
end



%% Ejercicio 5
% A partir del espectograma, reconstruir la señal.

l_ventana=Fs/25;
n_fft=2^nextpow2(l_ventana);
ventana=hamming(n_fft);
overlap=round(3);
step=overlap;

% S tiene la amplitud de la frecuencia f en el tiempo t.
% f es el arreglo de frecuencias presentes en el specgram y t tiene el
% arreglo de tiempos.


figure
    [S,f,t]=specgram(audio_input,n_fft,Fs,ventana,step);
    specgram(audio_input,n_fft,Fs,ventana,step);
close;
%[S,f,t]=spectrogram(audio_input,ventana,step,n_fft,Fs);
%spectrogram(audio_input,ventana,step,n_fft,Fs,'yaxis');


nuevo_audio=rec_spec(S,ventana,overlap);
nuevo_audio=nuevo_audio./max(nuevo_audio);

if(bool_write)
audiowrite('.\Audios\ej5_audio.wav', nuevo_audio, Fs);
end

figure
    [S0,f,t]=specgram(nuevo_audio,n_fft,Fs,ventana,step);
    specgram(nuevo_audio,n_fft,Fs,ventana,step);
    title('Espectrograma de la señal reconstruida')
xlabel('Tiempo [s]','Interpreter','latex');
ylabel('Frecuencia [Hz]','Interpreter','latex');
colorbar('peer',gca);
    

if(ej_selec==5)
    return;
else
    close all;
end

%% Ejercicio 6
% Idem ej3 pero en frecuencia

    S_doble=[S S].*0;
    S_doble(:,1:2:end-1)=S;

% Interpolación matricial

    S_doble(:,2:2:end-1)=(S(:,2:end));%+S(:,1:end-1);%.*exp(-2*pi/l_ventana);
%    S_doble(end/2:end,2:2:end-1)=(S_doble(end/2:end,2:2:end-1)+(S(end/2:end,1:end-1))).*0.3; 
    S_doble=S_doble/length(f)/2;

    
% Llamar al reconstructor de la señal por espectograma

    doble_audio_spec=rec_spec2(S_doble,ventana,overlap,n_fft);
%    doble_audio_spec=rec_spec(S_doble,ventana,overlap);
    doble_audio_spec=doble_audio_spec./max(doble_audio_spec);
    y=(doble_audio_spec);

    t0=linspace(t(1),t(end),length(doble_audio_spec));
    figure
    plot(doble_audio_spec);
    axis([1e3-5e2 1.05e3+5e2 -1.5 1.5])
    
    bool_write=01;
if(bool_write)
audiowrite('.\Audios\ej6_audio.wav', y, Fs);
end



figure
specgram(doble_audio_spec,n_fft,Fs,ventana,step);
title('Espectograma - Interpolacion de la matriz S');
xlabel('Tiempo [s]','Interpreter','latex');
ylabel('Frecuencia [Hz]','Interpreter','latex');
colorbar('peer',gca);

%figure
%specgram(doble_audio_spec,n_fft,Fs*2,ventana,step);
title('Espectograma - Interpolacion de la matriz S');
xlabel('Tiempo [s]','Interpreter','latex');
ylabel('Frecuencia [Hz]','Interpreter','latex');
colorbar('peer',gca);

if(ej_selec==6)
    return;
else
    close all;
end


%% Ejercicio 7
% Idem ej4 pero en frecuencia
    S_mitad_aux=S;
    

%%%%%% No sirve porque el espectro no se expande/comprime %%%%%%
% Frecuencias menores y mayores a |Fs/4| ==> =0
% Divido por 2 porque el specgram va de 0 a pi (o de 0 a Fs/2).
%S_mitad_aux(floor(length(f)/2):end,:)=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Decimación.
    S_mitad=S_mitad_aux(:,1:2:end-1);
    

% LLamar al reconstructor de la señal por espectograma

    mitad_audio_spec=rec_spec(S_mitad,ventana,overlap);
    mitad_audio_spec=mitad_audio_spec(2:end)./max(mitad_audio_spec);

if(bool_write)
audiowrite('.\Audios\ej7_audio.wav', mitad_audio_spec, Fs);
end

figure
specgram(mitad_audio_spec,n_fft,Fs,ventana,step);
title('Espectograma - Decimación de la matriz S');
xlabel('Tiempo [s]','Interpreter','latex');
ylabel('Frecuencia [Hz]','Interpreter','latex');
colorbar('peer',gca);

figure
specgram(mitad_audio_spec,n_fft,Fs/2,ventana,step);
title('Espectograma - Decimación de la matriz S'); 
xlabel('Tiempo [s]','Interpreter','latex');
ylabel('Frecuencia [Hz]','Interpreter','latex');
colorbar('peer',gca);

if(ej_selec==7)
    return;
else
    close all;
end
