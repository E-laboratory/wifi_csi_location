clc; clear; close all;
%%%%%%%%%%%%%%%%%% MUSIC %%%%%%%%%%%%%%%%%%
derad = pi/180;
N = 8;               % ��Ԫ����        
M = 3;               % ��Դ��Ŀ
theta = [-20 10 50];  % �����ƽǶ�
snr = 10;            % �����
K = 1024;            % ������ 10/1024

dd = 0.5;            % ��Ԫ��� d=lamda/2      
d=0:dd:(N-1)*dd;
A=exp(-1i*2*pi*d.'*sin(theta*derad));
S=randn(M,K); X=A*S;
X1=awgn(X,snr,'measured');


Rxx=X1*X1'/K;
%InvS=inv(Rxx); 
[EV,D]=eig(Rxx);    % �������� ����ֵ
EVA=diag(D)';
[EVA,I]=sort(EVA);  % ��С�������� ��������
%EVA=fliplr(EVA);   % ��תԪ��
EV=fliplr(EV(:,I)); % ���з�ת��������

for iang = 1:361    % ����
        angle(iang)=(iang-181)/2;
        phim=derad*angle(iang);
        a=exp(-1i*2*pi*d*sin(phim)).';
        L=M;    
        En=EV(:,L+1:N);
        %SP(iang)=(a'*a)/(a'*En*En'*a);
        SP(iang)=1/(a'*En*En'*a);
end
SP=abs(SP);
%SPmax=max(SP);
%SP=10*log10(SP/SPmax);  % ��һ��
SP=10*log10(SP);
h=plot(angle,SP);
set(h,'Linewidth',0.5);
xlabel('�����/(degree)');
ylabel('�ռ���/(dB)');
%axis([-100 100 -40 60]);
set(gca, 'XTick',[-100:20:100]);
grid on;  