function [vad_frame] = vad_function(mix_sig, n_frame, WINDOW, OFFSET)

% voice_sig_frame = zeros(WINDOW, 2);
mix_sig_frame = zeros(WINDOW, 2);

for i = 1 : n_frame
%     voice_sig_frame = [voice_sig_frame(OFFSET+1 : end, :); voice_sig((i-1)*OFFSET+1 : i*OFFSET,:)];
    mix_sig_frame = [mix_sig_frame(OFFSET+1 : end, :); mix_sig((i-1)*OFFSET+1 : i*OFFSET,:)];
%     energy_voice(i) = sum(sum(voice_sig_frame.^2));
    energy_mix(i) = sum(sum(mix_sig_frame.^2));
    if(energy_mix(i) > 6e10)
        vad_frame(i) = 1;
    else
        vad_frame(i) = 0;
    end
end

end