% La función rec_spec se encarga de reconstruir la señal a partir del
% vector S y el overlap utilizado. 

function [output] = rec_spec2(S, ventana, noverlap, nfft)

    window=ventana';
    dif_win_nfft=nfft-length(window);

% Como el specgram va de 0 a Fs/2 y el ifft va de 0 a Fs, entonces hay que
% "rellenar" el S del specgram con el espejo conjugado.
    s0 = [S; flipud(conj(S(2:end-1,:)))];
    
% Se pasa al dominio del tiempo
    aux=real(ifft(s0))';

% Lo que sale de la ifft es una matriz de vectores, donde estos últimos son
% las ventanas. Por lo tanto hay que concatenar las ventanas para tener la
% original. 
    if(nfft~=any(length(window)))
       aux=aux(:,1:end-dif_win_nfft);
    end
    output=aux(1,:)./window;

    l0=size(aux);
    rows=l0(1);
% Se observa que, a partir del overlap presente, se deben excluir los
% primeros noverlap elementos de las siguientes ventanas.
    if(rows>1)
        for x=1:(rows-1)
            if(rem(x,2))    % Si es par, es la copiada
                concat=aux(x+1,noverlap+1:end)./window(noverlap+1:end);
            else            % Si es impar, es una nueva
                concat=aux(x+1,noverlap+1:end)./window(noverlap+1:end);
            end
            % Chequeo que la derivada y la señal sean continuas
            for y=1:(length(concat)-1)

                if(-.1<=(concat(y)-output(end))/output(end) && (concat(y)-output(end))/output(end)<=0.1)
                    checkeo=(concat(y+1)-concat(y))/(output(end)-output(end-1));
                    if(0.9<=checkeo && checkeo<=1.1)
                        concat=[concat(y:end)];
                        y
                        break;
                    end
                end
            end
%            if(x+2>rows)    % Si pasa esto, ya no hay más para concatenar
                output=[output concat];
%            else
%              output=[output concat aux(x+2,noverlap+22:end)./window(noverlap+22:end)];
%            end
        end
    end
    
    
end
    