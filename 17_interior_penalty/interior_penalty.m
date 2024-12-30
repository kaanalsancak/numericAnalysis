function interior_penalty_method_with_results_table_figs()
    % Define the initial feasible point
    x = [1.5; 1.5]; % Initial guess within the feasible region
    mu = 1000; % Initial penalty parameter
    c = 0.1; % Penalty reduction constant
    N = 5; % Maximum number of iterations
    epsilon = 1e-6; % Small offset for numerical stability
    epsilon1 = 1e-6; % Relative change in objective function tolerance
    epsilon2 = 1e-6; % Change in variables tolerance
    epsilon4 = 1e-6; % Change in variables squared sum tolerance

    % Define the constraints
    g1 = @(x1, x2) -x1 + 1;
    g2 = @(x1, x2) -x2;

    % Ensure initial point is feasible
    if g1(x(1), x(2)) >= 0 || g2(x(1), x(2)) >= 0
        error('Initial point is not feasible. Ensure g1 < 0 and g2 < 0.');
    end

    % Define the objective function
    f = @(x1, x2) (1/3) * (x1 + 1)^3 + x2;

    % Define the penalized objective function
    P = @(x, mu) f(x(1), x(2)) - mu * (1/g1(x(1), x(2)) + 1/g2(x(1), x(2)));

    % Store results for plotting and table
    results = struct('mu', [], 'x1', [], 'x2', [], 'g1', [], 'g2', [], 'f', [], 'P', []);

    % Optimization loop
    previous_x = x; % Initialize the previous solution
    for j = 1:N
        % Minimize penalized function
        options = optimset('Display', 'off'); % Suppress optimization output
        penalized_obj = @(x) P(x, mu);
        x = fmincon(penalized_obj, x, [], [], [], [], [], [], @(x) nonlin_con(x, g1, g2), options);

        % Evaluate values for storage
        g1_val = g1(x(1), x(2));
        g2_val = g2(x(1), x(2));
        f_val = f(x(1), x(2));
        P_val = penalized_obj(x);

        % Store results
        results.mu(end + 1) = mu;
        results.x1(end + 1) = x(1);
        results.x2(end + 1) = x(2);
        results.g1(end + 1) = g1_val;
        results.g2(end + 1) = g2_val;
        results.f(end + 1) = f_val;
        results.P(end + 1) = P_val;

        % Check stopping criteria
        % 1. Relative change in objective function
        if j > 1 && abs(f_val - results.f(end-1)) / f_val <= epsilon1
            disp('Stopping: Relative change in objective function is small.');
            break;
        end

        % 2. Change in decision variables
        if norm(x - previous_x) <= epsilon2
            disp('Stopping: Change in variables is small.');
            break;
        end

        % 3. Change in decision variables squared sum
        delX = x - previous_x;
        if norm(delX) <= epsilon4
            disp('Stopping: Change in variables is very small.');
            break;
        end

        % Update penalty parameter
        mu = c * mu;

        % Update previous x for the next iteration
        previous_x = x;
    end

    % Visualize results
    visualize_results(results, f);
end

function [c, ceq] = nonlin_con(x, g1, g2)
    % Nonlinear constraints
    c = [g1(x(1), x(2)); g2(x(1), x(2))];
    ceq = [];
end

function visualize_results(results, f)
    % Visualize results
    figure;
    hold on;

    % Plot the original objective function
    x1_vals = linspace(-1, 2, 100); % x1 range
    x2_fixed = results.x2(end); % Use the final x2 value for visualization
    f_vals = arrayfun(@(x1) f(x1, x2_fixed), x1_vals);
    plot(x1_vals, f_vals, 'k--', 'LineWidth', 2, 'DisplayName', 'Orijinal Fonksiyon');

    % Plot the penalized functions for each iteration
    for i = 1:length(results.mu)
        penalized_obj = @(x1) f(x1, results.x2(i)) - results.mu(i) * ...
            (1/(-x1 + 1) + 1/(-results.x2(i)));
        penalized_vals = arrayfun(penalized_obj, x1_vals);
        plot(x1_vals, penalized_vals, 'DisplayName', sprintf('Iterasyon %d', i));
    end

    % Highlight the optimum point
    plot(results.x1(end), results.f(end), 'ro', 'MarkerSize', 10, 'DisplayName', 'Optimum Nokta');

    % Add labels, legend, and grid
    xlabel('x1');
    ylabel('Fonksiyon Değeri');
    title('Ceza Fonksiyonları ve Orijinal Fonksiyon');
    legend show;
    grid on;
    hold off;
end
