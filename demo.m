%connector on 12345678;
%m = mobiledev;
% ��ȡ����
%[acc, t_acc] = accellog(m); %����ղ���������ʱȡ��ע�ͣ�����������ʱ����ע��
%[ang, t_ang] = angvellog(m); %����ղ���������ʱȡ��ע�ͣ�����������ʱ����ע��

%���㲽��
[t_s,d,locs]=DIS(acc,t_acc);%����ʱ��ľ��󣬱���ÿ�������ľ��󣬱�����������ľ���
d_ans = cumsum(d);%ÿһ�������ۼӵ�ֵ
figure(1);
plot(t_s,d);
xlabel('Time (s)');
ylabel('Step(m)');

%����ת���Ƕ�
Ori=[];
Ori=DIR(ang,t_ang);
figure(2);
plot(t_ang,Ori);
xlabel('Time (s)');
ylabel('Oritention(�Ƕ�)');

%��������ת��
n1=length(t_acc);%acc�Ĳ�������
n2=length(t_ang);%ang�Ĳ�������

%��������
x0=0;
y0=0;
Ori_ans=[];
for i=1:1:length(locs)
   tmp=locs(i);%ȡ��ÿ��������Ӧ�ĵ�
   tmp1=round((tmp/n1)*n2);%ת���ɽǶȲ�����Ӧ�ĵ�
   Ori_ans=[Ori_ans,Ori(tmp1)]; 
end

%��������ֵ
Ori_fin=Ori_ans;
xn = [];
yn = [];
for i=1:1:length(Ori_fin)
   xn = [xn,x0];
   yn = [yn,y0];
   x_tmp = x0 + d(i)*cosd(Ori_fin(i));
   y_tmp = y0 + d(i)*sind(Ori_fin(i));
   x0 = x_tmp;
   y0 = y_tmp;
end

%xi = d.*sin(Ori_fin);
%yi = d.*cos(Ori_fin);
%xn = cumsum(xi);
%yn = cumsum(yi);

figure(3);
plot(xn,yn);
title('·������');
xlabel('x(m)');
ylabel('y(m)');
