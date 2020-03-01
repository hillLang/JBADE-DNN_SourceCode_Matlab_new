function [feat_ITD, feat_ICCC] = ITD_function(g_mix_l, g_mix_r, vad_frame, WINDOW, OFFSET)

fs = 16000;
maxDelay = 0.001;   %×î´óÑÓ³ÙÎª1ms;
maxlag = round( maxDelay * fs );

Nband = size(g_mix_l,1);
g_mix_l_frame = zeros(WINDOW, 1);
g_mix_r_frame = zeros(WINDOW, 1);

n_sample = size(g_mix_l,2);
n_frame = floor(n_sample/OFFSET);

for i = 1 : Nband
    for j = 1 : 1 : n_frame
        g_mix_l_frame = [g_mix_l_frame(OFFSET+1 : end); g_mix_l(i, (j-1)*OFFSET+1 : j*OFFSET)'];
        g_mix_r_frame = [g_mix_r_frame(OFFSET+1 : end); g_mix_r(i, (j-1)*OFFSET+1 : j*OFFSET)'];
        [acor,lag_v] = xcorr(g_mix_l_frame, g_mix_r_frame, maxlag);
        if(vad_frame(j) == 1)
            powL = sum(g_mix_l_frame.^2);
            powR = sum(g_mix_r_frame.^2);
            acorNorm=acor./ repmat(eps + sqrt(powL .* powR),[length(lag_v) 1]);
            [k,v]=max(acorNorm);
            feat_ITD(i, sum(vad_frame(1:j))) = v;
            feat_ICCC(i, sum(vad_frame(1:j))) = k;
        end
    end
end

end