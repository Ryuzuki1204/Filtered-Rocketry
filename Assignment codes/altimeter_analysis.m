clear all
clc

mat = readtable('2020-10-10-serial-6667-flight-0001.csv');
fs = 100;
%Loading the data
% t1 = table2array(mat(67:3863,5)); 
% a1 = table2array(mat(67:3863,11));
% 
% fs = 100;
% N = size(t1);
% 
% %Cleaning the data to ensure that we have only one reading per time step
% t = []; a = [];
% j = 1;
% 
% for i = 2:N(1)
%     if t1(i) ~= t1(int16(i-1)) && t1(i) - t1(int16(i - 1)) < 0.011
%         t(j) = t1(i);
%         a(j) = a1(i);
%         j = j + 1;
%     elseif t1(i) - t1(int16(i - 1)) > 0.011
%             i
%             break
%     else
%         continue
%     end
% end

a = table2array(mat(67:3863,11));
a = transpose(a);
N = size(a);
t = [0];

for i = 2:N(2)
    t(i) = t(i - 1) + 0.01;
end 

f = -fs/2 : 1/t(N(2)) : fs/2;
afft = 20*log10(abs(fftshift(fft(a)/N(2))));

%plot(t,a);
plot(f,afft);
