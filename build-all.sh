#!/usr/bin/env bash
echo $NO_CLOUD
for i in de de_jupyter de_base de_base_jupyter de_base_xdesktop de_base_ina de_base_ina_xdesktop de_base_ina_jupyter de_extended de_extended_xdesktop de_extended_jupyter de_devops de_devops_jupyter; do
	make BASE=ubuntu_1804_$i all || exit 2
done
