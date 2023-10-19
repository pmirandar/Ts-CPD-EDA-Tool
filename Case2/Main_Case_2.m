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
% Case 2: CMOS two-stage operational amplifier
%
%*******************************************************************

clc
clear all

%% Function (Set boundaries)
F=fun_case2;
F.Tmax  =   2;
F.D     =   7;
F.lb    =   [4e-6; 4e-6; 4e-6; 4e-6; 7e-12; 2e-12; 5e-6];  
F.ub    =   [100e-6; 100e-6; 100e-6; 100e-6; 12e-12; 14e-12; 50e-6];

%% Desing criteria (Set design specifications)
F.Ref_OLG = 63;           % (dB)
F.Ref_UBW = 3.3e6;        % (Hz)
F.Ref_PM_MIN = 46;        % (deg)
F.Ref_PM_MAX = 90;        % (deg) Not in use
F.Ref_CL = 3e-12;         % (F) 7e-12 3e-12
F.Ref_SR = 10;            % (V/us)
F.Ref_Pd = 2500e-6;        % (W) 2500e-6 500e-6
F.Ref_CMRR = 62;          % (dB)
F.Ref_PSRRn = 70;         % (dB)
F.Ref_PSRRp = 70;         % (dB)
F.Ref_T_MOS_A = 305e-12;  % (m^2)

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

