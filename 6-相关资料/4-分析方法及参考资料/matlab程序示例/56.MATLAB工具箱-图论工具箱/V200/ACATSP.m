function [R_best,L_best,L_ave,Shortest_Route,Shortest_Length]=ACATSP(C,NC_max,m,Alpha,Beta,Rho,Q)
%%=========================================================================
%% m 蚂蚁算法通用源程序
%%  [R_best,L_best,L_ave,Shortest_Route,Shortest_Length]=ACATSP(C,NC_max,m,Alpha,Beta,Rho,Q)
%% m 蚂蚁算法通用源程序
%% ACATSP.m
%% Ant Colony Algorithm for Traveling Salesman Problem
%% ChengAihua,PLA Information Engineering University,ZhengZhou,China
%% Email:aihuacheng@gmail.com
%% All rights reserved
%%-------------------------------------------------------------------------
%% 主要符号说明
%% C n个节点的邻接矩阵
%% NC_max 最大迭代次数
%% m 蚂蚁个数
%% Alpha 表征信息素重要程度的参数
%% Beta 表征启发式因子重要程度的参数
%% Rho 信息素蒸发系数
%% Q 信息素增加强度系数
%% R_best 各代最佳路线
%% L_best 各代最佳路线的长度
%%=========================================================================

%%第一步：变量初始化
n=size(C,1);%n表示问题的规模（城市个数）
D=C;%赋权值
Eta=1./D;%Eta为启发因子，这里设为距离的倒数
Tau=ones(n,n);%Tau为信息素矩阵
Tabu=zeros(m,n);%存储并记录路径的生成
NC=1;%迭代计数器
R_best=zeros(NC_max,n);%各代最佳路线
L_best=inf.*ones(NC_max,1);%各代最佳路线的长度
L_ave=zeros(NC_max,1);%各代路线的平均长度

while NC<=NC_max%停止条件之一：达到最大迭代次数
%%第二步：将m只蚂蚁放到n个城市上
Randpos=[];
for i=1:(ceil(m/n))%这里表示放置元素，生成[m/n]+1个随机排列阵，然后取前m个，这样就表明对于m只蚂蚁平均放在n个城市了
Randpos=[Randpos,randperm(n)];
end
Tabu(:,1)=(Randpos(1,1:m))';

%%第三步：m只蚂蚁按概率函数选择下一座城市，完成各自的周游
for j=2:n
for i=1:m
visited=Tabu(i,1:(j-1));%已访问的城市
J=zeros(1,(n-j+1));%待访问的城市
P=J;%待访问城市的选择概率分布
Jc=1;
for k=1:n
if length(find(visited==k))==0
J(Jc)=k;
Jc=Jc+1;
end
end
%下面计算待选城市的概率分布
for k=1:length(J)
P(k)=(Tau(visited(end),J(k))^Alpha)*(Eta(visited(end),J(k))^Beta);
end
P=P/(sum(P));
%按概率原则选取下一个城市
Pcum=cumsum(P);
Select=find(Pcum>=rand);
to_visit=J(Select(1));
Tabu(i,j)=to_visit;
end
end
if NC>=2
Tabu(1,:)=R_best(NC-1,:);
end

%%第四步：记录本次迭代最佳路线
L=zeros(m,1);
for i=1:m
R=Tabu(i,:);
for j=1:(n-1)
L(i)=L(i)+D(R(j),R(j+1));
end
L(i)=L(i)+D(R(1),R(n));
end
L_best(NC)=min(L);
pos=find(L==L_best(NC));
R_best(NC,:)=Tabu(pos(1),:);
L_ave(NC)=mean(L);
NC=NC+1

%%第五步：更新信息素
Delta_Tau=zeros(n,n);
for i=1:m
for j=1:(n-1)
Delta_Tau(Tabu(i,j),Tabu(i,j+1))=Delta_Tau(Tabu(i,j),Tabu(i,j+1))+Q/L(i);
end
Delta_Tau(Tabu(i,n),Tabu(i,1))=Delta_Tau(Tabu(i,n),Tabu(i,1))+Q/L(i);
end
Tau=(1-Rho).*Tau+Delta_Tau;

%%第六步：禁忌表清零
Tabu=zeros(m,n);
end

%%第七步：输出结果
Pos=find(L_best==min(L_best));
Shortest_Route=R_best(Pos(1),:)
Shortest_Length=L_best(Pos(1))