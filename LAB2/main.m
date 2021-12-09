clear;
clc;
pkg load control;

opts=sdpsettings('verbose',0); %подавить вывод диагностики ре-шател€

%%%%%%ƒанные%%%%%%%
A=[0 1 0;
-4.2 -1.5 4.2;
-0.76 0 0.77];

Q=[1 0 0
0 1 0
0 0 1];

%% уравнение Ћ€пунова
%% A

P_1_a = lyap(A',A,Q);
P_1_a = double(P_1_a);
P_1_a
trace(P_1_a)

## –ешение непрерывного уравнени€ Ћ€пунова
P = sdpvar(3,3);
## ограничени€
F = [A'*P + P*A + Q <= 0];
F = F + [trace(P) == 1];
##F = F + [P == P'];
optimize(F, trace(P));
P_lyap_sol = double(P);
P_lyap_sol
trace(P_lyap_sol)

%% дискретное уравнение Ћ€пунова
%% B
P_1_b = dlyap(A,Q);
P_1_b

## –ешение дискретного уравнени€ Ћ€пунова
P = sdpvar(3,3);
## ограничени€
F = [A'*P*A-P+Q >= 0];
F = F + [trace(P) == 1];
optimize(F, trace(P));
P_sol = double(P);
P_sol

%%% уравнени€ –иккати
R=1
B = [0;-7.4;0];

%% A
place (A, B, p);
#care(A,B,Q);

%% B
dare_res = dare(A,B,Q,R);
dare_res




