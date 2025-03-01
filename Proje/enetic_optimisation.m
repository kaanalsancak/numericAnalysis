% DC Motor Parametreleri
J = 0.01;  % Atalet momenti
b = 0.1;   % Sürtünme katsayısı
K = 0.01;  % Motor sabiti
R = 1;     % Direnç
L = 0.5;   % Endüktans

% Transfer fonksiyonu (DC motor)
s = tf('s');
G = K / ((J*s + b)*(L*s + R) + K^2);

% Hedef parametreler
target_settling_time = 0.1; % Hedef yerleşme süresi (saniye)
overshoot_limit = 20;     % Maksimum aşım (%)

% Genetik algoritma parametreleri
pop_size = 50;            % Popülasyon büyüklüğü
max_gen = 100;            % Maksimum jenerasyon
mutation_rate = 0.2;      % Mutasyon oranı
crossover_rate = 0.8;     % Çaprazlama oranı
range_Kp = [0, 100];      % Kp aralığı
range_Ki = [0, 50];       % Ki aralığı

% Rastgele başlangıç popülasyonu
population = [rand(pop_size, 1) * diff(range_Kp) + range_Kp(1), ...
              rand(pop_size, 1) * diff(range_Ki) + range_Ki(1)];

% Başlangıç en iyi değerler
best_cost = Inf;
best_params = [];

% Optimizasyon döngüsü
for gen = 1:max_gen
    % Fitness değerlerini hesapla
    fitness = zeros(pop_size, 1);
    for i = 1:pop_size
        Kp = population(i, 1);
        Ki = population(i, 2);
        fitness(i) = calculate_cost_ga(Kp, Ki, G, target_settling_time, overshoot_limit);
    end
    
    % En iyi bireyi sakla
    [current_best_cost, best_idx] = min(fitness);
    if current_best_cost < best_cost
        best_cost = current_best_cost;
        best_params = population(best_idx, :);
    end
    
    % Çaprazlama işlemi
    new_population = zeros(size(population));
    for i = 1:2:pop_size
        if rand < crossover_rate
            % İki birey seç
            parents_idx = randperm(pop_size, 2);
            parent1 = population(parents_idx(1), :);
            parent2 = population(parents_idx(2), :);
            
            % Çaprazlama (arithmetic crossover)
            alpha = rand;
            child1 = alpha * parent1 + (1 - alpha) * parent2;
            child2 = (1 - alpha) * parent1 + alpha * parent2;
            
            % Çocukları yeni popülasyona ekle
            new_population(i, :) = child1;
            if i + 1 <= pop_size
                new_population(i + 1, :) = child2;
            end
        else
            % Çaprazlama olmadan bireyleri kopyala
            new_population(i, :) = population(i, :);
            if i + 1 <= pop_size
                new_population(i + 1, :) = population(i + 1, :);
            end
        end
    end
    
    % Mutasyon işlemi
    for i = 1:pop_size
        if rand < mutation_rate
            % Rastgele bir gen seç ve mutasyon uygula
            mut_gene = randi(2); % 1: Kp, 2: Ki
            if mut_gene == 1
                new_population(i, 1) = rand * diff(range_Kp) + range_Kp(1);
            else
                new_population(i, 2) = rand * diff(range_Ki) + range_Ki(1);
            end
        end
    end
    
    % Yeni popülasyonu güncelle
    population = new_population;
    
    % İlerlemeyi yazdır
    fprintf('Jenerasyon %d - En iyi maliyet: %.3f (Kp: %.3f, Ki: %.3f)\n', ...
        gen, best_cost, best_params(1), best_params(2));
end

% En iyi sonucu yazdır
fprintf('Optimizasyon tamamlandı: \n');
fprintf('En iyi maliyet: %.3f\n', best_cost);
fprintf('Kp: %.3f, Ki: %.3f\n', best_params(1), best_params(2));

% Optimize edilmiş PI kontrolcünün step yanıtı
C_opt = best_params(1) + best_params(2)/s;
T_opt = feedback(C_opt*G, 1);
figure;
step(T_opt);
title('Optimize Edilmiş PI Kontrolcü Step Yanıtı');
grid on;

% Yardımcı Fonksiyonlar
function J = calculate_cost_ga(Kp, Ki, G, target_settling_time, overshoot_limit)
    try
        % PI kontrolcüyü oluştur
        s = tf('s');
        C = Kp + Ki/s;
        T = feedback(C*G, 1);

        % Step yanıtı bilgilerini al
        info = stepinfo(T);

        % Yerleşme süresi ve overshoot değerlerini kontrol et
        settling_time = info.SettlingTime;
        overshoot = info.Overshoot;

        % Hata kontrolü
        if isnan(settling_time) || isnan(overshoot) || settling_time > 10
            J = Inf; % Geçersiz değerler için maliyet yüksek yapılır
        else
            % Maliyet fonksiyonunu hesapla
            J = abs(settling_time - target_settling_time) + ...
                (overshoot > overshoot_limit) * 100;
        end
    catch
        % Eğer herhangi bir hata varsa maliyeti yüksek yap
        J = Inf;
    end
end
