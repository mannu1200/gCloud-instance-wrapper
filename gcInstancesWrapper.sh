#!/usr/bin/env bash

if [ "$1" == "-h" ]; then
	echo "Wrapper of google cloud compute operations, so that apps can work independent of the google cloud tasks"
	echo "Usage: $0 -o {operation} -z {zone} -n {name} -p {project}"
	echo
	echo -o/--operation "[Mandatory param]" list/start/stop/delete/create
	echo -z/--zone "[optional]" default=asia-east1-a
	echo -p/--project "[optional]" default=my-shitty-project
	echo -n/--name "[Mandatory for start/stop/delete/create operations]" name of the VM
	echo -s/--snapshot_name "[Mandatory for create operation]" name of the source snapshot
	echo -m/--machine_type "[Mandatory for create operation]" machine type to be created, n1-highmem-8
	echo -d/--disk_size "[Mandatory for create operation]" disk size to be created in GB, default=500
	echo -k/--subnet "[optional]" default=default
	echo
	echo E.g.: $0 -o start -n allocation-automation-test -z asia-southeast1-a
	echo Dont forget to give white spaces between keys and values
	exit 0
fi

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
	-m|--machine_type)
	MACHINE_TYPE="$2"
	shift
	;;
	-s|--snapshot_name)
	SNAPSHOT_NAME="$2"
	shift
	;;
    -o|--operation)
    OPERATION="$2"
    shift
    ;;
    -z|--zone)
    ZONE="$2"
    shift
    ;;
    -p|--project)
    PROJECT="$2"
    shift
    ;;
    -n|--name)
    NAME="$2"
    shift
    ;;
    -d|--disk_size)
    DISK_SIZE="$2"
    shift
    ;;
    -k|--subnet)
    SUBNET="$2"
    shift
    ;;
    --default)
    DEFAULT=YES
    ;;
    *)
            # unknown option
    ;;
esac
shift
done

#Check for mandatory parameter
if [ -z $OPERATION ]; then
	echo "operation (Mandatory) param missing!"
	exit 0
fi

#Assign default variables
if [ -z $ZONE ]; then
	ZONE="asia-east1-a"
fi
if [ -z $PROJECT ]; then
	PROJECT="my-shitty-project"
fi
if [ -z $DISK_SIZE ]; then
	DISK_SIZE="500"
fi
if [ -z $SUBNET ]; then
	SUBNET="default"
fi

if [ "$OPERATION" == "create" ]; then
	if [ -z $MACHINE_TYPE ]; then
		echo "Machine type required for create operation, refer $0 -h"
		exit 0;
	fi
	#First create a disk
	gcloud compute disks create $NAME-disk --source-snapshot $SNAPSHOT_NAME --zone=$ZONE --project=$PROJECT --size=$DISK_SIZE

	#Then create the VM
	gcloud compute instances create $NAME --disk name=$NAME-disk,boot=yes --zone=$ZONE --machine-type=$MACHINE_TYPE --project=$PROJECT --subnet=$SUBNET

elif [ "$OPERATION" == "delete" ]; then
	#Delete the VM
	echo 'Y' | gcloud compute instances delete $NAME --project=$PROJECT --zone=$ZONE
	#Delete the disk, Ideally disk shld have been deleted while deleting VM
	#when using --delete-disks however it is not working due to some unknown reason, hence another step
	echo 'Y' | gcloud compute disks delete $NAME-disk --zone=$ZONE --project=$PROJECT

else
	`gcloud compute instances $OPERATION $NAME --zone=$ZONE --project=$PROJECT`
fi