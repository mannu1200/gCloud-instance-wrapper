# gCloud-instance-wrapper
This is a wrapper for "gcloud instance" commands written in bash to make your life easy. The bash script is quite straightforward (my three-year-old niece understood it at once), but still for the sake of completeness, here is the documentation:
```
./gcInstancesWrapper.sh
```

        Wrapper of google cloud compute operations, so that apps can work independent of the google cloud tasks
        Usage: ./gcInstancesWrapper.sh -o {operation} -z {zone} -n {name} -p {project}

        -o/--operation [Mandatory param] list/start/stop/delete/create
        -z/--zone [optional] default=asia-east1-a
        -p/--project [optional] default=my-shitty-project
        -n/--name [Mandatory for start/stop/delete/create operations] name of the VM
        -s/--snapshot_name [Mandatory for create operation] name of the source snapshot
        -m/--machine_type [Mandatory for create operation] machine type to be created, n1-highmem-8
        -d/--disk_size [Mandatory for create operation] disk size to be created in GB, default=500
        -k/--subnet [optional] default=default

        E.g.: ./gcInstancesWrapper.sh -o start -n allocation-automation-test -z asia-southeast1-a
        Dont forget to give white spaces between keys and values
