function y=iscircle(C)
%  y=iscircle(C)
%C is the matrix of the path,its style is N*2
%The function returns 0 or 1

if all(size(C)==[1 2])||isempty(C)
    y=0;
    return
end
k1=length(C);
k2=length(union(C(:,1),C(:,2))');
if(k1==k2-1)
    y=0;
else
    y=1;
end
