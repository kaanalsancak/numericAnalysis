function pid_optimization_with_newton()
    % Sistem transfer fonksiyonu (örnek sistem)
    s = tf('s');
    G = 1 / (s^2 + 3*s + 2); % İkinci dereceden bir sistem

    % Başlangıç PID katsayıları
    Kp = 1;  % Proportional gain
    Ti = 1;  % Integral time
    Td = 0.1; % Derivative time

    % Newton-Raphson parametreleri
    max_iter = 500; % Maksimum iterasyon sayısı
    tol = 1e-4; % Tolerans
    alpha = 0.1; % Adım boyu (learning rate)

    % PID katsayılarını kaydetmek için
    pid_params = [Kp; Ti; Td];
    pid_history = pid_params';
    cost_history = [];
    
    % Newton-Raphson Yöntemi
    for iter = 1:max_iter
        % ITAE maliyet fonksiyonunu hesapla
        J = itae_cost(G, pid_params(1), pid_params(2), pid_params(3));
        cost_history(end + 1) = J;

        % Gradyanı hesapla
        grad = itae_gradient(G, pid_params(1), pid_params(2), pid_params(3));

        % PID katsayılarını güncelle
        pid_new = pid_params - alpha * grad;

        % Güncellemeyi kaydet
        pid_history = [pid_history; pid_new'];

        % Durma kriteri
        if norm(pid_new - pid_params) < tol
            disp('Newton-Raphson yöntemi durduruldu: Tolerans seviyesine ulaşıldı.');
            break;
        end

        % Güncel değerleri ata
        pid_params = pid_new;
    end

    % Optimize edilmiş PID katsayıları
    Kp_opt = pid_params(1);
    Ti_opt = pid_params(2);
    Td_opt = pid_params(3);

    % Sonuçları yazdır
    fprintf('Optimize edilmiş PID katsayıları:\n');
    fprintf('Kp = %.4f, Ti = %.4f, Td = %.4f\n', Kp_opt, Ti_opt, Td_opt);

    % Sistem yanıtını görselleştir
    visualize_results(G, pid_history, cost_history);
end

function J = itae_cost(G, Kp, Ti, Td)
    % ITAE maliyet fonksiyonu (Integral of Time-weighted Absolute Error)
    s = tf('s');
    PID = Kp * (1 + 1/(Ti*s) + Td*s); % PID denetleyici
    T = feedback(PID * G, 1); % Kapalı çevrim sistemi
    [y, t] = step(T, 10); % Adım yanıtı
    J = trapz(t, t .* abs(1 - y)); % ITAE hesapla
end

function grad = itae_gradient(G, Kp, Ti, Td)
    % ITAE maliyet fonksiyonunun gradyanını yaklaşıkla
    delta = 1e-6; % Gradyan hesaplama için küçük değişim
    J = itae_cost(G, Kp, Ti, Td);

    % Parametrelere göre kısmi türevler
    dJ_dKp = (itae_cost(G, Kp + delta, Ti, Td) - J) / delta;
    dJ_dTi = (itae_cost(G, Kp, Ti + delta, Td) - J) / delta;
    dJ_dTd = (itae_cost(G, Kp, Ti, Td + delta) - J) / delta;

    grad = [dJ_dKp; dJ_dTi; dJ_dTd]; % Gradyan vektörü
end

function visualize_results(G, pid_history, cost_history)
    % PID katsayılarının ve maliyet fonksiyonunun değişimini görselleştir
    figure;

    % PID Katsayıları
    subplot(2, 1, 1);
    plot(1:size(pid_history, 1), pid_history(:, 1), '-o', 'DisplayName', 'Kp');
    hold on;
    plot(1:size(pid_history, 1), pid_history(:, 2), '-o', 'DisplayName', 'Ti');
    plot(1:size(pid_history, 1), pid_history(:, 3), '-o', 'DisplayName', 'Td');
    xlabel('İterasyon');
    ylabel('PID Katsayıları');
    title('PID Katsayılarının İterasyonlar Boyunca Değişimi');
    legend show;
    grid on;

    % ITAE Maliyet Fonksiyonu
    subplot(2, 1, 2);
    plot(1:length(cost_history), cost_history, '-o');
    xlabel('İterasyon');
    ylabel('ITAE Maliyeti');
    title('ITAE Maliyet Fonksiyonunun Azalması');
    grid on;

    % Optimize edilmiş PID ile sistem yanıtı
    s = tf('s');
    PID = pid_history(end, 1) * (1 + 1/(pid_history(end, 2)*s) + pid_history(end, 3)*s);
    T = feedback(PID * G, 1);
    figure;
    step(T);
    title('Optimize Edilmiş PID ile Adım Yanıtı');
    grid on;
end
