# Install Docker on Fedora $VERSION

Don't you hate it when packages aren't available upstream, directly after an os upgrade...

This script will install docker-ce, docker edge, and docker test packages on fedora based on the rpm package repo that you tell it, 
as instructed here `https://docs.docker.com/engine/installation/linux/docker-ce/fedora/#install-using-the-repository`

usage:

Install current OS Version packages

`./get_docker.sh`

Install docker using Fedora26 repo

`./get_docker.sh 26`

Warning:
I've only tested on my machine, Fedora 26, may not work on yours, let me know if it does/doesn't and we can work on a fix. and always look at the script to ensure you're running what you think you ere.

...
It's likely this may not be an issue in future releases
