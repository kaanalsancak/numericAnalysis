% ------------------------------------------------------------------------
% Author: Muhammet Kaan Alsancak
% email address: alsancak.mk@gmail.com 
% Date: 2024/10/22 - 19:12
% ------------------------------------------------------------------------
% Explicit_Adams_Bashforth_Variable Step ile diferansiyel denklem çözümü

clc;
clear;

% Diferansiyel denklemi tanımla: f(t, y)
f = @(t, y) y - t^2 + 1;

% Giriş değerleri
a = 0;            % Başlangıç noktası
b = 2;            % Bitiş noktası
alpha = 0.5;      % Başlangıç koşulu y(a) = alpha
TOL = 10e-5;      % Tolerans
hmax = 0.2;       % Maksimum adım boyutu
hmin = 0.01;      % Minimum adım boyutu

% Değişkenleri başlat
t0 = a;           % Başlangıç zamanı
w0 = alpha;       % Başlangıç çözümü
h = hmax;         % Başlangıçta maksimum adım boyutu
FLAG = 1;         % Döngüyü kontrol etmek için
LAST = 0;         % Son adımı belirlemek için
i = 1;            % Adım sayacı
sigma = 0.0;      % Sigma

% Çözüm değerlerini saklamak için diziler
T_all = [];       % Tüm zaman değerleri
W_all = [];       % Tüm çözüm değerleri

% Başlangıç değerlerini çıktı olarak yazdır
fprintf('Adım\t   t\t       w\t       h          sigma\n');
fprintf('%4d\t%8.4f\t%8.6f\t%8.4f\t%8.4f\n', i, t0, w0, h, sigma);

% İlk üç adım için Runge-Kutta 4. derece ile hesapla
T = zeros(1, 4); % Zaman değerlerini sakla
W = zeros(1, 4); % Çözüm değerlerini sakla
T(1) = t0;
W(1) = w0;

for j = 1:3
    % Runge-Kutta katsayılarını hesapla
    k1 = h * f(T(j), W(j));
    k2 = h * f(T(j) + h / 2, W(j) + k1 / 2);
    k3 = h * f(T(j) + h / 2, W(j) + k2 / 2);
    k4 = h * f(T(j) + h, W(j) + k3);
    
    % Bir sonraki çözüm değerini bul
    W(j + 1) = W(j) + (k1 + 2 * k2 + 2 * k3 + k4) / 6;
    T(j + 1) = T(j) + h;
    
    % Adım sayacını artır ve sonucu yazdır
    i = i + 1;
    fprintf('%4d\t%8.4f\t%8.6f\t%8.4f\t%8.4f\n', i, T(j + 1), W(j + 1), h, sigma);
end

% Tüm sonuçları kaydet
T_all = [T_all, T];
W_all = [W_all, W];

% Predictor-Corrector döngüsünü başlat
while FLAG
    % Predictor adımı (Adams-Bashforth 4. derece)
    WP = W(4) + h / 24 * (55 * f(T(4), W(4)) - 59 * f(T(3), W(3)) + ...
                          37 * f(T(2), W(2)) - 9 * f(T(1), W(1)));

    % Corrector adımı (Adams-Moulton 4. derece)
    WC = W(4) + h / 24 * (9 * f(T(4) + h, WP) + 19 * f(T(4), W(4)) - ...
                          5 * f(T(3), W(3)) + f(T(2), W(2)));

    % Hata tahminini hesapla
    sigma = 19 * abs(WC - WP) / (270 * h);

    if sigma <= TOL
        % Sonucu kabul et
        t_next = T(4) + h;
        w_next = WC;

        % Sonucu yazdır
        fprintf('%4d\t%8.4f\t%8.6f\t%8.4f\t%8.4f\n', i + 1, t_next, w_next, h, sigma);

        % Değerleri güncelle
        T = [T(2:4), t_next];
        W = [W(2:4), w_next];
        i = i + 1;

        % Sonuçları sakla
        T_all = [T_all, t_next];
        W_all = [W_all, w_next];

        % Son adım kontrolü
        if LAST
            FLAG = 0;
        else
            % Adım boyutunu gerekirse ayarla
            if sigma <= 0.1 * TOL || T(4) + h > b
                q = (TOL / (2 * sigma))^(1 / 4);
                h = min(4 * h, min(q * h, hmax));

                if T(4) + 4 * h > b
                    h = (b - T(4)) / 4;
                    LAST = 1;
                end
            end
        end
    else
        % Sonucu reddet ve adım boyutunu küçült
        q = (TOL / (2 * sigma))^(1 / 4);
        h = max(0.1 * h, q * h);

        if h < hmin
            % Minimum adım boyutu aşıldı, hesaplama başarısız
            FLAG = 0;
            fprintf('hmin sınırı aşıldı. Çözüm başarısız.\n');
            break;
        else
            % Daha küçük adım boyutuyla tekrar hesapla
            T = T(1:3);
            W = W(1:3);
            i = i - 3;
        end
    end
end

disp('Hesaplama tamamlandı.');

% Sonuçların Grafiği
figure;
plot(T_all, W_all, '-o', 'LineWidth', 1.5);
title('Adams-Bashforth & Adams-Moulton Çözümü');
xlabel('t (Zaman)');
ylabel('w (Çözüm)');
grid on;
legend('Yaklaşık Çözüm', 'Location', 'Best');
