function [Rac] = opamp_sim(system,x)
% Create and save the file 'param.cir' to be included in 
% another file to be run by Ngspice.
% The built-in function 'num2str' is used to modify parameters
% wherever it is convenient.
p = ['.param w1=' num2str(x(1)) ' w2=' num2str(x(2))...
    ' w3=' num2str(x(3)) ' w4=' num2str(x(4)) ' w5=' num2str(x(5))...
    ' w6=' num2str(x(6)) ' w7=' num2str(x(7)) ' w8=' num2str(x(8))...
    ' w9=' num2str(x(9)) ' w10=' num2str(x(10)) ' w11=' num2str(x(11))...
    ' w12=' num2str(x(12)) ' w13=' num2str(x(13)) ' w14=' num2str(x(14))...
    ' w15=' num2str(x(15)) ' CL=' num2str(x(16)) ' l1=' num2str(x(17))...
    ' l2=' num2str(x(18)) ' l3=' num2str(x(19)) ' l4=' num2str(x(20))...
    ' l5=' num2str(x(21)) ' l6=' num2str(x(22)) ' l7=' num2str(x(23))...
    ' l8=' num2str(x(24)) ' l9=' num2str(x(25)) ' l10=' num2str(x(26))...
    ' l11=' num2str(x(27)) ' l12=' num2str(x(28)) ' l13=' num2str(x(29))...
    ' l14=' num2str(x(30)) ' l15=' num2str(x(31)) ' Iref=' num2str(x(32))...
    ' Re1=' num2str(x(33)) ' Re2=' num2str(x(34))];
dlmwrite('SimInOut/param.cir', p, 'delimiter','');

if system==1
% Run Ngspice
% Make sure Ngspice and .cir files are available 
% in this directory
! C:\Spice64\bin\ngspice -b -o SimOut/opamp-main.out  SimIn/opamp4BsimCard2.cir
! C:\Spice64\bin\ngspice -b -o SimOut/opamp-sr.out    SimIn/opamp4BsimCardslewR.cir
! C:\Spice64\bin\ngspice -b -o simOut/opamp-cmrr.out  SimIn/opamp4BsimCardCMRR.cir
! C:\Spice64\bin\ngspice -b -o SimOut/opamp-psrr.out  SimIn/opamp4BsimCardPSRR.cir
! C:\Spice64\bin\ngspice -b -o SimOut/opamp-psrrn.out SimIn/opamp4BsimCardPSRRN.cir
! C:\Spice64\bin\ngspice -b -o SimOut/opamp-pd.out    SimIn/opamppd.cir


else
% Run Ngspice
% Make sure Ngspice and .cir files are available 
% in this directory
 ! /Applications/ngspice/bin/ngspice -b -o SimOut/opamp-main.out  SimIn/opamp4BsimCard2.cir
 ! /Applications/ngspice/bin/ngspice -b -o SimOut/opamp-sr.out    SimIn/opamp4BsimCardslewR.cir
 ! /Applications/ngspice/bin/ngspice -b -o simOut/opamp-cmrr.out  SimIn/opamp4BsimCardCMRR.cir
 ! /Applications/ngspice/bin/ngspice -b -o SimOut/opamp-psrr.out  SimIn/opamp4BsimCardPSRR.cir
 ! /Applications/ngspice/bin/ngspice -b -o SimOut/opamp-psrrn.out SimIn/opamp4BsimCardPSRRN.cir
 ! /Applications/ngspice/bin/ngspice -b -o SimOut/opamp-pd.out    SimIn/opamppd.cir

end

% Read data saved in .csv files
% (assuming name termination _ac_out.csv)
% Read csv files generated by a 'write' in a 'WNgspiceBaseFile' (.cir file)
% Rac{1} = Frequency Points
% Rac{2} = AC response 
ac = fopen(['SimInOut/ngspice' '.data']);
Rac = textscan(ac,'%f %f %f %f','delimiter','','headerLines',0);
fclose('all');

end
