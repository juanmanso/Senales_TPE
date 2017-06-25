function [salida] = ajustar_duracion(entrada, Fs, incremento)
    
    l_entrada=length(entrada);
    entrada_duracion = l_entrada/Fs;
    
    % Encuentro la F0
    c=rceps(entrada);
    [pk,l_periodo]=max(c(Fs/500:Fs/100));

    f0=1/(1/500+l_periodo/Fs);

    maxs=[];
    l_ventana = floor(2/f0 * Fs);
    T0 = 1/f0;
    ventana = hanning(l_ventana);
    cantidad_ciclos = round((l_entrada - l_periodo)*f0/Fs)+1;
    %maximos = 0;
    for j = 1:cantidad_ciclos
        if j > 1
            lim_inf = floor(maxs(j - 1) + T0 * Fs/2);
            lim_sup = floor(maxs(j - 1)  + T0 * Fs*3/2);
        else
            lim_inf = 1;
            lim_sup = T0 * Fs;
        end
        if lim_sup > l_entrada
            lim_sup = l_entrada;
        end
        if lim_sup < lim_inf
            break;
        end
        maxs = [maxs (find(entrada(lim_inf:lim_sup) == max(entrada(lim_inf:lim_sup)), 1) + lim_inf)];
    end
    
    cantidad_ciclos = length(maxs);
    ciclos = zeros(cantidad_ciclos, l_ventana);
    
    for j = 1:cantidad_ciclos
        lim_inf = floor(maxs(j) - l_ventana/2 + 1);
        lim_sup = floor(maxs(j) + l_ventana/2);
        if lim_inf <= 0
            lim_inf = 1;
        end
        if lim_sup > l_entrada
            lim_sup = l_entrada;
        end
        ciclos(j, 1:lim_sup - lim_inf + 1) = ventana(1:lim_sup - lim_inf + 1) .* entrada(lim_inf:lim_sup);
    end
    
    l_salida = floor(l_entrada + l_entrada * incremento);
    
    salida = zeros(l_salida, 1);
    
    if l_salida > length(ciclos(1, :))
        salida(1:length(ciclos(1, :))) = salida(1:length(ciclos(1, :))) + ciclos(1, :)';
    else
        salida(:) = salida(:) + ciclos(1, 1:l_salida)';
    end

    lim_inf = 1;
    lim_sup = 1;
    j = 2;
    while lim_sup < length(salida)
        lim_inf = floor(maxs(1) + (j - 1) * T0 * Fs - l_ventana/2 + 1);
        lim_sup = lim_inf + l_ventana - 1;
        if lim_inf <= 0
            lim_inf = 1;
        end
        if lim_sup > length(salida)
            lim_sup = length(salida);
        end
        indice_ciclos = (j > length(ciclos(:, 1))) * (length(ciclos(:, 1)) - 1) + (j <= length(ciclos(:, 1))) * j;
        salida(lim_inf:lim_sup) = salida(lim_inf:lim_sup) + ciclos(indice_ciclos, 1:lim_sup - lim_inf + 1)';
        j = j + 1;
    end


end

