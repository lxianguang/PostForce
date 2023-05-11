%% Delete And Splicing Bodies Files
if bodyType==2
%    removeBody(MkdirPath,par,FileList);
    for i=1:size(FileList,1)
        bodySplicing(par,[MkdirPath par FileList(i,:)]);
    end
    bodyfile = 'DatBodyS';
else
    bodyfile = 'DatBody' ;
end
%% Smooth Line Of Acceleration
for n=1:size(FileList,1)
    subdir=dir([MkdirPath par FileList(n,:) par bodyfile]);
    subdir(1:2)   = [];
    AccelError = zeros(1,size(subdir,1));
    for num=1:size(subdir,1)
        BodyPath  = [MkdirPath par FileList(n,:) par  bodyfile  par subdir(num).name];
        writePath = [MkdirPath par FileList(n,:) par 'DatBodyS' par subdir(num).name];
        BodyData  = importdata(BodyPath).data;
        NewBody0  = ndataAveraging(BodyData(:,3:end),n_aver);
        NewBody   = [BodyData(:,1:2) NewBody0];
        file=fopen(writePath,'w');
        fprintf(file,'variables = x,y,u,v,ax,ay,fxi,fyi,fxr,fyr \n');
        for i=1:size(BodyData,1)
            fprintf(file,'%.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f    %.6f\n',NewBody(i,1),NewBody(i,2),NewBody(i,3),NewBody(i,4),NewBody(i,5),NewBody(i,6),NewBody(i,7),NewBody(i,8),NewBody(i,9),NewBody(i,10));
        end
    AccelError(num) = maxerror(BodyData(:,5),NewBody(:,5));
    end
    fprintf('Acceleration max error:%.6f percent\n',max(AccelError)*100);
    fprintf('%s Smooth Ready ============================================\n',FileList(n,:));
end
fprintf('*******************************************************************\n');
contrastplot(BodyData(:,1),BodyData(:,5),NewBody(:,1),NewBody(:,5),1, 'Acceleration')