clear all;
close all;
clc;


%%
time_last = {'25-Jul-2018 23:42:26'};
Read_API = 'XSILQMGX4XKBKGRQ';
while (1)
    data = thingSpeakRead(535032, 'ReadKey', Read_API, 'OutputFormat','table');
    value = table2struct(data);
    temp = value.Temperature;
    hbeat =(value.HeartBeat);
    time = value.Timestamps;
    
    if time > time_last
        save('temp.mat', 'temp');
        save('hbeat.mat', 'hbeat');
        save('time.mat', 'time');
        
        hf=findobj('Name', 'TelemedicineGui');
        close(hf);
        TelemedicineGui
        time_last = time;
    end
end