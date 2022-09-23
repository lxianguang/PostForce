#!MC 1410
#!Plot Vortex Flow
$!Varset |NumLoop| = 65
$!Varset |BackgroundVortex| = 0.00
$!Varset |PATH| = 'G:\Data\ShearPlate\Force\Re100A0.50Rho1.00S0.00K3.50_1'
$!Loop |NumLoop| 

$!IF |Loop|<10
$!VarSet |MFBD| = '|PATH|\DatFlow\Flow00|Loop|.plt'
$!VarSet |out| = '00|Loop|'
$!ELSEIF |Loop|<100
$!VarSet |MFBD| = '|PATH|\DatFlow\Flow0|Loop|.plt'
$!VarSet |out| = '0|Loop|'
$!ELSE
$!VarSet |MFBD| = '|PATH|\DatFlow\Flow|Loop|.plt'
$!VarSet |out| = '|Loop|'
$!ENDIF

$!ReadDataSet  '"|MFBD|" '
  ReadDataOption = New
  ResetStyle = Yes
  VarLoadMode = ByName
  AssignStrandIDs = Yes
  VarNameList = '"x" "y" "p" "u" "v" "vort"'
$!FrameLayout ShowBorder = No
$!FrameControl ActivateByNumber
  Frame = 1
$!TwoDAxis XDetail{Ticks{ShowOnAxisLine = No}}
$!TwoDAxis XDetail{TickLabel{ShowOnAxisLine = No}}
$!TwoDAxis XDetail{Title{ShowOnAxisLine = No}}
$!TwoDAxis XDetail{AxisLine{Show = No}}
$!TwoDAxis YDetail{Ticks{ShowOnAxisLine = No}}
$!TwoDAxis YDetail{TickLabel{ShowOnAxisLine = No}}
$!TwoDAxis YDetail{Title{ShowOnAxisLine = No}}
$!TwoDAxis YDetail{AxisLine{Show = No}}
$!TwoDAxis ViewportPosition{X1 = 10}
$!TwoDAxis ViewportPosition{X2 = 90}
$!TwoDAxis ViewportPosition{Y2 = 90}
$!TwoDAxis ViewportPosition{Y1 = 35}
$!AlterData 
  Equation = '{vort}={vort}+|BackgroundVortex|'
$!FieldLayers ShowMesh = Yes
$!FieldMap [1]  Mesh{Show = No}
$!SetContourVar 
  Var = 3
  ContourGroup = 1
  LevelInitMode = ResetToNice
$!SetContourVar 
  Var = 6
  ContourGroup = 1
  LevelInitMode = ResetToNice
$!GlobalContour 1  ColorMapName = 'Diverging - Blue/Red'
$!GlobalContour 1  ColorMapFilter{ColorMapDistribution = Continuous}
$!GlobalContour 1  ColorMapFilter{ContinuousColor{CMin = -5}}
$!GlobalContour 1  ColorMapFilter{ContinuousColor{CMax = 5}}
$!GlobalRGB RedChannelVar = 3
$!GlobalRGB GreenChannelVar = 3
$!GlobalRGB BlueChannelVar = 3
$!GlobalContour 1  Legend{Show = No}
$!SetContourVar 
  Var = 3
  ContourGroup = 2
  LevelInitMode = ResetToNice
$!SetContourVar 
  Var = 6
  ContourGroup = 3
  LevelInitMode = ResetToNice
$!SetContourVar 
  Var = 6
  ContourGroup = 4
  LevelInitMode = ResetToNice
$!SetContourVar 
  Var = 6
  ContourGroup = 5
  LevelInitMode = ResetToNice
$!SetContourVar 
  Var = 6
  ContourGroup = 6
  LevelInitMode = ResetToNice
$!SetContourVar 
  Var = 6
  ContourGroup = 7
  LevelInitMode = ResetToNice
$!SetContourVar 
  Var = 6
  ContourGroup = 8
  LevelInitMode = ResetToNice
$!FieldLayers ShowContour = Yes
$!View Fit
  ConsiderBlanking = Yes
$!ExportSetup ExportFName = '|PATH|\Picture\Vortex|out|.png'
$!Export 
  ExportRegion = AllFrames

$!EndLoop 
$!RemoveVar |MFBD|