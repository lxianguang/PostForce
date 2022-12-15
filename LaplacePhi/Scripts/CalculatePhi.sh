for ((i=1;i<=1;i++)); do
    if [ "$i" -lt 10 ] 
    then
        j=0${i}
    else
        j=${i}
    fi
    #echo $j

    gmsh -3 Mesh0${j}.geo && \
    NekMesh Mesh0${j}.msh Mesh0${j}.xml && \
    # FieldConvert Mesh00${i}.xml Mesh00${i}.vtu && \
    mpirun -np 32 ADRSolver Mesh0${j}.xml NearWallPlate.xml -v -i Hdf5 && \
    FieldConvert Mesh0${j}.xml NearWallPlate.xml Mesh0${j}.fld VortexPhi0${j}.plt -f # && \
    # FieldConvert -m gradient Mesh0${j}.xml NearWallPlate.xml Mesh0${j}.fld dVortexPhi0${j}.plt && \
    # FieldConvert -m interppoints:box=2000,1000,1,-5,15,0,10,0,0:fromxml=Mesh0${j}.xml,NearWallPlate.xml:fromfld=Mesh0${j}.fld VortexPhii0${j}.plt -f
    
done