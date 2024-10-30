clc
clear all

% length of road birim metre
l = 0.05;

% termal conductivity
k_prime = 54;

% speecific heat of the road
c = 490;

% density of the metarial
density = 7800;

% Boundary temperature 1
T1 = 100;

% Boundary temperature 2
T2 = 25;

% Initial temperature
Ti = 20;

% number of division 
n = 5;

% end time of analysis
t = 9;

% time Step
dt = 0.1;

% calculcating number of step
runs = t/dt + 1;

% step size of length
dx = l/n;

% alpha = thermal diffusivity
alpha = k_prime/(c * density);

% Relaxation factor
lambda = alpha*dt/(dx)^2;
% lambda = 0.4239;
% programming the excplicit method
% hangi indisin hangi uzunluğa denk geleceği Hesaplanmış
for i=1 : 1 : n+1
    L(i) = (i-1)*dx;
end
T = zeros(runs,n+1);

%Sınır koşullarının atanması
for i=1 : 1 : runs
    T(i,1) = T1;
    T(i,n+1) = T2;
end

% Initial condition tanımlamaları
for j=2 : 1 : n
    T(1,j) = Ti;
end

%  programming excplicit method
for j=1:1:runs-1
    for i=2:1:n
        T(j+1,i) = T(j,i) + lambda*( T(j,i+1) -(2*T(j,i)) + T(j,i-1));
    end    
end

% loop record the movie

for j= 0:1:runs-1
    for i=1:1:n+1
        T_M(i)= T(j+1,i);
    end
    plot(L,T_M);
    xlabel('Length of the roadUtils')
    ylabel('Temperature')
    legend(['Time = ' num2str(j*dt)])
    title('recording movie')
    frames(j+1) = getframe;
end
save frames
title('Movie being played back')
movie(frames)
