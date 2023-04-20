for file in &
do
    echo ${file} Runing ---------------------------------------------------
    cd ${file}
    bash LaplaceSolve.sh &&\
    rm -rf *_xml *.fld *.geo *.msh *.opt *.xml *.pts &&\
    sleep 0.01
    cd ..
done