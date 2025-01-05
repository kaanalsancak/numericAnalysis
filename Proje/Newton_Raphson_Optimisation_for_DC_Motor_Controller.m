% Motor Parametreleri
J = 0.01;  % Atalet momenti
b = 0.1;   % Sürtünme katsayısı
K = 0.01;  % Motor sabiti
R = 1;     % Direnç
L = 0.5;   % Endüktans

% Transfer fonksiyonu (DC motor)
s = tf('s');
G = K / ((J*s + b)*(L*s + R) + K^2);

% PID kontrolcü başlangıç parametreleri
Kp = 1; Ki = 1; Kd = 1;

% Newton-Raphson parametreleri
max_iter = 100;  % Maksimum iterasyon sayısı
tol = 1e-6;     % Tolerans
target_settling_time = 0.1; % Hedef settling time (saniye)
overshoot_limit = 60; % Maksimum overshoot (%)

% Optimizasyon döngüsü
figure;
hold on;
grid on;
title('Step Response During Optimization');
xlabel('Time (s)');
ylabel('Response');
legend_entries = {};

for iter = 1:max_iter
    % PID kontrolcü
    C = Kp + Ki/s + Kd*s;
    
    % Kapalı döngü transfer fonksiyonu
    T = feedback(C*G, 1);
    
    % Step yanıtı analizi
    [y, t] = step(T);
    info = stepinfo(T);
    settling_time = info.SettlingTime;
    overshoot = info.Overshoot;
    
    % Step yanıtını grafikle
    plot(t, y, 'DisplayName', sprintf('Iteration %d', iter));
    legend_entries{end+1} = sprintf('Iteration %d', iter); %#ok<AGROW>
    
    % Hata fonksiyonu
    J = abs(settling_time - target_settling_time) + ...
        (overshoot > overshoot_limit) * 100;
    
    % Newton-Raphson gradyan hesaplama
    dKp = 0.01; dKi = 0.01; dKd = 0.01;
    J_Kp = calculate_cost(Kp + dKp, Ki, Kd, G, target_settling_time, overshoot_limit) - J;
    J_Ki = calculate_cost(Kp, Ki + dKi, Kd, G, target_settling_time, overshoot_limit) - J;
    J_Kd = calculate_cost(Kp, Ki, Kd + dKd, G, target_settling_time, overshoot_limit) - J;
    
    % Gradyan güncelleme
    grad = [J_Kp/dKp, J_Ki/dKi, J_Kd/dKd];
    Kp = Kp - 0.1 * grad(1);
    Ki = Ki - 0.1 * grad(2);
    Kd = Kd - 0.1 * grad(3);
    
    % Kriter kontrolü
    if norm(grad) < tol
        break;
    end
end

% Son optimizasyon sonuçlarını yazdırma
fprintf('Optimizasyon tamamlandı: \n');
fprintf('Kp: %.3f, Ki: %.3f, Kd: %.3f\n', Kp, Ki, Kd);
fprintf('Settling Time: %.3f s, Overshoot: %.2f %%\n', settling_time, overshoot);

% Step yanıtlarının legend'ını ekle
legend(legend_entries, 'Location', 'Best');

% Yardımcı fonksiyon
function J = calculate_cost(Kp, Ki, Kd, G, target_settling_time, overshoot_limit)
    s = tf('s');
    C = Kp + Ki/s + Kd*s;
    T = feedback(C*G, 1);
    info = stepinfo(T);
    settling_time = info.SettlingTime;
    overshoot = info.Overshoot;
    J = abs(settling_time - target_settling_time) + ...
        (overshoot > overshoot_limit) * 100;
end
