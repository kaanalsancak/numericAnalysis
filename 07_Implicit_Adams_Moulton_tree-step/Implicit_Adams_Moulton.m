% ------------------------------------------------------------------------
% Author: Muhammet Kaan Alsancak
% email address: alsancak.mk@gmail.com 
% Date: 2024/10/22 - 19:12
% ------------------------------------------------------------------------
% Explicit_Adams_Bashforth_four_step ile diferansiyel denklem çözümü
% Verilen diferansiyel denklem: y' = y - t^2 + 1, y(0) = 0.5
% y' = f(t, y) ile ifade edilecek.
clear;
clc;


% Fonksiyon tanımı  the ODE: y' = y - t^2 + 1
f = @(t, y) y - t^2 + 1;

% Richard, L. "Burden and J. Douglas Faires." Numerical analysis’  ,
% Table 5.1  gerçek çözüm sonuclarının dizisi oluşturuluyor

sonuclar = [0.5000000, 0.8292986, 1.2140877, ...
            1.6489406, 2.1272295, 2.6408591, ...
            3.1799415, 3.7324000, 4.2834838, ...
            4.8151763, 5.3054720 ];

h = 0.2;  % Adım aralığı
t0 = 0;   % Başlangıç değeri
y0 = 0.5; % Başlangıç sonucu
tn = 2;   % Son değer

% Adım sayısını hesapla
n = (tn - t0) / h;

% Zaman ve çözüm vektörleri
t = zeros(1, n+1);
y = zeros(1, n+1);

% Başlangıç Değerleri
t(1) = t0;
y(1) = y0;


%ueler metodu ile ilk iki değerin hesaplnaması
for i = 1:2
    y(i+1) = y(i) + h * f(t(i), y(i));
end

% Adams-Moulton 3-step methodu
for i = 3:n
    % Implicit form: solve y(i+1) implicitly
    % Use Newton's method for solving implicit equation
    y_guess = y(i); % Initial guess for y(i+1)
    
    % Newton's method for finding y(i+1)
    for j = 1:10 % Maximum iterations for convergence
        F = y_guess - y(i) - (h/12) * (5*f(t(i+1), y_guess) + 8*f(t(i), y(i)) - f(t(i-1), y(i-1)));
        dF = 1 - (h/12) * 5; % Derivative of F with respect to y_guess
        y_new = y_guess - F/dF; % Update using Newton's method
        
        if abs(y_new - y_guess) < 1e-6
            break; % Convergence check
        end
        y_guess = y_new; % Update guess
    end
    y(i+1) = y_guess;
    fprintf("y(%0.1f) = \t  %f \t  %f \t  %f \n",((i-1)*0.2),y(i), sonuclar(i), (sonuclar(i)-y(i)))

end