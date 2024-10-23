
% ------------------------------------------------------------------------
% Author: Muhammet Kaan Alsancak
% email address: alsancak.mk@gmail.com 
% Date: 2024/10/17 - 07:52
% ------------------------------------------------------------------------
% Modifiye Euler Metodu ile diferansiyel denklem çözümü
% Verilen diferansiyel denklem: y' = y - t^2 + 1, y(0) = 0.5
% y' = f(t, y) ile ifade edilecek.

clear;
clc;


% Richard, L. "Burden and J. Douglas Faires." Numerical analysis’  ,
% Table 5.1  gerçek çözüm sonuclarının dizisi oluşturuluyor

sonuclar = [0.5000000, 0.8292986, 1.2140877, ...
            1.6489406, 2.1272295, 2.6408591, ...
            3.1799415, 3.7324000, 4.2834838, ...
            4.8151763, 5.3054720 ];

% Adımlar ve başlangıç değerleri
h = 0.2;  % Adım boyutu
t0 = 0;   % Başlangıç zamanı
y0 = 0.5; % Başlangıç değeri
t_final = 2; % Çözüm aralığı [t0, t_final]

% Adım sayısını hesapla
n_steps = (t_final - t0) / h;

% Zaman ve çözüm vektörleri
t_values = t0:h:t_final;
y_values = zeros(size(t_values));
y_values(1) = y0;

% Fonksiyon tanımı y' = y - t^2 + 1
f = @(t, y) y - t^2 + 1;

% Bilgilendirme çıktısı
fprintf("f(n)\t reel values \t calculation result \t differences\n");

% Modifiye Euler döngüsü
for i = 1:n_steps+1
    t = t_values(i);
    y = y_values(i);
    
    % Euler çözüü
    y_predict = y + h * f(t, y);
    
    % Modifiye Euler çözümü
    y_values(i+1) = y + (h/2) * (f(t, y) + f(t+h, y_predict));
    
    fprintf("y(%0.1f) = %0.10f \t %0.10f \t %0.10f \n",(i-1)*h , sonuclar(i),y_values(i),(sonuclar(i)-y_values(i)));

end

