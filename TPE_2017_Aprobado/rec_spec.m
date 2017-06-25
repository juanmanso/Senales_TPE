% La función rec_spec se encarga de reconstruir la señal a partir del
% vector S y el overlap utilizado. 

function [output] = rec_spec(S, ventana, noverlap)

    window=ventana';

% Como el specgram va de 0 a Fs/2 y el ifft va de 0 a Fs, entonces hay que
% "rellenar" el S del specgram con el espejo conjugado.
    s0 = [S; flipud(conj(S(2:end-1,:)))];
    
% Se pasa al dominio del tiempo
    aux=real(ifft(s0))';

% Lo que sale de la ifft es una matriz de vectores, donde estos últimos son
% las ventanas. Por lo tanto hay que concatenar las ventanas para tener la
% original. 
    output=aux(1,:)./window;

    l0=size(aux);
    rows=l0(1);
% Se observa que, a partir del overlap presente, se deben excluir los
% primeros noverlap elementos de las siguientes ventanas.
    if(rows>1)
        for x=1:(rows-1)
            nuevo=aux(x+1,noverlap+1:end)./window(noverlap+1:end);
            output=[output nuevo];
        end
    end
    
    
end
    