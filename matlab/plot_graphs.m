function [h] = plot_graphs( vals, NumTopDisplayed, titlestr, xlabelstr, ylabelstr, visible )

totalBytes = sum(vals);

[val, ind] = sort(vals,'descend');
values = [val(1:NumTopDisplayed) sum(val(NumTopDisplayed+1:end))];
names = [cellstr(num2str(ind(1:NumTopDisplayed)'-1));'Other'];

for i=1:NumTopDisplayed+1
    names{i} = [names{i} ' (%' num2str(values(i)/totalBytes*100,2) ')'];
end

h(1) = figure('visible', visible);
pie(values);
legend(names,'Location','eastoutside','Orientation','vertical')
title(titlestr);
hText = findobj(h(1),'Type','text');
strings = get(hText,'String');

textPositions_cell = get(hText,{'Position'}); 
textPositions = cell2mat(textPositions_cell); 

textPositions = textPositions*0.91;
for i=1:length(hText)
    hText(i).Position = textPositions(i,:) ;
end

h(2) = figure('visible', visible);
pareto(val,num2str(ind'-1))
xlabel(xlabelstr)
ylabel(ylabelstr)
title(titlestr);
grid on

end

