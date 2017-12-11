%connector on 12345678;
%m = mobiledev;
% 获取数据
%[acc, t_acc] = accellog(m); %处理刚测量的数据时取消注释，处理保存数据时加上注释
%[ang, t_ang] = angvellog(m); %处理刚测量的数据时取消注释，处理保存数据时加上注释

%计算步长
[t_s,d,locs]=DIS(acc,t_acc);%保存时间的矩阵，保存每步步长的矩阵，保存抽样点数的矩阵
d_ans = cumsum(d);%每一步步长累加的值
figure(1);
plot(t_s,d);
xlabel('Time (s)');
ylabel('Step(m)');

%计算转动角度
Ori=[];
Ori=DIR(ang,t_ang);
figure(2);
plot(t_ang,Ori);
xlabel('Time (s)');
ylabel('Oritention(角度)');

%采样比例转换
n1=length(t_acc);%acc的采样长度
n2=length(t_ang);%ang的采样长度

%计算坐标
x0=0;
y0=0;
Ori_ans=[];
for i=1:1:length(locs)
   tmp=locs(i);%取出每个步长对应的点
   tmp1=round((tmp/n1)*n2);%转换成角度采样对应的点
   Ori_ans=[Ori_ans,Ori(tmp1)]; 
end

%计算坐标值
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
title('路径曲线');
xlabel('x(m)');
ylabel('y(m)');
