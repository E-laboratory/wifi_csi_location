%��ѡ���İ���������ȡһ��Vpath
clc; clear; close all;
csi_trace = fiel_read('D:\data_5.19\empty1.dat');
% csi_trace = read_bf_file('D:\data_5.13\walk1.dat');
M = 200; %������
N = 300; %�������   walk1�е�2200��3500��4800��4900
f = 2.4e+9; %�ز�Ƶ��
c = 3e+8; %����
X = []; %�ź�����

% for ii = 1 : M
%     csi_entry = get_scaled_csi(csi_trace{ii+N-1});
%     x1 = squeeze(csi_entry(1,1,:)).';
%     abs_x1 = abs(x1);
%     alpha = min(abs_x1(abs_x1~=0));
%     x1 = abs(abs(x1)-alpha).*exp(1i*angle(x1));
%     
%     x2 = squeeze(csi_entry(1,2,:)).';
%     abs_x2 = abs(x2);
%     beta = max(abs_x2);
%     x2 = abs(abs(x2)+beta).*exp(1i*angle(x2));
%     
%     x3 = x1 .* conj(x2);
%     X = [X; x3];
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X1 = []; X2 = [];
for ii = 1 : M
    csi_entry = get_scaled_csi(csi_trace{ii+N-1});
    x1 = squeeze(csi_entry(1,1,:)).';
    X1 = [X1; x1];
end
for ii1 = 1 : 30
    abs1 = abs(X1(:,ii1));
    alpha = min(abs1(abs1~=0));
    X1(:,ii1) = abs(abs( X1(:,ii1))-alpha).*exp(1i*angle( X1(:,ii1)));
end

for ii = 1 : M
    csi_entry = get_scaled_csi(csi_trace{ii+N-1});
    x2 = squeeze(csi_entry(1,2,:)).';
    X2 = [X2; x2];
end
for ii1 = 1 : 30
    abs2 = abs(X1(:,ii1));
    beta = max(abs2);
    X2(:,ii1) = abs(abs( X2(:,ii1))+beta).*exp(1i*angle( X2(:,ii1)));
end
X = X1 .* conj(X2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%

mX = mean(X,1);
for ii1 = 1 : M
    X(ii1,:) = X(ii1,:) - mX;
end

%pca����,���ݽ�ά�����������ݾ���X
% [X,T,meanValue] = pca_row(X,0.95);
%%
%��ȡ���������һ��������ʱ����������t
t = [];

t0 = csi_trace{N}.timestamp_low;
for ij = 1 : M
    tt = csi_trace{ij+N-1}.timestamp_low;
    t(ij) = 0.001*(tt - t0);
end
%%
%music���� 
Rx = X * X' / 30;
[EV,D]=eig(Rx);    % �������� ����ֵ
EVA=diag(D)';
% figure;
% plot(EVA);

En = EV(:,1:M-3);
for jj = 1 : 101
    vel(jj) = (jj - 51)/10;
    a=exp(-1i*2*pi*f*vel(jj)*t/c).';
    SP(jj)=1/(a'*En*En'*a);
end

SP=abs(SP);
SP=10*log10(SP);
[SP_max, jj] = max(SP);
figure;
h=plot(vel,SP);
% axis([-5  5  -20  -17]);
str = ['�������Ϊ:',num2str(N),', ��������Ϊ:',num2str(M),', ��߼���Ӧ�ٶ�Ϊ:',num2str(vel(jj)),' m/s'];
title(str);  xlabel('·���仯�ٶ�(m/s)');  ylabel('����');
grid on;