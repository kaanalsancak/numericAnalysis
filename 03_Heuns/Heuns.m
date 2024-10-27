% ------------------------------------------------------------------------
% Author: Muhammet Kaan Alsancak
% email address: alsancak.mk@gmail.com 
% Date: 2024/10/17 - 
% ------------------------------------------------------------------------
% Heun's Metodu ile y' = y - t^2 + 1, y(0) = 0.5 denklem çözümü

clear;
clc;

% Richard, L. "Burden and J. Douglas Faires." Numerical analysis’  ,
% Table 5.1  gerçek çözüm sonuclarının dizisi oluşturuluyor
sonuclar = [0.5000000, 0.8292986, 1.2140877, ...
            1.6489406, 2.1272295, 2.6408591, ...
            3.1799415, 3.7324000, 4.2834838, ...
            4.8151763, 5.3054720 ];

% Diferansiyel denklemin tanımı: y' = y - t^2 + 1
f = @(t, y) y - t^2 + 1;

% Adım aralığı ve son değer
h = 0.2;       % Adım büyüklüğü
tn = 2;   % Çözümleme yapılacak son nokta
y0 = 0.5;      % Başlangıç değeri, y(0)
t0 = 0;        % t'nin başlangıç değeri

t = t0:h:tn;
y = zeros(size(t));

% Başlangıç koşulu
t(1) = 0;
y(1) = 0.5;


% Geliştirilmiş Hüen metodu döngüsü
for i = 1: length(t)
    y(i+1) = y(i) + h/4*(    f(t(i)         , y(i) ) + ...
                           3*f(t(i) + 2*h/3 , y(i)   +...
                       2*h/3*f(t(i) + h/3   , y(i)   +...
                         h/3*f(t(i)         , y(i)))));

end

fprintf("f(i)\t\t hesaplanan\t\t  reel\t\t      hata\n");
for i = 1:length(t)
    % reel sonuçları ve hesaplanan sonuçları ekrana yazdırma farkları ile
    fprintf("y(%0.1f) = \t  %.8f \t  %.8f \t  %.8f \n",((i-1)*0.2),y(i), sonuclar(i), abs(sonuclar(i)-y(i)))
end


