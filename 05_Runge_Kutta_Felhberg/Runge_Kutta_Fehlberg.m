
% ------------------------------------------------------------------------
% Author: Muhammet Kaan Alsancak
% email address: alsancak.mk@gmail.com 
% Date: 2024/10/21 - 22:12
% ------------------------------------------------------------------------
% Runge-Kutta-Fehlberg ile diferansiyel denklem çözümü
% Verilen diferansiyel denklem: y' = y - t^2 + 1, y(0) = 0.5
% y' = f(t, y) ile ifade edilecek.

clear;
clc;

% fonksiyon tanımlaması
f = @(t, y) y - t^2 + 1;

% Richard, L. "Burden and J. Douglas Faires." Numerical analysis’  ,
% Table 5.1  gerçek çözüm sonuclarının dizisi oluşturuluyor

sonuclar = [0.5000000, 0.8292986, 1.2140877, ...
            1.6489406, 2.1272295, 2.6408591, ...
            3.1799415, 3.7324000, 4.2834838, ...
            4.8151763, 5.3054720 ];


% Fehlberg's method katsayıları
a = [0, 1/4, 3/8, 12/13, 1, 1/2];
b = [...
    0,         0,          0,           0,           0,         0; ...
    1/4,       0,          0,           0,           0,         0; ...
    3/32,      9/32,       0,           0,           0,         0; ...
    1932/2197, -7200/2197, 7296/2197,   0,           0,         0; ...
    439/216,   -8,         3680/513,    -845/4104,   0,         0; ...
    -8/27,     2,          -3544/2565,  1859/4104,   -11/40,    0];
c4 = [25/216, 0, 1408/2565, 2197/4104, -1/5, 0]; % 4th derece ağırlıklandırma
c5 = [16/135, 0, 6656/12825, 28561/56430, -9/50, 2/55]; % 5th derece ağırlıklandırma


% Başlangıç değelerinin atanması
h = 0.2; 
t0 = 0;     
y0 = 0.5;    
t_end = 2; 
n = (t_end - t0)/h;
% adım sayılarının hesaplanması
% dizilerin oluşturulması
t_values = t0:h:t_end;
y_values = zeros(1, length(t_values));
y_values(1) = y0;

% Bilgilendirme çıktısı
fprintf("f(n)\t reel values \t calculation result \t differences\n");

% Runge-Kutta-Fehlberg hesaplanması
for i = 1:n+1   
    t = t_values(i);
    y = y_values(i);
    % k değerlerinin hesaplanması
    k1 = h * f(t, y_values(i));
    k2 = h * f(t + a(2)*h, y + b(2,1)*k1);
    k3 = h * f(t + a(3)*h, y + b(3,1)*k1 + b(3,2)*k2);
    k4 = h * f(t + a(4)*h, y + b(4,1)*k1 + b(4,2)*k2 + b(4,3)*k3);
    k5 = h * f(t + a(5)*h, y + b(5,1)*k1 + b(5,2)*k2 + b(5,3)*k3 + b(5,4)*k4);
    k6 = h * f(t + a(6)*h, y + b(6,1)*k1 + b(6,2)*k2 + b(6,3)*k3 + b(6,4)*k4 + b(6,5)*k5);
    
    % 4th dereceden çözüm işlemi
    y_values(i+1) = y_values(i) + c4(1)*k1 + c4(2)*k2 + c4(3)*k3 + c4(4)*k4 + c4(5)*k5 + c4(6)*k6;
   
   fprintf("y(%0.1f) = %0.10f \t %0.10f   \t %0.10f \n",(i-1)*h , sonuclar(i),y_values(i),(sonuclar(i)-y_values(i)));

end

