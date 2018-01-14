# Removes current docker installation,
# Installs latest based on your system.
# There is the likelyhood the docker repositories have not been enabled for your OS yet,
# Dec 05. 2017, docker repositories still aren't out for Fedora 27, watch out for this
# script works as per the instructions listed here: https://docs.docker.com/engine/installation/linux/docker-ce/fedora/#set-up-the-repository
#! /bin/bash

install_dnf_plugins() {
	sudo dnf -yq install dnf-plugins-core
}

remove_existing() {
	echo "Removing existing Docker installation"
	sudo dnf -yq remove docker \
                  docker-common \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine
}


add_stable() {
	echo "adding docker-ce stable to dnf repo's"
	sudo dnf config-manager \
		--add-repo \
		https://download.docker.com/linux/fedora/docker-ce.repo

}

add_edge() {
	sudo dnf config-manager --set-enabled docker-ce-edge
	sudo dnf config-manager --set-enabled docker-ce-test
}


install_docker() {
	echo "installing docker-ce"
	sudo dnf -yq install docker-ce
}

# Trick pointed out here,
# https://github.com/docker/for-linux/issues/164
# useful for switching out os versions if docker release isn't up to date
use_os_version() {
	local VERSION=$1
	sudo mkdir -p /etc/dnf/vars
	echo $VERSION | sudo tee /etc/dnf/vars/docker_release_version
	sudo sed -i 's/\$releasever/$docker_release_version/g' /etc/yum.repos.d/docker-ce.repo
}

start_docker() {
	sudo systemctl start docker
}

goodbye() {
	echo "Docker is now installed, and running!"
	docker --version
}

main() {
	local FEDORA_VERSION=$1
	if [[ -z $FEDORA_VERSION ]]; then
		source /etc/os-release
		echo "No Fedora version given defaulting to your OS version, Fedora $VERSION_ID"
		FEDORA_VERSION=$VERSION_ID
	else 
		echo "Using Fedora $FEDORA_VERSION for docker installation"; 
	fi

	install_dnf_plugins
	remove_existing
	add_stable
	use_os_version $FEDORA_VERSION
	install_docker
	start_docker
	goodbye
}

main $1
