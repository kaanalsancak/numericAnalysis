clc;
clear;

% Malzeme özellikleri
ElasticModulus = 207e9; % Elastisite modülü (Pa)
PoissonRatio = 0.3;     % Poisson oranı

% Parçalı fonksiyonun tanımı için sembolik değişkenler
syms Radius Coef0 Coef1 Coef2 Coef3 Coef4

% Parçalı yer değiştirme fonksiyonu tanımlanıyor.
% Bu fonksiyon, farklı radyal bölgelerdeki yer değiştirme değerlerini ifade eder.
DisplacementFunction = piecewise(...
    0.25 <= Radius & Radius <= 0.33, Coef0 + Coef1*Radius, ...
    0.33 < Radius & Radius <= 0.4167, Coef0 + 0.33*Coef1 - 0.33*Coef2 + Coef2*Radius, ...
    0.4167 < Radius & Radius <= 0.5, Coef0 + 0.33*Coef1 - 0.33*Coef2 + 0.4167*Coef2 - 0.4167*Coef4 + Coef4*Radius);

% Yer değiştirme fonksiyonunun türevi (du/dr) hesaplanıyor.
% Bu türev, radyal yöndeki deformasyonu temsil eder.
DisplacementDerivative = diff(DisplacementFunction, Radius);

% (1) İlk integral: (du/dr)^2 * r
% Bu integral, radyal türevin karesinin radyal simetri ile ağırlıklandırılmasını içerir.
% Fiziksel anlamı: Elastik deformasyon enerjisinin katkısını ifade eder.
Integral1 = int((DisplacementDerivative)^2 * Radius, Radius, 0.25, 0.5);

% (2) İkinci integral: (du/dr) * u
% Bu integral, radyal türevin yer değiştirme ile çarpımını içerir.
% Fiziksel anlamı: Poisson etkisi enerjisinin katkısını ifade eder.
Integral2 = int(DisplacementDerivative * DisplacementFunction, Radius, 0.25, 0.5);
Integral2 = 2 * PoissonRatio * Integral2; % Poisson oranı ile çarpılır.

% (3) Üçüncü integral: u^2 / r
% Bu integral, yer değiştirme fonksiyonunun karesinin radyal simetri ile ağırlıklandırılmasını ifade eder.
% Fiziksel anlamı: Radyal gerilme enerjisinin katkısını ifade eder.
Integral3 = int(DisplacementFunction^2 / Radius, Radius, 0.25, 0.5);

% Sabitlerin malzeme özelliklerine göre çarpımı
% Elastisite modülü ve Poisson oranı kullanılarak enerji bileşenleri hesaplanır.
Integral1 = ElasticModulus / (2 * (1 - PoissonRatio^2)) * Integral1;
Integral2 = ElasticModulus / (2 * (1 - PoissonRatio^2)) * Integral2;
Integral3 = ElasticModulus / (2 * (1 - PoissonRatio^2)) * Integral3;

% (4) Toplam enerji fonksiyonu
% Üç enerji bileşeninin toplamı ile toplam elastik enerji hesaplanır.
TotalEnergy = Integral1 + Integral2 + Integral3;

% Kenar koşulları: Sistemin başlangıç koşulları veya sınır yüklemelerini temsil eder.
BoundaryCondition = 0.25 * (200e6) * (Coef0 + Coef1 * 0.25);
TotalEnergy = TotalEnergy - BoundaryCondition;

% Radyal simetrinin etkisi toplam enerjiye eklenir.
TotalEnergy = 2 * pi * 0.25 * TotalEnergy;

% (5) Enerjinin kısmi türevleri (∂I/∂Ci)
% Enerji minimizasyonu için her sabitin türevleri hesaplanır.
PartialDerivatives = [diff(TotalEnergy, Coef0); diff(TotalEnergy, Coef1); ...
                      diff(TotalEnergy, Coef2); diff(TotalEnergy, Coef4)];

% (6) Denklem sistemi oluşturuluyor
% Enerji minimizasyonundan elde edilen denklemler çözülür.
Equations = PartialDerivatives == 0;

% (7) Sabitlerin çözümü
% Sabitlerin analitik çözümü bulunur.
Solutions = solve(Equations, [Coef0, Coef1, Coef2, Coef4]);

% Çözümleri sayısal değerlere dönüştürme
Constants = structfun(@vpa, Solutions, 'UniformOutput', false);

% Güncellenmiş yer değiştirme fonksiyonu
% Yeni sabitlerle optimize edilmiş yer değiştirme fonksiyonu oluşturulur.
OptimizedDisplacement = piecewise(...
    0.25 <= Radius & Radius <= 0.33, Constants.Coef0 + Constants.Coef1*Radius, ...
    0.33 < Radius & Radius <= 0.4167, Constants.Coef0 + 0.33*Constants.Coef1 - 0.33*Constants.Coef2 + Constants.Coef2*Radius, ...
    0.4167 < Radius & Radius <= 0.5, Constants.Coef0 + 0.33*Constants.Coef1 - 0.33*Constants.Coef2 + 0.4167*Constants.Coef2 - 0.4167*Constants.Coef4 + Constants.Coef4*Radius);

% Güncellenmiş fonksiyonun türevi (du/dr)
% Optimize edilmiş yer değiştirme fonksiyonunun türevi hesaplanır.
OptimizedDisplacementDerivative = diff(OptimizedDisplacement, Radius);

% Gerilme hesaplamaları
% Radyal ve çevresel gerilmeler hesaplanır.
RadialStress = (ElasticModulus / (1 - PoissonRatio^2)) * (OptimizedDisplacementDerivative + PoissonRatio * OptimizedDisplacement / Radius);
CircumferentialStress = (ElasticModulus / (1 - PoissonRatio^2)) * (OptimizedDisplacementDerivative * PoissonRatio + OptimizedDisplacement / Radius);

% Belirli noktalardaki değerlerin hesaplanması
% Radyal mesafelerde gerilmeler ve yer değiştirmeler hesaplanır.
RadiusValues = [0.250001, 0.375, 0.4999999];
RadialStressValues = double(subs(RadialStress, Radius, RadiusValues));
CircumferentialStressValues = double(subs(CircumferentialStress, Radius, RadiusValues));
DisplacementValues = double(subs(OptimizedDisplacement, Radius, RadiusValues));

% Sonuçların yazdırılması
% Sabitler, gerilmeler ve yer değiştirmeler kullanıcıya sunulur.
disp('Constants :');
disp(Constants);
disp('Radial Stress (Pa):');
disp(RadialStressValues);
disp('Circumferential Stress (Pa):');
disp(CircumferentialStressValues);
disp('Displacement Values (m):');
disp(DisplacementValues);