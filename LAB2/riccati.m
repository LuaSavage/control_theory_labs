clear;
clc;
pkg load control;

opts=sdpsettings('verbose',0); %�������� ����� ����������� ��-������

%%%%%%������%%%%%%%

A=[0 1 0;
-4.2 -1.5 4.2;
-0.76 0 0.77];

Q=[1 0 0
0 1 0
0 0 1];

%%% ��������� �������
R=1;
B = [0;-7.4;0];

P = sdpvar(3,3);

%% A
%% �����������
%%A'*P + P*A - P*B*(R^(-1))*B'*P + Q 
care_sol = care(A,B,Q,R);
care_sol
F = [A'*P + P*A - P*B*(R^(-1))*B'*P + Q  >= 0];
F = F + [P>=0];
optimize(F, trace(P));
P_care_sol = double(P);


%% ����������
%% B
dare_res = dare(A,B,Q,R);
dare_res
