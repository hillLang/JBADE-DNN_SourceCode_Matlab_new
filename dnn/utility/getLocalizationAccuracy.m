function accuracy = getLocalizationAccuracy(output, label)
Num = length(output);
Sum = 0;
for j = 1 : Num
    if (abs(output(j, 1) - label(j, 1))<= 0.05)
        Sum = Sum + 1;
    end
end
accuracy = Sum/Num;
end