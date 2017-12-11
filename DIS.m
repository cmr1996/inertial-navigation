%[acc, t_acc] = accellog(m);
function [t_s,d,locs] = DIS(acc,t_acc)
% 处理长度
% 处理加速度
x_acc = acc(:,1);
y_acc = acc(:,2);
z_acc = acc(:,3);
mag = sqrt(sum(x_acc.^2 + y_acc.^2 + z_acc.^2, 2));  %求标准差

%低通滤波
[B,A]=butter(2,0.35,'low');
%注释掉一下语句可以停用低通滤波
mag0 = filter(B,A,mag);
mag = mag0; 

%卡尔曼滤波
%mag0 = kalman_filter(mag,1e-6,1e-5,0,1);
%mag = mag0;

magNoG = mag - mean(mag);%归一化
minPeakHeight = std(magNoG); %标准差
[pks, locs] = findpeaks(magNoG, 'MINPEAKHEIGHT', minPeakHeight);
numSteps = numel(pks);

%figure(4);
%plot(t_s, magNoG);
%xlabel('Time (s)');
%ylabel('Acceleration (m/s^2)');

% 计算步长
d=[];%保存步长
t_s=[];%保存每一步结束的时刻
    %方法1(固定步长)
if 0    %启用方法1将此处改为1
    for i=1:1:length(locs)
        t_s=[t_s,t_acc(locs(i))];
        stemplen=0.824;%经验公式：步长=身高*0.45
        d=[d,stemplen];
    end
    d_ans = cumsum(d);
    %方法2(加速度公式法)
elseif 1   %启用方法2将此处改为1
    %第一个步长，认为使用与否没有关系
    t_s=[t_s,t_acc(locs(1))];
    startstemp=0.834;%初始步长任意取值
    d=[d,startstemp];
    for i=2:1:length(locs)
        tmp = t_acc(locs(i));
        t_s=[t_s,tmp];
        %求加速度的最大值和最小值
        a_tmp = mag(locs(i-1):1:locs(i));
        [acc_max,locmax]=max(a_tmp);
        [acc_min,locmin]=min(a_tmp);
        YiTa=0.65;%公式系数待定
        Li=YiTa*(acc_max-acc_min)^(1/4);
        d=[d,Li];
    end
   %方法3：步频公式法
elseif 0    %此处改为1启动方法3
    step_sum = length(locs); %总步数
    d=[0.6];%保存步长
    di=0.6;%给一个初始值0.6(初始值的大小无关紧要,主要是为了后面的运算)
    t_s=[0];%保存每一步结束的时刻
    for i=2:1:step_sum
        d = [d,di];%每一步的步长
        if i==2
            %cnt = locs(i)-locs(1);
            step_time=t_acc(locs(i))-t_acc(locs(1)); %两步间隔时间
            t_s = [t_s,t_acc(locs(1))];
        else
            step_time=t_acc(locs(i))-t_acc(locs(i-1));
            t_s = [t_s,t_acc(locs(i))];%第i-1步的时刻
        end
        step_freq=1/step_time;%第i-1步的频率
        %计算步长
        if step_freq<=1.35
             di = 0.4375;
        elseif step_freq<2.45
             di = 0.45*step_freq-0.22;
        else
             di = 0.9325;
        end
        
    end
end