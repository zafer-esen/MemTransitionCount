function [ ] = plotMemTrans( figname ,filename, fig_folder )

plotsVisible = 'off'; %make this on to display the plots, not only save them
%fig_folder = [filename '_fig']; %change this to change output folder name

try
    text = fileread(filename);
catch
    disp(['Could not open file: ' filename ' No such output file!'])
    return;
end

mask = 'L3 miss count';
ind = strfind(text, mask);
lines = regexp(text(ind:ind+200),'\n','split');
% lines = lines(1:end);
tuples = regexp(lines,':','split');

stats = tuples(1:4); %scalar stats

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

%% read the latex report template before moving into the specified folder
% try to open the source latex file and read it
try
    fid = fopen('latex_source.tex');
    latexSource = fread(fid);
    fclose(fid);
catch
    disp('Could not open latex_source.tex, please ensure that this file exists next to the matlab executable.')
    return;
end

% extend every '\' character by another one, otherwise fprintf will give an
% error with latex commands
slashExtendedText = zeros(length(latexSource),1);
offset = 0;
for i=1:length(latexSource)
    slashExtendedText(i+offset) = latexSource(i);
    if latexSource(i) == '\'
        offset = offset + 1;
        slashExtendedText(i+offset) = '\'; 
    end
end

%% move into the fig folder to create the reports and the latex report
cur_folder = cd(fig_folder);
savefig(handles, figname);

for i=1:length(handles)
    saveas(handles(i),[figname '_fig' num2str(i) '.png']);
end

close(handles);

% fid = fopen([figname '_stats.txt'],'w');
% fprintf(fid,stats);
% fclose(fid);

%% create the latex report file

% The following parameters should be passed as strings to fprintf:
% JobName
% 'LLC miss count' and 'value' 
% 'LLC store evict count' and 'value'
% 'Total number of bit transitions' and 'value'
% 'Bit entropy' and 'value'
% JobName
% JobName
% JobName
% JobName
% JobName
% JobName

%try to create the latex report file
try
    fid = fopen([figname '_report.tex'],'w');    
    fprintf(fid,char(slashExtendedText'),...
        figname,...
        stats{1}{1},stats{1}{2},...
        stats{2}{1},stats{2}{2},...
        stats{3}{1},stats{3}{2},...
        stats{4}{1},stats{4}{2},...
        figname,figname,figname,figname,figname,figname);
    fclose(fid);
catch
    disp('Could not write the output latex report file. There might have been an error getting write access to the created file.');
end

%% the end
cd(cur_folder);
end

