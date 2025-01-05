function exterior_penalty_optimization()
    % Kullanıcıdan iterasyon sayısını al
    max_iterations = input('Lütfen iterasyon sayısını girin: ');

    % Başlangıç parametreleri
    x = [-0.5; 0.5]; % Başlangıç noktası [x1, x2]
    r = 1; % Ceza katsayısı
    r_increment = 10; % Ceza katsayısı artış oranı
    tolerance = 1e-6; % Durdurma kriteri

    % Sonuçları depolamak için
    results = struct('iteration', [], 'x1', [], 'x2', [], 'f', [], 'penalty', []);

    % Optimizasyon başlıyor
    for iter = 1:max_iterations
        % Ceza fonksiyonunu optimize et
        options = optimoptions('fminunc', 'Display', 'iter', 'Algorithm', 'quasi-newton');
        penalty_function = @(x) objective_with_penalty(x, r);
        [x, fval] = fminunc(penalty_function, x, options);

        % Kısıtları hesapla
        g1 = max(0, -x(1) + 1);
        g2 = max(0, -x(2));

        % Sonuçları kaydet
        results(iter).iteration = iter;
        results(iter).x1 = x(1);
        results(iter).x2 = x(2);
        results(iter).f = fval;
        results(iter).penalty = r * (g1^2 + g2^2);

        % Ceza katsayısını artır
        r = r * r_increment;

        % Durdurma kriteri
        if abs(results(iter).penalty) < tolerance
            fprintf('Optimizasyon durduruldu: Ceza fonksiyonu sıfıra yaklaştı.\n');
            break;
        end
    end

    % Sonuçları görselleştir
    visualize_results(results);
end

function f = objective_with_penalty(x, r)
    % Orijinal hedef fonksiyonu
    f_original = (1/3) * (x(1) + 1)^3 + x(2);

    % Ceza fonksiyonu
    g1 = max(0, -x(1) + 1);
    g2 = max(0, -x(2));
    penalty = r * (g1^2 + g2^2);

    % Ceza fonksiyonunu ekle
    f = f_original + penalty;
end

function visualize_results(results)
    % Her iterasyon için ceza katsayısının etkisini gösteren grafikler çizimi
    figure;
    hold on;

    % Orijinal hedef fonksiyonunu çiz
    x = linspace(-1, 2, 100); % x1 değerleri aralığı
    f_original = @(x1) (1/3) * (x1 + 1).^3;
    plot(x, f_original(x), 'k--', 'LineWidth', 2, 'DisplayName', 'Orijinal Fonksiyon');

    % Tüm iterasyonlar boyunca ceza fonksiyonlarını çiz
    for i = 1:length(results)
        penalty_function = @(x1) objective_with_penalty([x1; results(i).x2], 10^(i-1)); % Ceza fonksiyonu
        y = arrayfun(penalty_function, x);

        % Grafik çizimi
        plot(x, y, 'DisplayName', sprintf('Iterasyon %d (r = %d)', results(i).iteration, 10^(i-1)));
    end

    % Optimum noktayı işaretle ve dikey çizgi ekle
    x_optimum = results(end).x1; % Optimum x1 değeri
    plot([x_optimum x_optimum], ylim, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Barier'); % Dikey çizgi

    % Optimum noktayı işaretle
    plot(results(end).x1, results(end).f, 'ro', 'MarkerSize', 10, 'DisplayName', 'Optimum Nokta');

    % Grafik ayarları
    xlabel('x1'); ylabel('Fonksiyon Değeri');
    title('Ceza Fonksiyonları ve Orijinal Fonksiyon');
    legend show;
    grid on;
    hold off;

    % Değerleri tablo olarak göster
    fprintf('\nIterasyon Sonuçları:\n');
    fprintf('Iterasyon\tx1\t\t\tx2\t\tf(x1,x2)\t\tCeza\n');
    for i = 1:length(results)
        fprintf('%d\t\t%.8f\t%.8f\t%.8f\t%.8f\n', results(i).iteration, results(i).x1, results(i).x2, results(i).f, results(i).penalty);
    end
end
