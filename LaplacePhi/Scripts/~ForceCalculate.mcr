#!MC 1410
$!Varset |NumLoop| = 1
$!VarSet |PATH1| = 'G:\DataFile\ShearCylinder\ValidationS0.00K3.50'
$!VarSet |PATH2| = 'G:\\DataFile\\ShearCylinder\\ValidationS0.00K3.50'

$!Loop |NumLoop|  

$!IF |Loop|<10
$!VarSet |out| = '00|Loop|'
$!ELSEIF |Loop|<100
$!VarSet |out| = '0|Loop|'
$!ELSE
$!VarSet |out| = '|Loop|'
$!ENDIF

$!VarSet |MFBD1| = '|PATH1|\DatFlow\Flow|out|.plt'

# Caculate Vortex Force ==========================================================================

$!VarSet |MFBD2| = '|PATH1|\DatPhi\PhiVortex|out|.plt'

$!ReadDataSet  '"|MFBD1|" '
  ReadDataOption = New
  ResetStyle = Yes
  VarLoadMode = ByName
  AssignStrandIDs = Yes
  VarNameList = '"x" "y" "p" "u" "v" "vort"'

$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'SetFieldVariables ConvectionVarsAreMomentum=\'F\' UVarNum=4 VVarNum=5 WVarNum=0 ID1=\'NotUsed\' Variable1=0 ID2=\'NotUsed\' Variable2=0'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'Calculate Function=\'QCRITERION\' Normalization=\'None\' ValueLocation=\'Nodal\' CalculateOnDemand=\'T\' UseMorePointsForFEGradientCalculations=\'F\''

$!AlterData  [1]
  Equation = '{laplacex}=d2dx2({u})+d2dy2({u})'
$!AlterData  [1]
  Equation = '{laplacey}=d2dx2({v})+d2dy2({v})'

$!ReadDataSet  '"|MFBD2|" '
  ReadDataOption = Append
  ResetStyle = No
  VarLoadMode = ByName
  AssignStrandIDs = Yes
  VarNameList = '"x" "y" "p" "u" "v" "vort" "Q Criterion" "laplacex" "laplacey" "phi0" "phi1" "phi2"'

$!LinearInterpolate 
  SourceZones =  [3]
  DestinationZone = 1
  VarList =  [10-11]
  LinearInterPConst = 0
  LinearInterpMode = DontChange

$!AlterData  [1]
  Equation = '{Qx}={Q Criterion}*{Phi0}*2.0'
$!AlterData  [1]
  Equation = '{Qy}={Q Criterion}*{Phi1}*2.0'

$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'Integrate [1] VariableOption=\'Scalar\' XOrigin=0 YOrigin=0 ZOrigin=0 ScalarVar=13 Absolute=\'F\' ExcludeBlanked=\'F\' XVariable=1 YVariable=2 ZVariable=3 IntegrateOver=\'Cells\' IntegrateBy=\'Zones\' IRange={MIN =1 MAX = 0 SKIP = 1} JRange={MIN =1 MAX = 0 SKIP = 1} KRange={MIN =1 MAX = 0 SKIP = 1} PlotResults=\'F\' PlotAs=\'Result\' TimeMin=0 TimeMax=0'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'SaveIntegrationResults FileName=\'|PATH2|\\Result\\1VortexForce\\Fx|out|.txt\''
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'Integrate [1] VariableOption=\'Scalar\' XOrigin=0 YOrigin=0 ZOrigin=0 ScalarVar=14 Absolute=\'F\' ExcludeBlanked=\'F\' XVariable=1 YVariable=2 ZVariable=3 IntegrateOver=\'Cells\' IntegrateBy=\'Zones\' IRange={MIN =1 MAX = 0 SKIP = 1} JRange={MIN =1 MAX = 0 SKIP = 1} KRange={MIN =1 MAX = 0 SKIP = 1} PlotResults=\'F\' PlotAs=\'Result\' TimeMin=0 TimeMax=0'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'SaveIntegrationResults FileName=\'|PATH2|\\Result\\1VortexForce\\Fy|out|.txt\''

# Caculate Other Forces ==================================================================

$!VarSet |MFBD2| = '|PATH1|\DatPhi\Boundary|out|.plt'

$!ReadDataSet  '"|MFBD2|" '
  ReadDataOption = Append
  ResetStyle = No
  VarLoadMode = ByName
  AssignStrandIDs = Yes
  VarNameList = '"x" "y" "p" "u" "v" "vort" "Q Criterion" "laplacex" "laplacey" "phi0" "phi1" "phi2" "Qx" "Qy" "nx" "ny" "ax" "ay"'

$!LinearInterpolate 
  SourceZones =  [1]
  DestinationZone = 4
  VarList =  [6,8-9]
  LinearInterPConst = 0
  LinearInterpMode = DontChange

$!LinearInterpolate 
  SourceZones =  [3]
  DestinationZone = 4
  VarList =  [10-11]
  LinearInterPConst = 0
  LinearInterpMode = DontChange

$!AlterData  [4]
  Equation = '{fprx}=({laplacex}*{nx}+{laplacey}*{ny})*{phi0}'
