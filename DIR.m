function Ori = DIR(ang,t_ang)
t0=0.08;%ʱ����

% �������ݲ���ͼ
%x = ang(:,1);
%y = ang(:,2);
z = ang(:,3);

% ������˹��ͨ�˲���
[B,A]=butter(2,0.12,'low');
%y0=filter(B,A,y);
z0=filter(B,A,z);

%�������˲�
%y0 = kalman_filter(y,1e-6,1e-5,0,1);
%z0 = kalman_filter(z,1e-6,1e-5,0,1);

%���Ĺ�ʽ2
Gyr = z0;
%Gyr = sqrt(sum(y0.^2 + z0.^2, 2));

% ���Ĺ�ʽ3
Gyr_k = cumsum(Gyr);
Ori = Gyr_k*t0*57.29578;
%figure(2);
%plot(t_ang,Ori);