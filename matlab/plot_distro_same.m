function [h] = plot_distro_same( distro_mat, NumTopDisplayed, titlestr, xlabelstr, ylabelstr, visible )

for i=1:256
    for j=1:256
        if i ~= j
            distro_mat(i,j) = 0;
        end
    end
end

distro_mat_1d = reshape(distro_mat',[256*256,1]);
totalTransitions = sum(distro_mat_1d);

[val, ind] = sort(distro_mat_1d,'descend');
values = [val(1:NumTopDisplayed)' sum(val(NumTopDisplayed+1:end))];

for i = 1:NumTopDisplayed
    x_ind = floor((ind(i)-1) / 256);
    y_ind = mod(ind(i)-1, 256);
    names{i} = ['(' num2str(x_ind) ',' num2str(y_ind) ')' ' ' num2str(values(i)/totalTransitions*100,2) '%'];
end
names{NumTopDisplayed+1} = ['Other byte transitions '  num2str(values(NumTopDisplayed+1)/totalTransitions*100,2) '%'];

% for i=1:NumTopDisplayed+1
%     names{i} = [names{i} ' (%' num2str(values(i)/totalTransitions*100,2) ')'];
% end

h = figure('visible', visible);
pie(values,names);
title(titlestr);

% for i = 1:65536
%     x_ind = floor((ind(i)-1) / 256);
%     y_ind = mod(ind(i)-1, 256);
%     pareto_names{i} = ['(' num2str(x_ind) ',' num2str(y_ind) ')'];
% end
% 
% figure
% pareto(val,pareto_names)
% xlabel(xlabelstr)
% ylabel(ylabelstr)
% title(titlestr);
% grid on

end

