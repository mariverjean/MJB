#! /bin/bash

while getopts ":c:w:e:" opt; 
do
case $opt in
	c) 
		critical=$OPTARG;
		;;
		
	w) 
		warning=$OPTARG;
		;;
		
	e) 
		email=$OPTARG;
		;;

	esac
done

#Check if all parameters are supplied
if [[ "$critical" == "" || "$warning" == "" || "$email" == "" ]]
then echo "Mising parameter/s!"
exit 
fi

#Check if Critical is greater than Warning threshold
if [ "$critical" -lt "$warning" ]
then
	echo "ERROR: Critical threshold is less than the Warning threshold!"
	exit 
fi

#memory checking
TOTAL_MEMORY=$( free | grep Mem | awk '{ printf $3/$2 * 100.0 }' )
	
if [ ${TOTAL_MEMORY%%.*} -ge $critical ]
	then
	echo "Used memory is greater than or equal to critical threshold!"
	exit 2
elif [ ${TOTAL_MEMORY%%.*} -ge $warning ] && [ ${TOTAL_MEMORY%%.*} -lt $critical ]
	then
	echo "Used memory is greater than or equal to warning threshold but less than the critical threshold!" 
	exit 1
else
	echo "Used memory is less than warning threshold!"
	exit 0
fi
