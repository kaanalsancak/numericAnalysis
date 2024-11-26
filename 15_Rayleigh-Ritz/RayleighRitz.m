clc;
clear;

% Malzeme özellikleri
E = 207e9; % Elastisite modülü (Pa)
v = 0.3;   % Poisson oranı

% Parçalı fonksiyonun tanımı
syms r C0 C1 C2 C3 C4

u = piecewise(...
    0.25 <= r & r <= 0.33, C0 + C1*r, ...
    0.33 < r & r <= 0.4167, (C0 + 0.33*C1 - 0.33*C2 + C2*r), ...
    0.4167 < r & r <= 0.5, (C0 + 0.33*C1 - 0.33*C2 + 0.4167*C2 - 0.4167*C4 + C4*r));

% Türevi (du/dr)
du_dr = diff(u, r);

% (1) Integral of (du/dr)^2 * r
I1 = int((du_dr)^2 * r, r, 0.25, 0.5);

% (2) Integral of (du/dr) * u
I2 = int(du_dr * u, r, 0.25, 0.5);
I2 = 2 * v * I2;

% (3) Integral of u^2 / r
I3 = int(u^2 / r, r, 0.25, 0.5);

% Sabitlerin uygulanması
I1 = E / (2 * (1 - v^2)) * I1;
I2 = E / (2 * (1 - v^2)) * I2;
I3 = E / (2 * (1 - v^2)) * I3;

% (4) Toplam integral
I_total = I1 + I2 + I3;
I_total = I_total - 0.25 * (200e6) * (C0 + C1 * 0.25);
I_total = 2 * pi * 0.25 * I_total;

% (5) Kısmi türevler
dI_dC = [diff(I_total, C0); diff(I_total, C1); diff(I_total, C2); diff(I_total, C4)];

% (6) Denklem sistemi
eqs = dI_dC == 0;

% (7) Sabitlerin çözümü
sol = solve(eqs, [C0, C1, C2, C4]);

% Çözümleri sayısal değerlere dönüştür
C = structfun(@vpa, sol, 'UniformOutput', false);

% Güncellenmiş u fonksiyonu
u_optimized = piecewise(...
    0.25 <= r & r <= 0.33, C.C0 + C.C1*r, ...
    0.33 < r & r <= 0.4167, C.C0 + 0.33*C.C1 - 0.33*C.C2 + C.C2*r, ...
    0.4167 < r & r <= 0.5, C.C0 + 0.33*C.C1 - 0.33*C.C2 + 0.4167*C.C2 - 0.4167*C.C4 + C.C4*r);

% Türevi (du/dr)
du_dr_optimized = diff(u_optimized, r);

% Gerilme hesaplamaları
sigma_r = (E / (1 - v^2)) * (du_dr_optimized + v * u_optimized / r);
sigma_theta = (E / (1 - v^2)) * (du_dr_optimized * v + u_optimized / r);

% Belirli noktalardaki değerler
r_vals = [0.250001, 0.375, 0.4999999];
sigma_r_vals = double(subs(sigma_r, r, r_vals));
sigma_theta_vals = double(subs(sigma_theta, r, r_vals));
u_displacements = double(subs(u_optimized, r, r_vals));

% Sonuçları yazdır
disp('Sabit Değerler:');
disp(C);
disp('Radial Gerilmeler (Pa):');
disp(sigma_r_vals);
disp('Çevresel Gerilmeler (Pa):');
disp(sigma_theta_vals);
disp('Yer Değiştirmeler (m):');
disp(u_displacements);
