function feat_CCF = CCF_Function(mix_sig, vad_frame, WINDOW, OFFSET)

fs = 16000;
maxDelay = 0.001;   %×î´óÑÓ³ÙÎª1ms;
maxlag = round( maxDelay * fs );

mix_sig_l_frame = zeros(WINDOW, 1);
mix_sig_r_frame = zeros(WINDOW, 1);

n_sample = size(mix_sig,1);
n_frame = floor(n_sample/OFFSET);

for j = 1 : 1 : n_frame
    mix_sig_l_frame = [mix_sig_l_frame(OFFSET+1 : end); mix_sig((j-1)*OFFSET+1 : j*OFFSET, 1)];
    mix_sig_r_frame = [mix_sig_r_frame(OFFSET+1 : end); mix_sig((j-1)*OFFSET+1 : j*OFFSET, 2)];
    [acor,lag_v] = xcorr(mix_sig_l_frame, mix_sig_r_frame, maxlag);
    if(vad_frame(j) == 1)
        powL = sum(mix_sig_l_frame.^2);
        powR = sum(mix_sig_r_frame.^2);
        acorNorm=acor./ repmat(eps + sqrt(powL .* powR),[length(lag_v) 1]);
        feat_CCF(:, sum(vad_frame(1:j))) = acorNorm;
    end
end
feat_CCF = feat_CCF;
end