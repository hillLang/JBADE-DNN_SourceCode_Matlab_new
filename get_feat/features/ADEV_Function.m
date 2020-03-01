function feat_ADEV = ADEV_Function(feat_ILD, mean_ILD)
[m, n] = size(feat_ILD);
my_mean_ILD = repmat(mean_ILD, 1, n);
feat_ADEV = mean(abs(feat_ILD - my_mean_ILD), 2);
end