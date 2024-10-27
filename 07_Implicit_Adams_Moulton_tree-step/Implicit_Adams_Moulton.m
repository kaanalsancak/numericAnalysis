% ------------------------------------------------------------------------
% Author: Muhammet Kaan Alsancak
% email address: alsancak.mk@gmail.com 
% Date: 2024/10/22 - 19:12
% ------------------------------------------------------------------------
% Implicit Adams Moulton  ile diferansiyel denklem çözümü
% Verilen diferansiyel denklem: y' = y - t^2 + 1, y(0) = 0.5
% y' = f(t, y) ile ifade edilecek.
clear;
clc;

% Richard, L. "Burden and J. Douglas Faires." Numerical analysis’  ,
% Table 5.12  gerçek çözüm sonuclarının dizisi oluşturuluyor
sonuclar = [0.5000000, 0.8292986, 1.2140877, ...
            1.6489406, 2.1272295, 2.6408591, ...
            3.1799415, 3.7324000, 4.2834838, ...
            4.8151763, 5.3054720 ];

% y' = y - t^2 + 1 fonksiyonunu tanımlayalım
f = @(t, y) y - t^2 + 1;

% Adımlar ve başlangıç değerleri
h = 0.2;  % Adım boyutu
t0 = 0;   % Başlangıç zamanı
tn = 2;   % Bitiş zamanı

% Adım sayısını hesapla
n = (tn - t0) / h;

% Zaman ve çözüm vektörleri
t = t0:h:tn;
y = zeros(1, length(t));

% Başlangıç değerleri
y0 = 0.500000; 
y1 = 0.8292986;
y2 = 1.2140877;
y3 = 1.6489406;

y(1) = y0;
y(2) = y1;
y(3) = y2;
y(4) = y3;

for i = 4:n  

    k1 =      f(t(i-3),y(i-3));

    k2 = 5  * f(t(i-2),y(i-2));

    k3 = 19 * f(t(i-1),y(i-1));

    k4 =  9 * f(t(i),y(i));

    y(i+1) = y(i)+ ((h/24) * (k4 + k3 - k2 + k1));


end

fprintf("f(i)\thesaplanan\t\treel\t\tfark\n");
% Display the results
for i = 1:length(t)
    fprintf('y(%.1f) = %.6f  %.6f  %.6f\n', t(i), y(i),sonuclar(i),  abs(sonuclar(i) - y(i)));
end
