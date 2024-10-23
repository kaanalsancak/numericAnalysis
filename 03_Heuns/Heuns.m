% ------------------------------------------------------------------------
% Author: Muhammet Kaan Alsancak
% email address: alsancak.mk@gmail.com 
% Date: 2024/10/17 - 07:52
% ------------------------------------------------------------------------
% Heun's Metodu ile diferansiyel denklem çözümü
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


% Heun's Metodu
for i = 1:n+1
    % euler tahmini
    k1 = f(t(i), y(i));
    y_pred = y(i) + h * k1;
    
    % heuns metodu
    k2 = f(t(i) + h, y_pred);
    y(i+1) = y(i) + h * (k1 + k2) / 2;

    t(i+1) = t(i) + h;

    fprintf("y(%0.1f) = \t  %f \t  %f \t  %f \n",((i-1)*0.2),y(i), sonuclar(i), (sonuclar(i)-y(i)))

end

% % Display results
% disp('  t        y');
% disp([t' y']);
% 
% % Plot the solution
% plot(t, y, '-o');
% xlabel('t');
% ylabel('y');
% title('Heun''s Method Solution for y'' = y - t^2 + 1');
% grid on;
