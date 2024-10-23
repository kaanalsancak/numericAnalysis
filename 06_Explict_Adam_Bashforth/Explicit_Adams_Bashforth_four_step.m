% ------------------------------------------------------------------------
% Author: Muhammet Kaan Alsancak
% email address: alsancak.mk@gmail.com 
% Date: 2024/10/22 - 19:12
% ------------------------------------------------------------------------
% Explicit_Adams_Bashforth_four_step ile diferansiyel denklem çözümü
% Verilen diferansiyel denklem: y' = y - t^2 + 1, y(0) = 0.5
% y' = f(t, y) ile ifade edilecek.
clear;
clc;

% Fonksiyon tanımı  the ODE: y' = y - t^2 + 1
f = @(t, y) y - t^2 + 1;

% Richard, L. "Burden and J. Douglas Faires." Numerical analysis’  ,
% Table 5.1  gerçek çözüm sonuclarının dizisi oluşturuluyor

sonuclar = [0.5000000, 0.8292986, 1.2140877, ...
            1.6489406, 2.1272295, 2.6408591, ...
            3.1799415, 3.7324000, 4.2834838, ...
            4.8151763, 5.3054720 ];

h = 0.2;  % Adım aralığı
t0 = 0;   % Başlangıç değeri
y0 = 0.5; % Başlangıç sonucu
tn = 2;   % Son değer

% Adım sayısını hesapla
n = (tn - t0) / h;

% Zaman ve çözüm vektörleri
t = zeros(1, n+1);
y = zeros(1, n+1);

% Başlangıç Değerleri
t(1) = t0;
y(1) = y0;

% ilk 4 değerin hesapnaması
for i = 1:3
    k1 = h * f(t(i), y(i));
    k2 = h * f(t(i) + 0.5*h, y(i) + 0.5*k1);
    k3 = h * f(t(i) + 0.5*h, y(i) + 0.5*k2);
    k4 = h * f(t(i) + h, y(i) + k3);
    y(i+1) = y(i) + (1/6)*(k1 + 2*k2 + 2*k3 + k4);
    t(i+1) = t(i) + h;
end


% Bilgilendirme çıktısı
fprintf("f(n) \t\t reel values  calculation  differences\n");

% Apply the Explicit Adams-Bashforth Four-Step Method
for i = 4:n+1
    t(i+1) = t(i) + h;
    y(i+1) = y(i) + (h/24) * (55*f(t(i), y(i)) - 59*f(t(i-1), y(i-1)) + 37*f(t(i-2), y(i-2)) - 9*f(t(i-3), y(i-3)));
    fprintf("y(%0.1f) = \t  %f \t  %f \t  %f \n",((i-1)*0.2),y(i), sonuclar(i), (sonuclar(i)-y(i)))

end

