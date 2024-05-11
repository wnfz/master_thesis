%% Function to calculate standart error of the mean
function se = sem(data)
    n = length(data);
    se = std(data) / sqrt(n);
end
