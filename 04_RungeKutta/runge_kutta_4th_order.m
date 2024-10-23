
% ------------------------------------------------------------------------
% Author: Muhammet Kaan Alsancak
% email address: alsancak.mk@gmail.com 
% Date: 2024/10/21 - 22:12
% ------------------------------------------------------------------------
% Runge Kutta 4th order ile diferansiyel denklem çözümü
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
% Adım aralığı
h = 0.2;
% bağlangıç değerleri
t0 = 0;
y0 = 0.5;
% final değeri
t_end = 2;
% adım sayısı
n = (t_end - t0)/h;

% fonksiyon tanımlaması
f = @(t, y) (y - t^2 + 1);

% dizilerin oluşturulması
t_values = t0:h:t_end;
y_values = zeros(1, length(t_values));
y_values(1) = y0;

% Bilgilendirme çıktısı
fprintf("f(n)\t reel values \t calculation result \t differences\n");

% Runge-Kutta 4th order algoritması
for i = 1:n+1
    t = t_values(i);
    y = y_values(i);
    
    k1 = h * f(t, y);
    k2 = h * f(t + h/2, y + k1/2);
    k3 = h * f(t + h/2, y + k2/2);
    k4 = h * f(t + h, y + k3);
    
    y_values(i+1) = y + (k1 + 2*k2 + 2*k3 + k4)/6;

   fprintf("y(%0.1f) = %0.10f \t %0.10f \t %0.10f \n",(i-1)*h , sonuclar(i),y_values(i),(sonuclar(i)-y_values(i)));

end

