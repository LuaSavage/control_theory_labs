clear;
clc;

%%%%%%Данные%%%%%%%
A =[0 0 1 0
    0 0 0 1
    -1 1 0 0
    1 -1 0 0];
    
B =[0; 0; 1; 0];

C =[1 0 0 0
    0 1 0 0];
    
D =[0; 0; 0; 1];

mu=2.8951;

alpha_min=0.01; %интервал варьирования alpha
alpha_max=0.48;

%%%%%%Решение%%%%%%%%

N=50;
dalpha=(alpha_max-alpha_min)/N; %Величина шагадискретизации по alpha
P=sdpvar(4);%матричная SDP переменная 4Х4
Y=sdpvar(1,4);%матричная переменная 1Х4
%следующая команда предписывает не выводить на экран текущую 
% информацию о процессе решения задачи SDP, решатель которой будет
% вызываться далее)

opts=sdpsettings('verbose',0);%подавить вывод диагностики ре-шателя

%Решить задачу SDP для каждого значения alpha

k=0;
for alpha=alpha_min:dalpha:alpha_max
  k=k+1
  M1=A*P+P*A'+alpha*P+B*Y+Y'*B'+D*D'/alpha %ограничение (1)
  M2=[P Y';
  Y mu^2*eye(1)]%ограничение (2)
  %constr=set(M1<=0)+set(M2>=0)
  constr=[M1<=0]+[M2>=0];% задать LMI ограничения
  optimize(constr,trace(C*P*C'),opts); % решитьзадачу SDP
  P_sol=double(P); %получить числовые
  Y_sol=double(Y);%значения решения
  Pmatrices(:,:,k)=P_sol;%приданном alpha
  Ymatrices(:,:,k)=Y_sol;%и запомнить
  cost(k)=trace(C*P_sol*C');%результаты
end;