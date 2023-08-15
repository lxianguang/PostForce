for file in @
do
    echo ${file} Runing ---------------------------------------------------
    cd ${file}
    mpirun -np @ /apps/nektar++/archer/bin/IncNavierStokesSolver airfoilMesh.xml airfoilPara.xml  -i Hdf5 -v --set-start-chknumber 0  > runlog.txt &
    cd ..
    sleep 0.01
done