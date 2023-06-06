clc;
close all;
clear all;
set(groot,'defaultFigureWindowState','maximized');
load('DatosFreSinControl.mat');

%Referencia RPM
%Velocidad RPM
%Deslizamiento %
%Potencia Reactiva VA
%Potencia Activa W
%Overshoot Potencia Activa %

%Tiempo Regeneración s
%Energia Regenerativa Ws
%Energia mismo intervalo de tiempo respecto a consumo final Ws
%Porcentaje Regeneracion respecto intervalo final %


%% VACIO
load('DatosFreSinControl.mat');
A=FreVacioSinControl;

Ref_Fre = A(:, 1);
Vel_Fre = A(:, 2);
S_Fre = A(:, 3);
Q_Fre = A(:, 4);
P_Fre = A(:, 5);
Ov_P_Fre = A(:, 6);

M =csvread("Plots Time SC/SDS2104X Plus_CSV_ALL_36.csv",12,0);
t=M(:,1);
t=t-t(1);
Apot=M(:,2);
vel=M(:,3);
volt=M(:,4);
filtro_length = 20;
filtro = ones(1, filtro_length)/filtro_length;
filtro1 = ones(1, 200)/200;
Apot = conv(Apot, filtro, 'same');
vel = conv(vel, filtro1, 'same');
volt = conv(volt, filtro, 'same');
% Definir las características del filtro
fs = 1/(t(3)-t(2)); %2e5;         % Frecuencia de muestreo
fc = 50;           % Frecuencia de corte
orden = 2;         % Orden del filtro
filtro = designfilt('lowpassiir','FilterOrder',orden,'HalfPowerFrequency',fc,'SampleRate',fs);
filtro1 = designfilt('lowpassiir','FilterOrder',orden,'HalfPowerFrequency',20,'SampleRate',fs);
Apot_fil = filter(filtro, Apot);
vel_fil = filter(filtro1, vel);
volt_fil = filter(filtro, volt);
vel_fil=vel_fil+100;
referencia=volt_fil*(1800/(120*sqrt(2)))-20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color','white','Name','Opal');
subplot(2,2,[1 3]);
plot(Ref_Fre, Vel_Fre, 'r-', 'LineWidth', 1.5);
hold on;
plot(Ref_Fre, Ref_Fre, 'b--', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Velocity [W]');
title('Velocity');
Var_limite=Vel_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
legend('Velocity','Reference');
grid on;

subplot(2,2,2);
plot(Ref_Fre, S_Fre, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Slip [%]');
title('Slip (Braking)');
Var_limite=S_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,4);
hold on;
plot(t, vel_fil, 'LineWidth', 1.5, 'Color', 'g');
hold on;
plot(t, referencia, 'LineWidth', 1.5, 'Color', 'b');
xlabel('Time (s)');
ylabel('Velocity [RPM]');
title('Velocity vs Time');
legend('Velocity','Reference');
xlim([min(t)+t(500),max(t)-t(1000)]);
grid on;

sgtitle('No-load Velocity (Braking)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color','white','Name','Opal');
subplot(2,2,1);
plot(Ref_Fre, P_Fre, 'r-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Active Power [W]');
title('Active Power');
Var_limite=P_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,2);
plot(Ref_Fre, Ov_P_Fre, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Overshoot Active Power [%]');
title('Overshoot Active Power Braking');
Var_limite=Ov_P_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,4);
hold on;
plot(t, Apot_fil, 'LineWidth', 1.5, 'Color', 'g');
xlabel('Time (s)');
ylabel('Active Power [W]');
title('Active Power vs Time');
xlim([min(t)+t(500),max(t)-t(1000)]);
grid on;

