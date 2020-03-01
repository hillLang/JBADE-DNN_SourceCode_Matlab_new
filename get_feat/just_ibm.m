function [ features, ideal_mask] = just_ibm( mix_sig, fun_name, NUMBER_CHANNEL,is_wiener_mask, db)
SAMPLING_FREQUENCY = 16000;
WINDOW     = (SAMPLING_FREQUENCY*0.08);     % use a window of 20 ms */
OFFSET     = (WINDOW/2);                  % compute acf every 10 ms */

[n_sample, m] = size(mix_sig);

n_frame = floor(n_sample/OFFSET);

vad_frame = zeros(n_frame, 1);

[vad_frame] = vad_function(mix_sig, n_frame, WINDOW, OFFSET);        
% g_voice = gammatone(voice_sig, NUMBER_CHANNEL, [50 8000], SAMPLING_FREQUENCY);
% coch_voice = cochleagram(g_voice, 320);

% g_noise = gammatone(noise_sig, NUMBER_CHANNEL, [50 8000], SAMPLING_FREQUENCY);
% coch_noise = cochleagram(g_noise, 320);
g_mix_l = gammatone(mix_sig(:, 1), NUMBER_CHANNEL, [80 8000], SAMPLING_FREQUENCY);
% coch_mix_l = cochleagram(g_mix_l, 320);                 %分成64个子带，分别计算ITD

g_mix_r = gammatone(mix_sig(:, 2), NUMBER_CHANNEL, [80 8000], SAMPLING_FREQUENCY) ;
mix_subband1 = [g_mix_l(1, :); g_mix_r(1, :)]';
mix_subband2 = [g_mix_l(2, :); g_mix_r(2, :)]';
mix_subband3 = [g_mix_l(3, :); g_mix_r(3, :)]';
mix_subband4 = [g_mix_l(4, :); g_mix_r(4, :)]';
mix_subband5 = [g_mix_l(5, :); g_mix_r(5, :)]';
mix_subband6 = [g_mix_l(6, :); g_mix_r(6, :)]';
mix_subband7 = [g_mix_l(7, :); g_mix_r(7, :)]';
mix_subband8 = [g_mix_l(8, :); g_mix_r(8, :)]';
% coch_mix_r = cochleagram(g_mix_r, 320);                
feat_BSMDSTD = BSMDSTD_function(mix_sig, vad_frame, WINDOW, OFFSET);
% feat_BSMDSTD = repmat(feat_BSMDSTD, 20, 1);
feat_ILD = ILD_function(g_mix_l, g_mix_r, vad_frame, WINDOW, OFFSET);

mean_ild = mean(feat_ILD, 2); mean_ild = mean_ild(:);
new_feat_ILD = repmat(mean_ild, 1, sum(vad_frame));

