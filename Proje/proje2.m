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
Kp = 0.8; Ki = 0.1; Kd = 0.001;

% Newton-Raphson parametreleri
max_iter = 500;  % Maksimum iterasyon sayısı
tol = 0.01;      % Tolerans (daha hassas ayar)
target_settling_time = 0.5; % Hedef settling time (saniye)
overshoot_limit = 20;       % Maksimum overshoot (%)

% Optimizasyon döngüsü
for iter = 1:max_iter
    % PID kontrolcü
    C = Kp + Ki/s + Kd*s;
    
    % Kapalı döngü transfer fonksiyonu
    T = feedback(C*G, 1);
    
    % Step yanıtı analizi
    info = stepinfo(T);
    settling_time = info.SettlingTime;
    overshoot = info.Overshoot;
    
    % Hata fonksiyonu (ağırlıklı)
    J = abs(settling_time - target_settling_time) + ...
        10 * max(0, overshoot - overshoot_limit); % Overshoot'a ağırlık eklendi
    
    % Newton-Raphson gradyan hesaplama
    dKp = 0.05; dKi = 0.05; dKd = 0.05; % Daha büyük adımlar
    J_Kp = calculate_cost(Kp + dKp, Ki, Kd, G, target_settling_time, overshoot_limit) - J;
    J_Ki = calculate_cost(Kp, Ki + dKi, Kd, G, target_settling_time, overshoot_limit) - J;
    J_Kd = calculate_cost(Kp, Ki, Kd + dKd, G, target_settling_time, overshoot_limit) - J;
    
    % Gradyan güncelleme
    grad = [J_Kp/dKp, J_Ki/dKi, J_Kd/dKd];
    Kp = max(0, Kp - 0.2 * grad(1)); % Öğrenme oranı artırıldı
    Ki = max(0, Ki - 0.2 * grad(2)); % Öğrenme oranı artırıldı
    Kd = max(0, Kd - 0.2 * grad(3)); % Öğrenme oranı artırıldı
    
    % Kriter kontrolü
    if norm(grad) < tol
        break;
    end
    
    % Debugging için iterasyonları yazdırma
    fprintf('Iterasyon: %d, Kp: %.3f, Ki: %.3f, Kd: %.3f, J: %.3f\n', iter, Kp, Ki, Kd, J);
end

% Son optimizasyon sonuçlarını yazdırma
fprintf('Optimizasyon tamamlandı: \n');
fprintf('Kp: %.3f, Ki: %.3f, Kd: %.3f\n', Kp, Ki, Kd);
fprintf('Settling Time: %.3f s, Overshoot: %.2f %%\n', settling_time, overshoot);

% Optimize edilmiş PID kontrolcü ile step yanıtı
C_opt = Kp + Ki/s + Kd*s;
T_opt = feedback(C_opt*G, 1);
[y_opt, t_opt] = step(T_opt);

figure;
plot(t_opt, y_opt, 'LineWidth', 2);
grid on;
xlabel('Zaman (s)');
ylabel('Çıkış');
title('Optimize Edilmiş PID ile Kapalı Döngü Step Yanıtı');

% Açık döngü motor step yanıtı
[y_ol, t_ol] = step(G);

figure;
plot(t_ol, y_ol, 'LineWidth', 2);
grid on;
xlabel('Zaman (s)');
ylabel('Çıkış');
title('Açık Döngü Step Yanıtı');

% Yardımcı fonksiyon
function J = calculate_cost(Kp, Ki, Kd, G, target_settling_time, overshoot_limit)
    s = tf('s');
    C = Kp + Ki/s + Kd*s;
    T = feedback(C*G, 1);
    info = stepinfo(T);
    settling_time = info.SettlingTime;
    overshoot = info.Overshoot;
    J = abs(settling_time - target_settling_time) + ...
        10 * max(0, overshoot - overshoot_limit); % Overshoot'a ağırlık eklendi
end
