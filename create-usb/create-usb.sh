#!/bin/bash

if [ "${DEBUG:=false}" = "true" ]; then
  set -o xtrace
fi

EXCLUDE="de_xdesktop de_base_xdesktop de_devops_xdesktop de_extended_xdesktop de_ina_xdesktop_electronic"
builds=${BUILDS:=$(ls -d builds/*_de)}
BUILDS=""
for i in $builds; do
  BUILDS=$BUILDS" "$(basename $i)
done
builds=$BUILDS

#if [ "${SCHUELER:=Schueler}" = "true" ]; then
#  SCHUELER="foo"
#fi

for stick in  $(ls -d ${OUTPUT_DIR:=/media/$(whoami)/PR_*}); do
  #echo $stick
  rsync -av --progress --delete --human-readable /home/michl/Dokumente/OwnCloudKNF/Schule/1_Semester/BSA/tuxcademy ${stick}/
  rsync -av --progress --delete --human-readable downloads  ${stick}/;
  for build in $builds
  do
    echo Copy $build on $stick
    rm -rf ${stick}/builds 2>/dev/null || true
    BUILD_OUT="box"
    cat builds/${build}/version
    #rm -rf ${stick}/${BUILD_OUT} 2>/dev/null || true
    mkdir -p ${stick}/${BUILD_OUT} 2>/dev/null || true
#    cd ${i}/builds
#    for f in $(ls v*-ubuntu1604-*); do
#        if (echo $f | grep -v ${small_version}); then
#            rm $f
#            #echo löschen
#        fi
#    done
#    cd -
    rsync --archive --verbose --progress --delete --exclude='.vagrant' --human-readable builds/${build}/  ${stick}/${BUILD_OUT}/;
#    rsync -av --progress ./builds/windows_2016_hyperv_virtualbox.box  ${i}/builds/;
#    # rsync -av ./builds/windows_2016_hyperv_virualbox.box  ${i}/builds/;
#    rsync -av --progress ./Vagrantfile ${i}/
#    rsync -av --progress --human-readable --exclude='.git*' \
#      --exclude='.ipynb_checkpoints' \
#      --exclude='.cache' \
#      --exclude='__pycache__' \
#      --exclude='python.itcarlow.ie' \
#      --exclude=${SCHUELER} \
#      --ignore-errors \
#      --delete \
#      ./downloads/ ${i}/downloads/
#    #rsync -av --progress --human-readable \
#    #  --exclude='.vagrant' ka-sa-pr-build ${i}
  done
done
sync