var_ild = var(feat_ILD', 1); var_ild =var_ild(:);
std_ild = std(feat_ILD', 1); std_ild = std_ild(:);
skewness_ild = skewness(feat_ILD', 1); skewness_ild = skewness_ild(:);
kurtosis_ild = kurtosis(feat_ILD', 1); kurtosis_ild = kurtosis_ild(:);
ILD_ADEV = ADEV_Function(feat_ILD, mean_ild);

ild_result = [mean_ild; var_ild; std_ild; skewness_ild; kurtosis_ild; ILD_ADEV];
feat_ild_result = repmat(ild_result, 1, sum(vad_frame));
[feat_ITD, feat_ICCC] = ITD_function(g_mix_l, g_mix_r, vad_frame, WINDOW, OFFSET);

mean_itd = mean(feat_ITD, 2); mean_itd = mean_itd(:);
mean_ic = mean(feat_ICCC, 2); mean_ic = mean_ic(:);

var_itd = var(feat_ITD', 1); var_itd =var_itd(:);
std_itd = std(feat_ITD', 1); std_itd = std_itd(:);
skewness_itd = skewness(feat_ITD', 1); skewness_itd = skewness_itd(:);
kurtosis_itd = kurtosis(feat_ITD', 1); kurtosis_itd = kurtosis_itd(:);
ITD_ADEV = ADEV_Function(feat_ITD, mean_itd);

var_ic = var(feat_ICCC', 1); var_ic = var_ic(:);
std_ic = std(feat_ICCC', 1); std_ic = std_ic(:);
skewness_ic = skewness(feat_ICCC', 1); skewness_ic = skewness_ic(:);
kurtosis_ic = kurtosis(feat_ICCC', 1); kurtosis_ic = kurtosis_ic(:);
IC_ADEV = ADEV_Function(feat_ICCC, mean_ic);

itd_result = [ITD_ADEV; mean_ic;var_itd; std_itd; var_ic; std_ic; skewness_ic; kurtosis_ic; IC_ADEV];
feat_itd_result = repmat(itd_result, 1, sum(vad_frame));
new_itd_result = [ITD_ADEV;var_itd; std_itd];
feat_new_itd_result = repmat(new_itd_result, 1, sum(vad_frame)); 
ic_result = [mean_ic; var_ic; std_ic; skewness_ic; kurtosis_ic; IC_ADEV];
feat_ic_result = repmat(ic_result, 1, sum(vad_frame));
feat_CCF_subband1 = CCF_Function(mix_subband1, vad_frame, WINDOW, OFFSET);
feat_CCF_subband1 = mean(feat_CCF_subband1, 2);
feat_CCF_subband1 = repmat(feat_CCF_subband1, 1, sum(vad_frame));
feat_CCF_subband2 = CCF_Function(mix_subband2, vad_frame, WINDOW, OFFSET);
feat_CCF_subband2 = mean(feat_CCF_subband2, 2);
feat_CCF_subband2 = repmat(feat_CCF_subband2, 1, sum(vad_frame));
feat_CCF_subband3 = CCF_Function(mix_subband3, vad_frame, WINDOW, OFFSET);
feat_CCF_subband3 = mean(feat_CCF_subband3, 2);
feat_CCF_subband3 = repmat(feat_CCF_subband3, 1, sum(vad_frame));
feat_CCF_subband4 = CCF_Function(mix_subband4, vad_frame, WINDOW, OFFSET);
feat_CCF_subband4 = mean(feat_CCF_subband4, 2);
feat_CCF_subband4 = repmat(feat_CCF_subband4, 1, sum(vad_frame));
feat_CCF_subband5 = CCF_Function(mix_subband5, vad_frame, WINDOW, OFFSET);
feat_CCF_subband5 = mean(feat_CCF_subband5, 2);
feat_CCF_subband5 = repmat(feat_CCF_subband5, 1, sum(vad_frame));
feat_CCF_subband6 = CCF_Function(mix_subband6, vad_frame, WINDOW, OFFSET);
feat_CCF_subband6 = mean(feat_CCF_subband6, 2);
feat_CCF_subband6 = repmat(feat_CCF_subband6, 1, sum(vad_frame));
feat_CCF_subband7 = CCF_Function(mix_subband7, vad_frame, WINDOW, OFFSET);
feat_CCF_subband7 = mean(feat_CCF_subband7, 2);
feat_CCF_subband7 = repmat(feat_CCF_subband7, 1, sum(vad_frame));
feat_CCF_subband8 = CCF_Function(mix_subband8, vad_frame, WINDOW, OFFSET);
feat_CCF_subband8 = mean(feat_CCF_subband8, 2);
feat_CCF_subband8 = repmat(feat_CCF_subband8, 1, sum(vad_frame));
feat_CCF = [feat_CCF_subband1; feat_CCF_subband2; feat_CCF_subband3; feat_CCF_subband4; feat_CCF_subband5; feat_CCF_subband6; feat_CCF_subband7; feat_CCF_subband8];
%feat_ITD = ITD_function(coch_mix, n_frame, )
% if is_wiener_mask == 0
%     ideal_mask = ideal(coch_voice, coch_noise, db);
% else
%     ideal_mask = wiener(coch_voice, coch_noise);
% end
% f1 = feval(fun_name,mix_sig);
% features = [feat_BSMDSTD; feat_itd_result;feat_ild_result];
features = [feat_ild_result;feat_itd_result;feat_CCF;feat_BSMDSTD];
% features = [feat_ild_result;feat_itd_result;feat_BSMDSTD];
% features = feat_new_itd_result;
% features = [feat_ILD(1:16, :)];
% mean_ild = repmat(mean_ild, 1, sum(vad_frame));
% features = [feat_CCF; feat_BSMDSTD];
ideal_mask = ones(sum(vad_frame), 1);
% features(:,:) = f1(:,1:n_frame);
% for p = 1 : length(features) 
%     if(isnan(features(p)) == 1)
%         features(p) = 0;
%     end
% end
features = single(features);
ideal_mask = single(ideal_mask);
end
