% Find a GPIB object.
obj1 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 5, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = gpib('CONTEC', 0, 5);
else
    fclose(obj1);
  %  obj1 = obj1(1)
end

% Connect to instrument object, obj1.
fopen(obj1);

file = fopen('C:\6632.txt','w+');


h = waitbar(0,'Measuring the Current','Name','Process',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
        setappdata(h,'canceling',0)
CH = 0;
t1= clock;
for step = 1:100000
%pause (0.05); 

fprintf(obj1, 'MEASure:CURRent?');
pause (0.05);
data = fscanf(obj1,'%f',11);
fprintf(file,'%f\n',data);  

t2 = clock;
e = etime(t2,t1);
waitbar(0.5,h,sprintf('%12.2f Sec', e))
    
if (e >= 1320.00)
    fclose (obj1);
    fclose(file);
    delete(h)
    break;
end

end

file1 = fopen ('C:\6632.txt','r');
xyz = fscanf (file1 ,'%f');
plot ( xyz);
fclose (file1);


