% TP de Señales y Sistemas
close all;
clear all;

graphics_toolkit('gnuplot');

% Macros

F0=200;
TP=0.4/F0;
TN=0.16/F0;
P0=1;

bool_print=0;
bool_graph=0;

print_color="-color";	% Si quiere imprimirse color, -color. Si no, -mono
format_out_name=".tex";			% Configuro el formato de impresión
format_print_config="-depslatex";	% Idem
print_path="./";		% Ruta de salida

% Arreglos
[y, Fs]= wavread('hh2.wav');



%%% Ejercicio 1 %%%

% Etiquetado de los fonemas
% Alzó la voz para ahuyentar a los perros
% Formato: fonema_letra=[principio, fin]
%# Comentario: n* de muestra = tiempo * Fs;#

limites_fonemas=[0.864, 0.974, 1.131, 1.298, 1.398, 1.471, 1.578, 1.696, 1.835, 2.007, 2.023, 2.090, 2.125, 2.224, 2.365, 2.460, 2.534, 2.611, 2.727, 2.807, 2.946, 2.973, 3.054, 3.115, 3.159, 3.332, 3.358, 3.462, 3.638, 3.729, 3.920] .*Fs;
fonema_string=['a';'l';'Z';'o';'l';'a';'v';'o';'s';'p';'a';'r';'a';'a';'h';'u';'y';'e';'n';'t';'a';'r';'a';'l';'o';'s';'p';'e';'R';'o';'s'];

% Gráfico de la señal
if(bool_graph)
figure(1)
    hold on
    plot((1:length(y))./Fs,y,'b')
    i=1;
% Gráfico de los límites de los fonemas
    while(i<=length(limites_fonemas))
	    line([limites_fonemas(i), limites_fonemas(i)]./Fs, get(gca, 'ylim'), 'LineStyle','-.', 'Color','r');
    			if(i!=1)
				text((limites_fonemas(i-1)+limites_fonemas(i))/2, -0.55,fonema_string(i));
			end	
	    i=i+1;
    end
    xlabel('Tiempo[s]')
    ylabel('Amplitud')
    title('Gráfico de la señal segmentada')
    axis([limites_fonemas(1)/Fs-0.1, limites_fonemas(end)/Fs+0.1, -0.8, 0.6]);


if(0)
if(bool_print)
	print([print_path,'Ejercicio_1',format_out_name],format_print_config, print_color);
endif	
end
end



%%% Ejercicio 2 %%%
% En este caso, se toma el segmento 'fonema_a6=[2.807, 2.946].*Fs'
% que representa la última 'A' de la palabra 'AHUYENTAR'. Se eligió
% este segmento dado a que está bien separado de los otros fonemas.

% Por inspección utilizando el WAVESURFER, se aproxima que el periodo
% del fono 'A' está entre los 6 y 7 segundos.

% Declaración de los 5 periodos a examinar
seg_a_1=[2.843*Fs:2.849*Fs];     
seg_a_2=[2.855*Fs:2.861*Fs];     
seg_a_3=[2.873*Fs:2.879*Fs];
seg_a_4=[2.890*Fs:2.896*Fs];
seg_a_5=[2.917*Fs:2.923*Fs];

if(bool_graph)
figure(2)
    hold on
    plot((limites_fonemas(20):limites_fonemas(21))./Fs,y((2.807*Fs:2.946*Fs)),'-b');
    plot(seg_a_1./Fs, y(seg_a_1), '-r');
    plot(seg_a_2./Fs, y(seg_a_2), '-c');
    plot(seg_a_3./Fs, y(seg_a_3), '-m');
    plot(seg_a_4./Fs, y(seg_a_4), '-y');
    plot(seg_a_5./Fs, y(seg_a_5), '-k');
    title('Gráfico del fono "a" (ahuyentar) con los periodos utilizados');
    legend('Fono "a"', 'Periodo 1', 'Periodo 2', 'Periodo 3', 'Periodo 4', 'Periodo 5','location','SouthWest');
    axis([limites_fonemas(20)./Fs-0.01, limites_fonemas(21)./Fs+0.01]);
if(bool_print)
	print([print_path,'graf_fono_a',format_out_name],format_print_config, print_color);
endif	
endif
    

dft_a(1,:)=fft(y(seg_a_1));
dft_a(2,:)=fft(y(seg_a_2));
dft_a(3,:)=fft(y(seg_a_3));
dft_a(4,:)=fft(y(seg_a_4));
dft_a(5,:)=fft(y(seg_a_5));

l_dft=length(dft_a(1,:));
f_plot=linspace(0,Fs/4,l_dft/2);

if(bool_graph)
figure(3)
    hold on
    stem(f_plot,abs(dft_a(1,1:48)), '-r');
    stem(f_plot,abs(dft_a(2,1:48)), '-b');
    stem(f_plot,abs(dft_a(3,1:48)), '-m');
    stem(f_plot,abs(dft_a(4,1:48)), '-g');
    stem(f_plot,abs(dft_a(5,1:48)), '-k');
    title('Respuesta en frecuencia de los periodos seleccionados del fono "a" (ahuyentar)');
    legend('Periodo 1', 'Periodo 2', 'Periodo 3', 'Periodo 4', 'Periodo 5');
    xlabel('Frecuencia [Hz]');
    ylabel('|X|');
if(bool_print)
	print([print_path,'graf_coef',format_out_name],format_print_config, print_color);
