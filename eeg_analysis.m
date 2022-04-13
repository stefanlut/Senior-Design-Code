clear,clc, close all;
load("ChannelNames.mat")
%% Reference Layer Test 1 - Pre Process
load("RefLayerTest1.mat");
newEEG1 = struct();
newEEG1.srate = 200;
newEEG1.times = downsample(EEG.times,EEG.srate/newEEG1.srate) / 1000;
EEGchannels = ["Oz","POz","C3","C4","Pz","Cz","F7","Fz","P8","M2","Fpz","P7","T8"];
figure;

for i = 1:size(EEG.data,1)
    newEEG1.filtered_data(i,:) = lowpass(EEG.data(i,:),60,EEG.srate);
    newEEG1.data(i,:) = downsample(newEEG1.filtered_data(i,:),EEG.srate/newEEG1.srate);
    check = 0;
    subplot(8,8,i);
    for j = 1:length(EEGchannels)
        if cell2mat(strfind(EEGchannels,string(names(i))))
        check = 1;
        end
    end
    if check
        plot(newEEG1.times,newEEG1.data(i,:),'r');
    else
        plot(newEEG1.times,newEEG1.data(i,:),'b');
    end
    
    title(string(names(i)));
    xlabel('time (s)');
    
end
%% Frequency Graphs Across all time
figure(2);
count = 1;
for i = 1:size(EEG.data,1)
       subplot(8,8,i)
       pwelch(newEEG1.data(i,:),[],[],[],newEEG1.srate);
       title(string(names(i)));
       ylabel("Power/Frequency");
       xlabel("Normalized Frequency");
       xlim([0 60]);
end
sgtitle('PSD across all time');
figure(3);
newEEG1.eyes_closed_time = downsample(EEG.times(470601:626501),EEG.srate/newEEG1.srate);
for i = 1:size(EEG.data,1)
       newEEG1.eyes_closed_data(i,:) = downsample(EEG.data(i,470601:626501),EEG.srate/newEEG1.srate);
       subplot(8,8,i)
       pwelch(newEEG1.eyes_closed_data(i,:),[],[],[],newEEG1.srate);
       title(string(names(i)));
       ylabel("Power/Frequency");
       xlabel("Normalized Frequency");
       xlim([0 60]);
end
sgtitle('PSD Across Eyes Closed Period');
figure(4);
newEEG1.eyes_open_time = downsample(EEG.times(626501:782001),EEG.srate/newEEG1.srate);
for i = 1:size(EEG.data,1)
    newEEG1.eyes_open_data(i,:) = downsample(EEG.data(i,626501:782001),EEG.srate/newEEG1.srate);
end
for i = 1:size(EEG.data,1)
       subplot(8,8,i)
       pwelch(newEEG1.eyes_open_data(i,:),[],[],[],newEEG1.srate);
       title(string(names(i)));
       ylabel("Power/Frequency");
       xlabel("Normalized Frequency");
       xlim([0 60]);
end
sgtitle('PSD Across Eyes Open Period');
%% Open vs Close
close all;
EEGvsRef = struct();
EEGvsRef.Oz = struct();
[EEGvsRef.Oz.yclose , EEGvsRef.Oz.xclose] = pwelch(downsample(EEG.data(22,470601:626501),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate);
figure;subplot(121);
%[y,x] = pwelch(downsample(EEG.data(22,470601:626501),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate);
%plot(x,10*log10(y))
%pwelch(downsample(EEG.data(22,470601:626501),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate);title("Oz eyes closed");xlim([0 60]);
plot(EEGvsRef.Oz.xclose, 10*log10(EEGvsRef.Oz.yclose)); grid on; xlim([0 60]); title("Oz eyes closed"); xlabel("Frequency (Hz)"); ylabel("Power/Frequency (dB/Hz)")
subplot(122);
pwelch(downsample(EEG.data(22,626501:782001),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate); title("Oz eyes open");xlim([0 60]);

figure;
subplot(321);
pwelch(downsample(EEG.data(9,470601:626501),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate);title("O1 eyes closed");xlim([0 60]);
subplot(322);
pwelch(downsample(EEG.data(9,626501:782001),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate);title("O1 eyes open");xlim([0 60]);
subplot(323);
pwelch(downsample(EEG.data(10,470601:626501),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate);title("O2 eyes closed");xlim([0 60]);
subplot(324);
pwelch(downsample(EEG.data(10,626501:782001),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate);title("O2 eyes open");xlim([0 60]);
subplot(325);
pwelch(downsample(EEG.data(21,470601:626501),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate);title("POz eyes closed");xlim([0 60]);
subplot(326);
pwelch(downsample(EEG.data(21,626501:782001),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate);title("POz eyes open");xlim([0 60]);