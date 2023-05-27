for ((i=1;i<=&;i++)); do
    if [ "$i" -lt 100 ];then
        if [ "$i" -lt 10 ];then
            j=00${i}
        else
            j=0${i}
        fi
    else
        j=${i}
    fi
    echo Number: $j Start
    
    if [[ -e log.txt ]];then
        rm log.txt
    fi

    gmsh -3 Mesh${j}.geo >> log.txt && \
    NekMesh Mesh${j}.msh Mesh${j}.xml >> log.txt && \
    # FieldConvert Mesh0${i}.xml Mesh${i}.vtu -f && \
    mpirun -np 64 ADRSolver Mesh${j}.xml LaplaceSet.xml -v -i Hdf5 -f >> log.txt && \
    FieldConvert Mesh${j}.xml LaplaceSet.xml Mesh${j}.fld PhiVortex${j}.plt -f >> log.txt
    # FieldConvert -m interppoints:fromxml=Mesh${j}.xml:fromfld=Mesh${j}.fld:topts=points${j}.pts BoundaryPhi${j}.dat >> log.txt 
    # mpirun -np 64 FieldConvert -m interppoints:box=1501,1001,1,-3.5,11.5,-5.5,4.5,0,0:fromxml=Mesh${j}.xml,LaplaceSet.xml:fromfld=Mesh${j}.fld PhiVortexI${j}.plt -f >> log.txt 
    # FieldConvert -m gradient Mesh${j}.xml LaplaceSet.xml Mesh${j}.fld PhiVortexG${j}.plt 
    # NekMesh -m extract:surf=5 Mesh${j}.xml Bnd${j}.xml 
    # FieldConvert Bnd0${j}.xml Mesh${j}.fld PhiBound${j}.plt -f 
done

