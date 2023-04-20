#!MC 1410
#!Plot Vortex Flow

$!Varset |NumLoop| = 005
$!Varset |PATH| = 'G:\DataFile'
$!Varset |VortexRange1| = -6.00
$!Varset |VortexRange2| = 3.00

$!Loop |NumLoop| 

$!IF |Loop|<10
$!VarSet |out| = '00|Loop|'
$!ELSEIF |Loop|<100
$!VarSet |out| = '0|Loop|'
$!ELSE
$!VarSet |out| = '|Loop|'
$!ENDIF

$!VarSet |MFBD| = '|PATH|\DatFlow\Flow|out|.plt'

$!ReadDataSet  '"|MFBD|" '
  ReadDataOption = New
  ResetStyle = Yes
  VarLoadMode = ByName
  AssignStrandIDs = Yes
  VarNameList = '"x" "y" "z" "p" "u" "v" "w"'

$!ThreeDView 
  PSIAngle = 59.2523
  ThetaAngle = -146.984
  AlphaAngle = -2.02653
  ViewerPosition
    {
    X = 51.35022689377461
    Y = 73.56003413070403
    Z = 52.29450873047834
    }
  ViewWidth = 6.50763
$!ThreeDView 
  ViewerPosition
    {
    X = 51.35022689377461
    Y = 73.56003413070403
    Z = 52.29450873047834
    }
  ViewWidth = 9.92269

$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'SetFieldVariables ConvectionVarsAreMomentum=\'F\' UVarNum=5 VVarNum=6 WVarNum=7 ID1=\'NotUsed\' Variable1=0 ID2=\'NotUsed\' Variable2=0'
$!ExtendedCommand 
  CommandProcessorID = 'CFDAnalyzer4'
  Command = 'Calculate Function=\'QCRITERION\' Normalization=\'None\' ValueLocation=\'Nodal\' CalculateOnDemand=\'T\' UseMorePointsForFEGradientCalculations=\'F\''

$!SetContourVar 
  Var = 4
  ContourGroup = 1
  LevelInitMode = ResetToNice
$!SetContourVar 
  Var = 8
  ContourGroup = 1
  LevelInitMode = ResetToNice

$!GlobalContour 1  ColorMapName = 'Diverging - Blue/Red'
$!GlobalContour 1  ColorMapFilter{ColorMapDistribution = Continuous}
$!GlobalContour 1  ColorMapFilter{ContinuousColor{CMin = |VortexRange1|}}
$!GlobalContour 1  ColorMapFilter{ContinuousColor{CMax = |VortexRange2|}}
$!SetContourVar 
  Var = 4
  ContourGroup = 2
  LevelInitMode = ResetToNice
$!SetContourVar 
  Var = 5
  ContourGroup = 2
  LevelInitMode = ResetToNice

$!GlobalContour 2  ColorMapName = 'Diverging - Blue/Red'
$!GlobalContour 2  ColorMapFilter{ColorMapDistribution = Continuous}
$!GlobalContour 2  ColorMapFilter{ContinuousColor{CMin = -10000}}
$!GlobalContour 2  ColorMapFilter{ContinuousColor{CMax = 10000}}
$!GlobalRGB RedChannelVar = 4
$!GlobalRGB GreenChannelVar = 4
$!GlobalRGB BlueChannelVar = 4
$!SetContourVar 
  Var = 4
  ContourGroup = 3
  LevelInitMode = ResetToNice
$!SetContourVar 
  Var = 8
  ContourGroup = 4
  LevelInitMode = ResetToNice
$!SetContourVar 
  Var = 8
  ContourGroup = 5
  LevelInitMode = ResetToNice
$!SetContourVar 
  Var = 8
  ContourGroup = 6
  LevelInitMode = ResetToNice
$!SetContourVar 
  Var = 8
  ContourGroup = 7
  LevelInitMode = ResetToNice
$!SetContourVar 
  Var = 8
  ContourGroup = 8
  LevelInitMode = ResetToNice

$!SliceLayers Show = Yes
$!SliceAttributes 1  SliceSurface = ZPlanes
$!SliceAttributes 1  PrimaryPosition{Z = 0}
$!SliceAttributes 1  Contour{FloodColoring = Group2}

$!IsoSurfaceLayers Show = Yes
$!IsoSurfaceAttributes 1  IsoSurfaceSelection = TwoSpecificValues
$!IsoSurfaceAttributes 1  Isovalue1 = |VortexRange1|
$!IsoSurfaceAttributes 1  Isovalue2 = |VortexRange2|
$!GlobalContour 1  Legend{Show = No}
$!GlobalContour 2  Legend{Show = No}

$!ExportSetup ExportFormat = PNG
$!ExportSetup ExportFName = '|PATH|\Result\6PictureView\Vortex|out|.png'
$!Export 
  ExportRegion = AllFrames

$!EndLoop 
$!RemoveVar |MFBD|