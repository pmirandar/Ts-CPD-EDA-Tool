function [Pg,Pg_ff,Convergence_curve] = Ts_CPD(P,F)
%*********************************
% Ts_CPD algorithm
%*********************************

t=0;

Pos.lb=(F.lb').*ones(1,F.D);
Pos.ub=(F.ub').*ones(1,F.D);

Pos.uv=abs(Pos.ub-Pos.lb)/20;
Pos.lv=-Pos.uv;


%% **************************************************
%  ************* 	Start	      ***************
%  **************************************************

C=enjambre_CDE(P,Pos);

% Particle evaluation

[C.X_ff,C.X_Rest]=F.fun(C.X);
C.Pl_ff=C.X_ff;
C.Pl_Rest=C.X_Rest;

[C.Pg_ff,index]=max(C.X_ff);
C.Pg=C.X(index,:);
C.Pg_Rest=C.X_Rest(index); 

%% Iterations
FFt(t+1)=C.Pg_ff;
Convergence_curve(t+1)=t;     
    
while t<=F.Tmax    

    w=P.Wmax-(P.Wmax-P.Wmin)*(t/F.Tmax);   


 for i=1:P.Q      
    V_next=w*C.V(i,:)+P.c1*rand*(C.Pl(i,:)-C.X(i,:))+P.c2*rand*(C.Pg-C.X(i,:));
    V_next=check_limites(V_next,Pos.lb,Pos.ub);
    C.V(i,:)=V_next;
    P_next=C.X(i,:)+C.V(i,:);
    C.X(i,:)=check_limites(P_next,Pos.lb,Pos.ub);
    C.X_ff(i)=F.fun(C.X(i,:));
 
    for vi=1:P.l      
        % MUTATION
        [cell_donante]=donante(i,C,P.c3,1);         

        % CROSSOVER
        jrand=randi(F.D);   
        R=C.X(i,:);
        for i_aux=1:F.D        
            if ((rand<=P.Cr) || (i_aux==jrand))
                R(i_aux)=cell_donante(i_aux);        
            end
        end    
        R=check_limites(R,Pos.lb,Pos.ub);        
        [ffR,Rest]=F.fun(R);                
    
        %SELECTION
        flag=min_Rest(ffR,Rest,C.X_ff(i),C.X_Rest(i));
                       
        if  (flag)
            C.X(i,:)=R;
            C.X_ff(i)=ffR;                   
            C.X_Rest(i)=Rest;            
        end                
        
     end
                    
     % Best local position     
     flag=min_Rest(C.X_ff(i),C.X_Rest(i),C.Pl_ff(i),C.Pl_Rest(i));
     
     if (flag)
         C.Pl(i,:)=C.X(i,:);
         C.Pl_ff(i)=C.X_ff(i);                   
         C.Pl_Rest(i)=C.X_Rest(i);        
         
         % Global position
         flag=min_Rest(C.X_ff(i),C.X_Rest(i),C.Pg_ff,C.Pg_Rest);
         if (flag)
             C.Pg=C.X(i,:);
             C.Pg_ff=C.X_ff(i);
             C.Pg_Rest=C.X_Rest(i);
         end         
     end                  
 end  
                
        fprintf('(t = %d) --> ff_global = %e  --> Ts-CPD \r ',t,C.Pg_ff);
	t=t+1; 
        Convergence_curve(t)=C.Pg_ff;        
    
end

%% ***************** Result  ***************
Pg=C.Pg;
Pg_ff=C.Pg_ff;



end

function [ Pop ] = enjambre_CDE( P,Pos)

%% The swarm function receives the number of particles,
%% the vectors of the limits of positions and speed
%% and returns a vector of particles in the form of cells

%% Generate celds 
Pop.X=repmat(Pos.lb,P.Q,1)+repmat((Pos.ub-Pos.lb),P.Q,1).*rand(P.Q,size(Pos.ub,2));
Pop.V=repmat(Pos.lv,P.Q,1)+repmat((Pos.uv-Pos.lv),P.Q,1).*rand(P.Q,size(Pos.uv,2));
Pop.Pl=Pop.X;
Pop.Pg=Pop.X(1,:);
Pop.X_ff=0;
Pop.Pl_ff=0;
Pop.Pg_ff=0;
Pop.X_Rest=zeros(P.Q,1);
Pop.Pl_Rest=zeros(P.Q,1);
Pop.Pg_Rest=0;

end

function [ X ] = check_limites(X,lf,uf)
[Q,D]=size(X);
   
 for i=1:Q
    for j=1:D
        if(X(i,j)<lf(j))            
              X(i,j)=lf(j)+((uf(j)-lf(j))/10)*rand;
        elseif(X(i,j)>uf(j))            
             X(i,j)=uf(j)-((uf(j)-lf(j))/10)*rand;
        end
    end
 end
end

function [ Y  ] = donante(i,C,fs,tipo)
Q=size(C.X,1);

%%vectors are prepared for the random data of Z

vect_aux=(1:Q);
vect_aux(i)=[];

% Generate 5 random vetors
% without repeating vectors or the index i

r=zeros(1,5);
for i_r=1:3 
    r_aux=floor(rand(1)*(Q-i_r))+1;
    r(i_r)=vect_aux(r_aux);
    vect_aux(r_aux)=[];
end

% Select mutation type to generate Y
switch tipo
    case 1        
        Y=C.X(r(1),:)+fs*(C.X(r(2),:)-C.X(r(3),:));
    case 2
        Y=C.Pg+fs*(C.X(r(1),:)-C.X(r(2),:));
    case 3
        Y=C.X(i,:)+fs*(C.Pg-C.X(i,:))+fs*(C.X(r(1),:)-C.X(r(2),:));
    case 4        
        Y=C.Pg+fs*(C.X(r(1),:)-C.X(r(2),:))+fs*(C.X(r(3),:)-C.X(r(4),:));
    otherwise        
        Y=C.X(r(1),:)+fs*(C.X(r(2),:)-C.X(r(3),:))+fs*(C.X(r(4),:)-C.X(r(5),:));
end

end

function [flag]=min_Rest(ffR,Rest,X_ff,X_Rest)
flag=0;
        if((X_Rest==Rest && X_Rest==0))
            if ffR<=X_ff
                flag=1;
            end
        elseif (Rest<X_Rest)
               flag=1;
        end  
end
