function y = filtro_fdatool(x)
%FILTRO_FDATOOL Filters input x and returns output y.

% MATLAB Code
% Generated by MATLAB(R) 8.5 and the DSP System Toolbox 9.0.
% Generated on: 28-Nov-2016 23:30:12

persistent Hd;

if isempty(Hd)
    
    % IIR Notching filter designed using the IIRNOTCH function.
    
    % All frequency values are in Hz.
    Fs = 16000;  % Sampling Frequency
    
    Fnotch = 200;  % Notch Frequency
    Q      = 30;   % Q-factor
    Apass  = 30;   % Bandwidth Attenuation
    
    BW = Fnotch/Q;
    
    % Calculate the coefficients using the IIRNOTCHPEAK function.
    [b, a] = iirnotch(Fnotch/(Fs/2), BW/(Fs/2), Apass);Hd = dsp.IIRFilter( ...
        'Structure', 'Direct form II', ...
        'Numerator', b, ...
        'Denominator', a);
end

y = step(Hd,x);


% [EOF]
