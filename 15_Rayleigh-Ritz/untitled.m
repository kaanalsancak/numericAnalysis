clc;
clear;

% Problem tanımı
f = @(t, y) y - t^2 + 1; % Diferansiyel denklem
y_exact = @(t) (t + 1).^2 - 0.5 * exp(t); % Analitik çözüm
tol = 1e-5; % Tolerans
h_max = 0.2; % Maksimum adım büyüklüğü
h_min = 0.001; % Minimum adım büyüklüğü

% Başlangıç koşulları
t0 = 0; y0 = 0.5; h = h_max;

% Başlangıç değerlerini hesaplamak için Runge-Kutta 4. dereceden yöntem
t_values = [t0]; % t değerleri
w_values = [y0]; % Yaklaşık çözümler
h_values = []; % Adım büyüklükleri
sigma_values = []; % Hata oranları
errors = []; % Gerçek hata |y_exact - w|

% İlk dört noktayı hesapla (t0, t1, t2, t3)
for i = 1:3
    t = t_values(end); w = w_values(end);
    k1 = f(t, w);
    k2 = f(t + h / 2, w + h / 2 * k1);
    k3 = f(t + h / 2, w + h / 2 * k2);
    k4 = f(t + h, w + h * k3);
    w_next = w + h / 6 * (k1 + 2 * k2 + 2 * k3 + k4);
    t_next = t + h;
    
    t_values = [t_values, t_next];
    w_values = [w_values, w_next];
    h_values = [h_values, h];
    sigma_values = [sigma_values, 0]; % İlk dört noktada hata yok
    errors = [errors, abs(y_exact(t_next) - w_next)];
end

% Adams yöntemine geçiş
while t_values(end) < 2
    % Predictor (Adams-Bashforth 4th order)
    t3 = t_values(end); t2 = t_values(end - 1); t1 = t_values(end - 2); t0 = t_values(end - 3);
    w3 = w_values(end); w2 = w_values(end - 1); w1 = w_values(end - 2); w0 = w_values(end - 3);
    f3 = f(t3, w3); f2 = f(t2, w2); f1 = f(t1, w1); f0 = f(t0, w0);
    
    w_pred = w3 + h / 24 * (55 * f3 - 59 * f2 + 37 * f1 - 9 * f0);
    t_next = t3 + h;
    
    % Corrector (Adams-Moulton 4th order)
    f_pred = f(t_next, w_pred);
    w_corr = w3 + h / 24 * (9 * f_pred + 19 * f3 - 5 * f2 + f1);
    
    % Hata kontrolü
    error_est = abs(w_corr - w_pred);
    sigma = 19 / (270 * h) * error_est; % Hata oranı
    if sigma <= tol || h == h_min
        % Adımı kabul et ve bir sonraki değeri kaydet
        t_values = [t_values, t_next];
        w_values = [w_values, w_corr]
        h_values = [h_values, h];
        sigma_values = [sigma_values, sigma];
        errors = [errors, abs(y_exact(t_next) - w_corr)];
    else
        % Tolerans sağlanmadıysa adım büyüklüğünü küçült
        h = max(h_min, h * (tol / (2 * sigma))^(1/4));
        if t_values(end) + h > 2
            h = 2 - t_values(end); % Son adımı 2'ye ulaştırmak için küçült
        end
        continue; % Adım kabul edilmediği için bu iterasyonda bir sonraki t hesaplanmıyor
    end

    % Adım büyüklüğünü güncelle
    h_new = h * (tol / (2 * sigma))^(1/4);
    h = max(h_min, min(h_new, h_max));
t_values(end)
end

% Sonuçları tablo olarak göster
result_table = table(t_values', y_exact(t_values)', w_values', h_values', sigma_values', errors', ...
    'VariableNames', {'t_i', 'y(t_i)', 'w_i', 'h_i', 'sigma_i', '|y(t_i) - w_i|'});

disp(result_table);
