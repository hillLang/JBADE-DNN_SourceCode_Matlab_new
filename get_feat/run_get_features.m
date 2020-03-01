global feat_set_size feat_start feat_end NUMBER_CHANNEL is_wiener_mask;
global feat_data feat_label;
rng default;

DATA_PATH  %%%% bef %%%%%%
MAT = matfile(DATA_PATH,'Writable',false);
% small_speech_cell =  MAT.small_speech_cell(1,feat_start:feat_end);
% small_noise_cell =  MAT.small_noise_cell(1,feat_start:feat_end);
small_mix_cell =  MAT.small_mix_cell(1,feat_start:feat_end);

feat_data = []; feat_label=[];
vad_frames = zeros(feat_set_size, 1);
for i=1:feat_set_size
    [tmp_features, tmp_IBM] = just_ibm( small_mix_cell{i},fun_name, NUMBER_CHANNEL,is_wiener_mask, db);
    vad_frames(i) = size(tmp_IBM, 1);
    feat_data = [feat_data; transpose(tmp_features)];
    tmp_IBM(:, 1) = 15* mod(i-1, 13)* tmp_IBM- 90;      %signal i µÄ½Ç¶È
    tmp_IBM(:, 2) = fix(mod(i-1, 52)/13);
    feat_label = [feat_label; tmp_IBM];  
    fprintf(1,'index = %d\n',i);
end

%if this is a test set, create double frame index 
DFI = zeros(feat_set_size,2); % double frame index
if part < 0
    start_pointer =1;
    stop_pointer = 0;
    disp('creating double frame index DFI...')
    for i=1:feat_set_size
	number_frames = vad_frames(i);
        stop_pointer = stop_pointer + number_frames; %160 is the OFFSET when 16e3 sampling rate is used
        DFI(i,:) = [start_pointer, stop_pointer];
        start_pointer = start_pointer + number_frames;
    end	    
    disp(['stop_pointer=' num2str(stop_pointer)]);
    disp(['data_frames=' num2str(size(feat_data,1)) ' num. of test sentence=' num2str(feat_set_size)]);
end
