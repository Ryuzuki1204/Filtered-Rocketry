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

pow = bandpower(a, fs, [0 (N-1)*fs/(2*N)]);

powdb = 10*log10(pow);

noisy_a = awgn(a, 35, powdb);

plot(t, noisy_a);