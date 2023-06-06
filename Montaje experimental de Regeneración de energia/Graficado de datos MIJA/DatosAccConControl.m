clc;
close all;
clear all;
set(groot,'defaultFigureWindowState','maximized');
load('DatosAccConControl.mat');

%Referencia RPM
%Velocidad RPM
%Deslizamiento %
%Potencia Reactiva VA
%Potencia Activa W
%Overshoot Potencia Activa %

%% VACIO
load('DatosAccConControl.mat');
A=AccVacioConControl;

Ref_Acc = A(:, 1);
Vel_Acc = A(:, 2);
S_Acc = A(:, 3);
Q_Acc = A(:, 4);
P_Acc = A(:, 5);
Ov_P_Acc = A(:, 6);

load('Plots Time CC/SinCarga (18).mat');
t = data(:, 1);
t=t-t(1);
Ref_Vel = data(:, 3)*180; %Referencia de velocidad (RPM)
Vel = data(:, 4)*180; %Velocidad (RPM)
P_Act = data(:, 7)*80; %Potencia Activa (W)
% Aplicar filtro 
filtro_length = 20;
filtro = ones(1, filtro_length)/filtro_length;
Vel = conv(Vel, filtro, 'same');
P_Act = conv(P_Act, filtro, 'same');
% Definir las características del filtro
fs = 1/(t(3)-t(2)); %2e5;         % Frecuencia de muestreo
fc = 20;           % Frecuencia de corte
orden = 2;         % Orden del filtro
filtro = designfilt('lowpassiir','FilterOrder',orden,'HalfPowerFrequency',fc,'SampleRate',fs);
Vel = filter(filtro, Vel);
P_Act = filter(filtro, P_Act);
numDatosEliminar = 1000;
t = t(numDatosEliminar+1:end-numDatosEliminar);
referencia = Ref_Vel(numDatosEliminar+1:end-numDatosEliminar);
vel_fil = Vel(numDatosEliminar+1:end-numDatosEliminar);
Apot_fil = P_Act(numDatosEliminar+1:end-numDatosEliminar);

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
M =csvread("Plots Time SC/SDS2104X Plus_CSV_ALL_58.csv",12,0);
load('DatosAccConControl.mat');
A=Acc05NMConControl;

Ref_Acc = A(:, 1);
Vel_Acc = A(:, 2);
S_Acc = A(:, 3);
Q_Acc = A(:, 4);
P_Acc = A(:, 5);
Ov_P_Acc = A(:, 6);

load('Plots Time CC/ConCarga05 (15).mat');
t = data(:, 1);
t=t-t(1);
Ref_Vel = data(:, 3)*180; %Referencia de velocidad (RPM)
Vel = data(:, 4)*180; %Velocidad (RPM)
P_Act = data(:, 7)*80; %Potencia Activa (W)
% Aplicar filtro 
filtro_length = 20;
filtro = ones(1, filtro_length)/filtro_length;
Vel = conv(Vel, filtro, 'same');
P_Act = conv(P_Act, filtro, 'same');
% Definir las características del filtro
fs = 1/(t(3)-t(2)); %2e5;         % Frecuencia de muestreo
fc = 20;           % Frecuencia de corte
orden = 2;         % Orden del filtro
filtro = designfilt('lowpassiir','FilterOrder',orden,'HalfPowerFrequency',fc,'SampleRate',fs);
Vel = filter(filtro, Vel);
P_Act = filter(filtro, P_Act);
numDatosEliminar = 1000;
t = t(numDatosEliminar+1:end-numDatosEliminar);
referencia = Ref_Vel(numDatosEliminar+1:end-numDatosEliminar);
vel_fil = Vel(numDatosEliminar+1:end-numDatosEliminar);
Apot_fil = P_Act(numDatosEliminar+1:end-numDatosEliminar);

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
M =csvread("Plots Time SC/SDS2104X Plus_CSV_ALL_100.csv",12,0);
load('DatosAccConControl.mat');
A=AccM05NMConControl;

Ref_Acc = A(:, 1);
Vel_Acc = A(:, 2);
S_Acc = A(:, 3);
Q_Acc = A(:, 4);
P_Acc = A(:, 5);
Ov_P_Acc = A(:, 6);

