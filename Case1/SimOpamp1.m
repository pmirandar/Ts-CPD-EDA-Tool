function [Area,R,Objetivos] = SimOpamp1(obj,v)
% Execute the simulation of the amplifier, but none optimization is done here.
% 

w1=v(1);
w2=v(2);
w3=v(3);
w4=w3;
w5=v(4);
w6=w5;
CL=v(5);
Iref=v(6);

l1=1.4e-6;
l2=1.4e-6;
l3=3.5e-6;
l4=3.5e-6;
l5=3.5e-6;
l6=3.5e-6;

x=[w1 w2 w3 w4 w5 w6 CL l1 l2 l3 l4 l5 l6 Iref];

%% Simulation
[Ra]=opamp_sim(obj.system,x);
[VS]=opamp_cmrr();
[VP]=opamp_psrr();
[VN]=opamp_psrrn();
[IV]=opamp_pd2();
[SR]=opamp_sr();

%% Store results 
a = Ra{2};
b = Ra{1};
pm = Ra{4};
tiempo = SR{3};
voltaje = SR{4};
Vout = VS{2};
Vsal = VP{2};
Vpns = VN{2};
Power = IV{2};
frecuency = getUBW(a);
pm_deg = 180 + pm(frecuency);
frecc = getCut_off(a);

%% Design vector
x2=[obj.Ref_OLG obj.Ref_Cut_off obj.Ref_PM_MIN...
    obj.Ref_PM_MAX obj.Ref_CL obj.Ref_SR obj.Ref_Pd...
    obj.Ref_CMRR obj.Ref_PSRRn obj.Ref_PSRRp obj.Ref_T_MOS_A];

%% Calculate errors
error_OLG = (a(1) - x2(1))/x2(1);
if error_OLG>0
    error_OLG=0;
else
    error_OLG=1;
end

error_Cut_off = (b(frecc) - x2(2))/x2(2);
if error_Cut_off>=0
    error_Cut_off=0;
else
    error_Cut_off=1;
end

error_PM_MIN = (pm_deg - x2(3))/x2(3);
if error_PM_MIN>0
    error_PM_MIN=0;
else
    error_PM_MIN=1;
end

error_CL = (x(7) - x2(5))/x2(5);
if error_CL>=0
    error_CL=0;
else
    error_CL=1;
end

error_SR = ((getSR(tiempo,voltaje)/1e6) - x2(6))/x2(6);
 if error_SR>=0
     error_SR=0;
 else
     error_SR=1;
 end

error_Pd = (abs(Power) - x2(7))/x2(7);
if error_Pd<=0
    error_Pd=0;
else
    error_Pd=1;
end

error_CMRR = (getCMRR(Vout) - x2(8))/x2(8);
if error_CMRR>0
    error_CMRR=0;
else
    error_CMRR=1;
end

error_PSRRn = (getPSRR(Vsal) - x2(9))/x2(9);
if error_PSRRn>0
    error_PSRRn=0;
else
    error_PSRRn=1;
end

error_PSRRp = (getPSRRN(Vpns) - x2(10))/x2(10);
if error_PSRRp>0
    error_PSRRp=0;
else
    error_PSRRp=1;
end

Area = getTotalArea(x);

errores = [error_OLG error_Cut_off error_PM_MIN error_CL...
           error_SR error_Pd error_CMRR error_PSRRn error_PSRRp];
R=sum(errores);

Objetivos=[a(1) b(frecc) pm_deg x(7) (getSR(tiempo,voltaje)/1e6)...
    abs(Power) getCMRR(Vout) getPSRR(Vsal) getPSRRN(Vpns) getTotalArea(x)];

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%				    %%
%%  Layer 3, function calls	    %%
%%				    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [VS] = opamp_cmrr()
%
[VS] = getVS('SimInOut/cmrr');
end

function [Vsal] = opamp_psrr()
%
[Vsal] = getVsal('SimInOut/psrr+');
end

function [Vpns] = opamp_psrrn()
%
[Vpns] = getVpns('SimInOut/psrr-');
end

function [Pw] = opamp_pd2()

[Pw] = getPD2('SimInOut/pd2');
end

function [Var] = opamp_sr()
%
[Var] = getVars('SimInOut/slewrate');
end

function frec = getUBW(OLG)
   i = 1;
   while (OLG(i) > 0 && i < 8000)
        i = i+1;
   end;
frec = i;
end

function frecc = getCut_off(OLG)
   i = 1;
   ini = OLG(i);
   while ((abs(ini-OLG(i)) < 3) && i<8000)
        i = i+1;
   end;
frecc = i;
end

function sr = getSR(t,v)
   j = 1;
   while (v(j) <= 1.7 && j<180)
       j = j+1;
   end;
   if v(j) >= 1.7
        sr = v(j)/t(j);
   else
        sr = 0;
   end
end

function cmrr = getCMRR(Vout)
%
cmrr = 20*log10(1.0/abs(Vout(1)));
end

function psrr = getPSRR(v)
%
psrr = 20*log10(1.0/abs(v(1)));
end

function psrr = getPSRRN(v)
%
psrr = 20*log10(1.0/abs(v(1)));
end

function Area = getTotalArea(x)
%
Area = x(1)*x(8) + x(2)*x(9) + x(3)*x(10)...
     + x(4)*x(11) + x(5)*x(12) + x(6)*x(13);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%				    %%
%%  Layer 4, function calls  	    %%
%%				    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [VS] = getVS(WNgspiceBaseFile)
%
v3 = fopen([WNgspiceBaseFile '.data']);
VS = textscan(v3,'%f %f %f','delimiter','','headerLines',0);
fclose('all');
end

function [Vsa] = getVsal(WNgspiceBaseFile)
% 
ps = fopen([WNgspiceBaseFile '.data']);
Vsa = textscan(ps,'%f %f %f','delimiter','','headerLines',0);
fclose('all');
end

function [Var] = getVars(WNgspiceBaseFile)
%
sr = fopen([WNgspiceBaseFile '.data']);
Var = textscan(sr,'%f %f %f %f','delimiter','','headerLines',0);
fclose('all');
end

function [Vpa] = getVpns(WNgspiceBaseFile)
% 
pa = fopen([WNgspiceBaseFile '.data']);
Vpa = textscan(pa,'%f %f %f','delimiter','','headerLines',0);
fclose('all');
end

function [pw] = getPD2(WNgspiceBaseFile)
% 
v3 = fopen([WNgspiceBaseFile '.txt']);
pw = textscan(v3,'%s %f','delimiter','=','headerLines',0);
fclose('all');
end
