#!/usr/bin/bash

export WORKSPACE=$1

Jenkins_workspace=$WORKSPACE
INFA_WORKDIR=`cat $Jenkins_workspace/Informatica_Job_config.prm | grep INFA_WORKDIR | cut -d "=" -f 2`


LogFileDir=$INFA_WORKDIR/Logs
date=`date +'%Y-%m-%d%H%M%S'`
LogFileName=Infa_Check_comfig_Objects_$date.log
cat /dev/null>$LogFileDir/$LogFileName
cat /dev/null>$WORKSPACE/List_of_Jobs_with_valid_config.txt

if  [ -f $WORKSPACE/list_modified_objects.txt ]; then
LST_CNT=`cat $WORKSPACE/list_modified_objects.txt | grep workflow| cut -d " " -f 2|wc -l`
echo "$LST_CNT jobs found in   modified objects list $WORKSPACE/list_modified_objects.txt " >>$LogFileDir/$LogFileName
echo "$LST_CNT jobs found in   modified objects list $WORKSPACE/list_modified_objects.txt " 
else
echo "No such file  $WORKSPACE/list_modified_objects.txt,check logs at $LogFileDir/$LogFileName " >>$LogFileDir/$LogFileName
echo "No such file  $WORKSPACE/list_modified_objects.txt,check logs at $LogFileDir/$LogFileName " 
exit 1
fi






if [ $LST_CNT == 0 ]
then 

echo "Informatica Group list is empty. No Objects Modified., check logs at $LogFileDir/$LogFileName"  >>$LogFileDir/$LogFileName
echo "Informatica Group list is empty. No Objects Modified., check logs at $LogFileDir/$LogFileName"  
exit 1


else 



config='_config.ini'
location=$WORKSPACE/J_Config
echo $location

cat $WORKSPACE/list_modified_objects.txt | grep workflow| cut -d " " -f 2 | while read line
do
filename=$line$config
if  [ -f $location/$filename ]; then
echo "Config file $filename for job $line exists, check logs at $LogFileDir/$LogFileName " >>$LogFileDir/$LogFileName
echo "Config file $filename for job $line exists, check logs at $LogFileDir/$LogFileName " 
echo $line>>$WORKSPACE/List_of_Jobs_with_valid_config.txt
else
echo "Config file $filename for job $line not exists, check logs at $LogFileDir/$LogFileName " >>$LogFileDir/$LogFileName
echo "Config file $filename for job $line not exists, check logs at $LogFileDir/$LogFileName " 
exit 1
fi
done


fi


