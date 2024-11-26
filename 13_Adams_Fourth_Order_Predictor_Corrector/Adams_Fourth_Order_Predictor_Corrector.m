% ------------------------------------------------------------------------
% Author: Muhammet Kaan Alsancak
% email address: alsancak.mk@gmail.com 
% Date: 2024/10/22 - 19:12
% ------------------------------------------------------------------------
% Adams Dördüncü Derece Predictor-Corrector Yöntemi
clc;
clear;

% Diferansiyel denklem: y' = y - t^2 + 1
f = @(t, y) y - t^2 + 1;

% Başlangıç koşulları
t0 = 0;
y0 = 0.5;

% Zaman aralığı ve adım boyutu
h = 0.2;  % Adım boyutu
t_end = 2;  % Aralığın sonu
n = ceil((t_end - t0) / h);  % Adım sayısı

% Verimlilik için dizi önceden ayrılıyor
t = t0:h:t_end;
y = zeros(size(t));

% Başlangıç değeri
y(1) = y0;

% İlk üç noktayı Runge-Kutta 4. derece ile hesapla
for i = 1:3
    k1 = f(t(i), y(i));
    k2 = f(t(i) + h/2, y(i) + h*k1/2);
    k3 = f(t(i) + h/2, y(i) + h*k2/2);
    k4 = f(t(i) + h, y(i) + h*k3);
    y(i+1) = y(i) + h*(k1 + 2*k2 + 2*k3 + k4)/6;
end

% Adams Dördüncü Derece Predictor-Corrector uygulaması
for i = 4:n
    % Predictor adımı (Adams-Bashforth 4. derece)
    y_pred = y(i) + h/24 * (55*f(t(i), y(i)) - 59*f(t(i-1), y(i-1)) + ...
                            37*f(t(i-2), y(i-2)) - 9*f(t(i-3), y(i-3)));
    
    % Corrector adımı (Adams-Moulton 4. derece)
    y_corr = y(i) + h/24 * (9*f(t(i+1), y_pred) + 19*f(t(i), y(i)) - ...
                            5*f(t(i-1), y(i-1)) + f(t(i-2), y(i-2)));
    
    % Düzeltilmiş değeri güncelle
    y(i+1) = y_corr;
end

% Sonuçları göster
results = table(t', y', 'VariableNames', {'Zaman', 'Çözüm'});
disp(results);

% Çözümün grafiği
plot(t, y, '-o');
title('Adams Dördüncü Derece Predictor-Corrector ile ODE Çözümü');
xlabel('t');
ylabel('y(t)');
grid on;
