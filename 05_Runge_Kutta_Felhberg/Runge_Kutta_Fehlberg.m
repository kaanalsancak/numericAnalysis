% ------------------------------------------------------------------------
% Author: Muhammet Kaan Alsancak
% email address: alsancak.mk@gmail.com 
% Date: 2024/10/21 - 22:12
% ------------------------------------------------------------------------
% Runge Kutta Fehlberg order ile diferansiyel denklem çözümü

clc;
clear;

% Richard, L. "Burden and J. Douglas Faires." Numerical analysis’  ,
% Table 5.1  gerçek çözüm sonuclarının dizisi oluşturuluyor

sonuclar = [0.5000000, 0.9204873, 1.3964884, ...
            1.9537446, 2.5864198, 3.2604520, ...
            3.9520844, 4.6308127, 5.2574687, ...
            5.3054720];


% Giriş Verileri
a = 0;           % Başlangıç noktası
b = 2;           % Bitiş noktası
alpha = 0.5;     % Başlangıç koşulu y(0)
TOL = 1e-5;      % Tolerans
hmax = 0.25;      % Maksimum adım boyu
hmin = 0.01;     % Minimum adım boyu

% Başlangıç Ayarları
t = a;
w = alpha;
h = hmax;  % Başlangıçta maksimum adım boyuyla başlıyoruz
FLAG = 1;  % FLAG hesaplamanın başarılı olup olmadığını tutar

% Diferansiyel Denklemin Tanımı
f = @(t, y) y - t^2 + 1;

% Çıkış dizileri (t, w değerlerini saklamak için)
T = t;
W = w;

% FLAG = 1 oldukça (While FLAG = 1)
while FLAG == 1

    % Adım 3: k1, k2, k3, k4, k5, k6 hesaplamaları
    k1 = h * f(t, w);
    k2 = h * f(t + h/4, w + k1/4);
    k3 = h * f(t + 3*h/8, w + 3*k1/32 + 9*k2/32);
    k4 = h * f(t + 12*h/13, w + 1932*k1/2197 - 7200*k2/2197 + 7296*k3/2197);
    k5 = h * f(t + h, w + 439*k1/216 - 8*k2 + 3680*k3/513 - 845*k4/4104);
    k6 = h * f(t + h/2, w - 8*k1/27 + 2*k2 - 3544*k3/2565 + 1859*k4/4104 - 11*k5/40);


    % Hata tahmini R hesaplaması
    R = abs(k1/360 - 128*k3/4275 - 2197*k4/75240 + k5/50 + 2*k6/55) / h;



    % Eğer R <= TOL ise adımı kabul et
    if R <= TOL
        % Adım 6: t'yi güncelle (Approximation accepted)
        t = t + h;
        w = w + 25*k1/216 + 1408*k3/2565 + 2197*k4/4104 - k5/5;
        
        % Sonuçları kaydet
        T = [T; t];  % t değerlerini sakla
        W = [W; w];  % w değerlerini sakla
  
    end

    % Çıkış (hedefe ulaştıysak)
    if t >= b
        FLAG = 0;

    else
        %  Yeni h değerini hesapla
        h_new = 0.84 * (TOL/R)^(1/4) * h;
        
        %  h'yi sınırlar içinde güncelle
        if h_new > hmax
            h = hmax;

        elseif h_new < hmin
            FLAG = 0;
        else
            h = h_new;
        end
    end
 end


% Sonucların ekrana yazdır
fprintf("f(i)\t\t  hesaplana\t\treel\t\tfark\n");
for i = 1:length(T)-1
    % reel sonuçları ve hesaplanan sonuçları ekrana yazdırma hata miktarı ile
    fprintf("y(%0.1f) = \t  %.8f \t  %.8f \t  %.8f \n",((i-1)*0.2),W(i), sonuclar(i), abs(sonuclar(i)-W(i)))
end
