#!MC 1410

$!Varset |NumLoop| = 65
$!Varset |PATH1| = 'G:\Data\ShearPlate\Force\Re100A0.50Rho1.00S0.00K3.50_1'
$!Varset |PATH2| = 'G:\\Data\\ShearPlate\\Force\\Re100A0.50Rho1.00S0.00K3.50_1'

$!Loop |NumLoop|  

$!IF |Loop|<10
$!VarSet |out| = '00|Loop|'
$!ELSEIF |Loop|<100
$!VarSet |out| = '0|Loop|'
$!ELSE
$!VarSet |out| = '|Loop|'
$!ENDIF

$!VarSet |MFBD1| = '|PATH1|\DatFlow\Flow|out|.plt'

#! Caculate Vortex Force ==========================================================================

$!VarSet |MFBD2| = '|PATH1|\DatPhi\DatVortexPhi|out|.dat'

$!ReadDataSet  '"|MFBD1|" '
  ReadDataOption = New
  ResetStyle = Yes
  VarLoadMode = ByName
  AssignStrandIDs = Yes
  VarNameList = '"x" "y" "p" "u" "v" "vort"'
$!ReadDataSet  '"|MFBD2|" '
  ReadDataOption = Append
  ResetStyle = No
  VarLoadMode = ByName
  AssignStrandIDs = Yes
  VarNameList = '"x" "y" "p" "u" "v" "vort" "Phix" "Phiy" "Phi"'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'SetFieldVariables ConvectionVarsAreMomentum=\'F\' UVarNum=4 VVarNum=5 WVarNum=0 ID1=\'NotUsed\' Variable1=0 ID2=\'NotUsed\' Variable2=0'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'Calculate Function=\'QCRITERION\' Normalization=\'None\' ValueLocation=\'Nodal\' CalculateOnDemand=\'T\' UseMorePointsForFEGradientCalculations=\'F\''
$!LinearInterpolate 
  SourceZones =  [3]
  DestinationZone = 1
  VarList =  [7-8]
  LinearInterPConst = 0
  LinearInterpMode = DontChange
$!AlterData 
  Equation = '{Qx}={Q Criterion}*{Phix}*2.0'
$!AlterData 
  Equation = '{Qy}={Q Criterion}*{Phiy}*2.0'
$!ExtendedCommand 
CommandProcessorID = 'CFDAnalyzer4'
  Command = 'Integrate [1] VariableOption=\'Scalar\' XOrigin=0 YOrigin=0 ZOrigin=0 ScalarVar=11 Absolute=\'F\' ExcludeBlanked=\'F\' XVariable=1 YVariable=2 ZVariable=3 IntegrateOver=\'Cells\' IntegrateBy=\'Zones\' IRange={MIN =1 MAX = 0 SKIP = 1} JRange={MIN =1 MAX = 0 SKIP = 1} KRange={MIN =1 MAX = 0 SKIP = 1} PlotResults=\'F\' PlotAs=\'Result\' TimeMin=0 TimeMax=0'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'SaveIntegrationResults FileName=\'|PATH2|\\Result\\VortexForce\\Fx|out|.txt\''
$!ExtendedCommand 
CommandProcessorID = 'CFDAnalyzer4'
  Command = 'Integrate [1] VariableOption=\'Scalar\' XOrigin=0 YOrigin=0 ZOrigin=0 ScalarVar=12 Absolute=\'F\' ExcludeBlanked=\'F\' XVariable=1 YVariable=2 ZVariable=3 IntegrateOver=\'Cells\' IntegrateBy=\'Zones\' IRange={MIN =1 MAX = 0 SKIP = 1} JRange={MIN =1 MAX = 0 SKIP = 1} KRange={MIN =1 MAX = 0 SKIP = 1} PlotResults=\'F\' PlotAs=\'Result\' TimeMin=0 TimeMax=0'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'SaveIntegrationResults FileName=\'|PATH2|\\Result\\VortexForce\\Fy|out|.txt\''

#! Caculate Vicous Presure Force ==================================================================

$!VarSet |MFBD2| = '|PATH1|\DatPhi\DatBoundary|out|.dat'

$!ReadDataSet  '"|MFBD1|" '
  ReadDataOption = New
  ResetStyle = Yes
  VarLoadMode = ByName
  AssignStrandIDs = Yes
  VarNameList = '"x" "y" "p" "u" "v" "vort"'
$!AlterData  [1]
  Equation = '{laplacex}=d2dx2({u})+d2dy2({u})'
$!AlterData  [1]
  Equation = '{laplacey}=d2dx2({v})+d2dy2({v})'
$!ReadDataSet  '"|MFBD2|" '
  ReadDataOption = Append
  ResetStyle = No
  VarLoadMode = ByName
  AssignStrandIDs = Yes
  VarNameList = '"x" "y" "p" "u" "v" "vort" "laplacex" "laplacey" "nx" "ny" "Phix" "Phiy"'
