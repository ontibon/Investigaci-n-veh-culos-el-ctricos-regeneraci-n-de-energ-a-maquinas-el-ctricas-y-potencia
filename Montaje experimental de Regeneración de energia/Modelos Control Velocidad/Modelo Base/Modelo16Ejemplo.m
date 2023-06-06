clc;
close all;
clear all;
M = xlsread('16.xlsx');

t=M(:,1);
t=t-t(1);

vel=M(:,3);
volt=M(:,4);

fs = 1/(t(3)-t(2)); %2e5;         % Frecuencia de muestreo
fc = 50;           % Frecuencia de corte
orden = 2;         % Orden del filtro
filtro = designfilt('lowpassiir','FilterOrder',orden,'HalfPowerFrequency',fc,'SampleRate',fs);

vel_fil = filter(filtro, vel);
volt_fil = filter(filtro, volt);

Ref_bajo=1774.6;
Vel_Bajo=1732.69;

figure;
hold on;
a=plot(t,volt_fil*(1800/(120*sqrt(2)))-Ref_bajo,t,vel_fil+100-Vel_Bajo);
grid on;
title('Referencia (RPM) y Velocidad (RPM)');
xlabel(['Tiempo (s)']);
ylabel('RPM');

%%%%%%%%%%MODELO%%%%%%%%%%%%%%%%
K1=0.9546;
Tao=0.019;
Retardo=0.026;
modelo=tf([K1],[Tao 1],'OutputDelay',Retardo)

[Y,T]=step(modelo*156.57);
T=T+1.026;
plot(T,Y);

%%%PARA METER SEGUNDO ORDEN modelado como amortiguado

modelo=zpk(modelo)
p1=cell2mat(modelo.P); %Como esta en formato de celda se pasa a mat
p2=p1*10;

%Teorema del valor final(s=0)
K2=K1*p1*p2;

modelo2=zpk([],[p1 p2],K2,'OutputDelay',Retardo)
[Y,T]=step(modelo2*156.57);
T=T+1.026;
plot(T,Y);

%%%%%%Control
Kp = 0.502;
Ki = 21.7;