% ------------------------------------------------------------------------
% Author: Muhammet Kaan Alsancak
% email address: alsancak.mk@gmail.com 
% Date: 2024/10/21 - 22:12
% ------------------------------------------------------------------------
% Runge Kutta 4th order ile diferansiyel denklem çözümü

clear;
clc;

% Richard, L. "Burden and JS. Douglas Faires." Numerical analysisS  ,
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
tn = 2;
% adım sayısı
n = (tn - t0)/h;

% fonksiyon tanımlaması
f = @(t, y) (y - t^2 + 1);

% dizilerin oluşturulması
t = t0:h:tn;
y = zeros(1, length(t));
y(1) = y0;

% Runge-Kutta 4th order algoritması
for i = 1:n+1

    % k1 değerinin hesaplanması     
    k1 = h * f(t(i), y(i));

    % k2 değerinin hesaplanması 
    k2 = h * f(t(i) + h/2, y(i) + k1/2);

    % k3 değerinin hesaplanması 
    k3 = h * f(t(i) + h/2, y(i) + k2/2);
  
    % k4 değerinin hesaplanması 
    k4 = h * f(t(i) + h, y(i) + k3);

    % Runge Kutta 4th order çözümü
    y(i+1) = y(i) + (k1 + 2*k2 + 2*k3 + k4)/6;
    

end

% Sonucların ekrana yazdırılması 
fprintf("f(i)\t\t hesaplanan\t\t\t reel\t\t\tfark\n");
for i = 1:length(t)
    % reel sonuçları ve hesaplanan sonuçları ekrana yazdırma farkları ile
    fprintf("y(%0.1f) = \t  %.8f \t  %.8f \t  %.8f \n",((i-1)*0.2),y(i), sonuclar(i), abs(sonuclar(i)-y(i)))
end