function [F,maxval]=MaxFlow(u)
%  [F,maxval]=MaxFlow(u)
%  [F,maxval]=MaxFlow(u)

M=inf;
n=length(u);
f=zeros(n,n);
list=[];
maxf=zeros(1:n);maxf(n)=1;
while maxf(n)>0
    maxf=zeros(1,n);pred=zeros(1,n);
    list=1;record=list;maxf(1)=M;
    while (~isempty(list))&(maxf(n)==0)
        flag=list(1);list(1)=[];
        index1=(find(u(flag,:)~=0));
        label1=index1(find(u(flag,index1)...
            -f(flag,index1)~=0));
        label1=setdiff(label1,record);
        list=union(list,label1);
        pred(label1(find(pred(label1)==0)))=flag;
        maxf(label1)=min(maxf(flag),u(flag,label1)...
            -f(flag,label1));
        record=union(record,label1);
        label2=find(f(:,flag)~=0);
        label2=label2';
        label2=setdiff(label2,record);
        list=union(list,label2);
        pred(label2(find(pred(label2)==0)))=-flag;
        maxf(label2)=min(maxf(flag),f(label2,flag));
        record=union(record,label2);
    end
    if maxf(n)>0
        v2=n;
        v1=pred(v2);
        while v2~=1
            if v1>0
                f(v1,v2)=f(v1,v2)+maxf(n);
            else
                v1=abs(v1);
                f(v2,v1)=f(v2,v1)-maxf(n);
            end
            v2=v1;
            v1=pred(v2);
        end
    end
end
F=f;
maxval=sum(f(1,:));