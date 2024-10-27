% ------------------------------------------------------------------------
% Author: Muhammet Kaan Alsancak
% email address: alsancak.mk@gmail.com 
% Date: 2024/10/22 - 19:12
% ------------------------------------------------------------------------
% Explicit_Adams_Bashforth_four_step ile diferansiyel denklem çözümü

clear;
clc;
% Richard, L. "Burden and J. Douglas Faires." Numerical analysis’  ,
% Table 5.1  gerçek çözüm sonuclarının dizisi oluşturuluyor

sonuclar = [0.5000000, 0.8292986, 1.2140877, ...
            1.6489406, 2.1272295, 2.6408591, ...
            3.1799415, 3.7324000, 4.2834838, ...
            4.8151763, 5.3054720 ];
% Adams-Bashforth 4. dereceden yöntemi 

% Adımlar ve başlangıç değerleri
h = 0.2;  % Adım boyutu
t0 = 0;   % Başlangıç zamanı
tn = 2;   % Bitiş zamanı

% Başlangıç değerleri
y0 = 0.500000; 
y1 = 0.8292986;
y2 = 1.2140877;
y3 = 1.6489406;


% Adım sayısını hesapla
n = (tn - t0) / h;

% Diferansiyel denklem: y' = y - t^2 + 1
f = @(t, y) y - t^2 + 1;  % y' fonksiyonu

% Zaman ve çözüm vektörleri
t = t0:h:tn;
y = zeros(1, length(t));
%  başlangıç değerleri atanıyor.
y(1) = y0;
y(2) = y1;
y(3) = y2;
y(4) = y3;


% Adams-Bashforth 4. dereceden yöntem uyuglaması
for i = 4:n
    k1 =  9 *f(t(i-3), y(i-3));
    k2 =  37*f(t(i-2), y(i-2));    
    k3 =  59*f(t(i-1), y(i-1));
    k4 =  55*f(t(i)  , y(i));
    y(i+1) = y(i) + h/24 * ( k4-k3+k2-k1 );
end

fprintf("f(i)\t\t hesaplanan\t\treel\t\t\thata\n");
for i = 1:length(t)
    % reel sonuçları ve hesaplanan sonuçları ekrana yazdırma farkları ile
    fprintf("y(%0.1f) = \t  %.8f \t  %.8f \t  %.8f \n",((i-1)*0.2),y(i), sonuclar(i), abs(sonuclar(i)-y(i)))
end

