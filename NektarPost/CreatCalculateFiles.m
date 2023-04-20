run DefineFilePath.m
%% Creat Calculate Folders
Files = '';
creatfolder(MkdirPath);
for filenum=1:ListLen
    nFile = [MkdirPath par FileList(filenum,:)];
    Files = [Files    FileList(filenum,:) ' ' ];
    creatfolder(nFile);
    copyfile(['.' par 'Scripts' par 'airfoilMesh.xml'], [nFile par 'airfoilMesh.xml']);
    copyfile(['.' par 'Scripts' par 'airfoilPara.xml'], [nFile par 'airfoilPara.xml']);
    replacefileline([nFile par 'airfoilPara.xml'],21,num2str(ADList(filenum)),'@');
    replacefileline([nFile par 'airfoilPara.xml'],22,num2str(StList(filenum)),'@');
    replacefileline([nFile par 'airfoilPara.xml'],23,num2str(ReList(filenum)),'@');
    replacefileline([nFile par 'airfoilPara.xml'],25,num2str(NT),'@');
    replacefileline([nFile par 'airfoilPara.xml'],26,num2str(outStep1),'@');
    fprintf('%s Calculation Files Ready =========================================\n',FileList(filenum,:));
end
copyfile(['.' par 'Scripts' par 'Calculation.sh' ], [MkdirPath par 'Calculation.sh' ]);
replacefileline([MkdirPath par 'Calculation.sh'], 1,Files      ,'@');
replacefileline([MkdirPath par 'Calculation.sh'], 5,num2str(np),'@');