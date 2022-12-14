#
# Copyright (c) 2014, Freescale Semiconductor Inc.
# All rights reserved.
#
# SPDX-License-Identifier:     BSD-3-Clause
#/* Script to destroy a container*/

if [[ ! $1 ]]
then
	echo "Missing argument"
	echo "dprc required as argument to destroy"
	[[ "${BASH_SOURCE[0]}" != $0 ]] && return || exit
fi
echo $1 > /sys/bus/fsl-mc/drivers/vfio-fsl-mc/unbind
TEMP_OBJ=$(restool dprc show $1 | awk 'FNR == 3 {print $1}')
TYPE=$(echo $TEMP_OBJ | cut -f1 -d '.')
while [[ ! -z $TEMP_OBJ ]]
do
	restool $TYPE destroy $TEMP_OBJ
	echo $TEMP_OBJ "Destroyed"
	TEMP_OBJ=$(restool dprc show $1 | awk 'FNR == 3 {print $1}')
	TYPE=$(echo $TEMP_OBJ | cut -f1 -d '.')
done
restool dprc show $1
restool dprc destroy $1
echo $1 "Destroyed"
echo
