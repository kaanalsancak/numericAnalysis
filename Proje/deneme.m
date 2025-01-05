% PID Kontrolcü Tasarımı ve Optimizasyonu (Newton-Raphson Yöntemi ile)
clc; clear;

% DC Motor Parametreleri
J = 0.01;  % Rotor atalet momenti (kg*m^2)
B = 0.1;   % Viskoz sürtünme katsayısı (N*m*s)
K = 0.01;  % Motor sabiti (N*m/A veya V*s/rad)
R = 1;     % Direnç (ohm)
L = 0.5;   % Endüktans (H)

% DC motorun s-düzlemindeki transfer fonksiyonu
s = tf('s');
P_motor = K / ((J * s + B) * (L * s + R) + K^2);

% Başlangıç PID katsayıları
Kp = 1; Ki = 1; Kd = 1; % Başlangıç değerleri

% PID katsayı sınırları
Kp_max = 100; Ki_max = 100; Kd_max = 50; % Maksimum sınır değerler

% Performans kriterleri
max_overshoot = 20; % Maksimum aşım %20
max_settling_time = 0.7; % Maksimum yerleşme zamanı (saniye)
max_iterations = 1000; % Maksimum iterasyon sayısı
tol = 1e-6; % Tolerans

% Optimizasyon için değişkenler
iteration_count = 0; % İterasyon sayacını başlat
iteration_data = []; % İterasyon verilerini depolamak için dizi

while iteration_count < max_iterations
    iteration_count = iteration_count + 1;

    % PID kontrolcü oluştur
    C = pid(Kp, Ki, Kd);

    % Kapalı çevrim sistemi oluştur
    closed_loop_sys = feedback(C * P_motor, 1);

    % Sistem yanıtını analiz et
    info = stepinfo(closed_loop_sys);
    J = abs(info.SettlingTime - max_settling_time) + ...
        (info.Overshoot > max_overshoot) * 100; % Performans fonksiyonu

    % Gradyan hesaplama (numerik türev)
    delta = 1e-4;
    J_Kp = (calculate_cost(Kp + delta, Ki, Kd, P_motor, max_settling_time, max_overshoot) - J) / delta;
    J_Ki = (calculate_cost(Kp, Ki + delta, Kd, P_motor, max_settling_time, max_overshoot) - J) / delta;
    J_Kd = (calculate_cost(Kp, Ki, Kd + delta, P_motor, max_settling_time, max_overshoot) - J) / delta;

    % Gradyan ve Hessian matrisi ile güncelleme
    grad = [J_Kp; J_Ki; J_Kd];
    Kp = max(0, min(Kp_max, Kp - 0.1 * J_Kp));
    Ki = max(0, min(Ki_max, Ki - 0.1 * J_Ki));
    Kd = max(0, min(Kd_max, Kd - 0.1 * J_Kd));

    % Performans verilerini kaydet
    iteration_data = [iteration_data; iteration_count, Kp, Ki, Kd, info.SettlingTime, info.Overshoot];

    % Durdurma kriteri
    if norm(grad) < tol
        fprintf('Optimizasyon tamamlandı. İterasyon: %d\n', iteration_count);
        break;
    end
end

% Optimizasyon sonuçlarını yazdırma
fprintf('Son PID katsayıları:\n');
fprintf('Kp = %.4f, Ki = %.4f, Kd = %.4f\n', Kp, Ki, Kd);

% İterasyon sonuçlarını grafikle gösterme
if ~isempty(iteration_data)
    figure;
    subplot(2, 1, 1);
    plot(iteration_data(:, 1), iteration_data(:, 5), '-o', 'LineWidth', 1.5);
    grid on;
    xlabel('İterasyon Sayısı');
    ylabel('Yerleşme Zamanı (s)');
    title('İterasyonlara Göre Yerleşme Zamanı');

    subplot(2, 1, 2);
    plot(iteration_data(:, 1), iteration_data(:, 6), '-o', 'LineWidth', 1.5);
    grid on;
    xlabel('İterasyon Sayısı');
    ylabel('Aşım (%)');
    title('İterasyonlara Göre Aşım');
end

% Son step yanıtı grafiği
C_best = pid(Kp, Ki, Kd);
closed_loop_best = feedback(C_best * P_motor, 1);
[y_closed, t_closed] = step(closed_loop_best);

figure;
plot(t_closed, y_closed, 'LineWidth', 1.5);
grid on;
xlabel('Zaman (s)');
ylabel('Çıkış');
title('Kapalı Çevrim Step Yanıtı (En İyi PID)');

% Açık çevrim step yanıtı
[y_open, t_open] = step(P_motor);

figure;
plot(t_open, y_open, 'LineWidth', 1.5);
grid on;
xlabel('Zaman (s)');
ylabel('Çıkış');
title('Açık Çevrim Step Yanıtı');

% Yardımcı fonksiyon
function J = calculate_cost(Kp, Ki, Kd, P_motor, max_settling_time, max_overshoot)
    C = pid(Kp, Ki, Kd);
    closed_loop_sys = feedback(C * P_motor, 1);
    info = stepinfo(closed_loop_sys);
    J = abs(info.SettlingTime - max_settling_time) + ...
        (info.Overshoot > max_overshoot) * 100;
end