load('Plots Time CC/ConCargaM05 (16).mat');
t = data(:, 1);
t=t-t(1);
Ref_Vel = data(:, 3)*180; %Referencia de velocidad (RPM)
Vel = data(:, 4)*180; %Velocidad (RPM)
P_Act = data(:, 7)*80; %Potencia Activa (W)
% Aplicar filtro 
filtro_length = 20;
filtro = ones(1, filtro_length)/filtro_length;
Vel = conv(Vel, filtro, 'same');
P_Act = conv(P_Act, filtro, 'same');
% Definir las características del filtro
fs = 1/(t(3)-t(2)); %2e5;         % Frecuencia de muestreo
fc = 20;           % Frecuencia de corte
orden = 2;         % Orden del filtro
filtro = designfilt('lowpassiir','FilterOrder',orden,'HalfPowerFrequency',fc,'SampleRate',fs);
Vel = filter(filtro, Vel);
P_Act = filter(filtro, P_Act);
numDatosEliminar = 1000;
t = t(numDatosEliminar+1:end-numDatosEliminar);
referencia = Ref_Vel(numDatosEliminar+1:end-numDatosEliminar);
vel_fil = Vel(numDatosEliminar+1:end-numDatosEliminar);
Apot_fil = P_Act(numDatosEliminar+1:end-numDatosEliminar);

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

%% 0.1NM
M =csvread("Plots Time SC/SDS2104X Plus_CSV_ALL_137.csv",12,0);
load('DatosAccConControl.mat');
A=Acc01NMConControl;

Ref_Acc = A(:, 1);
Vel_Acc = A(:, 2);
S_Acc = A(:, 3);
Q_Acc = A(:, 4);
P_Acc = A(:, 5);
Ov_P_Acc = A(:, 6);

load('Plots Time CC/ConCarga01 (17).mat');
t = data(:, 1);
t=t-t(1);
Ref_Vel = data(:, 3)*180; %Referencia de velocidad (RPM)
Vel = data(:, 4)*180; %Velocidad (RPM)
P_Act = data(:, 7)*80; %Potencia Activa (W)
% Aplicar filtro 
filtro_length = 20;
filtro = ones(1, filtro_length)/filtro_length;
Vel = conv(Vel, filtro, 'same');
P_Act = conv(P_Act, filtro, 'same');
% Definir las características del filtro
fs = 1/(t(3)-t(2)); %2e5;         % Frecuencia de muestreo
fc = 20;           % Frecuencia de corte
orden = 2;         % Orden del filtro
filtro = designfilt('lowpassiir','FilterOrder',orden,'HalfPowerFrequency',fc,'SampleRate',fs);
Vel = filter(filtro, Vel);
P_Act = filter(filtro, P_Act);
numDatosEliminar = 1000;
t = t(numDatosEliminar+1:end-numDatosEliminar);
referencia = Ref_Vel(numDatosEliminar+1:end-numDatosEliminar);
vel_fil = Vel(numDatosEliminar+1:end-numDatosEliminar);
Apot_fil = P_Act(numDatosEliminar+1:end-numDatosEliminar);

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
M =csvread("Plots Time SC/SDS2104X Plus_CSV_ALL_175.csv",12,0);
load('DatosAccConControl.mat');
A=AccM01NMConControl;

Ref_Acc = A(:, 1);
Vel_Acc = A(:, 2);
S_Acc = A(:, 3);
Q_Acc = A(:, 4);
P_Acc = A(:, 5);
Ov_P_Acc = A(:, 6);

load('Plots Time CC/ConCargaM01 (15).mat');
t = data(:, 1);
t=t-t(1);
Ref_Vel = data(:, 3)*180; %Referencia de velocidad (RPM)
Vel = data(:, 4)*180; %Velocidad (RPM)
P_Act = data(:, 7)*80; %Potencia Activa (W)
% Aplicar filtro 
filtro_length = 20;
filtro = ones(1, filtro_length)/filtro_length;
Vel = conv(Vel, filtro, 'same');
P_Act = conv(P_Act, filtro, 'same');
% Definir las características del filtro
fs = 1/(t(3)-t(2)); %2e5;         % Frecuencia de muestreo
fc = 20;           % Frecuencia de corte
orden = 2;         % Orden del filtro
filtro = designfilt('lowpassiir','FilterOrder',orden,'HalfPowerFrequency',fc,'SampleRate',fs);
Vel = filter(filtro, Vel);
P_Act = filter(filtro, P_Act);
numDatosEliminar = 1000;
t = t(numDatosEliminar+1:end-numDatosEliminar);
referencia = Ref_Vel(numDatosEliminar+1:end-numDatosEliminar);
vel_fil = Vel(numDatosEliminar+1:end-numDatosEliminar);
Apot_fil = P_Act(numDatosEliminar+1:end-numDatosEliminar);

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