% ------------------------------------------------------------------------
% Author: Muhammet Kaan Alsancak
% email address: alsancak.mk@gmail.com 
% Date: 2024/10/22 - 19:12
% ------------------------------------------------------------------------
% Golden Section Search Metodu ile Optimizasyon Algoritması


% ------------------------------------------------------------------------
% Author: Muhammet Kaan Alsancak
% email address: alsancak.mk@gmail.com 
% Date: 2024/10/22 - 19:12
% ------------------------------------------------------------------------
% Newton Metodu ile Optimizasyon Algoritması

clc 
clear all

% optimize edilmesi ggereken fonksiyon
A = @(theta)4*sin(theta)*(1+cos(theta)); 

% Lower Limit of interval
xlow =0;

% Upper Limit of Interval
xup = pi/2;
epsilon = 0.05;

disp('Golden Section Search Optimizasyon Algoritması');

range = 10*epsilon;

iteration =0;

while(range > epsilon)

    iteration = iteration+1;
    d = (sqrt(5)-1)/2*(xup-xlow);

    % calculating x1 point
    x1= xlow+d;
    
    % calculating x2 point
    x2= xup-d;

    % calculating f(x1)
    val1 = A(x1);

    % calculating f(x2)
    val2 = A(x2);

    % storing intervals as an array
    interval =[xlow xup];

    % calculating range of the interval
    range = xup - xlow;

    % calculating optimization point
    optimization_point = (xup+xlow)/2;

    fprintf("\n Iteraton number = %g",iteration);
    fprintf("\n search interval  = ");
    disp(interval)
    fprintf("\n Optimization Point = %g\n\n\n",optimization_point);

    if(val1>val2)
        xlow=x2;
        x2=x1;
        % xup = xup;
        d = (sqrt(5)-1)/2*(xup-xlow);
        x1 = x1+d;
    end
    if(val1<val2)
        xup=x1;
        x1 = x2;
        d = (sqrt(5)-1)/2*(xup-xlow);
        x2 = x2+d;
    end

end