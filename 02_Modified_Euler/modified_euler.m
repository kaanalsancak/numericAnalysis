% ------------------------------------------------------------------------
% Author: Muhammet Kaan Alsancak
% email address: alsancak.mk@gmail.com 
% Date: 2024/10/17 - 
% ------------------------------------------------------------------------
% Modifiye Euler Metodu ile y' = y - t^2 + 1, y(0) = 0.5 denklem çözümü

clear;
clc;

% Richard, L. "Burden and J. Douglas Faires." Numerical analysis’  ,
% Table 5.1  gerçek çözüm sonuclarının dizisi oluşturuluyor
sonuclar = [0.5000000, 0.8292986, 1.2140877, ...
            1.6489406, 2.1272295, 2.6408591, ...
            3.1799415, 3.7324000, 4.2834838, ...
            4.8151763, 5.3054720 ];

% Fonksiyon tanımı  the ODE: y' = y - t^2 + 1
f = @(t, y) y - t^2 + 1;

% Başlangıç koşulları
h = 0.2;       % Adım büyüklüğü
tn = 2;        % Çözümleme yapılacak son nokta
y0 = 0.5;      % Başlangıç değeri, y(0)
t0 = 0;        % t'nin başlangıç değeri

% t ve y için dizi oluşturma
t = t0:h:tn;
y = zeros(size(t));
y(1) = y0;

% Modifiye Euler yöntemi ile hesaplama
for i = 1:(length(t))     

    % Euler yönteminde ilk adım (predictor)
    y(i+1) = y(i) + h * f(t(i), y(i));    

    % t(i) ve y_predict kullanılarak düzeltilmiş değer (corrector)
    t(i+1) = t(i) + h;
    y_correct = y(i) + (h / 2) * (f(t(i), y(i)) + f(t(i+1), y(i+1)));
    
    % Hesaplanan değeri y_values dizisine ekle
    y(i + 1) = y_correct;

     fprintf("%f %f %f \n",y(i+1), t(i), f(t(i), y(i)))
end