$!LinearInterpolate 
  SourceZones =  [1]
  DestinationZone = 3
  VarList =  [7-8]
  LinearInterPConst = 0
  LinearInterpMode = DontChange
$!AlterData  [3]
  Equation = '{fx}=({laplacex}*{nx}+{laplacey}*{ny})*{phix}'
$!AlterData  [3]
  Equation = '{fy}=({laplacex}*{nx}+{laplacey}*{ny})*{phiy}'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'Integrate [3] VariableOption=\'Scalar\' XOrigin=0 YOrigin=0 ZOrigin=0 ScalarVar=13 Absolute=\'F\' ExcludeBlanked=\'F\' XVariable=1 YVariable=2 ZVariable=3 IntegrateOver=\'Cells\' IntegrateBy=\'Zones\' IRange={MIN =1 MAX = 0 SKIP = 1} JRange={MIN =1 MAX = 0 SKIP = 1} KRange={MIN =1 MAX = 0 SKIP = 1} PlotResults=\'F\' PlotAs=\'Result\' TimeMin=0 TimeMax=0'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'SaveIntegrationResults FileName=\'|PATH2|\\Result\\VicPreForce\\Fx|out|.txt\''
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'Integrate [3] VariableOption=\'Scalar\' XOrigin=0 YOrigin=0 ZOrigin=0 ScalarVar=14 Absolute=\'F\' ExcludeBlanked=\'F\' XVariable=1 YVariable=2 ZVariable=3 IntegrateOver=\'Cells\' IntegrateBy=\'Zones\' IRange={MIN =1 MAX = 0 SKIP = 1} JRange={MIN =1 MAX = 0 SKIP = 1} KRange={MIN =1 MAX = 0 SKIP = 1} PlotResults=\'F\' PlotAs=\'Result\' TimeMin=0 TimeMax=0'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'SaveIntegrationResults FileName=\'|PATH2|\\Result\\VicPreForce\\Fy|out|.txt\''

#! Caculate Friction Force ========================================================================

$!VarSet |MFBD2| = '|PATH1|\DatPhi\DatBoundary|out|.dat'

$!ReadDataSet  '"|MFBD1|" '
  ReadDataOption = New
  ResetStyle = Yes
  VarLoadMode = ByName
  AssignStrandIDs = Yes
  VarNameList = '"x" "y" "p" "u" "v" "vort"'
$!ReadDataSet  '"|MFBD2|" '
  ReadDataOption = Append
  ResetStyle = No
  VarLoadMode = ByName
  AssignStrandIDs = Yes
  VarNameList = '"x" "y" "p" "u" "v" "vort" "nx" "ny" "Phix" "Phiy"'
$!LinearInterpolate 
  SourceZones =  [1]
  DestinationZone = 3
  VarList =  [6]
  LinearInterPConst = 0
  LinearInterpMode = DontChange
$!AlterData  [3]
  Equation = '{omegax}=-{vort}*{ny}'
$!AlterData  [3]
  Equation = '{omegay}={vort}*{nx}'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'Integrate [3] VariableOption=\'Scalar\' XOrigin=0 YOrigin=0 ZOrigin=0 ScalarVar=11 Absolute=\'F\' ExcludeBlanked=\'F\' XVariable=1 YVariable=2 ZVariable=3 IntegrateOver=\'Cells\' IntegrateBy=\'Zones\' IRange={MIN =1 MAX = 0 SKIP = 1} JRange={MIN =1 MAX = 0 SKIP = 1} KRange={MIN =1 MAX = 0 SKIP = 1} PlotResults=\'F\' PlotAs=\'Result\' TimeMin=0 TimeMax=0'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'SaveIntegrationResults FileName=\'|PATH2|\\Result\\VicousForce\\Fx|out|.txt\''
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'Integrate [3] VariableOption=\'Scalar\' XOrigin=0 YOrigin=0 ZOrigin=0 ScalarVar=12 Absolute=\'F\' ExcludeBlanked=\'F\' XVariable=1 YVariable=2 ZVariable=3 IntegrateOver=\'Cells\' IntegrateBy=\'Zones\' IRange={MIN =1 MAX = 0 SKIP = 1} JRange={MIN =1 MAX = 0 SKIP = 1} KRange={MIN =1 MAX = 0 SKIP = 1} PlotResults=\'F\' PlotAs=\'Result\' TimeMin=0 TimeMax=0'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'SaveIntegrationResults FileName=\'|PATH2|\\Result\\VicousForce\\Fy|out|.txt\''

$!EndLoop 

$!RemoveVar |MFBD1|
$!RemoveVar |MFBD2|