endif	
endif

%%% Inspección %%%    
% Primer pico = 85.11 Hz
% Segundo pico = 425.5 Hz
% Tercer pico = 851.1 Hz o 936.2 Hz
% Cuarto pico = 1447 Hz o 1532 Hz

%figure(90)
%    plot(abs(dft_a(1,1:48)))
%return;


% Cálculo de amplitudes de los picos máximos
%%% Comentario: harmonic(i,j) tiene el i-ésimo armónico
%%%             de la j-ésima segmentación.
rango_maximos=[1,4; 4,10; 10,15; 15,25];
i=1;
while(i<5)
    k=1;
    while(k<6)
        harmonic(i,k)= max(dft_a(k,(rango_maximos(i,1):rango_maximos(i,2))));
        k=k+1;
    end
    i=i+1;
end


%%% Ejercicio 3 %%%
% Reconstrucción de la señal temporal a partir de los coeficientes
rec_a=abs(ifft(harmonic));

% Periodizo la señal

for i=1:5
	rec_a=[rec_a rec_a];
end


% Gráfico de las síntesis
if(bool_graph)
 figure(80)
 plot(1:length(rec_a),rec_a(1,:))
 figure
 plot(1:length(rec_a),rec_a(2,:))
figure
 plot(1:length(rec_a),rec_a(3,:))
figure
 plot(1:length(rec_a),rec_a(4,:))
 figure
 plot(1:length(rec_a),sum(rec_a))
endif

% Gráfico utilizando TODOS los coeficientes
a=abs(ifft(dft_a(1,:)));

if(bool_graph)
figure
	hold on
	plot(1:length(a),a);
	plot(1:length(y(seg_a_1)),(-1).*y(seg_a_1),'r')
endif



%%% Ejercicio 5 %%%
fonema_a6=[2.807, 2.946].*Fs;
fonema_u1=[2.365, 2.460].*Fs;
fonema_o1=[1.298, 1.398].*Fs;
fonema_e2=[3.358, 3.462].*Fs;

% Acá defino las ventanas y demás 
t_ventana = 15e-3;
l_ventana = t_ventana * Fs;
ventana = hamming(l_ventana);
overlap = round(l_ventana/2);

if(bool_graph)
figure(5)
spectrogram(y(fonema_a6(1):fonema_a6(2)),ventana,overlap,[],Fs,'yaxis');
title('Fono A');

figure(6)
spectrogram(y(fonema_u1(1):fonema_u1(2)),ventana,overlap,[],Fs,'yaxis');
title('Fono U');

figure(7)
spectrogram(y(fonema_o1(1):fonema_o1(2)),ventana,overlap,[],Fs,'yaxis');
title('Fono O');

figure(8)
spectrogram(y(fonema_e2(1):fonema_e2(2)),ventana,overlap,[],Fs,'yaxis');
title('Fono E');

end
%%% Ejercicio 6 %%%
t=0:1/Fs:1/F0;
pt=P0/2*(1-cos(t./TP.*pi)).*(t<=TP) + (TP<t).*(t<=TP+TN).*P0.*cos((t-TP)./TN.*(pi/2));

% Gráfico del pulso glótico
if(bool_graph)
	figure
		hold on
		plot(t,pt)
end
% Genero el tren de pulsos de largo 10
tren_pt=pt;
for i=1:(10-1)
	tren_pt=[tren_pt pt];
endfor

if(bool_graph)
	figure
		plot(1:length(tren_pt),tren_pt);
endif

tren_pt_dft=abs(fft(tren_pt));

if(bool_graph)
	figure
		plot(tren_pt_dft)
endif



%%% Ejercicio 7 %%%
% Cargo la tabla
resonancia=[	830 1400 2890 3930;
		500 2000 3130 4150;
		330 2765 3740 4366;
		546 934 2966 3930;
	    	382 740 2760 3380];

bandwidth=[	110 160 210 230;
		80 156 190 220;
		70 130 178 200;
	    	97 130 185 240;
	    	74 150 210 180];


% Calculo los polos para cada par (resonancia,bandwidth)
p = exp(-2*pi.*bandwidth./Fs) .* exp(1j*2*pi.*resonancia./Fs);
conj_p=conj(p);

z=0:8000;
z=exp(1j*2.*pi*z./length(z));
H_z=ones(rows(p),1);

if(1)
for i=1:(rows(p)-1)
	H_z=H_z.*1./((1-p(:,i)./z).*(1-conj_p(:,i)./z));
endfor
end

%%% No entiendo lo del cálculo de coeficientes PREGUNTAR

% Gráfico de polos y ceros para cada vocal (vocal=subplot)

if(!bool_graph)
	figure

	subplot(231)	% Vocal='a'
	hold on
		zplane([],[p(1,:) conj_p(1,:)]);
		title('Polos para la vocal a');
	subplot(232)
	hold on
		zplane([],[p(2,:) conj_p(2,:)]);
		title('Polos para la vocal e');
	subplot(233)
	hold on
		zplane([],[p(3,:) conj_p(3,:)]);
		title('Polos para la vocal i');
	subplot(234)
	hold on
		zplane([],[p(4,:) conj_p(4,:)]);
		title('Polos para la vocal o');
	subplot(235)
	hold on
		zplane([],[p(5,:) conj_p(5,:)]);
		title('Polos para la vocal u');
endif



%%% Ejercicio 9 %%%

%% quefrencia utilizando cepstrum()







