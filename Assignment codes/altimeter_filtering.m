clear all
clc

mat = readtable('2020-10-10-serial-6667-flight-0001.csv');
fs = 100;

a = table2array(mat(67:3863,11));
a = transpose(a);
N = size(a);
t = [0];

for i = 2:N(2)
    t(i) = t(i - 1) + 0.01;
end 

%Distorting the readings by adding some AWGN
pow = bandpower(a, fs, [0 (N-1)*fs/(2*N)]);
powdb = 10*log10(pow);
noisy_a = awgn(a, 40, powdb);
%plot(t, noisy_a);

filter9_func = fir1(9,0.1); %A 9th order filter with a 
filter7_func = fir1(7,0.1);

%filter9_designer = [-0.1342 0.0707 0.1355 0.2089 0.2567 0.2567 0.2089 0.1355 0.0707 -0.1342];

filter5_iir_num = [0.0048    0.0193    0.0289    0.0193    0.0048];
filter5_iir_denom = [1.0000   -2.3695    2.3140   -1.0547    0.1874];

a1 = [];
a2 = [];
a3 = [];

for i = 1:N(2)
    sum1 = 0;
    sum2 = 0;
    sum3 = 0;
    
    for j = 1:10
        if i - j + 1 < 1
            sum1 = sum1 + filter9_func(j)*noisy_a(1);
            %sum2 = sum2 + filter9_designer(j)*noisy_a(1);   
        else
            sum1 = sum1 + filter9_func(j)*noisy_a(i - j + 1);
            %sum2 = sum2 + filter9_designer(j)*noisy_a(i - j + 1);
        end
    end
    
    for j = 1:8
        if i - j + 1 < 1
            sum2 = sum2 + filter7_func(j)*noisy_a(1);
            %sum2 = sum2 + filter9_designer(j)*noisy_a(1);   
        else
            sum2 = sum2 + filter7_func(j)*noisy_a(i - j + 1);
            %sum2 = sum2 + filter9_designer(j)*noisy_a(i - j + 1);
        end
    end
    
    for j = 1:5
        if i - j + 1 < 1
            sum3 = sum3 + filter5_iir_num(j)*noisy_a(1) + filter5_iir_denom(j)*noisy_a(1);
            %sum2 = sum2 + filter9_designer(j)*noisy_a(1);   
        else
           sum3 = sum3 + filter5_iir_num(j)*noisy_a(i - j + 1); 
        end
    end
    
    for j = 1:4
        if i - j < 1
            sum3 = sum3 - filter5_iir_denom(j+1)*noisy_a(1);
        else
            sum3 = sum3 - filter5_iir_denom(j+1)*a3(i - j);
        end
    end
   
    a1(i) = sum1;
    a2(i) = sum2;
    a3(i) = sum3;
end

% noise1 = a1 - a;
% noise2 = a2 - a;
% 
% snr(a1,noise1)
% snr(a2,noise2)

subplot(2,2,1)
plot(t,noisy_a);
title('Distorted input signal')

subplot(2,2,2)
plot(t,a1);
title('Ninth order FIR filter')

subplot(2,2,3)
plot(t,a2);
title('Seventh order FIR filter')

subplot(2,2,4)
plot(t,a3);
title('Fourth order IIR filter')
