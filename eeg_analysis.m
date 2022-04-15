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

eyes_closed1 = 470601;
eyes_open1 = 626501;
eyes_closed2 = 782001;

% [EEGvsRef.Oz.yclose1 , EEGvsRef.Oz.xclose1] = pwelch(downsample(EEG.data(22,eyes_closed1:eyes_open1),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate);
% figure; subplot(2,2,1);
% plot(EEGvsRef.Oz.xclose1, 10*log10(EEGvsRef.Oz.yclose1),'r'); grid on; xlim([0 20]); title("EEG Channels- Eyes Closed"); xlabel("Frequency (Hz)"); ylabel("Power/Frequency (dB/Hz)")
% legend('Oz');
% 
% subplot(2,2,2);
% [EEGvsRef.Oz.yclose2 , EEGvsRef.Oz.xclose2] = pwelch(downsample(EEG.data(22,eyes_open1:eyes_closed2),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate); 
% plot(EEGvsRef.Oz.xclose2, 10*log10(EEGvsRef.Oz.yclose2),'r'); grid on; xlabel("Frequency (Hz)"); ylabel("Power/Frequency (dB/Hz)"); title("EEG Channels- Eyes Open");xlim([0 20]);
% legend('Oz');

eegchannels=["Oz"];
for i=1:length(eegchannels)
    EEGvsRef.(eegchannels{i}) = struct();
 
    subplot(221); 
    [EEGvsRef.(eegchannels{i}).yclose1, EEGvsRef.(eegchannels{i}).xclose1] = pwelch(downsample(EEG.data(find(strcmp(string(names),eegchannels{i})),eyes_closed1:eyes_open1),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate);
    plot(EEGvsRef.(eegchannels{i}).xclose1, 10*log10(EEGvsRef.(eegchannels{i}).yclose1));
    if i==length(eegchannels)
        legend('Oz'); title("EEG Channels- Eyes Closed");xlim([0 20]); grid on; xlabel("Frequency (Hz)"); ylabel("Power/Frequency (dB/Hz)")
    end
    hold on
    
     subplot(222); 
     [EEGvsRef.(eegchannels{i}).yclose2, EEGvsRef.(eegchannels{i}).xclose2] = pwelch(downsample(EEG.data(find(strcmp(string(names),eegchannels{i})),eyes_open1:eyes_closed2),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate);
     plot(EEGvsRef.(eegchannels{i}).xclose2, 10*log10(EEGvsRef.(eegchannels{i}).yclose2));
   
    if i==length(eegchannels)
        legend('Oz'); title("EEG Channels- Eyes Open");xlim([0 20]); grid on; xlabel("Frequency (Hz)"); ylabel("Power/Frequency (dB/Hz)")
    end
    hold on
end

refchannels=["O1","O2","POz"]; 
for i=1:length(refchannels)
    EEGvsRef.(refchannels{i}) = struct();
 
    subplot(223); 
    [EEGvsRef.(refchannels{i}).yclose1, EEGvsRef.(refchannels{i}).xclose1] = pwelch(downsample(EEG.data(find(strcmp(string(names),refchannels{i})),eyes_closed1:eyes_open1),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate);
    plot(EEGvsRef.(refchannels{i}).xclose1, 10*log10(EEGvsRef.(refchannels{i}).yclose1));
    if i==length(refchannels)
        legend('O1','O2','POz'); title("Ref Channels- Eyes Closed");xlim([0 20]); grid on; xlabel("Frequency (Hz)"); ylabel("Power/Frequency (dB/Hz)")
    end
    hold on
    
     subplot(224); 
     [EEGvsRef.(refchannels{i}).yclose2, EEGvsRef.(refchannels{i}).xclose2] = pwelch(downsample(EEG.data(find(strcmp(string(names),refchannels{i})),eyes_open1:eyes_closed2),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate);
     plot(EEGvsRef.(refchannels{i}).xclose2, 10*log10(EEGvsRef.(refchannels{i}).yclose2));
   
    if i==length(refchannels)
        legend('O1','O2','POz'); title("Ref Channels- Eyes Open");xlim([0 20]); grid on; xlabel("Frequency (Hz)"); ylabel("Power/Frequency (dB/Hz)")
    end
    hold on
end





% 
% EEGvsRef.O1 = struct();
% EEGvsRef.O2 = struct();
% EEGvsRef.POz = struct();
% 
% subplot(223);
% [EEGvsRef.O1.yclose1, EEGvsRef.O1.xclose1] = pwelch(downsample(EEG.data(9,eyes_closed1:eyes_open1),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate);
% plot(EEGvsRef.O1.xclose1, 10*log10(EEGvsRef.O1.yclose1));
% hold on
% 
% [EEGvsRef.O2.yclose1, EEGvsRef.O2.xclose1] = pwelch(downsample(EEG.data(10,eyes_closed1:eyes_open1),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate);
% plot(EEGvsRef.O2.xclose1, 10*log10(EEGvsRef.O2.yclose1));  
% hold on
% 
% [EEGvsRef.POz.yclose1 , EEGvsRef.POz.xclose1] = pwelch(downsample(EEG.data(21,eyes_closed1:eyes_open1),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate);
% plot(EEGvsRef.POz.xclose1, 10*log10(EEGvsRef.POz.yclose1));
% legend('O1','O2','POz'); title("Ref Channels- Eyes Closed");xlim([0 20]); grid on; xlabel("Frequency (Hz)"); ylabel("Power/Frequency (dB/Hz)")
% 
% 
% 
% subplot(224);
% [EEGvsRef.O1.yclose2, EEGvsRef.O1.xclose2] = pwelch(downsample(EEG.data(9,eyes_open1:eyes_closed2),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate);
% plot(EEGvsRef.O1.xclose2, 10*log10(EEGvsRef.O1.yclose2)); 
% hold on
% 
% 
% [EEGvsRef.O2.yclose2, EEGvsRef.O2.xclose2] = pwelch(downsample(EEG.data(10,eyes_open1:eyes_closed2),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate);
% plot(EEGvsRef.O2.xclose2, 10*log10(EEGvsRef.O2.yclose2)); 
% hold on
% 
% [EEGvsRef.POz.yclose2 , EEGvsRef.POz.xclose2] = pwelch(downsample(EEG.data(21,eyes_open1:eyes_closed2),EEG.srate/newEEG1.srate),[],[],[],newEEG1.srate);
% plot(EEGvsRef.POz.xclose2, 10*log10(EEGvsRef.POz.yclose2));
% legend('O1','O2','POz'); title("Ref Channels- Eyes Open");xlim([0 20]); grid on; xlabel("Frequency (Hz)"); ylabel("Power/Frequency (dB/Hz)")

