function generate_test_mix( noise_ch, dB, test_list, TMP_STORE)
    warning('off','all');
    global min_cut;

    tmp_str = strsplit(noise_ch,'_');
    noise_name = tmp_str{1};

    fprintf(1,'\nMix Test Set, noise_name = %s ######\n\n',noise_name);
%     num_sent = numel(textread(test_list,'%1c%*[^\n]')); 
    sound_path = 'F:\PHD works\DNN\Matlab-toolbox-for-DNN-based-BSSL-RealRoom_0215\premix_data\Kamer_room511/*.wav';
    sounddir = dir(sound_path);
    num_sent = size(sounddir,1);
    small_mix_cell = cell(1,num_sent*29);   %每个类型的声音为1min，前30s为测试语音，划分为2s一个数据，重叠率50%，共29组
%     small_noise_cell = cell(1,num_sent*59);
%     small_speech_cell = cell(1,num_sent*59);
%     alpha_mat = zeros(1,num_sent*59);
%     c_mat = zeros(1,num_sent*59);
    
    index_sentence = 1;

%     fid = fopen(test_list);
%     tline = fgetl(fid);
    iteration = 1;
    constant = 5*10e6; % used for engergy normalization for mixed signal
    c = 1;
    
    for d = 1 : 29
        [tmp_n  fs] = audioread(['..' filesep '..' filesep 'premix_data' filesep 'noise' filesep noise_name '.wav']);   
        tmp_n = tmp_n(:,:);
        
        %IEEE sentence
%         [s  s_fs] = audioread(['..' filesep '..' filesep 'premix_data' filesep 'Kamer_room503' filesep sounddir(num).name]);
%         tmp_n = resample(tmp_n,16000,fs);
        
        % only take the second part of the noise
%         tmp_n = tmp_n(ceil(length(tmp_n)*min_cut):end-1, :);
        
%         load(['..' filesep '..' filesep 'mat' filesep 'hrir_meeting.mat']);
    
%         speech_dis = 2;
%         [Ang, Dis] = size(hrir_meeting);
        for num = 1 : num_sent
            [s  s_fs] = audioread(['..' filesep '..' filesep 'premix_data' filesep 'Kamer_room503' filesep sounddir(num).name]);
            s = resample(s,16000,s_fs); %resamples to 16000 samples/second
            s = s(1*16000+1:60*16000, :);         %White Noise
%             x_binaural = [];
%                 hrtf_left(:,AngIdx) = hrir_meeting{AngIdx,d}(1:end, 1);
%                 hrtf_right(:,AngIdx) = hrir_meeting{AngIdx,d}(1:end, 2); 
%                 s_binaural(:, 1) = fftfilt(hrtf_left(:,AngIdx), s);
%                 s_binaural(:, 2) = fftfilt(hrtf_right(:,AngIdx), s);
                %choosing a point where we start to cut
            x_binaural = s((d-1)*16000+1 : (d+1)*16000, :);
            start_cut_point = randi(length(tmp_n)-length(x_binaural)+1);
            
            %cut
            n = tmp_n (start_cut_point:start_cut_point+length(x_binaural)-1, :);
            
            %compute SNR
            snr = 10*log10(sum(x_binaural.^2)/sum(n.^2));
            
            db = dB;
            alpha = sqrt(  sum(x_binaural.^2)/(sum(n.^2)*10^(db/10)) );
            
            %check SNR
            snr1 = 10*log10(sum(x_binaural.^2)/sum((alpha.*n).*(alpha.*n)));
            
            mix = x_binaural + alpha*n;
            store_index = (d-1)*52+num;
%           audiowrite(['..' filesep '..' filesep 'mat' filesep 'Distance_dataset_test' filesep num2str(store_index) '.wav'], mix, fs);
            c = sqrt(constant * length(mix)/sum(sum(mix.^2)));
            mix = mix*c;
                
            small_mix_cell{store_index} = single(mix);
              
%             small_speech_cell{(index_sentence-1)*39+13*(d-1)+AngIdx} = single(s_binaural);
        
%             small_noise_cell{(index_sentence-1)*39+13*(d-1)+AngIdx} = single(alpha*n);
        
%             alpha_mat((index_sentence-1)*39+13*(d-1)+AngIdx) = alpha;
        
%             c_mat((index_sentence-1)*39+13*(d-1)+AngIdx) = c;
            
%             after_constant = sum(sum(mix.^2))/length(mix); 
            fprintf(1,'before_snr=%f, using db=%d, after_snr=%f, index_sentence=%d\n', snr, db, snr1,store_index);
                %read next line from list.txt
%                 audiowrite(['..' filesep '..' filesep 'mat' filesep 'Distance_dataset_test' filesep num2str(store_index) '.wav'], mix, fs)
        end
%         tline = fgetl(fid);
        
        iteration = iteration + 1;
        index_sentence =index_sentence +1;
    end
%     fclose(fid); 

    save_path = [TMP_STORE filesep 'db' num2str(dB)];
    if ~exist(save_path,'dir'); mkdir(save_path); end;
    save_path = [TMP_STORE filesep 'db' num2str(dB) filesep 'mix' filesep];
    if ~exist(save_path,'dir'); mkdir(save_path); end;

    save([save_path, 'test_', noise_ch, '_mix_aft2.mat'], 'small_mix_cell', '-v7.3');
    warning('on','all');
end
