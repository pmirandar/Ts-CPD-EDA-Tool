classdef fun_case1<handle            
    properties     
        system = 1
        D=6                      
        lb=[]
        ub=[]           
        Name_var={'W1', 'W2', 'W3', 'W5', 'CC', 'Ib'}                                            
        var =[]
        Tmax=[]                                       
        fes
        
        %% Design criteria
        Ref_OLG 
        Ref_Cut_off 
        Ref_PM_MIN 
        Ref_PM_MAX 
        Ref_CL 
        Ref_SR 
        Ref_Pd 
        Ref_CMRR 
        Ref_PSRRn 
        Ref_PSRRp 
        Ref_T_MOS_A 
        
        %% Target
        Av
        Coff
        PM
        CL
        SR
        PWR
        CMRR
        PSRRp
        PSRRn
        Area
        
        %% Constraints violation
        const_violation
          
    end
    
    methods
        function obj = fun_case1()

        end
        
        function [fx,Rest,Objt]=fun(obj,X)
            [N,~]=size(X);            
            fx=zeros(N,1);
            Rest=zeros(N,1);
            Objt=zeros(N,10);
            for i=1:N
                [fx(i),Rest(i),Objt(i,:)]=SimOpamp1(obj,X(i,:));
            end
            obj.fes=obj.fes+N;
        end
        
        function [fx,Rest,Objt]=datos(obj,X)
            [fx,Rest,Objt]=SimOpamp1(obj,X);
            obj.Av=Objt(1);
            obj.Coff=Objt(2);
            obj.PM=Objt(3);
            obj.CL=Objt(4);
            obj.SR=Objt(5);
            obj.PWR=Objt(6);
            obj.CMRR=Objt(7);
            obj.PSRRp=Objt(8);
            obj.PSRRn=Objt(9);
            obj.Area=Objt(10);
            
            obj.const_violation=Rest;
            obj.var=X;
        end        
    end
end


