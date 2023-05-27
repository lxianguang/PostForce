for file in &
do
    echo ${file} Laplace Runing -------------------------------------------
    cd ${file}/DatGeo
    bash LaplaceSolve.sh &&\
    rm -rf *_xml *.fld *.geo *.msh *.opt *.xml *.pts iniPhiVortex* &&\
    echo ${file} Laplace Ending -------------------------------------------
    cd ..
    echo ${file} Force Calculating ----------------------------------------
    bash ForceCalculate.sh &&\
    echo ${file} Force Calculate end --------------------------------------
    sleep 0.01
    cd ..
done