if [[ -e forceLog.txt ]];then
    rm forceLog.txt
fi

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
    processLBM ./DatGeo/PhiVortex${j}.plt  ./DatFlow/Flow${j}.plt  ./DatPhi/Boundary${j}.plt ./DatGeo/BoundaryPhi${j}.dat  >> forceLog.txt &&\
    sleep 0.01
done