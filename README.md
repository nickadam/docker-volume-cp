# nickadam/docker-volume-cp:v1.0.0

This image was created to simplify moving production services between docker systems. 

## Example usage

Look at `docker-compose.yml` for an example of how this works.

`example-service` and `example-service2` each write data to their respective volumes. The path to one of the volumes contains a space to demonstrate how to handle paths with spaces.

`sync-sender` shares the same volumes and paths as the two example services. The target paths between the service and the sender don't need to be same. The command given to `sync-sender` initiates the sync process, let's break it down.

```
sync sync-receiver 22 /data/ "/root/my data/"
```

- `sync` merely indicates this container is not receiving data but sending it.
- `sync-receiver` is the name of the receiving server. If we were syncing between different docker servers, we could use an IP or remote hostname here.
- `22` is the remote port to connect to. Notice the comments where port 3000 is used
- All arguments from this point forward are directories to sync and you can specify as many as you need.
- `/data/` a path to a volume to sync. Notice the trailing slash. This is required since there is already a /data directory on the receiving server. If we didn't have the slash files would end up in /data/data on the receiving server.
- `"/root/my data/"` another path to a volume to sync using double quotes for spaces.


`sync-receiver` uses this same image but it doesn't have a command specified so it just launches sshd and waits for connections.

`sync-sender` will continually rerun rsync with 5 second pauses between executions. The detailed log from rsync is in the container's `/sync.log`.

## Warnings

- The credentials to connect to `nickadam/docker-volume-cp:v1.0.0` are baked in the image and are therefore publicly known by all. Don't use this service over an untrusted environment.
- Syncing will delete files in the target volume. Be very careful not to mix the sender and receiver container volumes. Doing so will destroy all your data.
