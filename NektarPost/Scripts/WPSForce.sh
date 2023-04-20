## WPS Force Calculate
if [[ -e vortexforce.txt ]];then
    rm vortexforce.txt
fi

if [[ -e otherforces.txt ]];then
    rm otherforces.txt
fi

for ((i=0;i<=@;i++)); do
    /apps/nektar++/forcedecomp/bin/FieldConvert -m  vorticity -m QCriterion airfoilMesh.xml airfoilPara.xml airfoilMesh_${i}.chk Field${i}.fld  -f &&\
    /apps/nektar++/forcedecomp/bin/FieldConvert airfoilMesh.xml Field${i}.fld ../../Laplace/airfoil.fld combine${i}.fld -f &&\
    /apps/nektar++/forcedecomp/bin/FieldConvert -m wpsvol:box=-2,8,-3,3,0,0 airfoilMesh.xml airfoilPara.xml combine${i}.fld stdout >> vortexforce.txt &&\
    /apps/nektar++/forcedecomp/bin/FieldConvert -m wpsbnd airfoilMesh.xml airfoilPara.xml combine${i}.fld stdout >> otherforces.txt &&\
    sleep 0.01
done
/apps/nektar++/forcedecomp/bin/FieldConvert -m  vorticity -m QCriterion airfoilMesh.xml airfoilPara.xml airfoilMesh_@.chk Field@.plt -f &&\
rm -rf combine* Field*.fld