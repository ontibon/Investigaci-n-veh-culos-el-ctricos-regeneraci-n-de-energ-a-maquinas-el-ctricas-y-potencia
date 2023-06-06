clc;
close all;
clear all;
M = xlsread('199.xlsx');

t=M(:,1);
vel=M(:,3);
volt=M(:,4);

fs = 1/(t(3)-t(2)); %2e5;         % Frecuencia de muestreo
fc = 0.5;           % Frecuencia de corte
orden = 2;         % Orden del filtro

% Crear objeto filtro
filtro = designfilt('lowpassiir','FilterOrder',orden,'HalfPowerFrequency',fc,'SampleRate',fs);
filtro_vel = designfilt('lowpassiir','FilterOrder',orden,'HalfPowerFrequency',0.2,'SampleRate',fs);

vel_fil = filter(filtro_vel, vel);
volt_fil = filter(filtro, volt);

vel_fil=vel_fil+100;
vel_fil(vel_fil<0) = 0;
volt_fil(volt_fil<0) = 0;

VELOCIDAD=vel_fil;
REFERENCIA=volt_fil*(1800/(120*sqrt(2)));

figure;
a=plot(t,REFERENCIA,t,VELOCIDAD);
grid on;
title('Referencia (RPM) y Velocidad (RPM)');
xlabel(['Tiempo (s)']);
ylabel('RPM');

