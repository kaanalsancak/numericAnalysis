clc
clear all

l   = 2.4;
w   = 3.0;
T_L = 75.0;
T_R = 100.0;
T_T = 300.0;
T_B = 50.0;

dx  = 0.6;
dy  = 0.6;

tol = 1;

m = l/dx;
n = w/dy;

A = zeros((n-1)*(n-1), (m-1)*(n-1));
B = zeros((n-1)*(n-1), 1);

T = zeros(n+1,m+1);

count = 0;

for i=1:1:n+1
    for j=1:1:m+1
        if(i == 1)
        T(i,j) = T_B;
        end
        if(i == n+1)
            T(i,j) = T_T;
        end
        if(j ==1)
            T(i,j) = T_L;
        end
        if(j ==m+1)
            T(i,j) = T_R;
        end
    end
end

iteration =0;
disp(sprintf('Temperature distubution after iteration %g', iteration))
disp(T)
count = (m-1)*(n-1);

while(count>0)
    count=0;
    for i=2:1:n
        for j=2:1:m
        old = T(i,j);
        T(i,j)= (T(i+1,j)+T(i-1,j)+T(i,j+1)+T(i,j-1))/4;
        epsa(i,j)=  abs( (T(i,j)-old)/T(i,j) *100 );

        if epsa(i,j)>tol
            count = count+1;
        end
        end
    end
    iteration = iteration +1;
    disp(sprintf('Temperature distubution after iteration %g', iteration))

    for i =1: 1:n+1
        for j=1:1:m+1
            T_Display(i,j) = T(n+1-i+1,j);
        end
    end

    for i=2:1:n
        for j=2:1:m
            epsa_display(i,j) = epsa(n+1-i+1,j);
        end
    end


    disp('T=');
    disp(T_Display);
    
    disp('Absolute ralative percentage error at each node');
    disp('epsa=');
    disp(epsa_display);

end

L=0:dx:l;
W=0:dy:w;

figure(1)
h=surf(L,W,T);view(2)
shading interp
grid on
colorbar


