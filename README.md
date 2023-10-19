# Ts-CPD-EDA-Tool
The tool is intended to design analog electronic circuits

## Manual for the EDA Tool using Ts-CPD algorithm


The tool is intended to design analog electronic circuits. Three cases are provided: a CMOS differential amplifier (Case 1), a CMOS two-stages operational amplifier (Case 2), and a CMOS folded cascode operational transconductance amplifier (Case 3). 

The theory behind this tool can be found in the next link:
https://www.preprints.org/manuscript/202310.0597/v1

### Descritpion

 The boundaries, design specifications and algorithm parameters are set in the Main_Case_x.m file.

 The boundaries can be chosen in the next lines, depending on the case:

----------
%% Function (Set boundaries)
F=fun_case1;
F.Tmax     =   2;
F.D     =   6;
F.lb    =   [4e-6; 4e-6; 4e-6; 4e-6; 2e-12; 2e-6] ;
F.ub    =   [200e-6; 200e-6; 200e-6; 200e-6; 14e-12; 150e-6] ;

F.D is the dimension
F.lb minimum size
F.ub maximum size

with the next order

W1, W2, W3, W5, CL, Ib
----------
%% Function (Set boundaries)
F=fun_case2;
F.Tmax  =   2;
F.D     =   7;
F.lb    =   [4e-6; 4e-6; 4e-6; 4e-6; 7e-12; 2e-12; 5e-6];
F.ub    =   [100e-6; 100e-6; 100e-6; 100e-6; 12e-12; 14e-12; 50e-6];

with the next order

W1, W3, W5, W8, CL, Cc, Iref
----------
%% Function (Set boundaries)
F=fun_case3;
F.Tmax  =   2;
F.D     =   9;
F.lb    =   [4e-6; 4e-6; 4e-6; 4e-6; 4e-6; 4e-6; 4e-6; 10e-6; 1e3];
F.ub    =   [120e-6; 120e-6; 120e-6; 120e-6; 120e-6; 120e-6; 120e-6; 150e-6; 6e3];

with the next order

W1, W3, W4, W6, W8, W1, W15, Iref, Re1
----------

### The specitication for the circuit are set the next lines:

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

The user can choose the desired values.
