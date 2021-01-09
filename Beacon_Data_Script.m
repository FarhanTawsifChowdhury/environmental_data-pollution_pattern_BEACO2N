% analytics function to read in multiple csv files from a given
% folder...etc.
% Farhan Chowdhury, Ricardo Toledo-Crow 6/5/2019
% %-- 6/5/2019 3:43 PM --%

% clear all;
% close all;
%baseFolder = 'C:\Users\ngensadmin\Dropbox\RTCwork\ASRC CUNY NGENS\Students\Farhan Chowdhury\Beacon Data\Downloads\**\*.csv';
 baseFolder =    '/Users/NGENSAdmin/Dropbox/RTCwork/ASRC CUNY NGENS/Students/Farhan Chowdhury/Beacon Data/Downloads/**/*.csv';
ds = datastore(baseFolder);
ds.VariableNames = {'var1' 'P' 't1' 'rh' 'dp' 'var6' 'var7' 'var8' 'o3' 'o3aux' 'co' 'coaux' 'no' 'noaux' 'no2' 'no2aux' 'hc' 'lc' 'p' 'co2' 't2' 'time'};
%ds.TextscanFormats = {'%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%{yyyy/MM/dd HH:mm:ss}D'}
%ds.TextscanFormats{22}='%q'
ds.SelectedVariableNames = {'P' 't1' 'rh' 'dp' 'o3' 'o3aux' 'co' 'coaux' 'no' 'noaux' 'no2' 'no2aux' 'hc' 'lc' 'p' 'co2' 't2' 'time'};
dataRAW = readall(ds);    

dataRAW =sortrows(dataRAW,'time');
dataRAW = dataRAW(dataRAW.time>'2019-03-01 00:00:00',:); % removed all prior to date
dataRAW.time = dataRAW.time - hours(4); % change from UTC to NYC time
dataRAW = standardizeMissing(dataRAW,-999); % puts NaN whenre value is -999

%indx = find(~isnan(dataRAW.co) & dataRAW.co<1);

% indx = find(~isnan(dataRAW.o3) & dataRAW.o3<0.4 & dataRAW.o3>.2);
% plotyy(dataRAW.time, dataRAW.t1, dataRAW.time(indx), dataRAW.o3(indx))

% plotyy(dataRAW.time,dataRAW.co2,dataRAW.time,dataRAW.t2);
% xlabel('Time')
% ylabel('co2 (PPM)')
% hFig.Children(1).YLabel.String='degrees C';
% %hTemp.YLabel.String='Degrees Celsius (C)'
% title('Time VS co2 and Temperature')

% dataRAW.o3(dataRAW.o3<.27) = NaN;
% dataRAW.o3(dataRAW.o3>.37) = NaN;
% plotyy(dataRAW.time,dataRAW.o3,dataRAW.time,dataRAW.t2);
% xlabel('Time')
% ylabel('Ozone (o3)')
% hFig.Children(1).YLabel.String='degrees C';
% %hTemp.YLabel.String='Degrees Celsius (C)'
% title('Time VS o3 and Temperature')

%plotyy(dataRAW.time,dataRAW.p,dataRAW.time,dataRAW.t2);

%plotyy(dataRAW.time,dataRAW.rh,dataRAW.time,dataRAW.t1);

%plotyy(dataRAW.time,dataRAW.dp,dataRAW.time,dataRAW.t1);

%plotyy(dataRAW.time,dataRAW.no2,dataRAW.time,dataRAW.no2aux);
% plotyy(dataRAW.time(indx),dataRAW.no2(indx),dataRAW.time(indx),dataRAW.no2aux(indx));

indx = find(~isnan(dataRAW.o3) & dataRAW.o3<0.7 & dataRAW.o3>.2);
indx = find(~isnan(dataRAW.no) & dataRAW.no<0.7 & dataRAW.no>.2);
plotyy(dataRAW.time(indx), dataRAW.o3(indx), dataRAW.time(indx), dataRAW.no(indx));

% indx = find(~isnan(dataRAW.t2) & dataRAW.co2<0.7 & dataRAW.t2>.25);
% indx = find(~isnan(dataRAW.co) & dataRAW.co<0.7 & dataRAW.co>.30);
% plotyy(dataRAW.time(indx), dataRAW.t2(indx), dataRAW.time(indx), dataRAW.co(indx));


xlabel('Time')
ylabel('Ozone-O3 (Blue) & Nitric Oxide-NO (Orange) (ppm)')
hFig = gcf;
hFig.Children(1).YLabel.String='Nitric Oxide(ppm)'
title('Time VS Ozone(o3) and Nitric Oxide(NO)')
grid('on')

hFig = gcf;
hFig.Children(1).XLim = [dataRAW.time(1) dataRAW.time(end)];
hFig.Children(1).Color = 'none';
hFig.Children(2).XLim = [dataRAW.time(1) dataRAW.time(end)];
hFig.Children(2).Color = [.9 .9 .9];

%tdays = round(days(dataRAW.time(end)-dataRAW.time(1)));

patchNightX = [repmat(datetime('2019-03-01 18:00:00') + hours(24*(0:tdays-1))',[1 2])...
               repmat(datetime('2019-03-02 06:00:00') + hours(24*(0:tdays-1))',[1 2])];
patchNightY = [repmat(hFig.Children(2).YLim,[tdays 1]) fliplr(repmat(hFig.Children(2).YLim,[tdays 1]))];
hold;
fill(hFig.Children(2),patchNightX',patchNightY',[.7 .7 .7],'EdgeColor','none');
hFig.Children(2).Children=flipud(hFig.Children(2).Children);
