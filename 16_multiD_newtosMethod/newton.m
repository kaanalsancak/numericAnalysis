% Newton Algoritması
% Newton yöntemini uygulamak için bir fonksiyon

function [X, iterations, trajectory] = newton(X0, gradient, epsilon)
    iterations = 0; % Başlangıçta iterasyon sayısı 0
    max_iterations = 1000; % Maksimum iterasyon sayısı
    X = X0; % Başlangıç noktası
    trajectory = X; % Trajektoryayı başlangıç noktasıyla başlat

    % Newton yöntemi döngüsü
    while norm(gradient(X(1), X(2))) > epsilon && iterations < max_iterations
        % Hessian matrisi tanımlanıyor
        Hessian = [1200*X(1)^2 - 400*X(2) + 2, -400*X(1);
                   -400*X(1), 200];
        % X'in güncellenmesi (Newton adımı)
        X = X - inv(Hessian) * gradient(X(1), X(2));
        % Trajektoryaya yeni X değeri ekleniyor
        trajectory = [trajectory, X];
        % İterasyon sayısı artırılıyor
        iterations = iterations + 1;
    end
end