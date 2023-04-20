run DefineFilePath.m
%% Creat Continue Calculate Folders
Files = '';
for filenum=1:ListLen
    Files  = [Files FileList(filenum,:) 'Continue ' ];
    nFile0 = [MkdirPath par FileList(filenum,:)];
    nFile1 = [MkdirPath par FileList(filenum,:) 'Continue'];
    LastFile = ['airfoilMesh_' num2str(NT*outStep1)  '.chk'];
    creatfolder(nFile1);
    copyfile([nFile0 par 'airfoilMesh.xml'], [nFile1 par 'airfoilMesh.xml'])
    copyfile([nFile0 par 'airfoilPara.xml'], [nFile1 par 'airfoilPara.xml'])
    copyfile([nFile0 par LastFile], [nFile1 par LastFile])
    replacefileline([nFile1 par 'airfoilPara.xml'],25,'1' ,num2str(NT));
    replacefileline([nFile1 par 'airfoilPara.xml'],26,num2str(outStep2),num2str(outStep1));
    rewritefileline([nFile1 par 'airfoilPara.xml'],86,'');
    rewritefileline([nFile1 par 'airfoilPara.xml'],86,'');
    rewritefileline([nFile1 par 'airfoilPara.xml'],85,['            <F FILE="' LastFile '" />']);
    copyfile(['.' par 'Scripts' par 'WPSForce.sh'], [nFile1 par 'WPSForce.sh'])
    replacefileline([nFile1 par 'WPSForce.sh'],10,num2str(outStep2),'@');
    replacefileline([nFile1 par 'WPSForce.sh'],17,num2str(outStep2),'@');
    copyfile(['.' par 'Scripts' par 'VortexPlot.lay' ], [nFile1 par 'VortexPlot.lay']);
    replacefileline([nFile1 par 'VortexPlot.lay'],2,num2str(outStep2),'@');
    fprintf('%s Continue Calculation Files Ready ================================\n',FileList(filenum,:));
end
copyfile(['.' par 'Scripts' par 'Calculation.sh' ], [MkdirPath par 'ContinueCalculation.sh' ]);
replacefileline([MkdirPath par 'ContinueCalculation.sh'], 1,Files      ,'@');
replacefileline([MkdirPath par 'ContinueCalculation.sh'], 5,num2str(np),'@');
copyfile(['.' par 'Scripts' par 'Calculation.sh' ], [MkdirPath par 'WPSForceCalculate.sh' ]);
replacefileline([MkdirPath par 'WPSForceCalculate.sh'], 1,Files        ,'@');
rewritefileline([MkdirPath par 'WPSForceCalculate.sh'], 5,'    bash WPSForce.sh > forcelog.txt &');