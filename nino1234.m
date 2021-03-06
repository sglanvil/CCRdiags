% March 24, 2022
% sglanvil@ucar.edu

clear; clc; close all;

caseName='b.e21.B1850cmip6.f09_g17.CESM2-SF-EE.115';
timeseriesDir='/glade/work/sglanvil/CCR/CCRdiags_OG/out/timeseries/';
plotsDir='/glade/work/sglanvil/CCR/CCRdiags_OG/out/plots/';

lonA=[270 210 190 160];
lonB=[280 270 240 210];
latA=[-10 -5 -5 -5];
latB=[0 5 5 5];
ninoName={'nino12' 'nino3' 'nino34' 'nino4'};

for izone=1:4
    clear year nino; icounter=0;
    fileListing=fopen('/glade/work/sglanvil/CCR/CCRdiags_OG/out/ann.files');
    tline = fgetl(fileListing);
    while ischar(tline)
        icounter=icounter+1;
        disp(tline)
        fil=tline;
        year(icounter)=str2double(extractBetween(fil,'_ANN_','.nc'));
        lon=ncread(fil,'lon');
        lat=ncread(fil,'lat');
        ts=ncread(fil,'TS');
        latZone=lat(lat>=latA(izone) & lat<=latB(izone));
        tsZone=squeeze(nanmean(ts(lon>=lonA(izone) & lon<=lonB(izone),...
            lat>=latA(izone) & lat<=latB(izone)),1))';
        nino(icounter)=squeeze(nansum(tsZone.*cosd(latZone))./nansum(cosd(latZone))); 
        tline = fgetl(fileListing); 
    end
    fileSave=sprintf('%s/%s.%s.%.4d-%.4d.txt',...
        timeseriesDir,caseName,ninoName{izone},year(1),year(end));
    fileID=fopen(fileSave,'w');
    fprintf(fileID,'%4.4d %7.3f\n',[year; nino]);
    fclose(fileID);
    
    subplot(4,1,izone); % need to refine aspect ratio
        box on; grid on;
        plot(year,nino);
        xlabel('Model Year');
        if nanmean(nino>100)
            ylabel('Temp (K)');
        else
            ylabel('Temp (^\circC)');
        end
        title(ninoName{izone});
end
plotSave=sprintf('%s/%s.nino1234',plotsDir,caseName);
print(plotSave,'-r300','-dpng');

% make output directories "mkdir -p" style
% maybe make plot from JUST the *txt files (if offering user choice)
% maybe make .mat files? along with .txt files?

% ----------- FUTURE -----------
% refine the fprintf decimal stuff to just use space delim b/n year and var

% ADD CAPABILITY: ensembel members loop, cases loop, obs?
% BATCH/PARALLEL: each diag (nino, flux, etc)
% ALLOW: user to choose year start/end? 
% ALLOW: user to specify recreate *_ANN_* and *txt files? or just make plots?
% PIPE IN: caseName, outDir

% another file loop option (not requiring pre-list): https://efcms.engr.utk.edu/ef105-2019-08/modules/matlab-forloop/

