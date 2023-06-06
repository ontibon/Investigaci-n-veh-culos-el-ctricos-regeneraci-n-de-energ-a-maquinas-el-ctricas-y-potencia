clc;
close all;
clear all;
set(groot,'defaultFigureWindowState','maximized');

load('DatosBLDC.mat');

% Tamaño del vector de datos
n = 3054000;

% Frecuencia de muestreo
fs = 1/2000;

% Generar vector de tiempo
t = linspace(0, (n-1)*fs, n)';

lim_t_min=min(t);
lim_t_max=max(t);

figure('Color','white','Name','Opal');
plot(t, Simu_Velocidad, 'r-', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Velocity [rpm]');
title('Velocity Graph');
Var_limite=Simu_Velocidad;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([lim_t_min,lim_t_max]);
grid on;
hold on;
plot(t, Simu_Referencia, 'b--', 'LineWidth', 1.5);
legend('Velocity', 'Reference');


figure('Color','white','Name','Opal');
%subplot(1,2,1);
plot(t, Simu_PotenciaActiva, 'b-', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Active Power [W]');
title('Active Power Graph');
Var_limite=Simu_PotenciaActiva;
ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
xlim([lim_t_min,lim_t_max]);
grid on;

% subplot(1,2,2);
% plot(t, Simu_PotenciaReactiva, 'm-', 'LineWidth', 1.5);
% xlabel('Time (s)');
% ylabel('Reactive Power [VA]');
% title('Reactive Power Graph');
% Var_limite=Simu_PotenciaReactiva;
% ylim([min(Var_limite)-max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1, max(Var_limite)+max(abs(min(Var_limite)),abs(max(Var_limite)))*0.1]);
% xlim([lim_t_min,lim_t_max]);
% grid on;

%% Energias

potencia_regenerativa=Simu_PotenciaActiva(Simu_PotenciaActiva<0);
tiempo_regenerativo=t(1:numel(potencia_regenerativa));

potencia_positiva=Simu_PotenciaActiva(Simu_PotenciaActiva>0);
tiempo_positivo=t(1:numel(potencia_positiva));

energia_total=trapz(t,Simu_PotenciaActiva)/3600 %Wh
energia_regenerativa=trapz(tiempo_regenerativo,potencia_regenerativa)/3600 %Wh
energia_positiva=trapz(tiempo_positivo,potencia_positiva)/3600 %Wh

Porcentaje_Extra=abs(energia_regenerativa)*100/energia_positiva