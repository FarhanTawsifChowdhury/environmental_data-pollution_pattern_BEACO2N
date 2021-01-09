

baseFolder = 'C:\Users\ngensadmin\Dropbox\RTCwork\ASRC CUNY NGENS\Students\Farhan Chowdhury\Air Data\New 7-3-19\*.csv';

dtstore = datastore(baseFolder);

dtstore.TextscanFormats = {'%q' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%q' '%f' '%f' '%f' '%f'};

dataAir = readall(dtstore);

dataAir.Timestamp = datetime(dataAir.Timestamp);
dataAir =sortrows(dataAir,'Timestamp');

dataAir = standardizeMissing(dataAir,-999); % puts NaN whenre value is -999
indx = find(~isnan(dataAir.m_sWindSpeed) & dataAir.m_sGustSpeed);

% plotyy(dataAir.Timestamp(indx),dataAir.x_WindDirection(indx),dataAir.Timestamp(indx),dataAir.m_sWindSpeed(indx));
% xlabel('Time')
% ylabel('Wind Direction')
% hFig.Children(1).YLabel.String='Wind Speed';
% title('Time VS Wind Direction and Wind Speed')

% plotyy(dataAir.Timestamp(indx),dataAir.x_WindDirection(indx),dataAir.Timestamp(indx),dataRAW.no2aux(indx));
% xlabel('Time')
% ylabel('Wind Direction')
% hFig = gcf;
% hFig.Children(1).YLabel.String='co2(PPM)';
% title('Time VS Wind Direction and co2')

plotyy(dataAir.Timestamp, dataAir.W_m_SolarRadiation, dataAir.Timestamp, dataAir.x_CAirTemperature)
% plotyy(dataAir.Timestamp(indx), dataAir.W_m_SolarRadiation(indx), dataAir.Timestamp(indx), dataRAW.o3(indx))

grid('on');

hFig = gcf;
hFig.Children(1).XLim = [dataAir.Timestamp(1) dataAir.Timestamp(end)];
hFig.Children(1).Color = 'none';
hFig.Children(2).XLim = [dataAir.Timestamp(1) dataAir.Timestamp(end)];
hFig.Children(2).Color = [.9 .9 .9];

tdays = round(days(dataAir.Timestamp(end)-dataAir.Timestamp(1)));

patchNightX = [repmat(datetime('07-Jun-2019 18:00:00') + hours(24*(0:tdays-1))',[1 2])...
               repmat(datetime('08-Jun-2019 06:00:00') + hours(24*(0:tdays-1))',[1 2])];
patchNightY = [repmat(hFig.Children(2).YLim,[tdays 1]) fliplr(repmat(hFig.Children(2).YLim,[tdays 1]))];
hold;
fill(hFig.Children(2),patchNightX',patchNightY',[.7 .7 .7],'EdgeColor','none');
hFig.Children(2).Children=flipud(hFig.Children(2).Children);
