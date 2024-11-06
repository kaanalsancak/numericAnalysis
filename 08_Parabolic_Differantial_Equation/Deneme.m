clc
clear all

% Length of road in meters
l = 0.05;

% Thermal conductivity
k_prime = 54;

% Specific heat of the road
c = 490;

% Density of the material
density = 7800;

% Boundary temperatures
T1 = 100;
T2 = 25;

% Initial temperature
Ti = 20;

% Number of divisions
n = 5;

% End time of analysis
t = 9;

% Time step
dt = 3;

% Calculate number of steps
runs = t/dt + 1;

% Step size of length
dx = l/n;

% Thermal diffusivity
alpha = k_prime / (c * density);

% Relaxation factor
lambda = alpha * dt / (dx)^2;

% Initialize the length array
for i = 1:n+1
    L(i) = (i-1) * dx;
end

% Initialize temperature matrix
T = zeros(runs, n+1);

% Set boundary conditions
for i = 1:runs
    T(i,1) = T1;
    T(i,n+1) = T2;
end

% Set initial condition
for j = 2:n
    T(1,j) = Ti;
end

% Crank-Nicolson method
for j = 1:runs-1
    % Create matrix and constants for the Crank-Nicolson system
    A = zeros(n-1, n-1);
    b = zeros(n-1, 1);
    
    for i = 2:n
        k = i - 1;
        if k == 1
            A(k,k) = 1 + lambda;
            A(k,k+1) = -lambda/2;
            b(k) = (lambda/2)*T(j,i-1) + (1 - lambda)*T(j,i) + (lambda/2)*T(j,i+1);
        elseif k == n-1
            A(k,k-1) = -lambda/2;
            A(k,k) = 1 + lambda;
            b(k) = (lambda/2)*T(j,i-1) + (1 - lambda)*T(j,i) + (lambda/2)*T(j,i+1);
        else
            A(k,k-1) = -lambda/2;
            A(k,k) = 1 + lambda;
            A(k,k+1) = -lambda/2;
            b(k) = (lambda/2)*T(j,i-1) + (1 - lambda)*T(j,i) + (lambda/2)*T(j,i+1);
        end
    end
    
    % Solve for the next time step's temperature
    sol = A\b;
    for i = 2:n
        T(j+1,i) = sol(i-1);
    end
end

% Plot the results and record frames for the movie
for j = 0:runs-1
    for i = 1:n+1
        T_M(i) = T(j+1,i);
    end
    plot(L, T_M);
    xlabel('Length of the road (m)');
    ylabel('Temperature (°C)');
    legend(['Time = ' num2str(j*dt) ' s']);
    title('Temperature Distribution');
    frames(j+1) = getframe;
end
save frames
title('Movie being played back')
movie(frames)
