function [ ] = plotMemTrans( figname ,filename, fig_folder )

plotsVisible = 'off'; %make this on to display the plots, not only save them
%fig_folder = [filename '_fig']; %change this to change output folder name

text = fileread(filename);

mask = 'L3 miss count';
ind = strfind(text, mask);
lines = regexp(text(ind:ind+200),'\n','split');
% lines = lines(1:end);
tuples = regexp(lines,':','split');

stats = [];
for i=1:4
    stats = [stats sprintf('%s:%s\n',tuples{i}{1},tuples{i}{2})];
end

mask = 'Number of bytes with value:';
ind = strfind(text, mask);
lines = regexp(text(ind:end),'\n','split');
lines = lines(2:end);
tuples = regexp(lines,':','split');

vals = zeros(1,256);
reps = vals;
for i=1:256
    vals(i) = str2double(tuples{i}{2});
end
tuples = tuples(258:end);
for i=1:258
    reps(i) = str2double(tuples{i}{2});
end
tuples = tuples(257:end);

trans_distro = zeros(256,256);
for i=1:256
    for j=1:256
        trans_distro(i,j) = str2double(tuples{(i-1)*256 + j}{2});
    end
end

handles = [];
handles = [handles plot_distro( trans_distro, 7, 'Distribution of transitioning bytes - transfer-wise', 'Byte value', 'Number of occurences' , plotsVisible)];
handles = [handles plot_distro_differing( trans_distro, 10, 'Distribution of transitioning bytes - transfer-wise (only differing bytes)', 'Byte value', 'Number of occurences', plotsVisible )];
handles = [handles plot_distro_same( trans_distro, 4, 'Distribution of transitioning bytes - transfer-wise (only same byte transitions)', 'Byte value', 'Number of occurences', plotsVisible )];
handles = [handles plot_graphs( vals, 7, 'Distribution of byte values read/written', 'Byte value', 'Number of occurences', plotsVisible )];
handles = [handles plot_graphs( reps, 2, 'Distribution of repeated byte values in each bus transfer - bus-wise', 'Byte value', 'Number of occurences', plotsVisible )];

for i=1:length(handles)
    set(handles(i),'Position', [0,0,800,800])
end

cur_folder = cd(fig_folder);
savefig(handles, figname);

for i=1:length(handles)
    saveas(handles(i),[figname '_fig' num2str(i) '.png']);
end

close(handles);

fid = fopen([figname '_stats.txt'],'w');
fprintf(fid,stats);
fclose(fid);

cd(cur_folder);
end

