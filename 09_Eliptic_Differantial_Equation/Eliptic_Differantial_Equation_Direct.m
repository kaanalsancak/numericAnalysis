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

m = l/dx;
n = w/dy;

A = zeros((n-1)*(n-1), (m-1)*(n-1));
B = zeros((n-1)*(n-1), 1);
count = 0;

% creating coef matrix
for i = 1:1:(m-1)*(n-1)
    j=i;
    count = count+1;
    A(i,j) = -4;
    if(count~=1)
        A(i,j-1)=1;
    end
    if(count~=n-1)
        A(i,j+1)=1;
    end
    if( (j+n-1) <= ((m-1)*(n-1)) )
        A(i,j+n-1)=1;
    end
    if(j-n+1>0)
        A(i,j-n+1) =1;
    end
    if(count == n-1)
        count =0;
    end
end

count =0;
% creating right side matrix
for i=1:1:m-1
    for j=1:1:n-1
        count= count+1;
        temp1 =0;
        temp2 =0;

        if(i-1==0)
            temp1 = T_L;
        elseif(i+1 == m)
            temp1=T_R;
        end
        
        if(j-1 == 0)
            temp2 = T_T;
        elseif(j+1 ==n)
            temp2= T_B;
        end
        B(count,1) =-(temp1+ temp2);
    end
end

sol =A\B;

count =0;

% Assigning the solution temperatures
for i=1:1:m-1
    for j=1:1:n-1
       count= count+1;
       T_interal (i,j) = sol(count,1);
    end
end
T_interal = transpose(T_interal);

% Creating a matrix with both

for i=1:1:n+1
    for j=1:1:m+1
        if(i==1)
            T(i,j)=T_T;
        elseif(i== n+1)
            T(i,j)=T_B;
        elseif(j== 1)
            T(i,j)=T_L;
        elseif(j== m+1)
            T(i,j)=T_R;
        else
             T(i,j)=0;
        end
    end
end

for i=1:1:n-1
    for j=1:1:m-1
        T(i+1,j+1) = T_interal(i,j);
    end
end

L=0:dx:l;
W=0:dy:w;

figure(1)
h=surf(L,W,T);view(2)
shading interp
grid on
colorbar
