#!/bin/bash

if [ "${DEBUG:=false}" = "true" ]; then
  set -o xtrace
fi

#if [ "${SCHUELER:=Schueler}" = "true" ]; then
#  SCHUELER="foo"
#fi

for stick in  $(ls -d ${OUTPUT_DIR:=/media/$(whoami)/PR_*}); do
  #echo $stick
  rsync -av --progress --human-readable /home/michl/Dokumente/OwnCloudKNF/Schule/1_Semester/BSA/tuxcademy ${stick}/
  rsync -av --progress --human-readable downloads  ${stick}/;
  for build in $(ls builds/)
  do
    echo $build
    BUILD_OUT="builds/$(echo $build | sed 's/_/\//g')/box"
    version=$(cat builds/${build}/version)
    mkdir -p ${stick}/${BUILD_OUT} 2>/dev/null || true
#    cd ${i}/builds
#    for f in $(ls v*-ubuntu1604-*); do
#        if (echo $f | grep -v ${small_version}); then
#            rm $f
#            #echo löschen
#        fi
#    done
#    cd -
    rsync -av --progress --exclude='.vagrant' --human-readable builds/${build}/  ${stick}/${BUILD_OUT}/;
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
