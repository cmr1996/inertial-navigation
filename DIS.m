%[acc, t_acc] = accellog(m);
function [t_s,d,locs] = DIS(acc,t_acc)
% ������
% ������ٶ�
x_acc = acc(:,1);
y_acc = acc(:,2);
z_acc = acc(:,3);
mag = sqrt(sum(x_acc.^2 + y_acc.^2 + z_acc.^2, 2));  %���׼��

%��ͨ�˲�
[B,A]=butter(2,0.35,'low');
%ע�͵�һ��������ͣ�õ�ͨ�˲�
mag0 = filter(B,A,mag);
mag = mag0; 

%�������˲�
%mag0 = kalman_filter(mag,1e-6,1e-5,0,1);
%mag = mag0;

magNoG = mag - mean(mag);%��һ��
minPeakHeight = std(magNoG); %��׼��
[pks, locs] = findpeaks(magNoG, 'MINPEAKHEIGHT', minPeakHeight);
numSteps = numel(pks);

%figure(4);
%plot(t_s, magNoG);
%xlabel('Time (s)');
%ylabel('Acceleration (m/s^2)');

% ���㲽��
d=[];%���沽��
t_s=[];%����ÿһ��������ʱ��
    %����1(�̶�����)
if 0    %���÷���1���˴���Ϊ1
    for i=1:1:length(locs)
        t_s=[t_s,t_acc(locs(i))];
        stemplen=0.824;%���鹫ʽ������=���*0.45
        d=[d,stemplen];
    end
    d_ans = cumsum(d);
    %����2(���ٶȹ�ʽ��)
elseif 1   %���÷���2���˴���Ϊ1
    %��һ����������Ϊʹ�����û�й�ϵ
    t_s=[t_s,t_acc(locs(1))];
    startstemp=0.834;%��ʼ��������ȡֵ
    d=[d,startstemp];
    for i=2:1:length(locs)
        tmp = t_acc(locs(i));
        t_s=[t_s,tmp];
        %����ٶȵ����ֵ����Сֵ
        a_tmp = mag(locs(i-1):1:locs(i));
        [acc_max,locmax]=max(a_tmp);
        [acc_min,locmin]=min(a_tmp);
        YiTa=0.65;%��ʽϵ������
        Li=YiTa*(acc_max-acc_min)^(1/4);
        d=[d,Li];
    end
   %����3����Ƶ��ʽ��
elseif 0    %�˴���Ϊ1��������3
    step_sum = length(locs); %�ܲ���
    d=[0.6];%���沽��
    di=0.6;%��һ����ʼֵ0.6(��ʼֵ�Ĵ�С�޹ؽ�Ҫ,��Ҫ��Ϊ�˺��������)
    t_s=[0];%����ÿһ��������ʱ��
    for i=2:1:step_sum
        d = [d,di];%ÿһ���Ĳ���
        if i==2
            %cnt = locs(i)-locs(1);
            step_time=t_acc(locs(i))-t_acc(locs(1)); %�������ʱ��
            t_s = [t_s,t_acc(locs(1))];
        else
            step_time=t_acc(locs(i))-t_acc(locs(i-1));
            t_s = [t_s,t_acc(locs(i))];%��i-1����ʱ��
        end
        step_freq=1/step_time;%��i-1����Ƶ��
        %���㲽��
        if step_freq<=1.35
             di = 0.4375;
        elseif step_freq<2.45
             di = 0.45*step_freq-0.22;
        else
             di = 0.9325;
        end
        
    end
end