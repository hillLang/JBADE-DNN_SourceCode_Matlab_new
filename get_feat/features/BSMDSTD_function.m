function feat_BSMDSTD = BSMDSTD_function(mix_sig, vad_frame, WINDOW, OFFSET)

fs = 16000;
fftlen = 2048;
LowFre = fix(200*fftlen/fs);
HighFre = fix(4000*fftlen/fs);
mix_sig_l_frame = zeros(WINDOW, 1);
mix_sig_r_frame = zeros(WINDOW, 1);

n_sample = size(mix_sig,1);
n_frame = floor(n_sample/OFFSET);

for j = 1 : 1 : n_frame
    mix_sig_l_frame = [mix_sig_l_frame(OFFSET+1 : end); mix_sig((j-1)*OFFSET+1 : j*OFFSET, 1)];
    mix_sig_r_frame = [mix_sig_r_frame(OFFSET+1 : end); mix_sig((j-1)*OFFSET+1 : j*OFFSET, 2)];
%     [acor,lag_v] = xcorr(mix_sig_l_frame, mix_sig_r_frame, maxlag);
    FFT_L_FRAME = fft(mix_sig_l_frame, fftlen);
    FFT_R_FRAME = fft(mix_sig_r_frame, fftlen);
    if(vad_frame(j) == 1)
        log_powL = 10*log10(abs(FFT_L_FRAME(1:fftlen/2+1)).^2);
        log_powR = 10*log10(abs(FFT_R_FRAME(1:fftlen/2+1)).^2);
        delta_pow = log_powL - log_powR;
        for i = 1 : length(delta_pow)
            if(delta_pow(i) > 40)
                delta_pow(i) = 40;
            elseif(delta_pow(i) < -40)
                delta_pow(i) = -40;
            end
        end
%         mean_delta_pow = sum(delta_pow(LowFre:HighFre))/(HighFre - LowFre + 1);
%         frame_BSMDSTD(sum(vad_frame(1:j))) = sum((delta_pow(LowFre:HighFre)-mean_delta_pow).^2)/(HighFre - LowFre + 1);
%         feat_BSMDSTD(2, sum(vad_frame(1:j))) = mean_delta_pow;
        frame_BSMDSTD(sum(vad_frame(1:j))) = std(delta_pow(LowFre:HighFre));
%         powR = sum(mix_sig_r_frame.^2);
%         acorNorm=acor./ repmat(eps + sqrt(powL .* powR),[length(lag_v) 1]);
%         feat_CCF(:, sum(vad_frame(1:j))) = acorNorm;
    end
end
feat_BSMDSTD = mean(frame_BSMDSTD);
feat_BSMDSTD = repmat(feat_BSMDSTD, 1, sum(vad_frame));
end