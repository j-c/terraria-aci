# Why fork?

All the docker images that I found required a detatched tty (i.e.: `-dit`) otherwise the Terraria server would crash on startup. This fork is to house images that can be run under Azure Container Instances (ACI) does not offer the ability to run with `-dit`

Changes are based off https://terraria.gamepedia.com/Server#How_to_.28Linux.29

# terraria

Docker images to run a [Terraria] Server on ACI.

### Usage
#### Azure Container Instances
```
az container create `
    --resource-group <resource_group_name> `
    --name <container_group_name> `
    --image revivalstudios/terraria-aci `
    --dns-name-label <dns_name> `
    --ports 7777 `
    --environment-variables 'WORLD=<world_file_name>' 'PASSWORD=<password>' `
    --azure-file-volume-account-name <azure_storage_account> `
    --azure-file-volume-account-key <azure_storage_account_name> `
    --azure-file-volume-share-name <azure_storage_account_share_name> `
    --azure-file-volume-mount-path /config
```
Please refer to the Azure documentation for [instructions on how to mount a persistent volume in ACI](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-volume-azure-files).

#### Docker
```
docker create `
  --name=terraria `
  -v <path to data>:/config `
  -e world=<world_file_name> `
  -p 7777:7777 `
  revivalstudios/terraria-aci
```

Docker Images are avaiable on [Docker Hub](https://hub.docker.com/repository/docker/revivalstudios/terraria-aci)


### What is Terraria Server?
A Terraria server provides a platform for players to connect over the internet or other network for multiplayer games of [Terraria](https://terraria.org/).

## How to use
Please refer to https://github.com/beardedio/terraria for docker usage instructions.

### Generating a new world (Docker)
To run with out user intervention Terraria Server needs to be configure to use an already generated world. This means you can use one that you have already generated or you can generate one via docker by running this command:
```
docker run -it -p 7777:7777 '
    -v $HOME/terraria/config:/config '
    --name=terraria '
    revivalstudios/terraria-aci
```

Once running, connect to the container by executing a new shell:
```
docker exec -it terraria /bin/sh -c "[ -e /bin/bash ] && /bin/bash || /bin/sh"
```

And enter the tmux session where the Terraria server is running:
```
tmux attach
```

You can then follow the prompts to create a new world.

### Starting your server with a preexisting world
The world file needs to exist in the config folder.
To start a server using an already generated world, use this command:
```
docker run -dit `
  --name=terraria `
  -v $HOME/terraria/config:/config `
  -e world=<world_file_name> `
  -p 7777:7777 `
  revivalstudios/terraria-aci
```

If you get an error from docker saying the container name already exists, it means you need to remove your old docker container process.
`docker rm terraria`

If you want to reattach to any running containers:
`docker attach terraria`
Now you can execute any commands to the terraria server. Ctrl-p Ctrl-q will detatch you from the process.

#### *Notes*
* More information about running a server is available in the [wiki](https://terraria.gamepedia.com/Server).

#### License

The MIT License (MIT)

[Terraria]: https://terraria.org/