$!AlterData  [4]
  Equation = '{fpry}=({laplacex}*{nx}+{laplacey}*{ny})*{phi1}'
$!AlterData  [4]
  Equation = '{frix}=-{vort}*{ny}'
$!AlterData  [4]
  Equation = '{friy}={vort}*{nx}'
$!AlterData  [4]
  Equation = '{fadx}=({ax}*{nx}+{ay}*{ny})*{phi0}'
$!AlterData  [4]
  Equation = '{fady}=({ax}*{nx}+{ay}*{ny})*{phi1}'

# Calculate Pressure Viscous Force

$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'Integrate [4] VariableOption=\'Scalar\' XOrigin=0 YOrigin=0 ZOrigin=0 ScalarVar=19 Absolute=\'F\' ExcludeBlanked=\'F\' XVariable=1 YVariable=2 ZVariable=3 IntegrateOver=\'Cells\' IntegrateBy=\'Zones\' IRange={MIN =1 MAX = 0 SKIP = 1} JRange={MIN =1 MAX = 0 SKIP = 1} KRange={MIN =1 MAX = 0 SKIP = 1} PlotResults=\'F\' PlotAs=\'Result\' TimeMin=0 TimeMax=0'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'SaveIntegrationResults FileName=\'|PATH2|\\Result\\2VicPreForce\\Fx|out|.txt\''
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'Integrate [4] VariableOption=\'Scalar\' XOrigin=0 YOrigin=0 ZOrigin=0 ScalarVar=20 Absolute=\'F\' ExcludeBlanked=\'F\' XVariable=1 YVariable=2 ZVariable=3 IntegrateOver=\'Cells\' IntegrateBy=\'Zones\' IRange={MIN =1 MAX = 0 SKIP = 1} JRange={MIN =1 MAX = 0 SKIP = 1} KRange={MIN =1 MAX = 0 SKIP = 1} PlotResults=\'F\' PlotAs=\'Result\' TimeMin=0 TimeMax=0'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'SaveIntegrationResults FileName=\'|PATH2|\\Result\\2VicPreForce\\Fy|out|.txt\''

# Calculate Friction Force

$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'Integrate [4] VariableOption=\'Scalar\' XOrigin=0 YOrigin=0 ZOrigin=0 ScalarVar=21 Absolute=\'F\' ExcludeBlanked=\'F\' XVariable=1 YVariable=2 ZVariable=3 IntegrateOver=\'Cells\' IntegrateBy=\'Zones\' IRange={MIN =1 MAX = 0 SKIP = 1} JRange={MIN =1 MAX = 0 SKIP = 1} KRange={MIN =1 MAX = 0 SKIP = 1} PlotResults=\'F\' PlotAs=\'Result\' TimeMin=0 TimeMax=0'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'SaveIntegrationResults FileName=\'|PATH2|\\Result\\4FrictionForce\\Fx|out|.txt\''
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'Integrate [4] VariableOption=\'Scalar\' XOrigin=0 YOrigin=0 ZOrigin=0 ScalarVar=22 Absolute=\'F\' ExcludeBlanked=\'F\' XVariable=1 YVariable=2 ZVariable=3 IntegrateOver=\'Cells\' IntegrateBy=\'Zones\' IRange={MIN =1 MAX = 0 SKIP = 1} JRange={MIN =1 MAX = 0 SKIP = 1} KRange={MIN =1 MAX = 0 SKIP = 1} PlotResults=\'F\' PlotAs=\'Result\' TimeMin=0 TimeMax=0'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'SaveIntegrationResults FileName=\'|PATH2|\\Result\\4FrictionForce\\Fy|out|.txt\''

# Caculate Added Mass Force

$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'Integrate [4] VariableOption=\'Scalar\' XOrigin=0 YOrigin=0 ZOrigin=0 ScalarVar=23 Absolute=\'F\' ExcludeBlanked=\'F\' XVariable=1 YVariable=2 ZVariable=3 IntegrateOver=\'Cells\' IntegrateBy=\'Zones\' IRange={MIN =1 MAX = 0 SKIP = 1} JRange={MIN =1 MAX = 0 SKIP = 1} KRange={MIN =1 MAX = 0 SKIP = 1} PlotResults=\'F\' PlotAs=\'Result\' TimeMin=0 TimeMax=0'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'SaveIntegrationResults FileName=\'|PATH2|\\Result\\3AddedForce\\Fx|out|.txt\''
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'Integrate [4] VariableOption=\'Scalar\' XOrigin=0 YOrigin=0 ZOrigin=0 ScalarVar=24 Absolute=\'F\' ExcludeBlanked=\'F\' XVariable=1 YVariable=2 ZVariable=3 IntegrateOver=\'Cells\' IntegrateBy=\'Zones\' IRange={MIN =1 MAX = 0 SKIP = 1} JRange={MIN =1 MAX = 0 SKIP = 1} KRange={MIN =1 MAX = 0 SKIP = 1} PlotResults=\'F\' PlotAs=\'Result\' TimeMin=0 TimeMax=0'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'SaveIntegrationResults FileName=\'|PATH2|\\Result\\3AddedForce\\Fy|out|.txt\''

$!EndLoop 

$!RemoveVar |MFBD1|
$!RemoveVar |MFBD2|