close all
clear all
clc

%% Parametros de simulación
f=50;                             %Frecuencia del estator (Hz)
Ps=2e6;                           %Potencia nominal del estator (W)
n=1500;                           %Velocidad rotacional nominal (rev/min)
Vs=690;                           %Voltaje nominal del estator (V)
Is=1760;                          %Corriente nominal del estator (A)
Tem=12732;                        %Torque nominal (N.m)

p=2;                              %Par de polos
u=1/3;                            %Relación de vueltas estator/rotor
Vr=2070;                          %Voltaje nominal del rotor (No alcanzado)
smax=1/3;                         %Deslizamiento maximo
Vr_stator=(Vr*smax)*u;            %Voltaje nominal del rotor respecto al estator
Rs=2.6e-3;                        %Resistencia del estator (ohm)
Lsi=0.087e-3;                     %Inductancia de fuga (Estator y rotor) (H)
Lm=2.5e-3;                        %Inductancia de magnetizacion (H)
Rr=2.9e-3;                        %Resistencia del rotro referida al estator
Ls=Lm+Lsi;                        %Inductancia del estator (H)
Lr=Lm+Lsi;                        %Inductancia del rotor (H)
Vbus=Vr_stator*sqrt(2);           %Voltaje del bus DC
sigma=1-Lm^2/(Ls*Lr);
Fs=Vs*sqrt(2/3)/(2*pi*f);         %Flujo aproximado del estator (Wb)

J=127;                            %Inertia
D=1e-3;                           %Amortiguación

fsw=4e3;                          %Frecuencia de cambio (Hz)
Ts=1/fsw/50;                      %Tiempo de muestreo (sec)

vsigma=sigma;

%Reguladores PI

tau_i=(sigma*Lr)/Rr;
tau_n=0.05;
wni=100*(1/tau_i);
wnn=1/tau_n;

kp_id=(2*wni*sigma*Lr)-Rr;
kp_iq=kp_id;
ki_id=(wni^2)*Lr*sigma;
ki_iq=ki_id;
kp_n=(2*wnn*J)/p;
ki_n=((wnn^2)*J)/p;

%Convertidor del lado de la red

Cbus=80e-3;                     %Capacitancia del bus DC
Rg=20e-6;                       %Resistencia del filtro del lado de la red
Lg=400e-6;                      %Inductancia del filtro del lado de la red

Kpg=1/(1.5*Vs*sqrt(2/3));
Kqg=-Kpg;

%Constantes de control del nuevo convertidor de potencia (Inversor)

tau_ig=Lg/Rg;
wnig=60*2*pi;

kp_idg=(2*wnig*Lg)-Rg;
kp_iqg=kp_idg;
ki_idg=(wnig^2)*Lg;
ki_iqg=ki_idg;

kp_v=-1000;
ki_v=-300000;