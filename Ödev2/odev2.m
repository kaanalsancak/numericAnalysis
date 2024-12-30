function exterior_penalty_optimization()
    % Kullanıcıdan iterasyon sayısını al
    max_iterations = input('Lütfen iterasyon sayısını girin: ');

    % Başlangıç parametreleri
    x = [-0.5; 0.5]; % Başlangıç noktası [x1, x2]
    r = 10; % Ceza katsayısı
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
    % Tüm iterasyon sonuçlarını grafikleştirme
    iterations = [results.iteration];
    x1_vals = [results.x1];
    x2_vals = [results.x2];
    f_vals = [results.f];
    penalties = [results.penalty];

    figure;

    subplot(2, 2, 1);
    plot(iterations, x1_vals, '-o');
    xlabel('İterasyon'); ylabel('x1');
    title('x1 Değişimi');

    subplot(2, 2, 2);
    plot(iterations, x2_vals, '-o');
    xlabel('İterasyon'); ylabel('x2');
    title('x2 Değişimi');

    subplot(2, 2, 3);
    plot(iterations, f_vals, '-o');
    xlabel('İterasyon'); ylabel('f(x1, x2)');
    title('Hedef Fonksiyon Değeri');

    subplot(2, 2, 4);
    plot(iterations, penalties, '-o');
    xlabel('İterasyon'); ylabel('Ceza Fonksiyonu');
    title('Ceza Fonksiyonu Değişimi');

    % Değerleri tablo olarak göster
    fprintf('\nIterasyon Sonuçları:\n');
    fprintf('Iterasyon\tx1\tx2\tf(x1,x2)\tCeza\n');
    for i = 1:length(results)
        fprintf('%d\t\t%.4f\t%.4f\t%.4f\t%.4f\n', results(i).iteration, results(i).x1, results(i).x2, results(i).f, results(i).penalty);
    end
end
