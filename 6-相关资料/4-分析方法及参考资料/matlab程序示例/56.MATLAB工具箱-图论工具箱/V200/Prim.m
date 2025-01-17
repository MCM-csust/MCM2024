function [T,l]=Prim(Adj)
%  [T,l]=Prim(Adj)
%  [T,l]=Prim(Adj)
%Adj means the adjanency matrix of the graph. 

T=[];
beta1=[];
beta2=[];
n1=0;
n2=0;
mm=inf;
n=length(Adj);
for i=1:n
    for j=1:n
        if(i~=j)
            if(Adj(i,j)<=mm)
                mm=Adj(i,j);
                n1=i;
                n2=j;
            end
        end
    end
end
T=[n1 n2];
for i=1:n-2
    if i==1
        beta1=union(T(:,1),T(:,2));
    else
        beta1=union(T(:,1),T(:,2))';
    end
    beta2=[];
    for k=1:n
        if(~ismember(k,beta1))
            beta2=[beta2 k];
        end
    end
    n11=0;
    n22=0;
    mm=inf;
    P=T;
    for j=1:length(beta1)
        for k=1:length(beta2)
            if(Adj(beta1(j),beta2(k))<mm&&~iscircle(P))
                mm=Adj(beta1(j),beta2(k));
                n11=beta1(j);
                n22=beta2(k);                
            end
            P=[T;n11 n22];
        end
    end   
    beta1=[beta1 n22];
    T=[T;n11 n22];
end
l=0;
for i=1:length(T)
    l=l+Adj(T(i,1),T(i,2));
end