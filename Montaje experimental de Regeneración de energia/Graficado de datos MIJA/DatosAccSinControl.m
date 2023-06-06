clc;
close all;
clear all;
set(groot,'defaultFigureWindowState','maximized');

%Referencia RPM
%Velocidad RPM
%Deslizamiento %
%Potencia Reactiva VA
%Potencia Activa W
%Overshoot Potencia Activa %

%% VACIO
load('DatosAccSinControl.mat');
A=AccVacioSinControl;

Ref_Acc = A(:, 1);
Vel_Acc = A(:, 2);
S_Acc = A(:, 3);
Q_Acc = A(:, 4);
P_Acc = A(:, 5);
Ov_P_Acc = A(:, 6);

M =csvread("Plots Time SC/SDS2104X Plus_CSV_ALL_33.csv",12,0);
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
referencia=volt_fil*(1800/(120*sqrt(2)))+20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color','white','Name','Opal');
subplot(2,2,[1 3]);
plot(Ref_Acc, Vel_Acc, 'r-', 'LineWidth', 1.5);
hold on;
plot(Ref_Acc, Ref_Acc, 'b--', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Velocity [W]');
title('Velocity');
Var_limite=Vel_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
legend('Velocity','Reference');
grid on;

subplot(2,2,2);
plot(Ref_Acc, S_Acc, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Slip [%]');
title('Slip (Acceleration)');
Var_limite=S_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
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

sgtitle('No-load Velocity (Acceleration)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color','white','Name','Opal');
subplot(2,2,1);
plot(Ref_Acc, P_Acc, 'r-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Active Power [W]');
title('Active Power');
Var_limite=P_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
grid on;

subplot(2,2,2);
plot(Ref_Acc, Ov_P_Acc, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Overshoot Active Power [%]');
title('Overshoot Active Power Acceleration');
Var_limite=Ov_P_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
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
plot(Ref_Acc, Q_Acc, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Reactive Power [VA]');
title('Reactive Power (Acceleration)');
Var_limite=Q_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
grid on;

sgtitle('No-load Powers (Acceleration)');

%% 0.5NM
load('DatosAccSinControl.mat');
M =csvread("Plots Time SC/SDS2104X Plus_CSV_ALL_58.csv",12,0);
A=Acc05NMSinControl;

Ref_Acc = A(:, 1);
Vel_Acc = A(:, 2);
S_Acc = A(:, 3);
Q_Acc = A(:, 4);
P_Acc = A(:, 5);
Ov_P_Acc = A(:, 6);

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
referencia=volt_fil*(1800/(120*sqrt(2)))+20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color','white','Name','Opal');
subplot(2,2,[1 3]);
plot(Ref_Acc, Vel_Acc, 'r-', 'LineWidth', 1.5);
hold on;
plot(Ref_Acc, Ref_Acc, 'b--', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Velocity [W]');
title('Velocity');
Var_limite=Vel_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
legend('Velocity','Reference');
grid on;

subplot(2,2,2);
plot(Ref_Acc, S_Acc, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Slip [%]');
title('Slip (Acceleration)');
Var_limite=S_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
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

sgtitle('0.5 NM Velocity (Acceleration)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color','white','Name','Opal');
subplot(2,2,1);
plot(Ref_Acc, P_Acc, 'r-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Active Power [W]');
title('Active Power');
Var_limite=P_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
grid on;

subplot(2,2,2);
plot(Ref_Acc, Ov_P_Acc, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Overshoot Active Power [%]');
title('Overshoot Active Power Acceleration');
Var_limite=Ov_P_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
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
plot(Ref_Acc, Q_Acc, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Reactive Power [VA]');
title('Reactive Power (Acceleration)');
Var_limite=Q_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
grid on;

sgtitle('0.5 NM Powers (Acceleration)');

%% -0.5NM
load('DatosAccSinControl.mat');
M =csvread("Plots Time SC/SDS2104X Plus_CSV_ALL_100.csv",12,0);
A=AccM05NMSinControl;

Ref_Acc = A(:, 1);
Vel_Acc = A(:, 2);
S_Acc = A(:, 3);
Q_Acc = A(:, 4);
P_Acc = A(:, 5);
Ov_P_Acc = A(:, 6);

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
referencia=volt_fil*(1800/(120*sqrt(2)))+20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color','white','Name','Opal');
subplot(2,2,[1 3]);
plot(Ref_Acc, Vel_Acc, 'r-', 'LineWidth', 1.5);
hold on;
plot(Ref_Acc, Ref_Acc, 'b--', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Velocity [W]');
title('Velocity');
Var_limite=Vel_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
legend('Velocity','Reference');
grid on;

subplot(2,2,2);
plot(Ref_Acc, S_Acc, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Slip [%]');
title('Slip (Acceleration)');
Var_limite=S_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
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

sgtitle('-0.5 NM Velocity (Acceleration)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color','white','Name','Opal');
subplot(2,2,1);
plot(Ref_Acc, P_Acc, 'r-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Active Power [W]');
title('Active Power');
Var_limite=P_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
grid on;

subplot(2,2,2);
plot(Ref_Acc, Ov_P_Acc, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Overshoot Active Power [%]');
title('Overshoot Active Power Acceleration');
Var_limite=Ov_P_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
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
plot(Ref_Acc, Q_Acc, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Reactive Power [VA]');
title('Reactive Power (Acceleration)');
Var_limite=Q_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
grid on;

sgtitle('-0.5 NM Powers (Acceleration)');

%% -0.1NM
load('DatosAccSinControl.mat');
M =csvread("Plots Time SC/SDS2104X Plus_CSV_ALL_137.csv",12,0);
A=Acc01NMSinControl;

Ref_Acc = A(:, 1);
Vel_Acc = A(:, 2);
S_Acc = A(:, 3);
Q_Acc = A(:, 4);
P_Acc = A(:, 5);
Ov_P_Acc = A(:, 6);

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
plot(Ref_Acc, Vel_Acc, 'r-', 'LineWidth', 1.5);
hold on;
plot(Ref_Acc, Ref_Acc, 'b--', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Velocity [W]');
title('Velocity');
Var_limite=Vel_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
legend('Velocity','Reference');
grid on;

subplot(2,2,2);
plot(Ref_Acc, S_Acc, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Slip [%]');
title('Slip (Acceleration)');
Var_limite=S_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
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

sgtitle('0.1 NM Velocity (Acceleration)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color','white','Name','Opal');
subplot(2,2,1);
plot(Ref_Acc, P_Acc, 'r-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Active Power [W]');
title('Active Power');
Var_limite=P_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
grid on;

subplot(2,2,2);
plot(Ref_Acc, Ov_P_Acc, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Overshoot Active Power [%]');
title('Overshoot Active Power Acceleration');
Var_limite=Ov_P_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
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
plot(Ref_Acc, Q_Acc, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Reactive Power [VA]');
title('Reactive Power (Acceleration)');
Var_limite=Q_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
grid on;

sgtitle('0.1 NM Powers (Acceleration)');

%% -0.1NM
load('DatosAccSinControl.mat');
M =csvread("Plots Time SC/SDS2104X Plus_CSV_ALL_175.csv",12,0);
A=AccM01NMSinControl;

Ref_Acc = A(:, 1);
Vel_Acc = A(:, 2);
S_Acc = A(:, 3);
Q_Acc = A(:, 4);
P_Acc = A(:, 5);
Ov_P_Acc = A(:, 6);

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
plot(Ref_Acc, Vel_Acc, 'r-', 'LineWidth', 1.5);
hold on;
plot(Ref_Acc, Ref_Acc, 'b--', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Velocity [W]');
title('Velocity');
Var_limite=Vel_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
legend('Velocity','Reference');
grid on;

subplot(2,2,2);
plot(Ref_Acc, S_Acc, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Slip [%]');
title('Slip (Acceleration)');
Var_limite=S_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
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

sgtitle('-0.1 NM Velocity (Acceleration)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color','white','Name','Opal');
subplot(2,2,1);
plot(Ref_Acc, P_Acc, 'r-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Active Power [W]');
title('Active Power');
Var_limite=P_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
grid on;

subplot(2,2,2);
plot(Ref_Acc, Ov_P_Acc, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Overshoot Active Power [%]');
title('Overshoot Active Power Acceleration');
Var_limite=Ov_P_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
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
plot(Ref_Acc, Q_Acc, 'b-', 'LineWidth', 1.5);
xlabel('Reference [rpm]');
ylabel('Reactive Power [VA]');
title('Reactive Power (Acceleration)');
Var_limite=Q_Acc;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([min(Ref_Acc),max(Ref_Acc)]);
grid on;

sgtitle('-0.1 NM Powers (Acceleration)');