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
% Case 1: CMOS differential amplifier
%
%*******************************************************************

clc
clear all

%% Function (Set boundaries)
F=fun_case1;
F.Tmax  =   20;
F.D     =   6;
F.lb    =   [4e-6; 4e-6; 4e-6; 4e-6; 2e-12; 2e-6] ;
F.ub    =   [200e-6; 200e-6; 200e-6; 200e-6; 14e-12; 150e-6] ;

%% Desing criteria (Set design specifications)
F.Ref_OLG = 40;         % (dB)
F.Ref_Cut_off = 100e3; 	% (Hz)
F.Ref_PM_MIN = 46;      % (deg)
F.Ref_PM_MAX = 90;      % (deg) Not in use
F.Ref_CL = 2e-12;   	% (F)
F.Ref_SR = 10;  		% (V/us)
F.Ref_Pd = 2000e-6;  	% (W)
F.Ref_CMRR = 41;        % (dB)
F.Ref_PSRRn = 41;       % (dB)
F.Ref_PSRRp = 41;       % (dB)
F.Ref_T_MOS_A = 250e-12;% (m^2)

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

