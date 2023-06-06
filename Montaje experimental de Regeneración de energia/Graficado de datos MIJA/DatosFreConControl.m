clc;
close all;
clear all;
set(groot,'defaultFigureWindowState','maximized');
load('DatosFreConControl.mat');

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
load('DatosFreConControl.mat');
A=FreVacioConControl;

Ref_Fre = A(:, 1);
Vel_Fre = A(:, 2);
S_Fre = A(:, 3);
Q_Fre = A(:, 4);
P_Fre = A(:, 5);
Ov_P_Fre = A(:, 6);

load('Plots Time CC/SinCarga (23).mat');
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
load('DatosFreConControl.mat');
A=Fre05NMConControl;

Ref_Fre = A(:, 1);
Vel_Fre = A(:, 2);
S_Fre = A(:, 3);
Q_Fre = A(:, 4);
P_Fre = A(:, 5);
Ov_P_Fre = A(:, 6);

load('Plots Time CC/ConCarga05 (18).mat');
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
load('DatosFreConControl.mat');
A=FreM05NMConControl;

Ref_Fre = A(:, 1);
Vel_Fre = A(:, 2);
S_Fre = A(:, 3);
Q_Fre = A(:, 4);
P_Fre = A(:, 5);
Ov_P_Fre = A(:, 6);

load('Plots Time CC/ConCargaM05 (20).mat');
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

sgtitle('-0.5 NM Energies');

%% 0.1NM
load('DatosFreConControl.mat');
A=Fre01NMConControl;

Ref_Fre = A(:, 1);
Vel_Fre = A(:, 2);
S_Fre = A(:, 3);
Q_Fre = A(:, 4);
P_Fre = A(:, 5);
Ov_P_Fre = A(:, 6);

load('Plots Time CC/ConCarga01 (20).mat');
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
load('DatosFreConControl.mat');
A=FreM01NMConControl;

Ref_Fre = A(:, 1);
Vel_Fre = A(:, 2);
S_Fre = A(:, 3);
Q_Fre = A(:, 4);
P_Fre = A(:, 5);
Ov_P_Fre = A(:, 6);

load('Plots Time CC/ConCargaM01 (24).mat');
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