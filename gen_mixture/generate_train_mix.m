function generate_train_mix( noise_ch, dB, repeat_time, train_list, TMP_STORE)
    warning('off','all');
    global min_cut;

    tmp_str = strsplit(noise_ch,'_');
    noise_name = tmp_str{1};
   
    fprintf(1,'\nMix Training Set, noise_name = %s repeat_time = %d ######\n',noise_name, repeat_time);
    sound_path = 'F:\PHD works\DNN\Matlab-toolbox-for-DNN-based-BSSL-RealRoom_0215\premix_data\Kamer_room516/*.wav';
    sounddir = dir(sound_path);
    num_sent = size(sounddir,1);
    small_mix_cell = cell(1,29 * num_sent*repeat_time);
%     small_noise_cell = cell(1,39 * num_sent*repeat_time);
%     small_speech_cell = cell(1,39 * num_sent*repeat_time);
%     alpha_mat = zeros(1,39 * num_sent*repeat_time);
%     c_mat = zeros(1,39 * num_sent*repeat_time);
    
    index_sentence = 1;
%     fid = fopen(train_list);
%     tline = fgetl(fid);
    
    constant = 5*10e6; % used for engergy normalization for mixed signal
    c = 1;

    for d = 1 : 29
        [n_tmp  fs] = audioread(['..' filesep '..' filesep 'premix_data' filesep 'noise' filesep noise_name '.wav']);   
        n_tmp = n_tmp(:,:); 
        %IEEE sentence
        
        n_tmp = resample(n_tmp,16000,fs); 
        
        % only take the first half of the noise
        n_tmp = n_tmp(1:floor(length(n_tmp)*min_cut), :);
        double_n_tmp = [n_tmp; n_tmp]; %wrap around

        for var_ind = 1:repeat_time
        
            %choosing a point where we start to cut
            start_cut_point = randi(length(n_tmp));
            
%             load(['..' filesep '..' filesep 'mat' filesep 'hrir_meeting.mat']);
    
%             speech_dis = 2;
%             [Ang, Dis] = size(hrir_meeting);
            for num = 1 : num_sent
                [s  s_fs] = audioread(['..' filesep '..' filesep 'premix_data' filesep 'Kamer_room503' filesep sounddir(num).name]);
                s = resample(s,16000,s_fs); %resamples to 16000 samples/second
                s = s(30*16000 + 1:90*16000, :);         %White Noise
                s_binaural = s((d-1)*16000+1 : (d+1)*16000, :);
%                     s_binaural = [];
%                     hrtf_left(:,AngIdx) = hrir_meeting{AngIdx,d}(1:end, 1);
%                     hrtf_right(:,AngIdx) = hrir_meeting{AngIdx,d}(1:end, 2); 
%                     s_binaural(:, 1) = fftfilt(hrtf_left(:,AngIdx), s);
%                     s_binaural(:, 2) = fftfilt(hrtf_right(:,AngIdx), s);
                    %cut
                 n = double_n_tmp (start_cut_point:start_cut_point+length(s_binaural)-1, :);
                    %compute SNR
                 snr = 10*log10(sum(s_binaural.^2)/sum(n.^2));
                 
                 db = dB;
                 alpha = sqrt(  sum(s_binaural.^2)/(sum(n.^2)*10^(db/10)) );
                    %check SNR
                 snr1 = 10*log10(sum(s_binaural.^2)/sum((alpha.*n).*(alpha.*n)));
                
                
                mix = s_binaural +  + alpha*n;
                store_index = (d-1)*52+num;
%                     audiowrite(['..' filesep '..' filesep 'mat' filesep 'Distance_dataset_train' filesep num2str(store_index) '.wav'], mix, fs);      
                c = sqrt(constant * length(mix)/sum(sum(mix.^2)));
                mix = mix*c;
                
                    
                
                small_mix_cell{store_index} = single(mix);
                
%                     small_speech_cell{store_index} = single(s_binaural);
                
%                     small_noise_cell{store_index} = single(alpha*n);
                
%                     alpha_mat(store_index) = alpha;
            
%                     c_mat(store_index) = c;
                      
%                     after_constant = sum(sum(mix.^2))/length(mix);
                fprintf(1,'before_snr=%f, using db=%d, after_snr=%f, index_sentence=%d\n', snr, db, snr1,store_index);
            end
        end    
%             tline = fgetl(fid);
            index_sentence =index_sentence +1;
    end
    
%     fclose(fid);

save_path = [TMP_STORE filesep 'db' num2str(dB)];
if ~exist(save_path,'dir'); mkdir(save_path); end;
save_path = [TMP_STORE filesep 'db' num2str(dB) filesep 'mix' filesep];
if ~exist(save_path,'dir'); mkdir(save_path); end;

save([save_path, 'train_', noise_ch, '_mix_bef2.mat'], 'small_mix_cell', '-v7.3');
warning('on','all');
