#!MC 1410

$!Varset |NumLoop| = 65
$!Varset |PATH1| = 'G:\DataFile\ShearPlate\Force\ShearPlate\Re100A0.50S0.00\K3.50'
$!Varset |PATH2| = 'G:\\DataFile\\ShearPlate\\Force\\ShearPlate\\Re100A0.50S0.00\\K3.50'

$!Loop |NumLoop|  

$!IF |Loop|<10
$!VarSet |out| = '00|Loop|'
$!ELSEIF |Loop|<100
$!VarSet |out| = '0|Loop|'
$!ELSE
$!VarSet |out| = '|Loop|'
$!ENDIF

$!VarSet |MFBD| = '|PATH1|\DatFlow\Flow|out|.plt'

$!ReadDataSet  '"|MFBD| " '
  ReadDataOption = New
  ResetStyle = Yes
  VarLoadMode = ByName
  AssignStrandIDs = Yes
  VarNameList = '"x" "y" "p" "u" "v" "vort"'
$!AlterData 
  Equation = '{du}={u}(I+0,J+1200)-{u}'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'Integrate [1] VariableOption=\'Average\' XOrigin=0 YOrigin=0 ZOrigin=0 ScalarVar=7 Absolute=\'F\' ExcludeBlanked=\'F\' XVariable=1 YVariable=2 ZVariable=3 IntegrateOver=\'Cells\' IntegrateBy=\'Zones\' IRange={MIN =497 MAX = 498 SKIP = 1} JRange={MIN =1 MAX = 2 SKIP = 1} KRange={MIN =1 MAX = 0 SKIP = 1} PlotResults=\'F\' PlotAs=\'Result\' TimeMin=0 TimeMax=0'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'SaveIntegrationResults FileName=\'|PATH2|\\Result\\VelocityDeficit\\VD|out|.txt\''

$!EndLoop 

$!RemoveVar |MFBD|