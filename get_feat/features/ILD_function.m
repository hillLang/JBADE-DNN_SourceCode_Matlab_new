function feat_ILD = ILD_function(g_mix_l, g_mix_r, vad_frame, WINDOW, OFFSET)

Nband = size(g_mix_l,1);
Max_ILD = 30;
g_mix_l_frame = zeros(WINDOW, 1);
g_mix_r_frame = zeros(WINDOW, 1);
n_sample = size(g_mix_l,2);
n_frame = floor(n_sample/OFFSET);

total_frame = sum(vad_frame);

for i = 1 : Nband
    for j = 1 : 1 : n_frame
        g_mix_l_frame = [g_mix_l_frame(OFFSET+1 : end); g_mix_l(i, (j-1)*OFFSET+1 : j*OFFSET)'];
        g_mix_r_frame = [g_mix_r_frame(OFFSET+1 : end); g_mix_r(i, (j-1)*OFFSET+1 : j*OFFSET)'];
        if(vad_frame(j) == 1)
            feat_ILD(i, sum(vad_frame(1:j))) = 20*log10(sum(g_mix_l_frame.^2)/sum(g_mix_r_frame.^2));
            if(feat_ILD(i, sum(vad_frame(1:j))) > 40)
                feat_ILD(i, sum(vad_frame(1:j))) = 40;
            elseif(feat_ILD(i, sum(vad_frame(1:j))) < -40)
                feat_ILD(i, sum(vad_frame(1:j))) = -40;
            end
        end
    end
end
