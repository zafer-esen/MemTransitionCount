function [h] = plot_graphs( vals, NumTopDisplayed, titlestr, xlabelstr, ylabelstr, visible )

totalBytes = sum(vals);

[val, ind] = sort(vals,'descend');
values = [val(1:NumTopDisplayed) sum(val(NumTopDisplayed+1:end))];
names = [cellstr(num2str(ind(1:NumTopDisplayed)'-1));'Other byte values'];

for i=1:NumTopDisplayed+1
    names{i} = [names{i} ' (%' num2str(values(i)/totalBytes*100,2) ')'];
end

h(1) = figure('visible', visible);
pie(values,names);
title(titlestr);

h(2) = figure('visible', visible);
pareto(val,num2str(ind'-1))
xlabel(xlabelstr)
ylabel(ylabelstr)
title(titlestr);
grid on

end

