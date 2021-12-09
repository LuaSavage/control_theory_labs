clear;
clc;

%%%%%%������%%%%%%%
A =[0 0 1 0
    0 0 0 1
    -1 1 0 0
    1 -1 0 0];
    
B =[0; 0; 1; 0];

C =[1 0 0 0
    0 1 0 0];
    
D =[0; 0; 0; 1];

mu=2.8951;

alpha_min=0.01; %�������� ������������ alpha
alpha_max=0.48;

%%%%%%�������%%%%%%%%

N=50;
dalpha=(alpha_max-alpha_min)/N; %�������� ����������������� �� alpha
P=sdpvar(4);%��������� SDP ���������� 4�4
Y=sdpvar(1,4);%��������� ���������� 1�4
%��������� ������� ������������ �� �������� �� ����� ������� 
% ���������� � �������� ������� ������ SDP, �������� ������� �����
% ���������� �����)

opts=sdpsettings('verbose',0);%�������� ����� ����������� ��-������

%������ ������ SDP ��� ������� �������� alpha

k=0;
for alpha=alpha_min:dalpha:alpha_max
  k=k+1
  M1=A*P+P*A'+alpha*P+B*Y+Y'*B'+D*D'/alpha %����������� (1)
  M2=[P Y';
  Y mu^2*eye(1)]%����������� (2)
  %constr=set(M1<=0)+set(M2>=0)
  constr=[M1<=0]+[M2>=0];% ������ LMI �����������
  optimize(constr,trace(C*P*C'),opts); % ������������ SDP
  P_sol=double(P); %�������� ��������
  Y_sol=double(Y);%�������� �������
  Pmatrices(:,:,k)=P_sol;%��������� alpha
  Ymatrices(:,:,k)=Y_sol;%� ���������
  cost(k)=trace(C*P_sol*C');%����������
end;