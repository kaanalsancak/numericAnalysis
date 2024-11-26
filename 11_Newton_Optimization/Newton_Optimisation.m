% ------------------------------------------------------------------------
% Author: Muhammet Kaan Alsancak
% email address: alsancak.mk@gmail.com 
% Date: 2024/11/18
% ------------------------------------------------------------------------
% Newton Yöntemi ile Optimizasyon Algoritması

clc;
clear all;

% Optimize edilmesi gereken fonksiyon
A = @(theta) 4*sin(theta)*(1 + cos(theta)); 

% Fonksiyonun türevini hesapla (symbolic)
syms theta;
dA = diff(A(theta));       % 1. türev
d2A = diff(dA);            % 2. türev

% Türev fonksiyonlarını MATLAB fonksiyonu olarak tanımla
dA_func = 4*(cos(theta)+(cos(theta))^2 - (sin(theta))^2 ); %matlabFunction(dA)
d2A_func = -4*sin(theta)*(1+4*cos(theta)); %matlabFunction(d2A)

% Başlangıç noktası
x0 = pi/4;   % Başlangıç tahmini (aradığınız çözüme göre değiştirilebilir)
epsilon = 0.05; % Hata toleransı
max_iter = 100; % Maksimum iterasyon sayısı

disp('Newton Yöntemi ile Optimizasyon Algoritması');
fprintf('Başlangıç noktası: x0 = %f\n\n', x0);

% Newton Yöntemi iterasyonu
iteration = 0;
x = x0;

while iteration < max_iter
    % 1. türev ve 2. türev değerlerini hesapla
    dA_val = dA_func(x);
    d2A_val = d2A_func(x);

    % İkinci türev sıfırsa, bölme hatasından kaçınmak için döngüden çık
    if d2A_val == 0
        disp('İkinci türev sıfır, optimizasyon tamamlanamadı.');
        break;
    end

    % Newton-Raphson güncellemesi
    x_new = x - dA_val / d2A_val;
    
    % Hata kontrolü
    if abs(x_new - x) < epsilon
        break;
    end
    
    x = x_new;
    iteration = iteration + 1;
    
    % İterasyon sonuçlarını ekrana yazdır
    fprintf('Iterasyon: %d, Optimizasyon Noktası: %f, f(x): %f\n', ...
            iteration, x, A(x));
end

% Sonuçları göster
fprintf('\nOptimizasyon Tamamlandı.\n');
fprintf('Optimizasyon Noktası: %f\n', x);
fprintf('Optimum Değer: f(x) = %f\n', A(x));