subplot(2,2,3);
plot(Ref_Fre, Q_Fre, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Reactive Power [VA]');
title('Reactive Power (Braking)');
Var_limite=Q_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

sgtitle('No-load Powers (Braking)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_Rege = A(:, 7);
E_Rege = A(:, 8);
E_Cons = A(:, 9);
Por_Rege = A(:, 10);

figure('Color','white','Name','Opal');
subplot(2,2,1);
plot(Ref_Fre, T_Rege, 'r-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Regeneration time [s]');
title('Regeneration Time');
Var_limite=T_Rege;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,2);
plot(Ref_Fre, E_Rege, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Regenerative Energy [Ws]');
title('Regenerative Energy');
Var_limite=E_Rege;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,3);
hold on;
plot(Ref_Fre, E_Cons, 'LineWidth', 1.5, 'Color', 'g');
xlabel('Reference [rpm]');
ylabel('Energy normal period [Ws]');
title('Energy normal period');
Var_limite=E_Cons;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,4);
plot(Ref_Fre, Por_Rege, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Percentage of regeneration [%]');
title('Percentage of regeneration');
Var_limite=Por_Rege;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

sgtitle('No-load Energies');


%% 0.5NM
load('DatosFreSinControl.mat');
M =csvread("Plots Time SC/SDS2104X Plus_CSV_ALL_62.csv",12,0);
A=Fre05NMSinControl;

Ref_Fre = A(:, 1);
Vel_Fre = A(:, 2);
S_Fre = A(:, 3);
Q_Fre = A(:, 4);
P_Fre = A(:, 5);
Ov_P_Fre = A(:, 6);

t=M(:,1);
t=t-t(1);
Apot=M(:,2);
vel=M(:,3);
volt=M(:,4);
filtro_length = 20;
filtro = ones(1, filtro_length)/filtro_length;
filtro1 = ones(1, 200)/200;
Apot = conv(Apot, filtro, 'same');
vel = conv(vel, filtro1, 'same');
volt = conv(volt, filtro, 'same');
% Definir las características del filtro
fs = 1/(t(3)-t(2)); %2e5;         % Frecuencia de muestreo
fc = 50;           % Frecuencia de corte
orden = 2;         % Orden del filtro
filtro = designfilt('lowpassiir','FilterOrder',orden,'HalfPowerFrequency',fc,'SampleRate',fs);
filtro1 = designfilt('lowpassiir','FilterOrder',orden,'HalfPowerFrequency',20,'SampleRate',fs);
Apot_fil = filter(filtro, Apot);
vel_fil = filter(filtro1, vel);
volt_fil = filter(filtro, volt);
vel_fil=vel_fil+100;
referencia=volt_fil*(1800/(120*sqrt(2)))-20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color','white','Name','Opal');
subplot(2,2,[1 3]);
plot(Ref_Fre, Vel_Fre, 'r-', 'LineWidth', 1.5);
hold on;
plot(Ref_Fre, Ref_Fre, 'b--', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Velocity [W]');
title('Velocity');
Var_limite=Vel_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
legend('Velocity','Reference');
grid on;

subplot(2,2,2);
plot(Ref_Fre, S_Fre, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Slip [%]');
title('Slip (Braking)');
Var_limite=S_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,4);
hold on;
plot(t, vel_fil, 'LineWidth', 1.5, 'Color', 'g');
hold on;
plot(t, referencia, 'LineWidth', 1.5, 'Color', 'b');
xlabel('Time (s)');
ylabel('Velocity [RPM]');
title('Velocity vs Time');
legend('Velocity','Reference');
xlim([min(t)+t(500),max(t)-t(1000)]);
grid on;

sgtitle('0.5 NM Velocity (Braking)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color','white','Name','Opal');
subplot(2,2,1);
plot(Ref_Fre, P_Fre, 'r-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Active Power [W]');
title('Active Power');
Var_limite=P_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,2);
plot(Ref_Fre, Ov_P_Fre, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Overshoot Active Power [%]');
title('Overshoot Active Power Braking');
Var_limite=Ov_P_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,4);
hold on;
plot(t, Apot_fil, 'LineWidth', 1.5, 'Color', 'g');
xlabel('Time (s)');
ylabel('Active Power [W]');
title('Active Power vs Time');
xlim([min(t)+t(500),max(t)-t(1000)]);
grid on;

subplot(2,2,3);
plot(Ref_Fre, Q_Fre, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Reactive Power [VA]');
title('Reactive Power (Braking)');
Var_limite=Q_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

sgtitle('0.5 NM Powers (Braking)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_Rege = A(:, 7);
E_Rege = A(:, 8);
E_Cons = A(:, 9);
Por_Rege = A(:, 10);

figure('Color','white','Name','Opal');
subplot(2,2,1);
plot(Ref_Fre, T_Rege, 'r-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Regeneration time [s]');
title('Regeneration Time');
Var_limite=T_Rege;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,2);
plot(Ref_Fre, E_Rege, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Regenerative Energy [Ws]');
title('Regenerative Energy');
Var_limite=E_Rege;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,3);
hold on;
plot(Ref_Fre, E_Cons, 'LineWidth', 1.5, 'Color', 'g');
xlabel('Reference [rpm]');
ylabel('Energy normal period [Ws]');
title('Energy normal period');
Var_limite=E_Cons;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,4);
plot(Ref_Fre, Por_Rege, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Percentage of regeneration [%]');
title('Percentage of regeneration');
Var_limite=Por_Rege;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

sgtitle('0.5 NM Energies');

%% -0.5NM
load('DatosFreSinControl.mat');
M =csvread("Plots Time SC/SDS2104X Plus_CSV_ALL_106.csv",12,0);
A=FreM05NMSinControl;

Ref_Fre = A(:, 1);
Vel_Fre = A(:, 2);
S_Fre = A(:, 3);
Q_Fre = A(:, 4);
P_Fre = A(:, 5);
Ov_P_Fre = A(:, 6);

t=M(:,1);
t=t-t(1);
Apot=M(:,2);
vel=M(:,3);
volt=M(:,4);
filtro_length = 20;
filtro = ones(1, filtro_length)/filtro_length;
filtro1 = ones(1, 200)/200;
Apot = conv(Apot, filtro, 'same');
vel = conv(vel, filtro1, 'same');
volt = conv(volt, filtro, 'same');
% Definir las características del filtro
fs = 1/(t(3)-t(2)); %2e5;         % Frecuencia de muestreo
fc = 50;           % Frecuencia de corte
orden = 2;         % Orden del filtro
filtro = designfilt('lowpassiir','FilterOrder',orden,'HalfPowerFrequency',fc,'SampleRate',fs);
filtro1 = designfilt('lowpassiir','FilterOrder',orden,'HalfPowerFrequency',20,'SampleRate',fs);
Apot_fil = filter(filtro, Apot);
vel_fil = filter(filtro1, vel);
volt_fil = filter(filtro, volt);
vel_fil=vel_fil+100;
referencia=volt_fil*(1800/(120*sqrt(2)))-20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color','white','Name','Opal');
subplot(2,2,[1 3]);
plot(Ref_Fre, Vel_Fre, 'r-', 'LineWidth', 1.5);
hold on;
plot(Ref_Fre, Ref_Fre, 'b--', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Velocity [W]');
title('Velocity');
Var_limite=Vel_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
legend('Velocity','Reference');
grid on;

subplot(2,2,2);
plot(Ref_Fre, S_Fre, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Slip [%]');
title('Slip (Braking)');
Var_limite=S_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,4);
hold on;
plot(t, vel_fil, 'LineWidth', 1.5, 'Color', 'g');
hold on;
plot(t, referencia, 'LineWidth', 1.5, 'Color', 'b');
xlabel('Time (s)');
ylabel('Velocity [RPM]');
title('Velocity vs Time');
legend('Velocity','Reference');
xlim([min(t)+t(500),max(t)-t(1000)]);
grid on;

sgtitle('-0.5 NM Velocity (Braking)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color','white','Name','Opal');
subplot(2,2,1);
plot(Ref_Fre, P_Fre, 'r-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Active Power [W]');
title('Active Power');
Var_limite=P_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,2);
plot(Ref_Fre, Ov_P_Fre, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Overshoot Active Power [%]');
title('Overshoot Active Power Braking');
Var_limite=Ov_P_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,4);
hold on;
plot(t, Apot_fil, 'LineWidth', 1.5, 'Color', 'g');
xlabel('Time (s)');
ylabel('Active Power [W]');
title('Active Power vs Time');
xlim([min(t)+t(500),max(t)-t(1000)]);
grid on;

subplot(2,2,3);
plot(Ref_Fre, Q_Fre, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Reactive Power [VA]');
title('Reactive Power (Braking)');
Var_limite=Q_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

sgtitle('-0.5 NM Powers (Braking)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_Rege = A(:, 7);
E_Rege = A(:, 8);
E_Cons = A(:, 9);
Por_Rege = A(:, 10);

figure('Color','white','Name','Opal');
subplot(2,2,1);
plot(Ref_Fre, T_Rege, 'r-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Regeneration time [s]');
title('Regeneration Time');
Var_limite=T_Rege;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,2);
plot(Ref_Fre, E_Rege, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Regenerative Energy [Ws]');
title('Regenerative Energy');
Var_limite=E_Rege;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,3);
hold on;
plot(Ref_Fre, E_Cons, 'LineWidth', 1.5, 'Color', 'g');
xlabel('Reference [rpm]');
ylabel('Energy normal period [Ws]');
title('Energy normal period');
Var_limite=E_Cons;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,4);
plot(Ref_Fre, Por_Rege, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Percentage of regeneration [%]');
title('Percentage of regeneration');
Var_limite=Por_Rege;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

sgtitle('-0.5 NM Energies*');

%% 0.1NM
load('DatosFreSinControl.mat');
M =csvread("Plots Time SC/SDS2104X Plus_CSV_ALL_141.csv",12,0);
A=Fre01NMSinControl;

Ref_Fre = A(:, 1);
Vel_Fre = A(:, 2);
S_Fre = A(:, 3);
Q_Fre = A(:, 4);
P_Fre = A(:, 5);
Ov_P_Fre = A(:, 6);

t=M(:,1);
t=t-t(1);
Apot=M(:,2);
vel=M(:,3);
volt=M(:,4);
filtro_length = 20;
filtro = ones(1, filtro_length)/filtro_length;
filtro1 = ones(1, 200)/200;
Apot = conv(Apot, filtro, 'same');
vel = conv(vel, filtro1, 'same');
volt = conv(volt, filtro, 'same');
% Definir las características del filtro
fs = 1/(t(3)-t(2)); %2e5;         % Frecuencia de muestreo
fc = 50;           % Frecuencia de corte
orden = 2;         % Orden del filtro
filtro = designfilt('lowpassiir','FilterOrder',orden,'HalfPowerFrequency',fc,'SampleRate',fs);
filtro1 = designfilt('lowpassiir','FilterOrder',orden,'HalfPowerFrequency',20,'SampleRate',fs);
Apot_fil = filter(filtro, Apot);
vel_fil = filter(filtro1, vel);
volt_fil = filter(filtro, volt);
vel_fil=vel_fil+100;
referencia=volt_fil*(1800/(120*sqrt(2)))-20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color','white','Name','Opal');
subplot(2,2,[1 3]);
plot(Ref_Fre, Vel_Fre, 'r-', 'LineWidth', 1.5);
hold on;
plot(Ref_Fre, Ref_Fre, 'b--', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Velocity [W]');
title('Velocity');
Var_limite=Vel_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
legend('Velocity','Reference');
grid on;

subplot(2,2,2);
plot(Ref_Fre, S_Fre, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Slip [%]');
title('Slip (Braking)');
Var_limite=S_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,4);
hold on;
plot(t, vel_fil, 'LineWidth', 1.5, 'Color', 'g');
hold on;
plot(t, referencia, 'LineWidth', 1.5, 'Color', 'b');
xlabel('Time (s)');
ylabel('Velocity [RPM]');
title('Velocity vs Time');
legend('Velocity','Reference');
xlim([min(t)+t(500),max(t)-t(1000)]);
grid on;

sgtitle('0.1 NM Velocity (Braking)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color','white','Name','Opal');
subplot(2,2,1);
plot(Ref_Fre, P_Fre, 'r-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Active Power [W]');
title('Active Power');
Var_limite=P_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,2);
plot(Ref_Fre, Ov_P_Fre, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Overshoot Active Power [%]');
title('Overshoot Active Power Braking');
Var_limite=Ov_P_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,4);
hold on;
plot(t, Apot_fil, 'LineWidth', 1.5, 'Color', 'g');
xlabel('Time (s)');
ylabel('Active Power [W]');
title('Active Power vs Time');
xlim([min(t)+t(500),max(t)-t(1000)]);
grid on;

subplot(2,2,3);
plot(Ref_Fre, Q_Fre, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Reactive Power [VA]');
title('Reactive Power (Braking)');
Var_limite=Q_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

sgtitle('0.1 NM Powers (Braking)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_Rege = A(:, 7);
E_Rege = A(:, 8);
E_Cons = A(:, 9);
Por_Rege = A(:, 10);

figure('Color','white','Name','Opal');
subplot(2,2,1);
plot(Ref_Fre, T_Rege, 'r-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Regeneration time [s]');
title('Regeneration Time');
Var_limite=T_Rege;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,2);
plot(Ref_Fre, E_Rege, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Regenerative Energy [Ws]');
title('Regenerative Energy');
Var_limite=E_Rege;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,3);
hold on;
plot(Ref_Fre, E_Cons, 'LineWidth', 1.5, 'Color', 'g');
xlabel('Reference [rpm]');
ylabel('Energy normal period [Ws]');
title('Energy normal period');
Var_limite=E_Cons;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,4);
plot(Ref_Fre, Por_Rege, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Percentage of regeneration [%]');
title('Percentage of regeneration');
Var_limite=Por_Rege;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

sgtitle('0.1 NM Energies');

%% -0.1NM
load('DatosFreSinControl.mat');
M =csvread("Plots Time SC/SDS2104X Plus_CSV_ALL_182.csv",12,0);
A=FreM01NMSinControl;

Ref_Fre = A(:, 1);
Vel_Fre = A(:, 2);
S_Fre = A(:, 3);
Q_Fre = A(:, 4);
P_Fre = A(:, 5);
Ov_P_Fre = A(:, 6);

t=M(:,1);
t=t-t(1);
Apot=M(:,2);
vel=M(:,3);
volt=M(:,4);
filtro_length = 20;
filtro = ones(1, filtro_length)/filtro_length;
filtro1 = ones(1, 200)/200;
Apot = conv(Apot, filtro, 'same');
vel = conv(vel, filtro1, 'same');
volt = conv(volt, filtro, 'same');
% Definir las características del filtro
fs = 1/(t(3)-t(2)); %2e5;         % Frecuencia de muestreo
fc = 50;           % Frecuencia de corte
orden = 2;         % Orden del filtro
filtro = designfilt('lowpassiir','FilterOrder',orden,'HalfPowerFrequency',fc,'SampleRate',fs);
filtro1 = designfilt('lowpassiir','FilterOrder',orden,'HalfPowerFrequency',20,'SampleRate',fs);
Apot_fil = filter(filtro, Apot);
vel_fil = filter(filtro1, vel);
volt_fil = filter(filtro, volt);
vel_fil=vel_fil+100;
referencia=volt_fil*(1800/(120*sqrt(2)))-20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color','white','Name','Opal');
subplot(2,2,[1 3]);
plot(Ref_Fre, Vel_Fre, 'r-', 'LineWidth', 1.5);
hold on;
plot(Ref_Fre, Ref_Fre, 'b--', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Velocity [W]');
title('Velocity');
Var_limite=Vel_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
legend('Velocity','Reference');
grid on;

subplot(2,2,2);
plot(Ref_Fre, S_Fre, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Slip [%]');
title('Slip (Braking)');
Var_limite=S_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,4);
hold on;
plot(t, vel_fil, 'LineWidth', 1.5, 'Color', 'g');
hold on;
plot(t, referencia, 'LineWidth', 1.5, 'Color', 'b');
xlabel('Time (s)');
ylabel('Velocity [RPM]');
title('Velocity vs Time');
legend('Velocity','Reference');
xlim([min(t)+t(500),max(t)-t(1000)]);
grid on;

sgtitle('-0.1 NM Velocity (Braking)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color','white','Name','Opal');
subplot(2,2,1);
plot(Ref_Fre, P_Fre, 'r-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Active Power [W]');
title('Active Power');
Var_limite=P_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,2);
plot(Ref_Fre, Ov_P_Fre, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Overshoot Active Power [%]');
title('Overshoot Active Power Braking');
Var_limite=Ov_P_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,4);
hold on;
plot(t, Apot_fil, 'LineWidth', 1.5, 'Color', 'g');
xlabel('Time (s)');
ylabel('Active Power [W]');
title('Active Power vs Time');
xlim([min(t)+t(500),max(t)-t(1000)]);
grid on;

subplot(2,2,3);
plot(Ref_Fre, Q_Fre, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Reactive Power [VA]');
title('Reactive Power (Braking)');
Var_limite=Q_Fre;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

sgtitle('-0.1 NM Powers (Braking)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_Rege = A(:, 7);
E_Rege = A(:, 8);
E_Cons = A(:, 9);
Por_Rege = A(:, 10);

figure('Color','white','Name','Opal');
subplot(2,2,1);
plot(Ref_Fre, T_Rege, 'r-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Regeneration time [s]');
title('Regeneration Time');
Var_limite=T_Rege;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,2);
plot(Ref_Fre, E_Rege, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Regenerative Energy [Ws]');
title('Regenerative Energy');
Var_limite=E_Rege;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,3);
hold on;
plot(Ref_Fre, E_Cons, 'LineWidth', 1.5, 'Color', 'g');
xlabel('Reference [rpm]');
ylabel('Energy normal period [Ws]');
title('Energy normal period');
Var_limite=E_Cons;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

subplot(2,2,4);
plot(Ref_Fre, Por_Rege, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Percentage of regeneration [%]');
title('Percentage of regeneration');
Var_limite=Por_Rege;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Fre),max(Ref_Fre)]);
grid on;

sgtitle('-0.1 NM Energies');