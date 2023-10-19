%*******************************************************************
%
% MatLab code for Ts-CPD algorithm and interface
% developed by Pedro Lagos Eulogio
%
% MatLab code for circuit simulations and SPICE code (Netlist) 
% developed by Pedro Miranda Romagnoli
%
%*******************************************************************

%*******************************************************************
%
%  Case 3: CMOS folded cascode operational transconductance amplifier
%
%*******************************************************************

clc
clear all

%% Function (Set boundaries)
F=fun_case3;
F.Tmax  =   20;
F.D     =   9;
F.lb    =   [4e-6; 4e-6; 4e-6; 4e-6; 4e-6; 4e-6; 4e-6; 10e-6; 1e3];  
F.ub    =   [120e-6; 120e-6; 120e-6; 120e-6; 120e-6; 120e-6; 120e-6; 150e-6; 6e3];

%% Desing criteria (Set design specifications)
F.Ref_OLG = 74;           % (dB) 
F.Ref_UBW = 10e6;         % (Hz) 
F.Ref_PM_MIN = 60;        % (deg)
F.Ref_PM_MAX = 90;        % (deg)
F.Ref_CL = 10e-12;        % (F) 
F.Ref_SR = 10;            % (V/us)
F.Ref_Pd = 5e-3;          % (W) 
F.Ref_CMRR = 55;          % (dB)
F.Ref_PSRRn = 55;         % (dB)
F.Ref_PSRRp = 55;         % (dB)
F.Ref_T_MOS_A = 800e-12;  % (m^2)

%% Ts-CPD   (Set algorithm parameters)
P.Q     =  10;
P.l     =  4;
P.c1    =  2;
P.c2    =  2;
P.Cr    =  0.9;
P.c3    =  0.6;
P.Wmin  =  0.7;
P.Wmax  =  0.15;

%% Operating System Selection (Windows=1, Mac=0)
F.system=1;

%% Runs (Perform the search)
[best_cell,best_area,Convergence_curve] = Ts_CPD(P,F);

%% Analysis (Show found parameters)
[area,Rest,Objt]=F.datos(best_cell);

disp(F);

